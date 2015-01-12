package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.entities.SFSConstants;
	
	/**
	 * The <em>RoomSettings</em> class is a container for the settings required to create a Room using the <em>CreateRoomRequest</em> request.
	 * 
	 * @see 	CreateRoomRequest
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public class RoomSettings
	{
		private var _name:String
		private var _password:String
		private var _groupId:String
		private var _isGame:Boolean
		private var _maxUsers:int
		private var _maxSpectators:int
		private var _maxVariables:int
		private var _variables:Array
		private var _permissions:RoomPermissions
		private var _events:RoomEvents 
		private var _extension:RoomExtension
		
		/**
		 * Creates a new <em>RoomSettings</em> instance.
		 * The instance must be passed to the <em>CreateRoomRequest</em> class constructor.
		 * 
		 * @param	name	The name of the Room to be created.
		 * 
		 * @see		CreateRoomRequest
		 */
		public function RoomSettings(name:String)
		{
			// Default settings
			_name = name
			_password = ""
			_isGame = false
			_maxUsers = 10
			_maxSpectators = 0
			_maxVariables = 5
			_groupId = SFSConstants.DEFAULT_GROUP_ID
		}
		
		/**
		 * Defines the name of the Room.
		 */
		public function get name():String 
		{ 
			return _name
		}
		
		/** @private */
		public function set name(value:String):void 
		{ 
			_name = value
		}
		
		/**
		 * Defines the password of the Room.
		 * If the password is set to an empty string, the Room won't be password protected.
		 * 
		 * <p>The default value is an empty string.</p>
		 */
		public function get password():String 
		{ 
			return _password
		}
		
		/** @private */
		public function set password(value:String):void 
		{ 
			_password = value
		}
		
		/**
		 * Indicates whether the Room is a Game Room or not.
		 * 
		 * @default	false
		 */
		public function get isGame():Boolean 
		{ 
			return _isGame
		}
		
		/** @private */
		public function set isGame(value:Boolean):void 
		{ 
			_isGame = value
		}
		
		/**
		 * Defines the maximum number of users allowed in the Room.
		 * In case of Game Rooms, this is the maximum number of players.
		 * 
		 * @default	10
		 * 
		 * @see		#maxSpectators
		 */
		public function get maxUsers():int 
		{ 
			return _maxUsers
		}
		
		/** @private */
		public function set maxUsers(value:int):void 
		{ 
			_maxUsers = value
		}
		
		/**
		 * Defines the maximum number of Room Variables allowed for the Room.
		 * 
		 * @default	5
		 */
		public function get maxVariables():int 
		{ 
			return _maxVariables
		}
		
		/** @private */
		public function set maxVariables(value:int):void 
		{ 
			_maxVariables = value
		}
		
		/**
		 * Defines the maximum number of spectators allowed in the Room (only for Game Rooms).
		 * 
		 * @default	0
		 * 
		 * @see		#maxUsers
		 */
		public function get maxSpectators():int 
		{ 
			return _maxSpectators
		}
		
		/** @private */
		public function set maxSpectators(value:int):void 
		{ 
			_maxSpectators = value
		}
		
		/**
		 * Defines a list of <em>RooomVariable</em> objects to be attached to the Room.
		 * 
		 * @default	null
		 * 
		 * @see		com.smartfoxserver.v2.entities.variables.RoomVariable RoomVariable
		 */
		public function get variables():Array 
		{ 
			return _variables
		}
		
		/** @private */
		public function set variables(value:Array):void 
		{ 
			_variables = value
		}
		
		/** 
		 * Defines the flags indicating which operations are permitted on the Room.
		 * 
		 * <p>Permissions include: name and password change, maximum users change and public messaging.
		 * If set to <code>null</code>, the permissions configured on the server-side are used (see the SmartFoxServer 2X Administration Tool documentation).</p>
		 * 
		 * @default	null
		 */ 
		public function get permissions():RoomPermissions 
		{ 
			return _permissions
		}
		
		/** @private */
		public function set permissions(value:RoomPermissions):void 
		{ 
			_permissions = value
		}
		
		/** 
		 * Defines the flags indicating which events related to the Room are dispatched by the <em>SmartFox</em> client.
		 * 
		 * <p>Room events include: users entering or leaving the room, user count change and user variables update.
		 * If set to <code>null</code>, the events configured on the server-side are used (see the SmartFoxServer 2X Administration Tool documentation).</p>
		 * 
		 * @default	null
		 */ 
		public function get events():RoomEvents 
		{ 
			return _events
		}
		
		/** @private */
		public function set events(value:RoomEvents):void 
		{ 
			_events = value
		}
		
		/**
		 * Defines the Extension that must be attached to the Room on the server-side, and its settings.
		 */
		public function get extension():RoomExtension
		{
			return _extension
		}
		
		/** @private */
		public function set extension(value:RoomExtension):void
		{
			_extension = value
		}
		
		/** 
		 * Defines the id of the Group to which the Room should belong.
		 * If the Group doesn't exist yet, a new one is created before assigning the Room to it.
		 * 
		 * @default default
		 * 
		 * @see com.smartfoxserver.v2.entities.Room#groupId
		 */	
		public function get groupId():String
		{
			return _groupId
		}
		
		/** @private */
		public function set groupId(value:String):void
		{
			_groupId = value
		}
	}
}