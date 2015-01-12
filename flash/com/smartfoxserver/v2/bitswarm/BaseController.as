package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.logging.Logger;
	
	/** @private */
	public class BaseController implements IController
	{
		protected var _id:int = -1 
		protected var log:Logger
		
		public function BaseController(bitSwarm:BitSwarmClient)
		{
			log = bitSwarm.sfs.logger
		}
		
		public function get id():int
		{
			return _id
		}
		
		public function set id(value:int):void
		{
			if (_id == -1)
				_id = value
			else
				throw new SFSError("Controller ID is already set: " + _id + ". Can't be changed at runtime!")	
		}

		public function handleMessage(message:IMessage):void
		{
			trace("System controller got request: " + message)
		}

	}
}