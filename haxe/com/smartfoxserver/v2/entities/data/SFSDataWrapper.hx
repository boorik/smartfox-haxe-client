package com.smartfoxserver.v2.entities.data;

/**
 * @private
 * 
 * A wrapper object used by SFSObject and SFSArray to encapsulate data and relative types.
 */
class SFSDataWrapper
{
	private var _type:Int;
	private var _data:Dynamic;
	
	public function new(type:Int, data:Dynamic)
	{
		this._type = type;
		this._data = data;
	}
	
	public var type(get_type, null):Int;
 	private function get_type():Int
	{
		return _type;
	} 
	
	public var data(get_data, null):Dynamic;
 	private function get_data():Dynamic
	{
		return _data;
	}
}