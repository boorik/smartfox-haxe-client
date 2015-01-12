package com.smartfoxserver.v2.bitswarm;

/** @private */
interface IController
{
	function get id():Int;
	function set id(value:Int):Void;
	
	function handleMessage(message:IMessage):Void;
}