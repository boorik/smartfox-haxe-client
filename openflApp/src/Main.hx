package;

import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.PublicMessageRequest;
import com.smartfoxserver.v2.SmartFox;
import openfl.display.Sprite;


class Main extends Sprite
{
	private var sfs:SmartFox;
	private var useWebSocket:Bool = true;
	private static inline var WS_PORT:Int = 8080;
	private static inline var WSS_PORT:Int = 8443;
	private static inline var SOCKET_PORT:Int = 9933;

	public function new()
	{
		super();
		sfs = new SmartFox(true);
		sfs.useWebSocket = useWebSocket; //Optional for non-html5 platforms
		sfs.useSSL = false;
		sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
		sfs.addEventListener(SFSEvent.LOGIN, onLogin);
		sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
		sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessage);
		if(useWebSocket)
		{
			sfs.connect("127.0.0.1", sfs.useSSL ? WSS_PORT : WS_PORT);
		}else{
			sfs.connect("127.0.0.1", SOCKET_PORT);
		}
	}

	private function onConnection(e:SFSEvent):Void
	{
		trace("onConnection");
		sfs.send(new LoginRequest("Guest#" + Std.random(10000),"","BasicExamples"));
	}

	private function onLogin(e:SFSEvent):Void
	{
		trace("onLogin");
		sfs.send(new JoinRoomRequest("The Lobby"));
	}

	private function onRoomJoin(e:SFSEvent):Void
	{
		trace("onRoomJoin");
		sfs.send(new PublicMessageRequest("PublicMessageRequest test!"));
	}

	private function onPublicMessage(e:SFSEvent):Void
	{
		trace("onPublicMessage");
		var message:String = e.params.message;
		var user:User = e.params.sender;
		trace(user.name, message);
	}
}