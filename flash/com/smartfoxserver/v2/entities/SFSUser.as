package com.smartfoxserver.v2.entities
{
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.Vec3D;
	import com.smartfoxserver.v2.entities.managers.IUserManager;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	import com.smartfoxserver.v2.entities.variables.UserVariable;
	import com.smartfoxserver.v2.exceptions.SFSError;
	
	/**
	 * The <em>SFSUser</em> object represents a client logged in SmartFoxServer.
	 * 
	 * <p>The SmartFoxServer 2X client API are not aware of all the clients (users) connected to the server,
	 * but only of those that are in the same Rooms joined by the current client; this reduces the traffic between the client and the server considerably.
	 * In order to interact with other users the client should join other Rooms or use the Buddy List system to keep track of and interact with friends.</p>
	 * 
	 * @see com.smartfoxserver.v2.SmartFox#userManager SmartFox.userManager
	 */
	public class SFSUser implements User
	{
		/** @private */
		protected var _id:int = -1
		
		/** @private */
		protected var _privilegeId:int = 0
		
		/** @private */
		protected var _name:String
		
		/** @private */
		protected var _isItMe:Boolean
		
		/** @private */
		protected var _variables:Object
		
		/** @private */
		protected var _properties:Object
		
		/** @private */
		protected var _isModerator:Boolean
		
		/** @private */
		protected var _playerIdByRoomId:Object
		
		/** @private */
		protected var _userManager:IUserManager
		
		/** @private */
		private var _aoiEntryPoint:Vec3D
		
		/** @private */
		public static function fromSFSArray(sfsa:ISFSArray, room:Room = null):User
		{
			// Pass id and name
			var newUser:User = new SFSUser(sfsa.getInt(0), sfsa.getUtfString(1))
			
			// Set privileges
			newUser.privilegeId = sfsa.getShort(2)
			
			// Set playerId
			if (room != null)
				newUser.setPlayerId(sfsa.getShort(3), room)
			
			// Populate variables
			var uVars:ISFSArray = sfsa.getSFSArray(4)
			for (var i:int = 0; i < uVars.size(); i++)
			{
				newUser.setVariable(SFSUserVariable.fromSFSArray(uVars.getSFSArray(i)))
			}

			return newUser
		}
		
		/**
		 * Creates a new <em>SFSUser</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never istantiate a <em>SFSUser</em> manually: this is done by the SmartFoxServer 2X API internally.</p>
		 *  
		 * @param 	id		The user id.
		 * @param 	name	The user name.
		 * @param 	isItMe	If <code>true</code>, the user being created corresponds to the current client.
		 */
		public function SFSUser(id:int, name:String, isItMe:Boolean = false)
		{
			_id = id
			_name = name
			_isItMe = isItMe
			_variables = {}
			_properties = {}
			_isModerator = false	
			_playerIdByRoomId = {}
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
		
		/** @inheritDoc */
		public function get playerId():int
		{
			// Return from default room
			return getPlayerId(userManager.smartFox.lastJoinedRoom)
		}
		
		/** @inheritDoc */
		public function isJoinedInRoom(room:Room):Boolean
		{
			return room.containsUser(this)
		}
		
		
		/** @inheritDoc */
		public function get privilegeId():int
		{
			return _privilegeId
		}
		
		/** @private */
		public function set privilegeId(value:int):void
		{
			_privilegeId = value	
		}
		
		/** @inheritDoc */
		public function isGuest():Boolean
		{
			return _privilegeId == UserPrivileges.GUEST	
		}
		
		/** @inheritDoc */
		public function isStandardUser():Boolean
		{
			return _privilegeId == UserPrivileges.STANDARD
		}
		
		/** @inheritDoc */
		public function isModerator():Boolean
		{
			return _privilegeId == UserPrivileges.MODERATOR
		}
		
		/** @inheritDoc */
		public function isAdmin():Boolean
		{
			return _privilegeId == UserPrivileges.ADMINISTRATOR
		}
		
		/** @inheritDoc */
		public function get isPlayer():Boolean
		{
			return playerId > 0
		}
		
		/** @inheritDoc */
		public function get isSpectator():Boolean
		{
			return !this.isPlayer
		}
		
		/** @inheritDoc */
		public function getPlayerId(room:Room):int
		{			
			var pId:int = 0
			
			if (_playerIdByRoomId[room.id] != null)
				pId = _playerIdByRoomId[room.id]
		
			return pId
		}
		
		/** @private */
		public function setPlayerId(id:int, room:Room):void
		{
			_playerIdByRoomId[room.id] = id
		}
		
		/** @private */
		public function removePlayerId(room:Room):void
		{
			delete _playerIdByRoomId[room.id]
		}
		
		/** @inheritDoc */
		public function isPlayerInRoom(room:Room):Boolean
		{
			return _playerIdByRoomId[room.id] > 0
		}
		
		/** @inheritDoc */
		public function isSpectatorInRoom(room:Room):Boolean
		{
			return _playerIdByRoomId[room.id] < 0
		}
		
		/** @inheritDoc */
		public function get isItMe():Boolean
		{
			return _isItMe
		}
		
		/** @inheritDoc */
		public function get userManager():IUserManager
		{
			return _userManager
		}
		
		/** @private */
		public function set userManager(manager:IUserManager):void
		{
			if (_userManager != null)
				throw new SFSError("Cannot re-assign the User Manager. Already set. User: " + this)
				
			_userManager = manager
		}
		
		/** @inheritDoc */
		public function getVariables():Array
		{
			// Return a copy of the internal data structure as array
			var variables:Array = []
			for each (var uv:SFSUserVariable in _variables)
				variables.push(uv)
				
			return variables
		}
		
		/** @inheritDoc */
		public function getVariable(name:String):UserVariable
		{
			return _variables[name]
		}
		
		/** @private */
		public function setVariable(userVariable:UserVariable):void
		{
			if (userVariable != null)
			{
				// If varType == NULL delete var
				if (userVariable.isNull())
					delete _variables[userVariable.name]
				else
					_variables[userVariable.name] = userVariable
			}
		}
		
		/** @private */
		public function setVariables(userVariables:Array):void
		{
			for each (var userVar:UserVariable in userVariables)
			{
				setVariable(userVar)
			}
		}
		
		/** @inheritDoc */
		public function containsVariable(name:String):Boolean
		{
			return _variables[name] != null
		}
		
		/** @private */
		private function removeUserVariable(varName:String):void
		{
			delete _variables[varName]	
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
		
		/** @inheritDoc */
		public function get aoiEntryPoint():Vec3D
		{
			return _aoiEntryPoint;
		}
		
		/** @private */
		public function set aoiEntryPoint(loc:Vec3D):void
		{
			_aoiEntryPoint = loc
		}
		
		/**
		 * Returns a string that contains the user id, name and a boolean indicating if the <em>SFSUser</em> object represents the current client.
		 * 
		 * @return	The string representation of the <em>SFSUser</em> object.
		 */
		public function toString():String
		{
			return "[User: " + _name + ", Id: " + _id + ", isMe: " + _isItMe + "]"	
		}
	}
}