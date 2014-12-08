package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.logging.Logger;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public class DefaultUDPManager implements IUDPManager
	{
		private var _sfs:SmartFox
		
		public function DefaultUDPManager(sfs:SmartFox)
		{
			_sfs = sfs
		}
		
		public function initialize(udpAddr:String, udpPort:int):void
		{
			logUsageError()
		}
		
		public function nextUdpPacketId():Number
		{
			return -1;
		}
		
		public function send(binaryData:ByteArray):void
		{
			logUsageError();
		}
		
		public function get inited():Boolean
		{
			return false
		}
		
		public function set sfs(sfs:SmartFox):void
		{
			// Not used here, we do it in the constructor
		}
		
		public function reset():void
		{
			// Nothing to do here
		}
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function logUsageError():void
		{
			if (_sfs.udpAvailable)
				_sfs.logger.warn("UDP protocol is not initialized yet. Pleas use the initUDP() method. If you have any doubts please refer to the documentation of initUDP()")
			else
				_sfs.logger.warn("You are not currently enabled to use UDP protocol. UDP is available only for Air 2 runtime and higher.");	
		}
		
		
	}
}