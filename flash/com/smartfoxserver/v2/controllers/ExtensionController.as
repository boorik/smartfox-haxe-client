package com.smartfoxserver.v2.controllers
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.bitswarm.BaseController;
	import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
	import com.smartfoxserver.v2.bitswarm.IMessage;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	
	/** @private */
	public class ExtensionController extends BaseController
	{
		public static const KEY_CMD:String = "c"
		public static const KEY_PARAMS:String = "p"
		public static const KEY_ROOM:String = "r"
		
		private var sfs:SmartFox
		private var bitSwarm:BitSwarmClient
		
		public function ExtensionController(bitSwarm:BitSwarmClient)
		{
			super(bitSwarm)
			this.bitSwarm = bitSwarm
			this.sfs = bitSwarm.sfs
		}
		
		public override function handleMessage(message:IMessage):void
		{
			if (sfs.debug)
				log.info(message)
			
			var obj:ISFSObject = message.content
			var evtParams:Object = {}
			
			evtParams.cmd = obj.getUtfString(KEY_CMD)
			evtParams.params = obj.getSFSObject(KEY_PARAMS)
			if (obj.containsKey(KEY_ROOM))
				evtParams.sourceRoom = obj.getInt(KEY_ROOM)
					
			if (message.isUDP)
				evtParams.packetId = message.packetId
			
			sfs.dispatchEvent( new SFSEvent(SFSEvent.EXTENSION_RESPONSE, evtParams) )
		}
	}
}