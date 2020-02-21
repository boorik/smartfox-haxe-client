package com.smartfoxserver.v2.test;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IoHandler;
import com.smartfoxserver.v2.kernel;
import com.smartfoxserver.v2.protocol.IProtocolCodec;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;

import com.smartfoxserver.v2.util.ByteArray<Dynamic>;

class TestProtocolCodec implements IProtocolCodec
{
	private var verificationPacket:ByteArray
	
	public function new()
	{

	}
	
	public function onPacketRead(packet:Dynamic):Void
	{
		var bytes:ByteArray<Dynamic>=cast(packet, ByteArray);
		if(verifyPacketIntegrity(bytes, verificationPacket))
			trace("Codec - Packet complete:" + bytes.length)
		else
		{
			trace("Codec - Dynamic, packets don't match.")
			trace("Expected:\n" + DefaultObjectDumpFormatter.hexDump(verificationPacket))
			trace("Received:\n" + DefaultObjectDumpFormatter.hexDump(bytes))
		}
			
	}
	
	public function onPacketWrite(message:IMessage):Void
	{
		trace("No write suppoerted")
	}
	
	public var ioHandler(get, set):IoHandler;
 	private function get_ioHandler():IoHandler
	{
		return null	
	}
	
	private function set_ioHandler(handler:IoHandler):Void
	{
	
	}
	
	public function setVerificationPacket(bb:ByteArray):Void
	{
		verificationPacket = new ByteArray();
		verificationPacket.endian = Endian.BIG_ENDIAN;
		verificationPacket.writeBytes(bb, 3, bb.length - 3)
	}
	
	private function verifyPacketIntegrity(data:ByteArray, verifyData:ByteArray):Bool
	{
		if(data.length !=verifyData.length)
			return false;
		
		for(i in 0...verifyData.length)
		{
			if(data[i]==verifyData[i])
				continue;
			
			else
				return false;
		}
		
		return true
	}
	
}