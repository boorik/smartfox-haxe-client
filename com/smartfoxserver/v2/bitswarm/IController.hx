package com.smartfoxserver.v2.bitswarm;

/** @private */
interface IController
{
	public var id(get, set):Int;
	
	function handleMessage(message:IMessage):Void;
}