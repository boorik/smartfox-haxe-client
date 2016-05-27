package com.smartfoxserver.v2.protocol;

import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IoHandler;

import flash.utils.ByteArray;

/** @private */
interface IProtocolCodec
{
	function onPacketRead(packet:Dynamic):Void;
	function onPacketWrite(message:IMessage):Void;

	public var ioHandler(get_ioHandler, set_ioHandler):IoHandler;
}