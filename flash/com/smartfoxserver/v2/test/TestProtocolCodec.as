package com.smartfoxserver.v2.test
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.bitswarm.IMessage;
	import com.smartfoxserver.v2.bitswarm.IoHandler;
	import com.smartfoxserver.v2.kernel;
	import com.smartfoxserver.v2.protocol.IProtocolCodec;
	import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
	
	import flash.utils.ByteArray;

	public class TestProtocolCodec implements IProtocolCodec
	{
		private var verificationPacket:ByteArray
		
		public function TestProtocolCodec()
		{

		}
		
		public function onPacketRead(packet:*):void
		{
			var bytes:ByteArray = packet as ByteArray;
			if (verifyPacketIntegrity(bytes, verificationPacket))
				trace("Codec - Packet complete: " + bytes.length)
			else
			{
				trace("Codec - Error, packets don't match.")
				trace("Expected:\n" + DefaultObjectDumpFormatter.hexDump(verificationPacket))
				trace("Received:\n" + DefaultObjectDumpFormatter.hexDump(bytes))
			}
				
		}
		
		public function onPacketWrite(message:IMessage):void
		{
			trace("No write suppoerted")
		}
		
		public function get ioHandler():IoHandler
		{
			return null	
		}
		
		public function set ioHandler(handler:IoHandler):void
		{
		
		}
		
		public function setVerificationPacket(bb:ByteArray):void
		{
			verificationPacket = new ByteArray(); 
			verificationPacket.writeBytes(bb, 3, bb.length - 3)
		}
		
		private function verifyPacketIntegrity(data:ByteArray, verifyData:ByteArray):Boolean
		{
			if (data.length != verifyData.length)
				return false;
			
			for (var i:int = 0; i < verifyData.length; i++)
			{
				if (data[i] == verifyData[i])
					continue;
				
				else
					return false;
			}
			
			return true
		}
		
	}
}