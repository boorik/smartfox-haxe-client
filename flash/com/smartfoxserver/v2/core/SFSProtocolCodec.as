package com.smartfoxserver.v2.core
{
	import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
	import com.smartfoxserver.v2.bitswarm.IController;
	import com.smartfoxserver.v2.bitswarm.IMessage;
	import com.smartfoxserver.v2.bitswarm.IoHandler;
	import com.smartfoxserver.v2.bitswarm.Message;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.exceptions.SFSCodecError;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.logging.Logger;
	import com.smartfoxserver.v2.protocol.IProtocolCodec;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public class SFSProtocolCodec implements IProtocolCodec
	{
		private static const CONTROLLER_ID:String = "c"
		private static const ACTION_ID:String = "a"
		private static const PARAM_ID:String = "p"
		private static const USER_ID:String = "u"			// UDP Only
		private static const UDP_PACKET_ID:String = "i"		// UDP Only
				
		private var _ioHandler:IoHandler
		private var log:Logger
		private var bitSwarm:BitSwarmClient
		
		public function SFSProtocolCodec(ioHandler:IoHandler, bitSwarm:BitSwarmClient)
		{
			this._ioHandler = ioHandler
			this.bitSwarm = bitSwarm
			this.log = bitSwarm.sfs.logger
		}
		
		public function onPacketRead(packet:*):void
		{		
			var sfsObj:ISFSObject = null
				
			/*
			* TCP Data provides a ByteArray
			*/
			if (packet is ByteArray)
				sfsObj = SFSObject.newFromBinaryData(packet)
					
			/*
			* UDP and JSON provide an ISFSObject
			*/
			else
				sfsObj = packet as ISFSObject
					
			// Create a Request and dispatch to ProtocolCodec
			dispatchRequest(sfsObj)	
		}
		
		public function onPacketWrite(message:IMessage):void
		{
			var sfsObj:ISFSObject;
			
			if (message.isUDP)
				sfsObj = prepareUDPPacket(message)
			else
				sfsObj = prepareTCPPacket(message)
			
			// Now the SFSObj is wrapped by its header object
			message.content = sfsObj
				
			if (bitSwarm.sfs.debug)
				log.info("Object going out: " + message.content.getDump())
				
			// Hand it to the IOHandler
			ioHandler.onDataWrite(message)
		}
		
		private function prepareTCPPacket(message:IMessage):ISFSObject
		{
			var sfsObj:ISFSObject = new SFSObject()
			
			// Target controller
			sfsObj.putByte(CONTROLLER_ID, message.targetController)
			
			// Action id
			sfsObj.putShort(ACTION_ID, message.id)
			
			// Params
			sfsObj.putSFSObject(PARAM_ID, message.content)
			
			return sfsObj
		}
		
		private function prepareUDPPacket(message:IMessage):ISFSObject
		{
			var sfsObj:ISFSObject = new SFSObject()
				
			// Target controller
			sfsObj.putByte(CONTROLLER_ID, message.targetController)
			
			// User id: in case we're not logged in the packet will sent with UID = -1, and the server will refuse it
			sfsObj.putInt(USER_ID, bitSwarm.sfs.mySelf != null ? bitSwarm.sfs.mySelf.id : -1)

			// Packet id	
			sfsObj.putLong(UDP_PACKET_ID, bitSwarm.nextUdpPacketId())
				
			// Params
			sfsObj.putSFSObject(PARAM_ID, message.content)
			
			return sfsObj
		}
		
		public function get ioHandler():IoHandler
		{
			return _ioHandler	
		}
		
		public function set ioHandler(handler:IoHandler):void
		{
			if (_ioHandler != null)
				throw new SFSError("IOHandler is already defined for thir ProtocolHandler instance: " + this)
				
			this._ioHandler = ioHandler
		}
		
		private function dispatchRequest(requestObject:ISFSObject):void
		{
			var message:IMessage = new Message()

			// Check controller ID
			if (requestObject.isNull(CONTROLLER_ID))
				throw new SFSCodecError("Request rejected: No Controller ID in request!")
			
			// Check if action ID exist 
			if (requestObject.isNull(ACTION_ID))
				throw new SFSCodecError("Request rejected: No Action ID in request!")
			
			message.id = requestObject.getByte(ACTION_ID)
			message.content = requestObject.getSFSObject(PARAM_ID)
			message.isUDP = requestObject.containsKey(UDP_PACKET_ID)
			
			if (message.isUDP)
				message.packetId = requestObject.getLong(UDP_PACKET_ID)
			
			var controllerId:int = requestObject.getByte(CONTROLLER_ID)
			var controller:IController = bitSwarm.getController(controllerId)
			
			if (controller == null)
				throw new SFSError("Cannot handle server response. Unknown controller, id: " + controllerId)
			
			// Dispatch to controller
			controller.handleMessage(message)
		}
	}
}