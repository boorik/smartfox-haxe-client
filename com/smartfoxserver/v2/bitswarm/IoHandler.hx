package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.protocol.IProtocolCodec;

import com.smartfoxserver.v2.util.ByteArray;

/** @private */
interface IoHandler
{
	function onDataRead(buffer:ByteArray):Void;
	function onDataWrite(message:IMessage):Void;
	var codec(get, set):IProtocolCodec;
}