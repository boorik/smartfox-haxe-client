package com.smartfoxserver.v2.exceptions
{
	/** @private */
	public class SFSCodecError extends Error
	{
		public function SFSCodecError(message:String="", id:int=0)
		{
			super(message, id);
		}	
	}
}