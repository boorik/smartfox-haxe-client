package com.smartfoxserver.v2.entities;

/**
 * The<em>UserPrivileges</em>class contains the costants describing the default user types known by SmartFoxServer.
 * The server assigns one of these values or a custom-defined one to the<em>User.privilegeId</em>property  whenever a user logs in.
 * 
 *<p>Read the SmartFoxServer 2X documentation for more informations about privilege profiles and their permissions.</p>
 * 
 * @see		com.smartfoxserver.v2.entities.User#privilegeId User.privilegeId
 */
class UserPrivileges
{
	/**
	 * The Guest user is usually the lowest level in the privilege profiles scale.
	 */
	public static inline var GUEST:Int = 0;
	
	/**
	 * The standard user is usually registered in the application custom login system;uses a unique name and password to login.
	 */
	public static inline var STANDARD:Int = 1;
	
	/**
	 * The moderator user can send dedicated "moderator messages", kick and ban users.
	 * 
	 * @see		com.smartfoxserver.v2.requests.ModeratorMessageRequest ModeratorMessageRequest
	 * @see		com.smartfoxserver.v2.requests.KickUserRequest KickUserRequest
	 * @see		com.smartfoxserver.v2.requests.BanUserRequest BanUserRequest
	 */
	public static inline var MODERATOR:Int = 2;
	
	/**
	 * The administrator user can send dedicated "administrator messages", kick and ban users.
	 * 
	 * @see		com.smartfoxserver.v2.requests.ModeratorMessageRequest AdminMessageRequest
	 * @see		com.smartfoxserver.v2.requests.KickUserRequest KickUserRequest
	 * @see		com.smartfoxserver.v2.requests.BanUserRequest BanUserRequest
	 */
	public static inline var ADMINISTRATOR:Int = 3;
}