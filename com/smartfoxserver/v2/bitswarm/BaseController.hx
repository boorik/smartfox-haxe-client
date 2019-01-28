package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.logging.Logger;

/** @private */
class BaseController implements IController
{
	private var _id:Int = -1;
	private var log:Logger;
	
	public function new(bitSwarm:BitSwarmClient)
	{
		log = bitSwarm.sfs.logger;
	}
	
	public var id(get, set):Int;
 	private function get_id():Int
	{
		return _id;
	}
	
	private function set_id(value:Int):Int
	{
		if(_id==-1)
			return _id = value;
		else
			throw new SFSError("Controller ID is already set:" + _id + ". Can't be changed at runtime!");
	}

	public function handleMessage(message:IMessage):Void
	{
		trace("System controller got request:" + message);
	}

}