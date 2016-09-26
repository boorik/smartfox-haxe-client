package com.smartfoxserver.v2.util;
import openfl.utils.ByteArray;

/**
 * ...
 * @author vincent blanchet
 */
class CryptoKey
{
	public var iv(get, null):ByteArray;
	public var key(get, null):ByteArray;
	public function new(iv:ByteArray, key:ByteArray) 
	{
		this.iv = iv;
		this.key = key;	
	}
	
	function get_iv():ByteArray 
	{
		return iv;
	}
	
	function get_key():ByteArray 
	{
		return key;
	}
	
}