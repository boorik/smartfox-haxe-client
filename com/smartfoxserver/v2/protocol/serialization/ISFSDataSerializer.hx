package com.smartfoxserver.v2.protocol.serialization;

import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;

import com.smartfoxserver.v2.util.ByteArray;

/** @private */
interface ISFSDataSerializer
{
	function object2binary(object:ISFSObject):ByteArray;
	function array2binary(array:ISFSArray):ByteArray;
	function binary2object(data:ByteArray):ISFSObject;
	function binary2array(data:ByteArray):ISFSArray;
}