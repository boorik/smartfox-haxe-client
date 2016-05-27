package com.smartfoxserver.v2.entities.variables;

/**
 * The<em>ReservedBuddyVariables</em>class contains the constants describing the SmartFoxServer API reserved Buddy Variable names.
 * Reserved Buddy Variables are used to store specific buddy-related informations.
 */
class ReservedBuddyVariables
{
	/**
	 * The Buddy Variable with this name keeps track of the online/offline state of the user in a buddy list.
	 * This variable is persistent, which means that the online/offline state is preserved upon disconnection.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#isOnline Buddy.isOnline
	 * @see		com.smartfoxserver.v2.entities.managers.IBuddyManager#myOnlineState IBuddyManager.myOnlineState
	 */
	public static inline var BV_ONLINE:String = "$__BV_ONLINE__" ;
	
	/**
	 * The Buddy Variable with this name stores the custom state of the user in a buddy list.
	 * This variable is persistent, which means that the custom state is preserved upon disconnection.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#state Buddy.state
	 * @see		com.smartfoxserver.v2.entities.managers.IBuddyManager#myState IBuddyManager.myState
	 */
	public static inline var BV_STATE:String = "$__BV_STATE__";
	
	/**
	 * The Buddy Variable with this name stores the optional nickname of the user in a buddy list.
	 * This variable is persistent, which means that the nickname is preserved upon disconnection.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#nickName Buddy.nickName
	 * @see		com.smartfoxserver.v2.entities.managers.IBuddyManager#myNickName IBuddyManager.myNickName
	 */
	public static inline var BV_NICKNAME:String = "$__BV_NICKNAME__";
}