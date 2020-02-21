package com.smartfoxserver.v2.util;
import haxe.Http;
import com.hurlant.util.Base64;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.util.ByteArray;
import com.hurlant.util.Endian;

/**
 * ...
 * @author vincent blanchet
 */
class CryptoInitializer
{
	private static var KEY_SESSION_TOKEN:String = "SessToken";
	private static var TARGET_SERVLET:String = "/BlueBox/CryptoManager";
	private var sfs:SmartFox;
	private var useHttps:Bool = true;
	
	public function new(sfs:SmartFox)
	{
		// These are not events because they should fail at test time.
		if (!sfs.isConnected)
			throw "Cryptography cannot be initialized before connecting to SmartFoxServer!";

		if (sfs.socketEngine.cryptoKey != null)
			throw "Cryptography is already initialized!";

		this.sfs = sfs;

		run();
	}
	
	private function run():Void
	{
		var targetUrl:String = 	"https://" + sfs.config.host + ":" +
								sfs.config.httpsPort + 
								TARGET_SERVLET;

		var httpReq:Http = new Http(targetUrl);
		httpReq.cnxTimeout = 30;
		httpReq.onError = function(msg:String)
		{
			sfs.logger.warn("onError: " + msg);
			sfs.dispatchEvent( new SFSEvent(SFSEvent.CRYPTO_INIT, {success: false, errorMsg: msg}) );
		};
		httpReq.onData = function(rawData:String)
		{
			var byteData:ByteArray = cast Base64.decodeToByteArray(rawData);

			var iv:ByteArray = new ByteArray();
			iv.endian = Endian.BIG_ENDIAN;
			var key:ByteArray = new ByteArray();
			key.endian = Endian.BIG_ENDIAN;

			// Extract the key and init vector and pass them to the BitSwarmClient
			key.writeBytes(byteData, 0, 16);
			iv.writeBytes(byteData, 16, 16);

			sfs.socketEngine.cryptoKey = new CryptoKey(iv, key);

			sfs.dispatchEvent( new SFSEvent(SFSEvent.CRYPTO_INIT, { success:true }) );
		}
		httpReq.setPostData(KEY_SESSION_TOKEN + "=" + sfs.sessionToken);
		httpReq.request(true);
	}
}