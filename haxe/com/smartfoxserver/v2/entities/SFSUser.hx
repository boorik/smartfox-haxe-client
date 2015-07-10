package com.smartfoxserver.v2.entities;

import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.managers.IUserManager;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.exceptions.SFSError;
import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * The<em>SFSUser</em>object represents a client logged in SmartFoxServer.
 * 
 *<p>The SmartFoxServer 2X client API are not aware of all the clients(users)connected to the server,
 * but only of those that are in the same Rooms joined by the current client;this reduces the traffic between the client and the server considerably.
 * In order to Interact with other users the client should join other Rooms or use the Buddy List system to keep track of and Interact with friends.</p>
 * 
 * @see com.smartfoxserver.v2.SmartFox#userManager SmartFox.userManager
 */
class SFSUser implements User
{
	/** @private */
	private var _id:Int = -1;
	
	/** @private */
	private var _privilegeId:Int = 0;
	
	/** @private */
	private var _name:String;
	
	/** @private */
	private var _isItMe:Bool;
	
	/** @private */
	private var _variables:StringMap<Dynamic>;
	
	/** @private */
	private var _properties:Dynamic;
	
	/** @private */
	private var _isModerator:Bool;
	
	/** @private */
	private var _playerIdByRoomId:IntMap<Int>;
	
	/** @private */
	private var _userManager:IUserManager;
	
	/** @private */
	private var _aoiEntryPoint:Vec3D;
	
	/** @private */
	public static function fromSFSArray(sfsa:ISFSArray, room:Room=null):User
	{
		// Pass id and name
		var newUser:User = new SFSUser(sfsa.getInt(0), sfsa.getUtfString(1));
		
		// Set privileges
		newUser.privilegeId = sfsa.getShort(2);
		
		// Set playerId
		if(room !=null)
			newUser.setPlayerId(sfsa.getShort(3), room);
		
		// Populate variables
		var uVars:ISFSArray<Dynamic> = sfsa.getSFSArray(4);
		for(i in 0...uVars.size())
		{
			newUser.setVariable(SFSUserVariable.fromSFSArray(uVars.getSFSArray(i)));
		}

		return newUser;
	}
	
	/**
	 * Creates a new<em>SFSUser</em>instance.
	 * 
	 *<p><b>NOTE</b>:developers never istantiate a<em>SFSUser</em>manually:this is done by the SmartFoxServer 2X API Internally.</p>
	 *  
	 * @param 	id		The user id.
	 * @param 	name	The user name.
	 * @param 	isItMe	If<code>true</code>, the user being created corresponds to the current client.
	 */
	public function new(id:Int, name:String, isItMe:Bool=false)
	{
		_id = id;
		_name = name;
		_isItMe = isItMe;
		_variables = new StringMap<Dynamic>();
		_properties = { };
		_isModerator = false;
		_playerIdByRoomId = new IntMap<Int>();
	}
	
	/** @inheritDoc */
	public var id(get_id, set_id):Int;
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
	
	/** @inheritDoc */
	public var playerId(get_playerId, set_playerId):Int;
 	private function get_playerId():Int
	{
		// Return from default room
		return getPlayerId(userManager.smartFox.lastJoinedRoom);
	}
	
	/** @inheritDoc */
	public function isJoinedInRoom(room:Room):Bool
	{
		return room.containsUser(this);
	}
	
	
	/** @inheritDoc */
	public var privilegeId(get_privilegeId, set_privilegeId):Int;
 	private function get_privilegeId():Int
	{
		return _privilegeId;
	}
	
	/** @private */
	private function set_privilegeId(value:Int):Void
	{
		_privilegeId = value;
	}
	
	/** @inheritDoc */
	public function isGuest():Bool
	{
		return _privilegeId == UserPrivileges.GUEST;	
	}
	
	/** @inheritDoc */
	public function isStandardUser():Bool
	{
		return _privilegeId == UserPrivileges.STANDARD;
	}
	
	/** @inheritDoc */
	public function isModerator():Bool
	{
		return _privilegeId == UserPrivileges.MODERATOR;
	}
	
	/** @inheritDoc */
	public function isAdmin():Bool
	{
		return _privilegeId == UserPrivileges.ADMINISTRATOR;
	}
	
	/** @inheritDoc */
	public var isPlayer(get_isPlayer, set_isPlayer):Bool;
 	private function get_isPlayer():Bool
	{
		return playerId > 0;
	}
	
	/** @inheritDoc */
	public var isSpectator(get_isSpectator, set_isSpectator):Bool;
 	private function get_isSpectator():Bool
	{
		return !this.isPlayer;
	}
	
	/** @inheritDoc */
	public function getPlayerId(room:Room):Int
	{			
		var pId:Int = 0;
		
		if(_playerIdByRoomId[room.id] !=null)
			pId = _playerIdByRoomId[room.id];
	
		return pId;
	}
	
	/** @private */
	public function setPlayerId(id:Int, room:Room):Void
	{
		_playerIdByRoomId[room.id] = id;
	}
	
	/** @private */
	public function removePlayerId(room:Room):Void
	{
		_playerIdByRoomId[room.id];
	}
	
	/** @inheritDoc */
	public function isPlayerInRoom(room:Room):Bool
	{
		return _playerIdByRoomId[room.id] > 0;
	}
	
	/** @inheritDoc */
	public function isSpectatorInRoom(room:Room):Bool
	{
		return _playerIdByRoomId[room.id] < 0;
	}
	
	/** @inheritDoc */
	public var isItMe(get_isItMe, set_isItMe):Bool;
 	private function get_isItMe():Bool
	{
		return _isItMe;
	}
	
	/** @inheritDoc */
	public var userManager(get_userManager, set_userManager):IUserManager;
 	private function get_userManager():IUserManager
	{
		return _userManager;
	}
	
	/** @private */
	private function set_userManager(manager:IUserManager):Void
	{
		if(_userManager !=null)
			throw new SFSError("Cannot re-assign the User Manager. Already set. User:" + this);
			
		_userManager = manager;
	}
	
	/** @inheritDoc */
	public function getVariables():Array<UserVariable>
	{
		// Return a copy of the Internal data structure as array
		var variables:Array<Dynamic> = [];
		for(uv in _variables)
			variables.push(uv);
			
		return variables;
	}
	
	/** @inheritDoc */
	public function getVariable(name:String):UserVariable
	{
		return _variables.get(name);
	}
	
	/** @private */
	public function setVariable(userVariable:UserVariable):Void
	{
		if(userVariable !=null)
		{
			// If varType==NULL delete var
			if(userVariable.isNull())
				_variables.remove(userVariable.name);
			else
				_variables.set(userVariable.name, userVariable);
		}
	}
	
	/** @private */
	public function setVariables(userVariables:Array<UserVariable>):Void
	{
		for(userVar in userVariables)
		{
			setVariable(userVar);
		}
	}
	
	/** @inheritDoc */
	public function containsVariable(name:String):Bool
	{
		return _variables.exists(name) && _variables.get(name) != null;
	}
	
	/** @private */
	private function removeUserVariable(varName:String):Void
	{
		_variables.remove(varName);	
	}
	
	/** @inheritDoc */
	public var properties(get_properties, set_properties):Dynamic;
 	private function get_properties():Dynamic
	{
		return _properties;
	}
	
	/** @private */
	private function set_properties(value:Dynamic):Void
	{
		_properties = value;	
	}
	
	/** @inheritDoc */
	public var aoiEntryPoint(get_aoiEntryPoint, set_aoiEntryPoint):Vec3D;
 	private function get_aoiEntryPoint():Vec3D
	{
		return _aoiEntryPoint;
	}
	
	/** @private */
	private function set_aoiEntryPoint(loc:Vec3D):Void
	{
		_aoiEntryPoint = loc;
	}
	
	/**
	 * Returns a string that contains the user id, name and a boolean indicating if the<em>SFSUser</em>object represents the current client.
	 * 
	 * @return	The string representation of the<em>SFSUser</em>object.
	 */
	public function toString():String
	{
		return "[User:" + _name + ", Id:" + _id + ", isMe:" + _isItMe + "]";
	}
}