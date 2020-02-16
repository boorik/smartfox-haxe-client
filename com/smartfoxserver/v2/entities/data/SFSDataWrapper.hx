package com.smartfoxserver.v2.entities.data;

/**
 * @private
 * 
 * A wrapper object used by SFSObject and SFSArray to encapsulate data and relative types.
 */

class SFSDataWrapper
{
	public var type(default, null):Int;
	public var data(default, null):Dynamic;

	public function new(type:Int, data:Dynamic)
	{
		this.type = type;
		this.data = data;
	}
}