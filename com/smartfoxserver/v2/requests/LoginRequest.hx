package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

import com.smartfoxserver.v2.util.ByteArray;

/**
 * Logs the current user in one of the server Zones.
 * 
 *<p>Each Zone represent an independent multiuser application governed by SmartFoxServer. In order to join a Zone, a user name and password are usually required.
 * In order to validate the user credentials, a custom login process should be implemented in the Zone's server-side Extension.</p>
 * 
 *<p>Read the SmartFoxServer 2X documentation about the login process for more informations.</p>
 * 
 *<p>If the login operation is successful, the current user receives a<em>login</em>event;otherwise the<em>loginError</em>event is fired.</p>
 * 
 * @example	The following example performs a login in the "SimpleChat" Zone:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.LOGIN, onLogin);
 * 	sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
 * 	
 * 	// Login
 * 	sfs.send(new LoginRequest("FozzieTheBear", "", "SimpleChat"));
 * }
 * 
 * private function onLogin(evt:SFSEvent):Void
 * {
 * 	trace("Login successful!");
 * }
 * 
 * private function onLoginError(evt:SFSEvent):Void
 * {
 * 	trace("Login failure:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:login login event
 * @see		com.smartfoxserver.v2.SmartFox#event:loginError loginError event
 */
class LoginRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ZONE_NAME:String = "zn";
	
	/** @private */
	public static inline var KEY_USER_NAME:String = "un";
	
	/** @private */
	public static inline var KEY_PASSWORD:String = "pw";
	
	/** @private */
	public static inline var KEY_PARAMS:String = "p";
	
	/** @private */
	public static inline var KEY_PRIVILEGE_ID:String = "pi";
	
	/** @private */
	public static inline var KEY_ID:String = "id";
	
	/** @private */
	public static inline var KEY_ROOMLIST:String = "rl";
	
	/** @private */
	public static inline var KEY_RECONNECTION_SECONDS:String = "rs";
	
	private var _zoneName:String;
	private var _userName:String;
	private var _password:String;
	private var _params:ISFSObject;
	
	/**
	 * Creates a new<em>LoginRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	userName	The name to be assigned to the user. If not passed and if the Zone allows guest users, the name is generated automatically by the server.
	 * @param	password	The user password to access the system. SmartFoxServer doesn't offer a default authentication system,
	 * 						so the password must be validated implementing a custom login system in the Zone's server-side Extension.
	 * @param	zoneName	The name(case-sensitive)of the server Zone to login to;if a Zone name is not specified, the client will use the setting loaded via<em>SmartFox.loadConfig()</em>method.
	 * @param	params		An instance of<em>SFSObject</em>containing custom parameters to be passed to the Zone Extension(requires a custom login system to be in place).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.SmartFox#loadConfig()SmartFox.loadConfig()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(userName:String="", password:String="", zoneName:String="", params:ISFSObject=null)
	{
		super(BaseRequest.Login);

		_zoneName = zoneName;
		_userName = userName;
		_password = (password == null)? "":password;
		_params = params	;
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		// zone name
		_sfso.putUtfString(KEY_ZONE_NAME, _zoneName);
		
		// user name
		_sfso.putUtfString(KEY_USER_NAME, _userName);
		
		/*
		* password:use secure login system based on CHAP technique
		* http://www.networkworld.com/newsletters/web/2004/0419web1.html
		*/
		if(_password.length>0)
			_password = getMD5Hash(sfs.sessionToken + _password);
		
		_sfso.putUtfString(KEY_PASSWORD, _password);
		
		//(optional)params
		if(_params !=null)
			_sfso.putSFSObject(KEY_PARAMS, _params);
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		if(sfs.mySelf !=null)
			throw new SFSValidationError("LoginRequest Dynamic", ["You are already logged in. Logout first"]);
		
		// Attempt to use config data, if any
		if ((_zoneName == null || _zoneName.length == 0) && sfs.config != null)
			_zoneName = sfs.config.zone;
		
		if(_zoneName==null || _zoneName.length==0)
			throw new SFSValidationError("LoginRequest Dynamic", ["Missing Zone name"]);
	}
	
	/**
	 * -----------------------------------------------------------------
	 * UPDATED since version 0.9.4
	 * -----------------------------------------------------------------
	 * Adobe's CoreLib is bugged, the MD5 class doesn't return correct hashes when using certain UTF-8 multibyte chars.
	 * We are now using CryptoLib from -->http://code.google.com/p/as3crypto/
	 */
	private function getMD5Hash(text:String):String
	{
		return haxe.crypto.Md5.encode(text);
	}
}