package com.smartfoxserver.v2.requests
{
	import flash.system.Capabilities;
	import flash.system.System;
	
	/**
	 * @private
	 * 
	 * This request is used by the API sub-system at connection time.
	 * It's not intended for other uses.
	 */
	public class HandshakeRequest extends BaseRequest
	{
		/** @private */
		public static const KEY_SESSION_TOKEN:String = "tk"
		
		/** @private */
		public static const KEY_API:String = "api"
		
		/** @private */
		public static const KEY_COMPRESSION_THRESHOLD:String = "ct"
		
		/** @private */
		public static const KEY_RECONNECTION_TOKEN:String = "rt"
		
		/** @private */
		public static const KEY_CLIENT_TYPE:String = "cl"
			
		/** @private */
		public static const KEY_MAX_MESSAGE_SIZE:String = "ms"
		
		public function HandshakeRequest(apiVersion:String, clientDetails:String, reconnectionToken:String = null)
		{
			super(BaseRequest.Handshake)
			
			// api version
			_sfso.putUtfString(KEY_API, apiVersion)
			
			// client Type string
			_sfso.putUtfString(KEY_CLIENT_TYPE, clientDetails)
	
			// send reconnection token, if any
			if (reconnectionToken != null)
				_sfso.putUtfString(KEY_RECONNECTION_TOKEN, reconnectionToken)	
		}
	}
}