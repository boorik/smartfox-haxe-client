package com.smartfoxserver.v2.exceptions;
import openfl.errors.Error;

/** @private */
class SFSCodecError extends Error
{
	public function new(message:String="", id:Int=0)
	{
		super(message, id);
	}	
}