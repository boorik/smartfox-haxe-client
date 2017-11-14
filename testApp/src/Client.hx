package;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.MMORoom;
import com.smartfoxserver.v2.entities.MMOItem;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.mmo.SetUserPositionRequest;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.core.SFSBuddyEvent;
import flash.utils.ByteArray;
//import tools.SFSObjectTool;
/**
 * ...
 * @author vincent blanchet
 */
class Client
{
	var nick:String;
	var sfs:SmartFox;

	public var onTurn:Int->String->Void;
	public var onRoomJoined:String->Float->Float->flash.display.BitmapData->Void;
	public var onLoginCB:Bool->Void;

	public var currentTurn:String;
	public var currentTurnId:Int;
	public var me(get, null):com.smartfoxserver.v2.entities.SFSUser;
	public var log:String->Void;
	
    var onConnectionCB:Bool->Void;
	public var onUserAdded:User->Void;
	public var onUserRemoved:User->Void;
	public var onUserMoved:User->Float->Float->String->Void;
	public var onItemAdded:MMOItem->Bool->Void;
	public var onItemRemoved:MMOItem->Void;
	public var onBuddyList:Array<Buddy>->Void;
	public var onPublicMessage:User->String->Void;

	static inline var USERVAR_X = "x";
	static inline var USERVAR_Y = "y";
	static inline var USERVAR_DIR = "dir";
	static inline var MMOITEMVAR_OPEN = "open";

	public function new(name:String) 
	{
        nick = name;
	}
	
	private function onUserExit(e:SFSEvent):Void 
	{
		#if html5
		log("User disconnected :" + e.user.name);
		#else
		log("User disconnected :" + e.params.user.name);
		#end
	}
	
	private function run(e:SFSEvent):Void 
	{
		trace("on extension response");
		var extParams:SFSObject = #if html5 e.params #else e.params.params #end;

/* 		switch(e.parameters.cmd)
		{
			case Commands.TURN :
				currentTurn = extParams.getUtfString("name");
				currentTurnId = extParams.getInt("id");
				trace('it is $currentTurn\'s turn');
				if (onTurn != null)
					onTurn(currentTurnId,currentTurn);
					
			case Commands.MOVE :
				var move : Move = null;//SFSObjectTool.sfsObjectToInstance(extParams);
		
			case Commands.WAIT_OPPONENT:
				log("Game joined, waiting for opponent...");
					
		} */
	}
	
	//public function move(move:Move):Void{
//sfs.send(new ExtensionRequest(Commands.MOVE, SFSObjectTool.instanceToSFSObject(move)));
	//}
	/**
	 * player is ready
	 */
	// public function ready():Void{
		// sfs.send(new ExtensionRequest(Commands.READY));
	// }
	
	public function leaveGame():Void
	{
		sfs.send(new LeaveRoomRequest());
	}
	
	// public function play():Void
	// {
		// log("Sending request for joining a game.");
		// sfs.send(new ExtensionRequest(Commands.PLAY));
	// }
	
	
	public function connect(cb:Bool->Void):Void
	{
        this.onConnectionCB = cb;

		#if !html5 
		var config:com.smartfoxserver.v2.util.ConfigData = new com.smartfoxserver.v2.util.ConfigData();
		config.httpPort = 8080;
		config.useBlueBox = false;
		#else
		var config:com.smartfoxserver.v2.SmartFox.ConfigObj = {host:"",port:0,useSSL:false,zone:"",debug:false};
		#end
		//config.debug = true;
		config.host = "sfs2x.boorik.com";
		config.port = #if html5 8080 #else 9933 #end;
		config.zone = "SimpleMMOWorld2";
		#if html5
		sfs = new com.smartfoxserver.v2.SmartFox(config);
		//sfs.logger.level = 0;
		#else
		sfs = new com.smartfoxserver.v2.SmartFox();
		#end
		sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
        /*
		sfs.addEventListener(SFSEvent.SOCKET_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
		sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, run);
		sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
		sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
		sfs.addEventListener(SFSEvent.PROXIMITY_LIST_UPDATE, onProximityListUpdate);
		sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVariableUpdate);
		sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessageCB);
		sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE, onPublicMessageCB);
        */
		trace("config:" + config);
		try{
		#if html5
		sfs.connect();
		#else
		sfs.connectWithConfig(config);
		#end
		}catch (e:Dynamic){
			trace(e+" " + haxe.CallStack.toString( haxe.CallStack.exceptionStack()));
		}
	}

	private function onUserVariableUpdate(e:SFSEvent):Void 
	{
		//trace("===> onUserVariableUpdate");
		var changedVars:Array<String> = e.parameters.changedVars;
		var user:User = e.parameters.user;
		
		// Check if the user changed his position
		if (changedVars.indexOf(USERVAR_X) != -1 || changedVars.indexOf(USERVAR_Y) != -1)
		{
			var px = user.getVariable(USERVAR_X).getDoubleValue();
			var py = user.getVariable(USERVAR_Y).getDoubleValue();
			var dir = user.getVariable(USERVAR_DIR).getStringValue();
			// Move the user avatar
			onUserMoved(user,px,py,dir);
		}
	}
	
	private function onProximityListUpdate(e:SFSEvent):Void 
	{
		
		//log("Proximity update : " + e.parameters.room + " addedUsers:" + e.parameters.addedUsers + " removedUsers:" + e.parameters.removedUsers);
		var au:Array<User> = e.parameters.addedUsers;
		if (au.length > 0 )
		{
			for(u in au)
				onUserAdded(u);
		}
		var ru:Array<User> = e.parameters.removedUsers;
		if (ru.length > 0 )
		{
			for(u in ru)
				onUserRemoved(u);
		}
		var removedItems:Array<MMOItem> = e.parameters.removedItems;
		if(removedItems.length >0)
		{
			for(i in removedItems)
			{
				onItemRemoved(i);
			}
		}
		var addedItems:Array<MMOItem> = e.parameters.addedItems;
		if(addedItems.length >0)
		{
			for(i in addedItems)
			{
				trace("item in AOI :"+i);
				onItemAdded(i,i.getVariable(MMOITEMVAR_OPEN).getBoolValue());
			}
		}
	}
	
	private function onConnectionLost(e:SFSEvent):Void 
	{
		log("Connection lost!!!");
	}

	function onRoomFound(e:SFSEvent)
	{
		trace("rooms:"+e.parameters.rooms);
	}

	public function joinRoom(roomName:String)
	{
		sfs.send(new com.smartfoxserver.v2.requests.JoinRoomRequest(roomName));
	}
	
	private function onRoomJoin(e:SFSEvent):Void 
	{
		trace("toto:" + e.parameters);
		var r:com.smartfoxserver.v2.entities.Room = e.parameters.room;
		log("Room joined:" + r.name);
		

		// Retrieve Room Variable containing access points coordinates
		// (see Extension comments to understand how data is organized)
		var mapData:SFSObject = cast r.getVariable("mapData").getSFSObjectValue();
		var accessPoints = mapData.getIntArray("accessPoints");

		// Select a random access point among those available
		var index = Math.floor(Math.random() * accessPoints.length / 2) * 2;
		var accessX = accessPoints[index];
		var accessY = accessPoints[index + 1];
		sfs.send(new SetUserPositionRequest(new Vec3D(accessX,accessY,0)));

		var ba: ByteArray =  mapData.getByteArray("hitmap");
		var bmpData:lime.app.Future<openfl.display.BitmapData> = flash.display.BitmapData.loadFromBytes(ba);
		bmpData.onComplete(function(bd:openfl.display.BitmapData){
			onRoomJoined(r.name,accessX,accessY,bd);
		});
		
	}
	private function onConnection(e:SFSEvent):Void 
	{
		trace('e.parameters.success : ${e.parameters.success}');
        onConnectionCB(e.parameters.success);
	}

    public function login(zone:String,cb:Bool->Void)
    {
        onLoginCB = cb;
        sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
        sfs.addEventListener(SFSEvent.LOGIN, onLogin);
	    sfs.send(new LoginRequest(nick, null, zone));
    }

    private function onLogin(e:SFSEvent):Void 
	{
        trace("pouet");
		onLoginCB(true);
	}

    function onLoginError(e:SFSEvent)
    {
        onLoginCB(false);
    }	

    public function matchEquals()
    {
    	var exp = new com.smartfoxserver.v2.entities.match.MatchExpression(
			com.smartfoxserver.v2.entities.match.RoomProperties.IS_GAME,
			com.smartfoxserver.v2.entities.match.BoolMatch.EQUALS,
			false);

		trace(com.smartfoxserver.v2.entities.match.BoolMatch.EQUALS);
		trace("condition:"+exp.condition);
		var req = new com.smartfoxserver.v2.requests.FindRoomsRequest(exp);
		sfs.addEventListener(SFSEvent.ROOM_FIND_RESULT,onRoomFound);
		sfs.send(req);
    }

	private function onSocketError(e:SFSEvent):Void 
	{
		log("socket error:" + e.parameters);
	}
	
	public function isAvailable():Bool
	{
		return sfs.isConnected;
	}
	
	public function destroy():Void
	{
		sfs.removeEventListener(SFSEvent.CONNECTION, onConnection);
		sfs.removeEventListener(SFSEvent.SOCKET_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.LOGIN_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.ROOM_CREATION_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.ROOM_JOIN_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
		sfs.removeEventListener(SFSEvent.EXTENSION_RESPONSE, run);
		sfs.removeEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
		sfs.removeEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
	}
	
	function get_me():com.smartfoxserver.v2.entities.SFSUser 
	{
		return cast sfs.mySelf;
	}

	public function aoi():Vec3D{
		var r:MMORoom = cast sfs.lastJoinedRoom;
		return r.defaultAOI;
	}

	public function sendPosition(x:Float,y:Float,dir:String)
	{
		//trace("pos:"+x+", "+y);
		var userVars:Array<UserVariable> = [];
		userVars.push(new SFSUserVariable(USERVAR_X, x));
		userVars.push(new SFSUserVariable(USERVAR_Y, y));
		userVars.push(new SFSUserVariable(USERVAR_DIR, dir));

		sfs.send(new com.smartfoxserver.v2.requests.SetUserVariablesRequest(userVars));
		sfs.send(new SetUserPositionRequest(new Vec3D(Std.int(x),Std.int(y),0)));
	}

	public function initBuddyList()
	{
		trace("sending init buddy request");
		sfs.addEventListener(SFSBuddyEvent.BUDDY_ADD,onBuddyListInitialized);
		sfs.addEventListener(SFSBuddyEvent.BUDDY_REMOVE,onBuddyListInitialized);
		sfs.addEventListener(SFSBuddyEvent.BUDDY_LIST_INIT,onBuddyListInitialized);
		sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR,onBuddyListError);
		sfs.send(new com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest());
	}

	function onBuddyListError(e:SFSBuddyEvent)
	{
		trace(e);
	}


	function onBuddyListInitialized(e:SFSBuddyEvent)
	{
		trace("IsInited:" + sfs.buddyManager.isInited);
		
		trace("Buddy list inited");
		var buddies:Array<Buddy> = sfs.buddyManager.buddyList;

		onBuddyList(buddies);

	}

	public function addBuddy(u:User)
	{
		trace("user name:"+u.name);
		if(!sfs.buddyManager.containsBuddy(u.name))
			sfs.send(new com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest(u.name));
	}

	public function removeBuddy(b:Buddy)
	{
		if(sfs.buddyManager.containsBuddy(b.name))
			sfs.send(new com.smartfoxserver.v2.requests.buddylist.RemoveBuddyRequest(b.name));
	}

	function onPublicMessageCB(e:SFSEvent)
	{
		
		onPublicMessage(e.parameters.sender,e.parameters.message);
	}

	public function sendPublic(msg:String)
	{
		sfs.send(new com.smartfoxserver.v2.requests.PublicMessageRequest(msg));
	}
	
	public function sendPrivate(name:String,msg:String)
	{
		var u = sfs.userManager.getUserByName(name);
		if(u!=null)
		{
			sfs.send(new com.smartfoxserver.v2.requests.PrivateMessageRequest(msg,u.id));
		}
	}

	public function itemClicked(id:Int)
	{
		var params = new SFSObject();
		params.putInt("id",id);
		sfs.send(new ExtensionRequest("barrelClick",params,sfs.lastJoinedRoom));
	}
}