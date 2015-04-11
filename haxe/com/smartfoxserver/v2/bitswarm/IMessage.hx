package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.entities.data.ISFSObject;

/** @private */
interface IMessage
{
	function get_id():Int;
	function set_id(value:Int):Void;
	
	function get_content():ISFSObject;
	function set_content(obj:ISFSObject):Void;
	
	function get_targetController():Int;
	function set_targetController(value:Int):Void;
	
	function get_isEncrypted():Bool;
	function set_isEncrypted(value:Bool):Void;
		
	function get_isUDP():Bool;
	function set_isUDP(value:Bool):Void;
		
	function get_packetId():Float;
	function set_packetId(value:Float):Void;
}