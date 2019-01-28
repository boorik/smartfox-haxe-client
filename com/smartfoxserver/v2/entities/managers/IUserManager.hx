package com.smartfoxserver.v2.entities.managers;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.User;

/**
 * The<em>IUserManager</em>interface defines all the methods and properties exposed by the client-side manager of the SmartFoxServer User entities.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSUserManager</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSUserManager
 */
interface IUserManager
{
	/**
	 * Indicates whether a user exists in the local users list or not from the name.
	 * 
	 * @param	userName	The name of the user whose presence in the users list is to be tested.
	 * 
	 * @return	<code>true</code>if the passed user exists in the users list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.User#name User.name
	 */
	function containsUserName(userName:String):Bool;
	
	/**
	 * Indicates whether a user exists in the local users list or not from the id.
	 * 
	 * @param	userId	The id of the user whose presence in the users list is to be tested.
	 * 
	 * @return	<code>true</code>if the passed user exists in the users list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.User#id User.id
	 */
	function containsUserId(userId:Int):Bool;
	
	/**
	 * Indicates whether a user exists in the local users list or not.
	 * 
	 * @param	user	The<em>User</em>object representing the user whose presence in the users list is to be tested.
	 * 
	 * @return	<code>true</code>if the passed user exists in the users list.
	 */
	function containsUser(user:User):Bool;
	
	/**
	 * Retrieves a<em>User</em>object from its<em>name</em>property.
	 * 
	 * @param	userName	The name of the user to be found.
	 * 
	 * @return	The<em>User</em>object representing the user, or<code>null</code>if no user with the passed name exists in the local users list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.User#name User.name
	 * @see		#getUserById()
	 */ 
	function getUserByName(userName:String):User;
	
	/**
	 * Retrieves a<em>User</em>object from its<em>id</em>property.
	 * 
	 * @param	userId	The id of the user to be found.
	 * 
	 * @return	The<em>User</em>object representing the user, or<code>null</code>if no user with the passed id exists in the local users list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.User#id User.id
	 * @see		#getUserByName()
	 */ 
	function getUserById(userId:Int):User;
	
	/** @private */
	function addUser(user:User):Void;
	
	/** @private */
	function removeUser(user:User):Void;
	
	/** @private */
	function removeUserById(id:Int):Void;
	
	/**
	 * Returns the total number of users in the local users list.
	 */
	var userCount(get, null):Int;
	//function get userCount():Int
	
	/**
	 * Get the whole list of users inside the Rooms joined by the client.
	 * 
	 * @return	The list of<em>User</em>objects representing the users in the local users list.
	 */
	function getUserList():Array<User>;
	
	/** @private */
	var smartFox(get, null):SmartFox;
	//function get smartFox():SmartFox
}