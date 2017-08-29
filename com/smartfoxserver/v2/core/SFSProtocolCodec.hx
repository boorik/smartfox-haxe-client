package com.smartfoxserver.v2.core;

import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.bitswarm.IController;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IoHandler;
import com.smartfoxserver.v2.bitswarm.Message;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSCodecError;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.logging.Logger;
import com.smartfoxserver.v2.protocol.IProtocolCodec;

import flash.utils.ByteArray;

/** @private */
class SFSProtocolCodec implements IProtocolCodec
{
	private static inline var CONTROLLER_ID:String = "c";
	private static inline var ACTION_ID:String = "a";
	private static inline var PARAM_ID:String = "p";
	private static inline var USER_ID:String = "u";			// UDP Only
	private static inline var UDP_PACKET_ID:String = "i";		// UDP Only
			
	private var _ioHandler:IoHandler;
	private var log:Logger;
	private var bitSwarm:BitSwarmClient;
	
	public function new(ioHandler:IoHandler, bitSwarm:BitSwarmClient)
	{
		this._ioHandler = ioHandler;
		this.bitSwarm = bitSwarm;
		this.log = bitSwarm.sfs.logger;
	}
	
	public function onPacketRead(packet:Dynamic):Void
	{		
		var sfsObj:SFSObject = null;
			
		/*
		* TCP Data provides a ByteArray
		*/
		if(Std.is(packet, #if flash ByteArray #else openfl.utils.ByteArray.ByteArrayData #end))
			sfsObj = SFSObject.newFromBinaryData(packet);
				
		/*
		* UDP and JSON provide an SFSObject
		*/
		else
			sfsObj = cast(packet, SFSObject);
				
		// Create a Request and dispatch to ProtocolCodec
		dispatchRequest(sfsObj);
	}
	
	public function onPacketWrite(message:IMessage):Void
	{
		var sfsObj:SFSObject;
		
		if(message.isUDP)
			sfsObj = prepareUDPPacket(message);
		else
			sfsObj = prepareTCPPacket(message);
		
		// Now the SFSObj is wrapped by its header object
		message.content = sfsObj;
			
		if(bitSwarm.sfs.debug)
			log.info("Object going out:" + message.content.getDump());
			
		// Hand it to the IOHandler
		ioHandler.onDataWrite(message);
	}
	
	private function prepareTCPPacket(message:IMessage):SFSObject
	{
		var sfsObj:SFSObject = new SFSObject();
		
		// Target controller
		sfsObj.putByte(CONTROLLER_ID, message.targetController);
		
		// Action id
		sfsObj.putShort(ACTION_ID, message.id);
		
		// Params
		sfsObj.putSFSObject(PARAM_ID, message.content);
		
		return sfsObj;
	}
	
	private function prepareUDPPacket(message:IMessage):SFSObject
	{
		var sfsObj:SFSObject = new SFSObject();
			
		// Target controller
		sfsObj.putByte(CONTROLLER_ID, message.targetController);
		
		// User id:in case we're not logged in the packet will sent with UID=-1, and the server will refuse it
		sfsObj.putInt(USER_ID, bitSwarm.sfs.mySelf != null ? bitSwarm.sfs.mySelf.id: -1);

		// Packet id	
		sfsObj.putLong(UDP_PACKET_ID, bitSwarm.nextUdpPacketId());
			
		// Params
		sfsObj.putSFSObject(PARAM_ID, message.content);
		
		return sfsObj;
	}
	
	public var ioHandler(get_ioHandler, set_ioHandler):IoHandler;
 	private function get_ioHandler():IoHandler
	{
		return _ioHandler;
	}
	
	private function set_ioHandler(handler:IoHandler):IoHandler
	{
		if(_ioHandler !=null)
			throw new SFSError("IOHandler is already defined for thir ProtocolHandler instance:" + this);
			
		return this._ioHandler = ioHandler;
	}
	
	private function dispatchRequest(requestObject:SFSObject):Void
	{
		var message:IMessage = new Message();

		// Check controller ID
		if(requestObject.isNull(CONTROLLER_ID))
			throw new SFSCodecError("Request rejected:No Controller ID in request!");
		
		// Check if action ID exist 
		if(requestObject.isNull(ACTION_ID))
			throw new SFSCodecError("Request rejected:No Action ID in request!");
		
		message.id = requestObject.getByte(ACTION_ID);
		message.content = requestObject.getSFSObject(PARAM_ID);
		message.isUDP = requestObject.containsKey(UDP_PACKET_ID);
		
		if(message.isUDP)
			message.packetId = requestObject.getLong(UDP_PACKET_ID);
		
		var controllerId:Int = requestObject.getByte(CONTROLLER_ID);
		var controller:IController = bitSwarm.getController(controllerId);
		
		if(controller==null)
			throw new SFSError("Cannot handle server response. Unknown controller, id:" + controllerId);
		
		// Dispatch to controller
		controller.handleMessage(message);
	}
}