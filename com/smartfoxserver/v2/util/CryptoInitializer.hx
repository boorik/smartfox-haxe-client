package com.smartfoxserver.v2.util;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;

/**
 * ...
 * @author vincent blanchet
 */
class CryptoInitializer
{
	private static var KEY_SESSION_TOKEN:String = "SessToken";
	private static var TARGET_SERVLET:String = "/BlueBox/CryptoManager";
	
	private var sfs:SmartFox;
	private var httpReq:URLRequest;
	private var useHttps:Bool = true;
	
	public function new(sfs:SmartFox)
	{
		// These are not events because they should fail at test time.
		if (!sfs.isConnected)
			throw new IllegalOperationError("Cryptography cannot be initialized before connecting to SmartFoxServer!");
		
		if (sfs.socketEngine.cryptoKey != null)
			throw new IllegalOperationError("Cryptography is already initialized!");
		
		this.sfs = sfs;
		
		run();
	}
	
	private function run():Void
	{
		var targetUrl:String = 	"https://" + sfs.config.host + ":" +
								sfs.config.httpsPort + 
								TARGET_SERVLET;
		
		// Prepare HTTPS Request
		httpReq = new URLRequest(targetUrl);
		httpReq.method = URLRequestMethod.POST;
		
		// Configure loader
		var loader:URLLoader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, onHttpResponse);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onHttpIOError);
		loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onHttpIOError);
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		
		// Request params
		var vars:URLVariables = new URLVariables();
		Reflect.setField(vars,KEY_SESSION_TOKEN,sfs.sessionToken);
		httpReq.data = vars;
		
		//urlLoader.data = vars;
		loader.load(httpReq);
	}
	
}