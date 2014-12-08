package com.smartfoxserver.v2.exceptions
{
	/** @private */
	public class SFSValidationError extends Error
	{
		private var _errors:Array
		
		public function SFSValidationError(message:String, errors:Array, errorId:int = 0)
		{
			super(message, errorId)
			_errors = errors
		}
		
		public function get errors():Array
		{
			return _errors
		}
	}
}