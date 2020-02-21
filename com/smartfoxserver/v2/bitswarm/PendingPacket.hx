package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.core.PacketHeader;
import com.hurlant.util.Endian;

import com.smartfoxserver.v2.util.ByteArray;

/** @private */
class PendingPacket
{
	private var _header:PacketHeader;
	private var _buffer:ByteArray;
	
	public function new(header:PacketHeader)
	{
		_header = header;
		_buffer = new ByteArray();
		_buffer.endian = Endian.BIG_ENDIAN;
	}
	
	public var header(get, set):PacketHeader;
	
	
	public var buffer(get, set):ByteArray;
 	private function get_buffer():ByteArray
	{
		return _buffer;
	}
	
	private function set_buffer(buffer:ByteArray):ByteArray
	{
		return _buffer = buffer;
	}
	
	function get_header():PacketHeader 
	{
		return _header;
	}
	
	function set_header(value:PacketHeader):PacketHeader 
	{
		return _header = value;
	}
}