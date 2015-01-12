package com.smartfoxserver.v2.exceptions;

/** @private */
class SFSValidationError extends Dynamic
{
	private var _errors:Array
	
	public function new(message:String, errors:Array, errorId:Int=0)
	{
		super(message, errorId)
		_errors=errors
	}
	
	public var errors(get_errors, null):Array;
 	private function get_errors():Array
	{
		return _errors
	}
}