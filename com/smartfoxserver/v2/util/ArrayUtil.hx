package com.smartfoxserver.v2.util;

/** @private */
class ArrayUtil
{
	public function new()
	{
		throw "This class contains static methods only! Do not instaniate it";
	}
	
	public static function removeElement(arr:Array<Dynamic>, item:Dynamic):Void
	{
		var p:Int = arr.indexOf(item);
	
		if(p>-1)
			arr.splice(p, 1);
	}
	
	public static function copy(arr:Array<Dynamic>):Array<Dynamic>
	{
		var arrCopy:Array<Dynamic> = new Array();
		for(j in 0...arr.length)
			arrCopy[j] = arr[j];
			
		return arrCopy;
	}
	
	public static function objToArray(obj:Dynamic):Array<Dynamic>
	{
		var array:Array<Dynamic> = [];
		
		for(o in Reflect.fields(obj))
			array.push(Reflect.field(obj,o));
			
		return array;
	}
}