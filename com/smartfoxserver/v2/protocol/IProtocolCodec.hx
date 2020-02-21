package com.smartfoxserver.v2.protocol;

import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IoHandler;

import com.smartfoxserver.v2.util.ByteArray;

/** @private */
interface IProtocolCodec
{
	function onPacketRead(packet:Dynamic):Void;
	function onPacketWrite(message:IMessage):Void;

	public var ioHandler(get, set):IoHandler;
}