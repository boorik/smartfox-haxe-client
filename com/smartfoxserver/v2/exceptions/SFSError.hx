package com.smartfoxserver.v2.exceptions;
import openfl.errors.Error;

/** @private */
class SFSError extends Error
{
	private var _details:String;
	
	public function new(message:String, errorId:Int=0, extra:String=null)
	{
		super(message, errorId);
		_details=extra;
	}
	
	#if (openfl <= "9.1.0")
	public var details(get, null):String;
 	private override function get_details():String
	{
		return _details;
	}
	#end
}
