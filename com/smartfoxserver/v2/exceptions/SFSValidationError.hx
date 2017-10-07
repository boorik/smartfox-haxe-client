package com.smartfoxserver.v2.exceptions;
import openfl.errors.Error;

/** @private */
class SFSValidationError extends Error
{
	private var _errors:Array<String>;
	
	public function new(message:String, errors:Array<String>, errorId:Int=0)
	{
		super(message, errorId);
		_errors = errors;
	}
	
	public var errors(get_errors, null):Array<String>;
 	private function get_errors():Array<String>
	{
		return _errors;
	}
}