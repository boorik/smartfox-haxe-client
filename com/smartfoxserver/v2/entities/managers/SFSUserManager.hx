package com.smartfoxserver.v2.entities.managers;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.logging.Logger;
import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * The<em>SFSUserManager</em>class is the entity in charge of managing the local(client-side)users list.
 * It keeps track of all the users that are currently joined in the same Rooms of the current user.
 * It also provides utility methods to look for users by name and id.
 * 
 * @see		com.smartfoxserver.v2.SmartFox#userManager SmartFox.userManager
 */
class SFSUserManager implements IUserManager
{
	private var _usersByName:StringMap<User>;
	private var _usersById:IntMap<User>;
	
	/** @private */
	private var _smartFox:SmartFox;
	
	/**
	 * Creates a new<em>SFSUserManager</em>instance.
	 * 
	 *<p><b>NOTE</b>:developers never instantiate a<em>SFSUserManager</em>manually:this is done by the SmartFoxServer 2X API Internally.
	 * A reference to the existing instance can be retrieved using the<em>SmartFox.userManager</em>property.</p>
	 *  
	 * @param 	sfs		An instance of the SmartFoxServer 2X client API main<em>SmartFox</em>class.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#userManager SmartFox.userManager
	 */
	public function new(sfs:SmartFox)
	{
		_smartFox = sfs;
		_usersByName = new StringMap();
		_usersById = new IntMap();
	}
	
	/** @inheritDoc */
	public function containsUserName(userName:String):Bool
	{
		return _usersByName.exists(userName);
	}
	
	/** @inheritDoc */
	public function containsUserId(userId:Int):Bool
	{
		return _usersById.exists(userId);
	}
	
	/** @inheritDoc */
	public function containsUser(user:User):Bool
	{
		return _usersByName.exists(user.name);
	}
	
	/** @inheritDoc */
	public function getUserByName(userName:String):User
	{
		return _usersByName.get(userName);
	}
	
	/** @inheritDoc */
	public function getUserById(userId:Int):User
	{
		return _usersById.get(userId);
	}
	
	/** @private */
	public function addUser(user:User):Void
	{
		// TODO:very defensive, no need to fire exception, however we keep it for debugging
		if(_usersById.exists(user.id) && _smartFox != null)
			_smartFox.logger.warn("Unexpected:duplicate user in UserManager:" + user);
			
		_addUser(user);
	}
	
	/** @private */
	private function _addUser(user:User):Void
	{
		_usersByName.set(user.name, user);
		_usersById.set(user.id, user);
	}
	
	/** @private */
	public function removeUser(user:User):Void
	{
		_usersByName.remove(user.name);
		_usersById.remove(user.id);
	}
	
	/** @private */
	public function removeUserById(id:Int):Void
	{
		var user:User = _usersById.get(id);
		
		if(user !=null)
			removeUser(user);
	}
	
	/** @inheritDoc */
	public var userCount(get, null):Int;
 	private function get_userCount():Int
	{
		return Lambda.count(_usersById);
	}
	
	/** @private */
	public var smartFox(get, null):SmartFox;
 	private function get_smartFox():SmartFox
	{
		return _smartFox;
	}
	
	/** @inheritDoc */
	public function getUserList():Array<User>
	{
		return Lambda.array(_usersById);
	}
	
	public function clearAll():Void
	{
		_usersByName = new StringMap<User>();
		_usersById = new IntMap<User>();
	}
}