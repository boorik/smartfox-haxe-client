package com.smartfoxserver.v2.exceptions;

/** @private */
class SFSError extends Dynamic
{
	private var _details:String;
	
	public function new(message:String, errorId:Int=0, extra:String=null)
	{
		super(message, errorId)
		_details=extra;
	}
	
	public var details(get_details, null):String;
 	private function get_details():String
	{
		return _details;
	}
}