package com.smartfoxserver.v2.bitswarm.bbox;

import com.smartfoxserver.v2.core.BaseEvent;

/** @private */
class BBEvent extends BaseEvent
{
	public static inline var CONNECT:String="bb-connect";
	public static inline var DISCONNECT:String="bb-disconnect";
	public static inline var DATA:String="bb-data";
	public static inline var IO_ERROR:String="bb-ioError";
	public static inline var SECURITY_ERROR:String="bb-securityError";
	
	public function new(type:String, params:Dynamic=null)
	{
		super(type);
		this.params = params;
	}
}