package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.entities.data.SFSObject;

/** @private */
interface IMessage
{
	var id(get,set):Int;
	var content(get, set):SFSObject;
	//function get_content():SFSObject;
	//function set_content(obj:SFSObject):Void;
	
	var targetController(get, set):Int;
	//function get_targetController():Int;
	//function set_targetController(value:Int):Void;
	
	var isEncrypted(get, set):Bool;
	//function get_isEncrypted():Bool;
	//function set_isEncrypted(value:Bool):Void;
		
	var isUDP(get, set):Bool;
	//function get_isUDP():Bool;
	//function set_isUDP(value:Bool):Void;
	
	var packetId(get, set):Float;
	//function get_packetId():Float;
	//function set_packetId(value:Float):Void;
}