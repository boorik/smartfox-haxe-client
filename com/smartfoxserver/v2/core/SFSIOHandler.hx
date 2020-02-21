package com.smartfoxserver.v2.core;

import haxe.io.Bytes;
import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IoHandler;
import com.smartfoxserver.v2.bitswarm.PacketReadState;
import com.smartfoxserver.v2.bitswarm.PendingPacket;
import com.smartfoxserver.v2.exceptions.SFSCodecError;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.logging.LogLevel;
import com.smartfoxserver.v2.logging.Logger;
import com.smartfoxserver.v2.protocol.IProtocolCodec;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
import com.hurlant.util.Endian;

import com.smartfoxserver.v2.errors.IOError;
import com.smartfoxserver.v2.util.ByteArray;

/** @private */
class SFSIOHandler implements IoHandler
{
	public static inline var SHORT_BYTE_SIZE:Int = 2;
	public static inline var INT_BYTE_SIZE:Int = 4;
	
	private var bitSwarm:BitSwarmClient;
	private var log:Logger;
	private var readState:Int;
	private var pendingPacket:PendingPacket;
	private var protocolCodec:IProtocolCodec;
	private var fullPacketDump:Bool=false;
	private var packetEncrypter:IPacketEncrypter;
	
	private static var EMPTY_BUFFER:ByteArray;
	
	public function new(bitSwarm:BitSwarmClient)
	{
		EMPTY_BUFFER = new ByteArray();
		EMPTY_BUFFER.endian = Endian.BIG_ENDIAN;
		this.bitSwarm = bitSwarm;
		this.log = bitSwarm.sfs.logger;
		this.packetEncrypter = new DefaultPacketEncrypter(bitSwarm);
		this.readState = PacketReadState.WAIT_NEW_PACKET;
		this.protocolCodec = new SFSProtocolCodec(this, bitSwarm);
	}
	
	public function enableFullPacketDump(b:Bool):Void
	{
		fullPacketDump=b;
	}
	
	public var codec(get, set):IProtocolCodec;
 	private function get_codec():IProtocolCodec
	{
		return protocolCodec;
	}
	
	/*
	* FOR TESTING PURPOSES ONLY
	*/
	private function set_codec(codec:IProtocolCodec):IProtocolCodec
	{
		return this.protocolCodec = codec;
	}
	
	/*
	 * STATE_MACHINE:
	 * Advances its job in aggregating the packet data through five possible states:
	 * 
	 * 1. WAIT_NEW_PACKET:start a brand new packet constructions
	 * 2. WAIT_DATA_SIZE:waiting for the DATA_SIZE field to come next
	 * 3. WAIT_DATA_SIZE_FRAGMENT:handle DATA_SIZE field fragmentation, if it didn't come through all at once
	 * 4. WAIT_DATA:handle the DATA field until DATA_SIZE(or more)is reached.
	 * 
	 */
	public function onDataRead(data:ByteArray):Void
	{
		if(data.length==0)
			throw new SFSError("Unexpected empty packet data:no readable bytes available!");
			
		/*
		trace("GOT DATA:", data.length, data.position)
		data=handleNewPacket(data)
		trace("DATA:", data.length, data.position)
		return
		*/
		
		if(bitSwarm !=null && bitSwarm.sfs.debug)
		{
			if(data.length>1024 && fullPacketDump==false)
				log.info("Data Read:Size>1024, dump omitted");
			else
				log.info("Data Read:" + DefaultObjectDumpFormatter.hexDump(data));
		}
		
		data.position = 0;
		
		while(data.length>0)
		{
			if(readState==PacketReadState.WAIT_NEW_PACKET)
			{
				data = handleNewPacket(data);
			}
			
			if(readState==PacketReadState.WAIT_DATA_SIZE)
			{
				data = handleDataSize(data);
			}
			
			if(readState==PacketReadState.WAIT_DATA_SIZE_FRAGMENT)
			{
				data = handleDataSizeFragment(data);
			}
			
			if(readState==PacketReadState.WAIT_DATA)
			{
				data = handlePacketData(data);
			}
		}
	}
	
	private function handleNewPacket(data:ByteArray):ByteArray
	{
		log.debug("Handling New Packet");
		
		// Decode the header byte
		var headerByte:Int = data.readByte();
		
		if((headerByte & 128)==0)
		{
			// NOTE:Added extra debug info, for unexpected packets
			throw new SFSError("Unexpected header byte:" + headerByte, 0, DefaultObjectDumpFormatter.hexDump(data));
		}
			
		var header:PacketHeader = PacketHeader.fromBinary(headerByte);
		
		// Store the pending packet
		pendingPacket = new PendingPacket(header);
		
		// Change state
		readState = PacketReadState.WAIT_DATA_SIZE;
		
		// Resize the array
		return resizeByteArray(data, 1, data.length-1);
	}
	
	private function handleDataSize(data:ByteArray):ByteArray
	{
		log.debug("Handling Header Size. Size:" + data.length + "(" +(pendingPacket.header.bigSized ? "big":"small") + ")");
		
		var dataSize:Int = -1;
		var sizeBytes:Int = 2; // default==2 bytes
		
		// Size is expressed in 4 bytes(signed Int)
		if(pendingPacket.header.bigSized)
		{
			// Check if we have the full header
			if(data.length>=4)
			{
				dataSize = data.readUnsignedInt();
			}
			
			sizeBytes = 4;
		}
		
		// Size is expressed in 2 bytes(unsigned short)
		else
		{
			if(data.length>=2)
			{
				dataSize = data.readUnsignedShort();
			}
		}
		
		if(dataSize !=-1)
		{
			// Store expected packet size
			pendingPacket.header.expectedLen = dataSize;
			
			data = resizeByteArray(data, sizeBytes, data.length - sizeBytes);
			readState = PacketReadState.WAIT_DATA;
		}
		
		// We didn't decode the whole size
		else
		{
			readState = PacketReadState.WAIT_DATA_SIZE_FRAGMENT;
			
			// Store the data we have
			pendingPacket.buffer.writeBytes(data);
			
			// An empty data will signal that we need to wait the next fragment
			data = EMPTY_BUFFER;
		}
		
		return data;
	}
	
	private function handleDataSizeFragment(data:ByteArray):ByteArray
	{
		log.debug("Handling Size fragment. Data:" + data.length);
		
		var remaining:Int = pendingPacket.header.bigSized ? 4 - pendingPacket.buffer.position:2 - pendingPacket.buffer.position;
		
		// Ok, we have enough data to finish
		if(data.length>=remaining)
		{
			pendingPacket.buffer.writeBytes(data, 0, remaining);
			pendingPacket.buffer.position = 0;
			var dataSize:Int = pendingPacket.header.bigSized ? pendingPacket.buffer.readInt():pendingPacket.buffer.readShort();
			
			log.debug('DataSize is ready:$dataSize bytes');
			pendingPacket.header.expectedLen = dataSize;
			pendingPacket.buffer = new ByteArray();
			pendingPacket.buffer.endian = Endian.BIG_ENDIAN;
			
			// Next state
			readState = PacketReadState.WAIT_DATA;
			
			// Remove bytes that were analyzed
			if(data.length>remaining)
				data = resizeByteArray(data, remaining, data.length - remaining);
			else
				data = EMPTY_BUFFER;
		}
		
		// Nope, we're not done yet
		else
		{
			pendingPacket.buffer.writeBytes(data);
			data = EMPTY_BUFFER;
		}
		
		return data;
	}
	
	private function handlePacketData(data:ByteArray):ByteArray
	{	
		// is there more data for the next incoming packet?
		var remaining:Int = pendingPacket.header.expectedLen - pendingPacket.buffer.length;
		var isThereMore:Bool = (data.length > remaining);
		
		log.debug("Handling Data:" + data.length + ", previous state:" + pendingPacket.buffer.length + "/" + pendingPacket.header.expectedLen);

		if(data.length>=remaining)
		{
			pendingPacket.buffer.writeBytes(data, 0, remaining);
			log.debug("<<<Packet Complete>>>");
			
			// Handle encryption
			if (pendingPacket.header.encrypted)
				packetEncrypter.decrypt(pendingPacket.buffer);
			
			// Handle compression
			/*if(pendingPacket.header.compressed)
				pendingPacket.buffer.uncompress();*/
				///TODO: Enable!
			
			// Send to protocol codec
			protocolCodec.onPacketRead(pendingPacket.buffer);
			
			readState = PacketReadState.WAIT_NEW_PACKET;
		}
		
		// Not enough data to complete the packet
		else
		{
			// Add bytes to buffer and let's wait for the rest to come over th network
			pendingPacket.buffer.writeBytes(data);
		}
		
		if(isThereMore)
			data = resizeByteArray(data, remaining, data.length - remaining);
		else
			data = EMPTY_BUFFER;
		
		return data;
	}
	
	private function resizeByteArray(array:ByteArray, pos:Int, len:Int):ByteArray
	{
		var newArray:ByteArray = new ByteArray();
		newArray.endian = Endian.BIG_ENDIAN;
		newArray.writeBytes(array, pos, len);
		newArray.position = 0;
		
		return newArray;
	}
	
	
	public function onDataWrite(message:IMessage):Void
	{
		var writeBuffer:ByteArray = new ByteArray();
		writeBuffer.endian = Endian.BIG_ENDIAN;//fix for new openfl versions
		var binData:ByteArray = message.content.toBinary();
		var isCompressed:Bool = false;
		var isEncrypted:Bool = false;
		
		// 1. Handle Compression
		if (cast(binData.length,Int) > bitSwarm.compressionThreshold)
		{
			trace("Before compression:" + binData.length);
			//binData.compress();
			///TODO: Enable!
			trace("After compression:" + binData.length);
			isCompressed = true;
		}	
		
		if(cast(binData.length,Int)>bitSwarm.maxMessageSize)
		{
			/*
			* Houston we have problem!
			* The outgoing message is bigger than what the server allows
			* We should stop here and provide an error to the developer
			*/
			
			throw new SFSCodecError("Message size is too big:" + binData.length + ", the server limit is:" + bitSwarm.maxMessageSize);
		}
		
		// 2. Handle Encryption
		if (bitSwarm.cryptoKey != null)
		{
			packetEncrypter.encrypt(binData);
			isEncrypted = true;
		}
		
		var sizeBytes:Int = SHORT_BYTE_SIZE;
		
		if(binData.length>65535)
			sizeBytes = INT_BYTE_SIZE;
		
		// BlueBoxed flag is not implemented yet
		var packetHeader:PacketHeader = new PacketHeader(isEncrypted, isCompressed, false, sizeBytes == INT_BYTE_SIZE);
		
		// 1. Write packet header byte
		writeBuffer.writeByte(packetHeader.encode());
		
		// 2. Write packet size
		if(sizeBytes>SHORT_BYTE_SIZE)
			writeBuffer.writeInt(binData.length);
		else
			writeBuffer.writeShort(binData.length);
		
		// 3. Write actual packet data
		writeBuffer.writeBytes(binData);
			
		// 4. Send in hyperspace!
		if(bitSwarm.useWebSocket)
		{
			bitSwarm.webSocket.send(writeBuffer);
			if(bitSwarm.sfs.debug)
				trace("webSocketSend");
		}else if(bitSwarm.useBlueBox)
		{
			bitSwarm.httpSocket.send(writeBuffer);
			if(bitSwarm.sfs.debug)
				trace("blueBoxSend");
		}
		else
		{
			#if !html5
			if(bitSwarm.socket.connected)
			{
				if(message.isUDP)
				{
					writeUDP(message, writeBuffer);
					trace("udpSend");
				}
				else
				{
					writeTCP(message, writeBuffer);
					trace("tcpSend");
				}
			}
			#end
		}
	}

	#if !html5
	private function writeTCP(message:IMessage, writeBuffer:ByteArray):Void
	{
		try
		{
			var bytes:Bytes = writeBuffer.getBytes();
			bitSwarm.socket.send(bytes);
			
			if (bitSwarm.sfs.debug)
			{
				log.info("Data written:" + message.content.getHexDump());
			}
		}
		catch(error:IOError)
		{
			log.warn("WriteTCP operation failed due to I/O Dynamic:" + error.message);
		}
	}
	
	private function writeUDP(message:IMessage, writeBuffer:ByteArray):Void
	{
		bitSwarm.udpManager.send(writeBuffer);
	}
	#end
}
