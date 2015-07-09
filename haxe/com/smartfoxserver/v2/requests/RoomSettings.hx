package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.entities.SFSConstants;

/**
 * The<em>RoomSettings</em>class is a container for the settings required to create a Room using the<em>CreateRoomRequest</em>request.
 * 
 * @see 	CreateRoomRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */
class RoomSettings
{
	private var _name:String;
	private var _password:String;
	private var _groupId:String;
	private var _isGame:Bool;
	private var _maxUsers:Int;
	private var _maxSpectators:Int;
	private var _maxVariables:Int;
	private var _variables:Array;
	private var _permissions:RoomPermissions;
	private var _events:RoomEvents ;
	private var _extension:RoomExtension;
	
	/**
	 * Creates a new<em>RoomSettings</em>instance.
	 * The instance must be passed to the<em>CreateRoomRequest</em>class constructor.
	 * 
	 * @param	name	The name of the Room to be created.
	 * 
	 * @see		CreateRoomRequest
	 */
	public function new(name:String)
	{
		// Default settings
		_name = name;
		_password = "";
		_isGame = false;
		_maxUsers = 10;
		_maxSpectators = 0;
		_maxVariables = 5;
		_groupId = SFSConstants.DEFAULT_GROUP_ID;
	}
	
	/**
	 * Defines the name of the Room.
	 */
	public var name(get_name, set_name):String;
 	private function get_name():String 
	{ 
		return _name;
	}
	
	/** @private */
	private function set_name(value:String):Void 
	{ 
		_name = value;
	}
	
	/**
	 * Defines the password of the Room.
	 * If the password is set to an empty string, the Room won't be password protected.
	 * 
	 *<p>The default value is an empty string.</p>
	 */
	public var password(get_password, set_password):String;
 	private function get_password():String 
	{ 
		return _password;
	}
	
	/** @private */
	private function set_password(value:String):Void 
	{ 
		_password = value;
	}
	
	/**
	 * Indicates whether the Room is a Game Room or not.
	 * 
	 * @default	false
	 */
	public var isGame(get_isGame, set_isGame):Bool;
 	private function get_isGame():Bool 
	{ 
		return _isGame;
	}
	
	/** @private */
	private function set_isGame(value:Bool):Void 
	{ 
		_isGame = value;
	}
	
	/**
	 * Defines the maximum number of users allowed in the Room.
	 * In case of Game Rooms, this is the maximum number of players.
	 * 
	 * @default	10
	 * 
	 * @see		#maxSpectators
	 */
	public var maxUsers(get_maxUsers, set_maxUsers):Int;
 	private function get_maxUsers():Int 
	{ 
		return _maxUsers;
	}
	
	/** @private */
	private function set_maxUsers(value:Int):Void 
	{ 
		_maxUsers = value;
	}
	
	/**
	 * Defines the maximum number of Room Variables allowed for the Room.
	 * 
	 * @default	5
	 */
	public var maxVariables(get_maxVariables, set_maxVariables):Int;
 	private function get_maxVariables():Int 
	{ 
		return _maxVariables;
	}
	
	/** @private */
	private function set_maxVariables(value:Int):Void 
	{ 
		_maxVariables = value;
	}
	
	/**
	 * Defines the maximum number of spectators allowed in the Room(only for Game Rooms).
	 * 
	 * @default	0
	 * 
	 * @see		#maxUsers
	 */
	public var maxSpectators(get_maxSpectators, set_maxSpectators):Int;
 	private function get_maxSpectators():Int 
	{ 
		return _maxSpectators;
	}
	
	/** @private */
	private function set_maxSpectators(value:Int):Void 
	{ 
		_maxSpectators = value;
	}
	
	/**
	 * Defines a list of<em>RooomVariable</em>objects to be attached to the Room.
	 * 
	 * @default	null
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.RoomVariable RoomVariable
	 */
	public var variables(get_variables, set_variables):Array;
 	private function get_variables():Array 
	{ 
		return _variables;
	}
	
	/** @private */
	private function set_variables(value:Array):Void 
	{ 
		_variables = value;
	}
	
	/** 
	 * Defines the flags indicating which operations are permitted on the Room.
	 * 
	 *<p>Permissions include:name and password change, maximum users change and public messaging.
	 * If set to<code>null</code>, the permissions configured on the server-side are used(see the SmartFoxServer 2X Administration Tool documentation).</p>
	 * 
	 * @default	null
	 */ 
	public var permissions(get_permissions, set_permissions):RoomPermissions;
 	private function get_permissions():RoomPermissions 
	{ 
		return _permissions;
	}
	
	/** @private */
	private function set_permissions(value:RoomPermissions):Void 
	{ 
		_permissions = value;
	}
	
	/** 
	 * Defines the flags indicating which events related to the Room are dispatched by the<em>SmartFox</em>client.
	 * 
	 *<p>Room events include:users entering or leaving the room, user count change and user variables update.
	 * If set to<code>null</code>, the events configured on the server-side are used(see the SmartFoxServer 2X Administration Tool documentation).</p>
	 * 
	 * @default	null
	 */ 
	public var events(get_events, set_events):RoomEvents;
 	private function get_events():RoomEvents 
	{ 
		return _events;
	}
	
	/** @private */
	private function set_events(value:RoomEvents):Void 
	{ 
		_events = value;
	}
	
	/**
	 * Defines the Extension that must be attached to the Room on the server-side, and its settings.
	 */
	public var extension(get_extension, set_extension):RoomExtension;
 	private function get_extension():RoomExtension
	{
		return _extension;
	}
	
	/** @private */
	private function set_extension(value:RoomExtension):Void
	{
		_extension = value;
	}
	
	/** 
	 * Defines the id of the Group to which the Room should belong.
	 * If the Group doesn't exist yet, a new one is created before assigning the Room to it.
	 * 
	 * @default default
	 * 
	 * @see com.smartfoxserver.v2.entities.Room#groupId
	 */	
	public var groupId(get_groupId, set_groupId):String;
 	private function get_groupId():String
	{
		return _groupId;
	}
	
	/** @private */
	private function set_groupId(value:String):Void
	{
		_groupId = value;
	}
}