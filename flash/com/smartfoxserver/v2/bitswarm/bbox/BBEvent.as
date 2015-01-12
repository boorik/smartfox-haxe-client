package com.smartfoxserver.v2.bitswarm.bbox
{
	import com.smartfoxserver.v2.core.BaseEvent;
	
	/** @private */
	public class BBEvent extends BaseEvent
	{
		public static const CONNECT:String = "bb-connect";
		public static const DISCONNECT:String = "bb-disconnect";
		public static const DATA:String = "bb-data";
		public static const IO_ERROR:String = "bb-ioError";
		public static const SECURITY_ERROR:String = "bb-securityError";
		
		public function BBEvent(type:String, params:Object = null)
		{
			super(type)
			this.params = params
		}
	}
}