package;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.PublicMessageRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.SmartFox;
import openfl.events.Event;
import openfl.display.Sprite;


class Main extends Sprite
{
	private var sfs:SmartFox;
	public function new()
	{
		super();
		sfs = new SmartFox(true);
		sfs.useWebSocket = true; //Optional for non-html5 platforms
		sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
		sfs.addEventListener(SFSEvent.LOGIN, onLogin);
		sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
		sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessage);
		sfs.connect("127.0.0.1", 8080);
	}

	private function onConnection(e:SFSEvent):Void
	{
		sfs.send(new LoginRequest("Guest#10000","","BasicExamples"));
	}

	private function onLogin(e:SFSEvent):Void
	{
		sfs.send(new JoinRoomRequest("The Lobby"));
	}

	private function onRoomJoin(e:SFSEvent):Void
	{
		sfs.send(new PublicMessageRequest("PublicMessageRequest test!"));
	}

	private function onPublicMessage(e:SFSEvent):Void
	{
		var message:String = e.params.message;
		var user:User = e.params.sender;
		trace(user.name, message);
	}
}