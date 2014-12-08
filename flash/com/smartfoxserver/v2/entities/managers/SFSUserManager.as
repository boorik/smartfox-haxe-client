package com.smartfoxserver.v2.entities.managers
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.kernel;
	import com.smartfoxserver.v2.logging.Logger;
	
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Itr;
	
	/**
	 * The <em>SFSUserManager</em> class is the entity in charge of managing the local (client-side) users list.
	 * It keeps track of all the users that are currently joined in the same Rooms of the current user.
	 * It also provides utility methods to look for users by name and id.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#userManager SmartFox.userManager
	 */
	public class SFSUserManager implements IUserManager
	{
		private var _usersByName:HashMap
		private var _usersById:HashMap
		
		/** @private */
		protected var _smartFox:SmartFox
		
		/**
		 * Creates a new <em>SFSUserManager</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never instantiate a <em>SFSUserManager</em> manually: this is done by the SmartFoxServer 2X API internally.
		 * A reference to the existing instance can be retrieved using the <em>SmartFox.userManager</em> property.</p>
		 *  
		 * @param 	sfs		An instance of the SmartFoxServer 2X client API main <em>SmartFox</em> class.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#userManager SmartFox.userManager
		 */
		public function SFSUserManager(sfs:SmartFox)
		{
			_smartFox = sfs
			_usersByName = new HashMap()
			_usersById = new HashMap()
		}
		
		/** @inheritDoc */
		public function containsUserName(userName:String):Boolean
		{
			return _usersByName.hasKey(userName) 
		}
		
		/** @inheritDoc */
		public function containsUserId(userId:int):Boolean
		{
			return _usersById.hasKey(userId)
		}
		
		/** @inheritDoc */
		public function containsUser(user:User):Boolean
		{
			return _usersByName.contains(user)
		}
		
		/** @inheritDoc */
		public function getUserByName(userName:String):User
		{
			return _usersByName.get(userName) as User
		}
		
		/** @inheritDoc */
		public function getUserById(userId:int):User
		{
			return _usersById.get(userId) as User
		}
		
		/** @private */
		public function addUser(user:User):void
		{
			// TODO: very defensive, no need to fire exception, however we keep it for debugging
			if (_usersById.hasKey(user.id))
				_smartFox.logger.warn("Unexpected: duplicate user in UserManager: " + user)
				
			_addUser(user)
		}
		
		/** @private */
		protected function _addUser(user:User):void
		{
			_usersByName.set(user.name, user)
			_usersById.set(user.id, user)
		}
		
		/** @private */
		public function removeUser(user:User):void
		{
			_usersByName.clr(user.name)
			_usersById.clr(user.id)
		}
		
		/** @private */
		public function removeUserById(id:int):void
		{
			var user:User = _usersById.get(id) as User
			
			if (user != null)
				removeUser(user)
		}
		
		/** @inheritDoc */
		public function get userCount():int
		{
			return _usersById.size()
		}
		
		/** @private */
		public function get smartFox():SmartFox
		{
			return _smartFox
		}
		
		/** @inheritDoc */
		public function getUserList():Array
		{
			var userList:Array = []
			var iter:Itr = _usersById.iterator()
			
			while (iter.hasNext())
				userList.push(iter.next())
			
			return userList
		}
		
		kernel function clearAll():void
		{
			_usersByName = new HashMap()
			_usersById = new HashMap()
		}
	}
}