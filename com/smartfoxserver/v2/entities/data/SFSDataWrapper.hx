package com.smartfoxserver.v2.entities.data;

/**
 * @private
 * 
 * A wrapper object used by SFSObject and SFSArray to encapsulate data and relative types.
 */

#if !html5

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

#else

abstract SFSDataWrapper (SFSDataWrapperExtern)
{
	public var type (get,never):Int;
	public var data (get,never):Dynamic;

	public inline function new (type:Int, data:Dynamic)
	{
		this = cast { type: type, value:data };
	}

	private inline function get_data ():Dynamic return this.value;
	private inline function get_type ():Dynamic return this.type;
}

@:native('SFS2X.SFSDataWrapper')
private extern class SFSDataWrapperExtern
{
	public var type(default,null):Int;
	public var value(default, null):Dynamic;
}

#end