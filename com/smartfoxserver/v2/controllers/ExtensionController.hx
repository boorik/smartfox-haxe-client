package com.smartfoxserver.v2.controllers;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.BaseController;
import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.data.ISFSObject;

/** @private */
class ExtensionController extends BaseController
{
	public static inline var KEY_CMD:String = "c";
	public static inline var KEY_PARAMS:String = "p";
	public static inline var KEY_ROOM:String = "r";
	
	private var sfs:SmartFox;
	private var bitSwarm:BitSwarmClient;
	
	public function new(bitSwarm:BitSwarmClient)
	{
		super(bitSwarm);
		this.bitSwarm = bitSwarm;
		this.sfs = bitSwarm.sfs;
	}
	
	public override function handleMessage(message:IMessage):Void
	{
		if(sfs.debug)
			log.info(Std.string(message));
		var obj:ISFSObject = message.content;
		var evtParams:Dynamic = { };
		
		evtParams.cmd = obj.getUtfString(KEY_CMD);
		evtParams.params = obj.getSFSObject(KEY_PARAMS);
		if(obj.containsKey(KEY_ROOM))
			evtParams.sourceRoom = obj.getInt(KEY_ROOM);
				
		if(message.isUDP)
			evtParams.packetId = message.packetId;
		
		sfs.dispatchEvent(new SFSEvent(SFSEvent.EXTENSION_RESPONSE, evtParams));
	}
}