package com.smartfoxserver.v2.requests;

/**
 * @private
 * 
 * This request is used by the API sub-system at connection time.
 * It's not Intended for other uses.
 */
class HandshakeRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_SESSION_TOKEN:String = "tk";
	
	/** @private */
	public static inline var KEY_API:String = "api";
	
	/** @private */
	public static inline var KEY_COMPRESSION_THRESHOLD:String = "ct";
	
	/** @private */
	public static inline var KEY_RECONNECTION_TOKEN:String = "rt";
	
	/** @private */
	public static inline var KEY_CLIENT_TYPE:String = "cl";
		
	/** @private */
	public static inline var KEY_MAX_MESSAGE_SIZE:String = "ms";
	
	public function new(apiVersion:String, clientDetails:String, reconnectionToken:String=null)
	{
		super(BaseRequest.Handshake);
		
		// api version
		_sfso.putUtfString(KEY_API, apiVersion);
		
		// client Type string
		_sfso.putUtfString(KEY_CLIENT_TYPE, clientDetails);

		// send reconnection token, if any
		if(reconnectionToken !=null)
			_sfso.putUtfString(KEY_RECONNECTION_TOKEN, reconnectionToken);
	}
}