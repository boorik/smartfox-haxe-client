package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;

import com.smartfoxserver.v2.util.ByteArray;

/** @private */
interface IUDPManager
{
	function initialize(udpAddr:String, udpPort:Int):Void;
	var inited(get,null):Bool;
	var sfs(get,set):SmartFox;
	function nextUdpPacketId():Float;
	function send(binaryData:ByteArray):Void;
	function reset():Void;
}