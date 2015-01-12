package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.protocol.IProtocolCodec;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public interface IoHandler
	{
		function onDataRead(buffer:ByteArray):void
		function onDataWrite(message:IMessage):void
		function get codec():IProtocolCodec
	}
}