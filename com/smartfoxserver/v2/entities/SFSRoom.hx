package com.smartfoxserver.v2.entities;
import com.smartfoxserver.v2.entities.managers.SFSRoomManager;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
#if html5
@:native('SFS2X.SFSRoom')
extern class SFSRoom{
	var capacity:Int;
	var groupId:Int;
	var id:Int;
	var isGame:Bool;
	var isHidden:Bool;
	var isJoined:Bool;
	var isPasswordProtected:Bool;
	var maxSpectators:Int;
	var maxUsers:Int;
	var name:String;
	var properties:Dynamic;
	var spectatorCount:Int;
	var userCount:Int;

	public function new();

	function containsUser(user:SFSUser):Bool;
	function containsVariable(varName:String):Bool;
	function getPlayerList():Array<SFSUser>;
	function getRoomManager():SFSRoomManager;
	function getSpectatorList():Array<SFSUser>;
	function getUserById(id:Int):SFSUser;
	function getUserByName(name:String):SFSUser;
	function getUserList():Array<SFSUser>;
	function getVariable(varName:String):SFSRoomVariable;
	function getVariables():Array<SFSRoomVariable>;
	function toString():String;
}
#else
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.managers.IRoomManager;
import com.smartfoxserver.v2.entities.managers.IUserManager;
import com.smartfoxserver.v2.entities.managers.SFSUserManager;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.util.ArrayUtil;
import haxe.ds.StringMap;

/**
 * The<em>SFSRoom</em>object represents a SmartFoxServer Room entity on the client.
 * 
 *<p>The SmartFoxServer 2X client API are not aware of all the Rooms which exist on the server side,
 * but only of those that are joined by the user and those in the Room Groups that have been subscribed.
 * Subscribing to one or more Groups allows the client to listen to Room events in specific "areas" of the Zone,
 * without having to retrieve and keep synchronized the details of all available Rooms, thus reducing 
 * the traffic between the client and the server considerably.</p>
 * 
 *<p>The list of available Rooms is created after a successful login and it is kept updated continuously by the server.</p>
 * 
 * @see 	com.smartfoxserver.v2.SmartFox#roomManager SmartFox.roomManager
 * @see		com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
 * @see		com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest SubscribeRoomGroupRequest
 * @see		com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest UnsubscribeRoomGroupRequest
 * @see		com.smartfoxserver.v2.requests.ChangeRoomNameRequest ChangeRoomNameRequest
 * @see		com.smartfoxserver.v2.requests.ChangeRoomPasswordStateRequest ChangeRoomPasswordStateRequest
 * @see		com.smartfoxserver.v2.requests.ChangeRoomCapacityRequest ChangeRoomCapacityRequest
 */
class SFSRoom implements Room
{
	/** @private */
	private var _id:Int;
	
	/** @private */
	private var _name:String;
	
	/** @private */
	private var _groupId:String;
	
	/** @private */
	private var _isGame:Bool;
	
	/** @private */
	private var _isHidden:Bool;
	
	/** @private */
	private var _isJoined:Bool ;
	
	/** @private */
	private var _isPasswordProtected:Bool;
	
	/** @private */
	private var _isManaged:Bool;
	
	/** @private */
	private var _variables:StringMap<RoomVariable>;
	
	/** @private */
	private var _properties:Dynamic;
	
	/** @private */
	private var _userManager:IUserManager;
	
	/** @private */
	private var _maxUsers:Int;
	
	/** @private */
	private var _maxSpectators:Int;
	
	/** @private */
	private var _userCount:Int; 				// only for non joined rooms
	
	/** @private */
	private var _specCount:Int; 				// only for non joined rooms
	
	/** @private */
	private var _roomManager:IRoomManager;
	
	/** @private */
	public static function fromSFSArray(sfsa:ISFSArray):Room
	{
		// An MMORoom contains 14 properties
		var isMMORoom:Bool=sfsa.size()==14;
		
		var newRoom:Room=null;
		if(isMMORoom)
			newRoom=new MMORoom(sfsa.getInt(0), sfsa.getUtfString(1), sfsa.getUtfString(2));
		else
			newRoom=new SFSRoom(sfsa.getInt(0), sfsa.getUtfString(1), sfsa.getUtfString(2));
		
		newRoom.isGame = sfsa.getBool(3);
		newRoom.isHidden = sfsa.getBool(4);
		newRoom.isPasswordProtected = sfsa.getBool(5);
		newRoom.userCount = sfsa.getShort(6);
		newRoom.maxUsers = sfsa.getShort(7);
		
		// Room vars
		var varsList:ISFSArray = sfsa.getSFSArray(8);
		if(varsList.size()>0)
		{
			var vars:Array<RoomVariable> = [];
		
			for(j in 0...varsList.size())
			{
				var roomVariable:RoomVariable = SFSRoomVariable.fromSFSArray(varsList.getSFSArray(j));
				vars.push(roomVariable);
			}
			newRoom.setVariables(vars);
		}
		
		if(newRoom.isGame)
		{
			newRoom.spectatorCount = sfsa.getShort(9);
			newRoom.maxSpectators = sfsa.getShort(10);
		}
		
		if(isMMORoom)
		{
			var mmoRoom:MMORoom=cast(newRoom, MMORoom);
			mmoRoom.defaultAOI=Vec3D.fromArray(sfsa.getElementAt(11));
			
			// Check if map limits are non null
			if(!sfsa.isNull(13))
			{
				mmoRoom.lowerMapLimit=Vec3D.fromArray(sfsa.getElementAt(12));
				mmoRoom.higherMapLimit=Vec3D.fromArray(sfsa.getElementAt(13));
			}
		}
		
		return newRoom;
	}
	
	/**
	 * Creates a new<em>SFSRoom</em>instance.
	 * 
	 *<p><b>NOTE</b>:developers never istantiate a<em>SFSRoom</em>manually:this is done by the SmartFoxServer 2X API Internally.</p>
	 *  
	 * @param 	id		The Room id.
	 * @param 	name	The Room name.
	 * @param 	groupId	The id of the Group to which the Room belongs.
	 */
	public function new(id:Int, name:String, groupId:String="default")
	{
		_id = id;
		_name = name;
		_groupId = groupId;
		
		// default flags
		_isJoined = _isGame = _isHidden = false;
		_isManaged = true;
		
		// counters
		_userCount = _specCount = 0;
		
		_variables = new StringMap<RoomVariable>();
		_properties = {};
		_userManager = new SFSUserManager(null);	
	}
	
	/** @inheritDoc */
	public var id(get_id, null):Int;
 	private function get_id():Int
	{
		return _id;
	}
	
	/** @inheritDoc */
	public var name(get_name, set_name):String;
 	private function get_name():String	
	{
		return _name;
	}
	
	/** @private */
	private function set_name(value:String):String
	{
		return _name = value;
	}
	
	/** @inheritDoc */
	public var groupId(get_groupId, null):String;
 	private function get_groupId():String
	{
		return _groupId;
	}
	
	/** @inheritDoc */
	public var isGame(get_isGame, set_isGame):Bool;
 	private function get_isGame():Bool
	{
		return _isGame;		
	}
	
	/** @inheritDoc */
	public var isHidden(get_isHidden, set_isHidden):Bool;
 	private function get_isHidden():Bool
	{
		return _isHidden;
	}
	
	/** @inheritDoc */
	public var isJoined(get_isJoined, set_isJoined):Bool;
 	private function get_isJoined():Bool
	{
		return _isJoined;
	}
	
	/** @inheritDoc */
	public var isPasswordProtected(get, set):Bool;
 	private function get_isPasswordProtected():Bool
	{
		return _isPasswordProtected;
	}
	
	/** @private */
	private function set_isPasswordProtected(value:Bool):Bool
	{
		return _isPasswordProtected = value;	
	}
	
	/** @private */
	private function set_isJoined(value:Bool):Bool
	{
		return _isJoined = value;
	}
	
	/** @private */
	private function set_isGame(value:Bool):Bool
	{
		return _isGame = value;	
	}
	
	/** @private */
	private function set_isHidden(value:Bool):Bool
	{
		return _isHidden = value;
	}
	
	/** @private */
	public var isManaged(get_isManaged, set_isManaged):Bool;
 	private function get_isManaged():Bool
	{
		return _isManaged;
	}
	
	/** @private */
	private function set_isManaged(value:Bool):Bool
	{
		return _isManaged = value;
	}
	
	/** @inheritDoc */
	public function getVariables():Array<RoomVariable>
	{
		//return ArrayUtil.objToArray(_variables)	;
		return Lambda.array(_variables);
	}
	
	/** @inheritDoc */
	public function getVariable(name:String):RoomVariable
	{
		return _variables.get(name);
	}
	
	/*
	* If the room is joined the user count is taken from the Room's UserManager
	* otherwise we return the static counter(which will work only if you have activated the uCount updates)
	*/
	
	/** @inheritDoc */
	public var userCount(get_userCount, set_userCount):Int;
 	private function get_userCount():Int
	{
		// Return server count from UCountUpdate	
		if(!_isJoined)
			return _userCount;
		
		// Locally joined
		else 
		{
			// For game rooms, return only player count
			if(isGame)
				return playerList.length;
			
			// For regular rooms, return the full user count
			else 
				return _userManager.userCount;
		}
	}
	
	/** @inheritDoc */
	public var maxUsers(get_maxUsers, set_maxUsers):Int;
 	private function get_maxUsers():Int
	{
		return _maxUsers;
	}
	
	/** @inheritDoc */
	public var capacity(get_capacity, null):Int;
 	private function get_capacity():Int
	{
		return _maxUsers + _maxSpectators;
	}
	
	/** @inheritDoc */
	public var spectatorCount(get_spectatorCount, set_spectatorCount):Int;
 	private function get_spectatorCount():Int
	{
		// No spectators in regular rooms
		if(!isGame)
			return 0;
		
		// Joined Room? Dynamically calculate spectators
		if(_isJoined)
			return spectatorList.length;
		
		// Not joined, use the static value sent by the server
		else
			return _specCount;
	}
	
	/** @inheritDoc */
	public var maxSpectators(get_maxSpectators, set_maxSpectators):Int;
 	private function get_maxSpectators():Int
	{
		return _maxSpectators;
	}
	
	/** @private */
	private function set_userCount(value:Int):Int
	{
		return _userCount = value ;
	}
	
	/** @private */
	private function set_maxUsers(value:Int):Int
	{
		return _maxUsers = value;
	}
	
	/** @private */
	private function set_spectatorCount(value:Int):Int
	{
		return _specCount = value;
	}
	
	/** @private */
	private function set_maxSpectators(value:Int):Int
	{
		return _maxSpectators = value;
	}
	
	/** @inheritDoc */
	public function getUserByName(name:String):User
	{
		return _userManager.getUserByName(name);
	}
	
	/** @inheritDoc */
	public function getUserById(id:Int):User
	{
		return _userManager.getUserById(id);
	}
	
	/** @inheritDoc */
	public var userList(get_userList, null):Array<User>;
 	private function get_userList():Array<User>
	{
		return _userManager.getUserList();
	}
	
	/** @inheritDoc */
	public var playerList(get_playerList, null):Array<User>;
 	private function get_playerList():Array<User>
	{
		var playerList:Array<User> = [];
		
		for(user in _userManager.getUserList())
		{
			if(user.isPlayerInRoom(this))
				playerList.push(user);
		}
		
		return playerList;
	}
	
	/** @inheritDoc */
	public var spectatorList(get_spectatorList, null):Array<User>;
 	private function get_spectatorList():Array<User>
	{
		var spectatorList:Array<User> = [];
		
		for(user in _userManager.getUserList())
		{
			if(user.isSpectatorInRoom(this))
				spectatorList.push(user);
		}
		
		return spectatorList;
	}
	
	/** @private */
	public function removeUser(user:User):Void
	{
		_userManager.removeUser(user);
	}
	
	/** @private */
	public function setVariable(roomVariable:RoomVariable):Void
	{
		// If varType==NULL delete var
		if(roomVariable.isNull())
			_variables.remove(roomVariable.name);
		else{
			_variables.set(roomVariable.name, roomVariable);
		}
	}
	
	/** @private */
	public function setVariables(roomVariables:Array<RoomVariable>):Void
	{
		for(roomVar in roomVariables)
		{
			setVariable(roomVar);
		}
	}
	
	/** @inheritDoc */
	public function containsVariable(name:String):Bool
	{
		return _variables.exists(name) && _variables.get(name) != null;
	}
	
	/** @inheritDoc */
	public var properties(get_properties, set_properties):Dynamic;
 	private function get_properties():Dynamic
	{
		return _properties;
	}
	
	/** @private */
	private function set_properties(value:Dynamic):Dynamic
	{
		return _properties = value;
	}
	
	/** @private */
	public function addUser(user:User):Void
	{
		_userManager.addUser(user);
	}
	
	/** @inheritDoc */
	public function containsUser(user:User):Bool
	{
		return _userManager.containsUser(user);
	}
	
	/** @inheritDoc */
	public var roomManager(get_roomManager, set_roomManager):IRoomManager;
 	private function get_roomManager():IRoomManager
	{
		return _roomManager;
	}
	
	/** @private */
	private function set_roomManager(value:IRoomManager):IRoomManager
	{
		/** THIS IS INSANE BECAUSE _roomManager is never null
		if(_roomManager !=null)
			throw new SFSError("Room manager already assigned. Room:" + this);
		**/
		return _roomManager = value	;  
	}
	
	/** @private */
	public function setPasswordProtected(isProtected:Bool):Bool
	{
		return _isPasswordProtected = isProtected;
	}
	
	/**
	 * Returns a string that contains the Room id, name and id of the Group to which it belongs.
	 * 
	 * @return	The string representation of the<em>SFSRoom</em>object.
	 */
	public function toString():String
	{
		return "[Room:" + _name + ", Id:" + _id + ", GroupId:" + _groupId + "]"	;
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Private methods
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	public function merge(anotherRoom:Room):Void
	{
		// Clear all vars
		_variables= new StringMap<RoomVariable>();
		
		// Copy Variables
		for(rv in anotherRoom.getVariables())
			_variables.set(rv.name,rv);
		
		// Rebuild User List
		cast(_userManager,SFSUserManager).clearAll();
		
		for(user in anotherRoom.userList)
			_userManager.addUser(user);
		
	}
}
#end