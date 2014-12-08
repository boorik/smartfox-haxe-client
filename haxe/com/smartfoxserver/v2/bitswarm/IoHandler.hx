package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.protocol.IProtocolCodec;

import flash.utils.ByteArray<Dynamic>;

/** @private */
interface IoHandler
{
	function onDataRead(buffer:ByteArray):Void;
	function onDataWrite(message:IMessage):Void;
	function get codec():IProtocolCodec;
}