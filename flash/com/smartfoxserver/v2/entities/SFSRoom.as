package com.smartfoxserver.v2.entities
{
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.Vec3D;
	import com.smartfoxserver.v2.entities.managers.IRoomManager;
	import com.smartfoxserver.v2.entities.managers.IUserManager;
	import com.smartfoxserver.v2.entities.managers.SFSUserManager;
	import com.smartfoxserver.v2.entities.variables.RoomVariable;
	import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.kernel;
	import com.smartfoxserver.v2.util.ArrayUtil;
	
	/**
	 * The <em>SFSRoom</em> object represents a SmartFoxServer Room entity on the client.
	 * 
	 * <p>The SmartFoxServer 2X client API are not aware of all the Rooms which exist on the server side,
	 * but only of those that are joined by the user and those in the Room Groups that have been subscribed.
	 * Subscribing to one or more Groups allows the client to listen to Room events in specific "areas" of the Zone,
	 * without having to retrieve and keep synchronized the details of all available Rooms, thus reducing 
	 * the traffic between the client and the server considerably.</p>
	 * 
	 * <p>The list of available Rooms is created after a successful login and it is kept updated continuously by the server.</p>
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
	public class SFSRoom implements Room
	{
		/** @private */
		protected var _id:int
		
		/** @private */
		protected var _name:String
		
		/** @private */
		protected var _groupId:String
		
		/** @private */
		protected var _isGame:Boolean
		
		/** @private */
		protected var _isHidden:Boolean
		
		/** @private */
		protected var _isJoined:Boolean 
		
		/** @private */
		protected var _isPasswordProtected:Boolean
		
		/** @private */
		protected var _isManaged:Boolean
		
		/** @private */
		protected var _variables:Object
		
		/** @private */
		protected var _properties:Object
		
		/** @private */
		protected var _userManager:IUserManager
		
		/** @private */
		protected var _maxUsers:int
		
		/** @private */
		protected var _maxSpectators:int
		
		/** @private */
		protected var _userCount:int 				// only for non joined rooms
		
		/** @private */
		protected var _specCount:int 				// only for non joined rooms
		
		/** @private */
		protected var _roomManager:IRoomManager
		
		/** @private */
		public static function fromSFSArray(sfsa:ISFSArray):Room
		{
			// An MMORoom contains 14 properties
			var isMMORoom:Boolean = sfsa.size() == 14;
			
			var newRoom:Room = null;
			if (isMMORoom)
				newRoom = new MMORoom(sfsa.getInt(0), sfsa.getUtfString(1), sfsa.getUtfString(2));
			else
				newRoom = new SFSRoom(sfsa.getInt(0), sfsa.getUtfString(1), sfsa.getUtfString(2));
			
			newRoom.isGame = sfsa.getBool(3)
			newRoom.isHidden = sfsa.getBool(4)
			newRoom.isPasswordProtected = sfsa.getBool(5)
			newRoom.userCount = sfsa.getShort(6)
			newRoom.maxUsers = sfsa.getShort(7)
			
			// Room vars
			var varsList:ISFSArray = sfsa.getSFSArray(8)
			if (varsList.size() > 0)
			{
				var vars:Array = new Array()
			
				for (var j:int = 0; j < varsList.size(); j++)
				{
					var roomVariable:RoomVariable = SFSRoomVariable.fromSFSArray(varsList.getSFSArray(j))
					vars.push(roomVariable)	
				}
				newRoom.setVariables(vars)
			}
			
			if (newRoom.isGame)
			{
				newRoom.spectatorCount = sfsa.getShort(9)
				newRoom.maxSpectators = sfsa.getShort(10)	
			}
			
			if (isMMORoom)
			{
				var mmoRoom:MMORoom = newRoom as MMORoom;
				mmoRoom.defaultAOI = Vec3D.fromArray(sfsa.getElementAt(11));
				
				// Check if map limits are non null
				if (!sfsa.isNull(13))
				{
					mmoRoom.lowerMapLimit = Vec3D.fromArray(sfsa.getElementAt(12));
					mmoRoom.higherMapLimit = Vec3D.fromArray(sfsa.getElementAt(13));
				}
			}
			
			return newRoom
		}
		
		/**
		 * Creates a new <em>SFSRoom</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never istantiate a <em>SFSRoom</em> manually: this is done by the SmartFoxServer 2X API internally.</p>
		 *  
		 * @param 	id		The Room id.
		 * @param 	name	The Room name.
		 * @param 	groupId	The id of the Group to which the Room belongs.
		 */
		public function SFSRoom(id:int, name:String, groupId:String = "default")
		{
			_id = id
			_name = name
			_groupId = groupId
			
			// default flags
			_isJoined = _isGame = _isHidden = false
			_isManaged = true
			
			// counters
			_userCount = _specCount = 0
			
			_variables = new Object()
			_properties = new Object()
			_userManager = new SFSUserManager(null)	
		}
		
		/** @inheritDoc */
		public function get id():int
		{
			return _id
		}
		
		/** @inheritDoc */
		public function get name():String	
		{
			return _name
		}
		
		/** @private */
		public function set name(value:String):void
		{
			_name = value
		}
		
		/** @inheritDoc */
		public function get groupId():String
		{
			return _groupId
		}
		
		/** @inheritDoc */
		public function get isGame():Boolean
		{
			return _isGame		
		}
		
		/** @inheritDoc */
		public function get isHidden():Boolean
		{
			return _isHidden
		}
		
		/** @inheritDoc */
		public function get isJoined():Boolean
		{
			return _isJoined
		}
		
		/** @inheritDoc */
		public function get isPasswordProtected():Boolean
		{
			return _isPasswordProtected
		}
		
		/** @private */
		public function set isPasswordProtected(value:Boolean):void
		{
			_isPasswordProtected = value	
		}
		
		/** @private */
		public function set isJoined(value:Boolean):void
		{
			_isJoined = value
		}
		
		/** @private */
		public function set isGame(value:Boolean):void
		{
			_isGame = value	
		}
		
		/** @private */
		public function set isHidden(value:Boolean):void
		{
			_isHidden = value
		}
		
		/** @private */
		public function get isManaged():Boolean
		{
			return _isManaged
		}
		
		/** @private */
		public function set isManaged(value:Boolean):void
		{
			_isManaged = value
		}
		
		/** @inheritDoc */
		public function getVariables():Array
		{
			return ArrayUtil.objToArray(_variables)	
		}
		
		/** @inheritDoc */
		public function getVariable(name:String):RoomVariable
		{
			return _variables[name]
		}
		
		/*
		* If the room is joined the user count is taken from the Room's UserManager
		* otherwise we return the static counter (which will work only if you have activated the uCount updates)
		*/
		
		/** @inheritDoc */
		public function get userCount():int
		{
			// Return server count from UCountUpdate	
			if (!_isJoined)
				return _userCount;
			
			// Locally joined
			else 
			{
				// For game rooms, return only player count
				if (isGame)
					return playerList.length;
				
				// For regular rooms, return the full user count
				else 
					return _userManager.userCount
			}
		}
		
		/** @inheritDoc */
		public function get maxUsers():int
		{
			return _maxUsers
		}
		
		/** @inheritDoc */
		public function get capacity():int
		{
			return _maxUsers + _maxSpectators
		}
		
		/** @inheritDoc */
		public function get spectatorCount():int
		{
			// No spectators in regular rooms
			if (!isGame)
				return 0;
			
			// Joined Room? Dynamically calculate spectators
			if (_isJoined)
				return spectatorList.length;
			
			// Not joined, use the static value sent by the server
			else
				return _specCount
		}
		
		/** @inheritDoc */
		public function get maxSpectators():int
		{
			return _maxSpectators
		}
		
		/** @private */
		public function set userCount(value:int):void
		{
			_userCount = value 
		}
		
		/** @private */
		public function set maxUsers(value:int):void
		{
			_maxUsers = value
		}
		
		/** @private */
		public function set spectatorCount(value:int):void
		{
			_specCount = value
		}
		
		/** @private */
		public function set maxSpectators(value:int):void
		{
			_maxSpectators = value
		}
		
		/** @inheritDoc */
		public function getUserByName(name:String):User
		{
			return _userManager.getUserByName(name)
		}
		
		/** @inheritDoc */
		public function getUserById(id:int):User
		{
			return _userManager.getUserById(id)
		}
		
		/** @inheritDoc */
		public function get userList():Array
		{
			return _userManager.getUserList()
		}
		
		/** @inheritDoc */
		public function get playerList():Array
		{
			var playerList:Array = []
			
			for each(var user:User in _userManager.getUserList())
			{
				if (user.isPlayerInRoom(this))
					playerList.push(user)
			}
			
			return playerList
		}
		
		/** @inheritDoc */
		public function get spectatorList():Array
		{
			var spectatorList:Array = []
			
			for each(var user:User in _userManager.getUserList())
			{
				if (user.isSpectatorInRoom(this))
					spectatorList.push(user)
			}
			
			return spectatorList
		}
		
		/** @private */
		public function removeUser(user:User):void
		{
			_userManager.removeUser(user)
		}
		
		/** @private */
		public function setVariable(roomVariable:RoomVariable):void
		{
			// If varType == NULL delete var
			if (roomVariable.isNull())
				delete _variables[roomVariable.name]
			
			else
			{
				_variables[roomVariable.name] = roomVariable
			}
		}
		
		/** @private */
		public function setVariables(roomVariables:Array):void
		{
			for each (var roomVar:RoomVariable in roomVariables)
			{
				setVariable(roomVar)
			}
		}
		
		/** @inheritDoc */
		public function containsVariable(name:String):Boolean
		{
			return _variables[name] != null
		}
		
		/** @inheritDoc */
		public function get properties():Object
		{
			return _properties
		}
		
		/** @private */
		public function set properties(value:Object):void
		{
			_properties = value
		}
		
		/** @private */
		public function addUser(user:User):void
		{
			_userManager.addUser(user)
		}
		
		/** @inheritDoc */
		public function containsUser(user:User):Boolean
		{
			return _userManager.containsUser(user)
		}
		
		/** @inheritDoc */
		public function get roomManager():IRoomManager
		{
			return _roomManager
		}
		
		/** @private */
		public function set roomManager(value:IRoomManager):void
		{
			if (_roomManager != null)
				throw new SFSError("Room manager already assigned. Room: " + this)
				
			_roomManager = value	  
		}
		
		/** @private */
		public function setPasswordProtected(isProtected:Boolean):void
		{
			_isPasswordProtected = isProtected
		}
		
		/**
		 * Returns a string that contains the Room id, name and id of the Group to which it belongs.
		 * 
		 * @return	The string representation of the <em>SFSRoom</em> object.
		 */
		public function toString():String
		{
			return "[Room: " + _name + ", Id: " + _id + ", GroupId: " + _groupId + "]"	
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private methods
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		kernel function merge(anotherRoom:Room):void
		{
			// Clear all vars
			_variables = [];
			
			// Copy Variables
			for each (var rv:RoomVariable in anotherRoom.getVariables())
				_variables[rv.name] = rv;
			
			// Rebuild User List
			_userManager.kernel::clearAll();
			
			for each (var user:User in anotherRoom.userList)
				_userManager.addUser(user)
			
		}
	}
}