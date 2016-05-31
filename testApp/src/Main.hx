package;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.requests.LoginRequest;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Vincent Blanchet
 */
class Main extends Sprite 
{
	var sfs:com.smartfoxserver.v2.SmartFox;

	public function new() 
	{
	
		super();
		
		sfs = new SmartFox(true);
		sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
		sfs.connect("localhost", 9933);
		//trace("Type:" + Type.typeof("toto"));
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
	}
	
	private function onConnection(e:SFSEvent):Void 
	{
		trace("connected");
		sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
		sfs.addEventListener(SFSEvent.LOGIN, onLogin);
		var loginCredentials = new SFSObject();
		var sid = "jhjhbjhb";
		var ck = "jhbjhjbjhb";
		loginCredentials.putUtfString("sid",sid);
		loginCredentials.putUtfString("key", ck);
		sfs.send( new LoginRequest("Booorik","","Chapatiz",loginCredentials) );
	}
	
	private function onLogin(e:SFSEvent):Void 
	{
		trace("logged");
	}
	
	private function onLoginError(e:SFSEvent):Void 
	{
		trace(e);
	}

}
