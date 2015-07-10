package com.smartfoxserver.v2.exceptions;
import openfl.errors.Error;

/** @private */
class SFSValidationError extends Error
{
	private var _errors:Array<Error>;
	
	public function new(message:String, errors:Array<Error>, errorId:Int=0)
	{
		super(message, errorId);
		_errors = errors;
	}
	
	public var errors(get_errors, null):Array<Error>;
 	private function get_errors():Array<Error>
	{
		return _errors;
	}
}