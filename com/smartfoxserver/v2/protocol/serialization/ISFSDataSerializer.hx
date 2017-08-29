package com.smartfoxserver.v2.protocol.serialization;

import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

import flash.utils.ByteArray;

/** @private */
interface ISFSDataSerializer
{
	function object2binary(object:SFSObject):ByteArray;
	function array2binary(array:SFSArray):ByteArray;
	function binary2object(data:ByteArray):SFSObject;
	function binary2array(data:ByteArray):SFSArray;
}