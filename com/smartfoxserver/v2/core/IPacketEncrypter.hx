package com.smartfoxserver.v2.core;
import openfl.utils.ByteArray;

/**
 * ...
 * @author vincent blanchet
 */
interface IPacketEncrypter
{

	function encrypt(data:ByteArray):Void;		
	function decrypt(data:ByteArray):Void;
}