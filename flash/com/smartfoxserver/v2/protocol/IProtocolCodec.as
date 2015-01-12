package com.smartfoxserver.v2.protocol
{
	import com.smartfoxserver.v2.bitswarm.IMessage;
	import com.smartfoxserver.v2.bitswarm.IoHandler;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public interface IProtocolCodec
	{
		function onPacketRead(packet:*):void
		function onPacketWrite(message:IMessage):void
	
		function get ioHandler():IoHandler
		function set ioHandler(handler:IoHandler):void
	}
}