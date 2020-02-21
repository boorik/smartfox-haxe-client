package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.logging.Logger;

import com.smartfoxserver.v2.util.ByteArray;

/** @private */
class DefaultUDPManager implements IUDPManager
{
	private var _sfs:SmartFox;
	
	public function new(sfs:SmartFox)
	{
		_sfs = sfs;
	}
	
	public function initialize(udpAddr:String, udpPort:Int):Void
	{
		logUsageError();
	}
	
	public function nextUdpPacketId():Float
	{
		return -1;
	}
	
	public function send(binaryData:ByteArray):Void
	{
		logUsageError();
	}
	@:isVar
	public var inited(get, null):Bool;
 	private function get_inited():Bool
	{
		return false;
	}
	private function set_inited(value:Bool):Bool
	{
		return inited = value;
	}
	
	public var sfs(get, set):SmartFox;
	
	
	
	public function reset():Void
	{
		// Nothing to do here
	}
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function logUsageError():Void
	{
		if(_sfs.udpAvailable)
			_sfs.logger.warn("UDP protocol is not initialized yet. Pleas use the initUDP()method. If you have any doubts please refer to the documentation of initUDP()");
		else
			_sfs.logger.warn("You are not currently enabled to use UDP protocol. UDP is available only for Air 2 runtime and higher.");	
	}
	
	function get_sfs():SmartFox 
	{
		return _sfs;
	}
	function set_sfs(sfs:SmartFox):SmartFox
	{
		// Not used here, we do it in the constructor
		return _sfs;
	}
	
	
}