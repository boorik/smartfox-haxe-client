package com.smartfoxserver.v2.protocol;

import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IoHandler;

import flash.utils.ByteArray<Dynamic>;

/** @private */
interface IProtocolCodec
{
	function onPacketRead(packet:Dynamic):Void
	function onPacketWrite(message:IMessage):Void

	function get ioHandler():IoHandler
	function set ioHandler(handler:IoHandler):Void
}