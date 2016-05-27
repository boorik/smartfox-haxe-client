package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Logs the user out of the current server Zone.
 * 
 *<p>The user is notified of the logout operation by means of the<em>logout</em>event.
 * This doesn't shut down the connection, so the user will be able to login again in the same Zone or in a different one right after the confirmation event.</p>
 * 
 * @example	The following example performs a logout from the current Zone:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.LOGOUT, onLogout);
 * 	
 * 	// Logout
 * 	sfs.send(new LogoutRequest());
 * }
 * 
 * private function onLogout(evt:SFSEvent):Void
 * {
 * 	trace("Logout executed!");
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:logout logout event
 */
class LogoutRequest  extends BaseRequest
{
	/** @private */
	public static inline var KEY_ZONE_NAME:String = "zn";
	
	/**
	 * Creates a new<em>LogoutRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new()
	{
		super(BaseRequest.Logout);
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		if(sfs.mySelf==null)
			throw new SFSValidationError("LogoutRequest Dynamic", ["You are not logged in a the moment!"]);
	}
}