package com.smartfoxserver.v2.exceptions
{
	/** @private */
	public class SFSError extends Error
	{
		private var _details:String;
		
		public function SFSError(message:String, errorId:int = 0, extra:String = null)
		{
			super(message, errorId)
			_details = extra;
		}
		
		public function get details():String
		{
			return _details;
		}
	}
}