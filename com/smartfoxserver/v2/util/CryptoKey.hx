package com.smartfoxserver.v2.util;
import openfl.utils.ByteArray;

/**
 * ...
 * @author vincent blanchet
 */
class CryptoKey
{
	private var _iv(get, null):ByteArray;
	private var _key(get, null):ByteArray;
	public function new(iv:ByteArray, key:ByteArray) 
	{
		this._iv = iv;
		this._key = key;	
	}
	
	function get_iv():ByteArray 
	{
		return _iv;
	}
	
	function get_key():ByteArray 
	{
		return _key;
	}
	
}