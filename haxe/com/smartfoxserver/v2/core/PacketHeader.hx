package com.smartfoxserver.v2.core;

/** @private */
class PacketHeader
{
	private var _expectedLen:Int
	private var _binary:Bool
	private var _compressed:Bool
	private var _encrypted:Bool
	private var _blueBoxed:Bool
	private var _bigSized:Bool
	
	public function new(encrypted:Bool,
								compressed:Bool=false,
								blueBoxed:Bool=false,
								bigSized:Bool=false
							)
	{
		_expectedLen=-1
		
		_binary=true
		_compressed=compressed
		_encrypted=encrypted
		_blueBoxed=blueBoxed
		_bigSized=bigSized 
	}
	
	public static function fromBinary(headerByte:Int):PacketHeader
	{
		return new PacketHeader(
									(headerByte & 0x40)>0,
									(headerByte & 0x20)>0,
									(headerByte & 0x10)>0,
									(headerByte & 0x8)>0
							)
	}
	
	public var expectedLen(get_expectedLen, set_expectedLen):Int;
 	private function get_expectedLen():Int
	{
		return _expectedLen	
	}
	private function set_expectedLen(value:Int):Void
	{
		_expectedLen=value
	}
	
	public var binary(get_binary, set_binary):Bool;
 	private function get_binary():Bool
	{
		return _binary	
	}
	private function set_binary(value:Bool):Void
	{
		_binary=value
	}
	
	public var compressed(get_compressed, set_compressed):Bool;
 	private function get_compressed():Bool
	{
		return _compressed
	}
	private function set_compressed(value:Bool):Void
	{
		_compressed=value
	}
	
	public var encrypted(get_encrypted, set_encrypted):Bool;
 	private function get_encrypted():Bool
	{
		return	_encrypted
	}
	private function set_encrypted(value:Bool):Void
	{
		_encrypted=value	
	}
	
	public var blueBoxed(get_blueBoxed, set_blueBoxed):Bool;
 	private function get_blueBoxed():Bool
	{
		return	_blueBoxed	
	}
	
	private function set_blueBoxed(value:Bool):Void
	{
		_blueBoxed=value	
	}
	
	public var bigSized(get_bigSized, set_bigSized):Bool;
 	private function get_bigSized():Bool
	{
		return	_bigSized
	}
	private function set_bigSized(value:Bool):Void
	{
		_bigSized=value
	}
	
	public function encode():Int
	{
		var headerByte:Int=0
		
		if(binary)
			headerByte +=0x80
			
		if(encrypted)
			headerByte +=0x40
			
		if(compressed)
			headerByte +=0x20
			
		if(blueBoxed)
			headerByte +=0x10
		
		if(bigSized)
			headerByte +=0x08
			
		return headerByte
	}
	
	public function toString():String
	{
		var buf:String=""
		buf +="---------------------------------------------\n"
		buf +="Binary:\t" + binary + "\n"
		buf +="Compressed:\t" + compressed + "\n"
		buf +="Encrypted:\t" + encrypted + "\n"
		buf +="BlueBoxed:\t" + blueBoxed + "\n"
		buf +="BigSized:\t" + bigSized + "\n"
		buf +="---------------------------------------------\n"
		
		return buf
	}
}