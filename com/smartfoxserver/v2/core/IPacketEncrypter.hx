package com.smartfoxserver.v2.core;
import com.smartfoxserver.v2.util.ByteArray;

/**
 * ...
 * @author vincent blanchet
 */
interface IPacketEncrypter
{

	function encrypt(data:ByteArray):Void;		
	function decrypt(data:ByteArray):Void;
}