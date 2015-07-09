package com.smartfoxserver.v2.bitswarm;

/** @private */
interface IController
{
	function get_id():Int;
	function set_id(value:Int):Void;
	
	function handleMessage(message:IMessage):Void;
}