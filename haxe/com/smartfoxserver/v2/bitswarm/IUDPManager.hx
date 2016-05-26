package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;

import flash.utils.ByteArray;

/** @private */
interface IUDPManager
{
	function initialize(udpAddr:String, udpPort:Int):Void;
	var inited:Bool;
	var sfs:SmartFox;
	function nextUdpPacketId():Float;
	function send(binaryData:ByteArray):Void;
	function reset():Void;
}