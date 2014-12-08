package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public interface IUDPManager
	{
		function initialize(udpAddr:String, udpPort:int):void;
		function get inited():Boolean
		function set sfs(sfs:SmartFox):void
		function nextUdpPacketId():Number;
		function send(binaryData:ByteArray):void;
		function reset():void;
	}
}