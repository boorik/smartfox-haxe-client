package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.entities.data.ISFSObject;

/** @private */
interface IMessage
{
	function get id():Int;
	function set id(value:Int):Void;
	
	function get content():ISFSObject;
	function set content(obj:ISFSObject):Void;
	
	function get targetController():Int;
	function set targetController(value:Int):Void;
	
	function get isEncrypted():Bool;
	function set isEncrypted(value:Bool):Void;
		
	function get isUDP():Bool;
	function set isUDP(value:Bool):Void;
		
	function get packetId():Float;
	function set packetId(value:Float):Void;
}