package com.smartfoxserver.v2.exceptions;

/** @private */
import com.smartfoxserver.v2.errors.Error;
class SFSCodecError extends Error
{
	public function new(message:String="", id:Int=0)
	{
		super(message, id);
	}	
}