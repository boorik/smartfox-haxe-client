package com.smartfoxserver.v2.bitswarm;

/** @private */
interface IController
{
	public var id(get_id, set_id):Int;
	
	function handleMessage(message:IMessage):Void;
}