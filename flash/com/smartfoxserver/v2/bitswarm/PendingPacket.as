package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.core.PacketHeader;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public class PendingPacket
	{
		private var _header:PacketHeader
		private var _buffer:ByteArray
		
		public function PendingPacket(header:PacketHeader)
		{
			_header = header
			_buffer = new ByteArray()
		}
		
		public function get header():PacketHeader
		{
			return _header	
		}
		
		public function get buffer():ByteArray
		{
			return _buffer
		}
		
		public function set buffer(buffer:ByteArray):void
		{
			_buffer = buffer
		}
	}
}