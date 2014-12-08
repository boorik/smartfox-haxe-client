package com.smartfoxserver.v2.core
{
	/** @private */
	public class PacketHeader
	{
		private var _expectedLen:int
		private var _binary:Boolean
		private var _compressed:Boolean
		private var _encrypted:Boolean
		private var _blueBoxed:Boolean
		private var _bigSized:Boolean
		
		public function PacketHeader(encrypted:Boolean,
									compressed:Boolean = false,
									blueBoxed:Boolean = false,
									bigSized:Boolean = false
								)
		{
			_expectedLen = -1
			
			_binary = true
			_compressed = compressed
			_encrypted = encrypted
			_blueBoxed = blueBoxed
			_bigSized = bigSized 
		}
		
		public static function fromBinary(headerByte:int):PacketHeader
		{
			return new PacketHeader(
										(headerByte & 0x40) > 0,
										(headerByte & 0x20) > 0,
										(headerByte & 0x10) > 0,
										(headerByte & 0x8) > 0
								)
		}
		
		public function get expectedLen():int
		{
			return _expectedLen	
		}
		public function set expectedLen(value:int):void
		{
			_expectedLen = value
		}
		
		public function get binary():Boolean
		{
			return _binary	
		}
		public function set binary(value:Boolean):void
		{
			_binary = value
		}
		
		public function get compressed():Boolean
		{
			return _compressed
		}
		public function set compressed(value:Boolean):void
		{
			_compressed = value
		}
		
		public function get encrypted():Boolean
		{
			return	_encrypted
		}
		public function set encrypted(value:Boolean):void
		{
			_encrypted = value	
		}
		
		public function get blueBoxed():Boolean
		{
			return	_blueBoxed	
		}
		
		public function set blueBoxed(value:Boolean):void
		{
			_blueBoxed = value	
		}
		
		public function get bigSized():Boolean
		{
			return	_bigSized
		}
		public function set bigSized(value:Boolean):void
		{
			_bigSized = value
		}
		
		public function encode():int
		{
			var headerByte:int = 0
			
			if (binary)
				headerByte += 0x80
				
			if (encrypted)
				headerByte += 0x40
				
			if (compressed)
				headerByte += 0x20
				
			if (blueBoxed)
				headerByte += 0x10
			
			if (bigSized)
				headerByte += 0x08
				
			return headerByte
		}
		
		public function toString():String
		{
			var buf:String = ""
			buf += "---------------------------------------------\n"
			buf += "Binary:  \t" + binary + "\n"
			buf += "Compressed:\t" + compressed + "\n"
			buf += "Encrypted:\t" + encrypted + "\n"
			buf += "BlueBoxed:\t" + blueBoxed + "\n"
			buf += "BigSized:\t" + bigSized + "\n"
			buf += "---------------------------------------------\n"
			
			return buf
		}
	}
}