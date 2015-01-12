package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.core.BaseEvent;

/** @private */
class BitSwarmEvent extends BaseEvent
{
	public static inline var CONNECT:String = "connect";
	public static inline var DISCONNECT:String = "disconnect";
	public static inline var RECONNECTION_TRY:String = "reconnectionTry";
	public static inline var IO_ERROR:String = "ioError";
	public static inline var SECURITY_ERROR:String = "securityError";
	public static inline var DATA_ERROR:String = "dataError";
	
	public function new(type:String, params:Dynamic=null)
	{
		super(type);
		this.params = params;
	}
}