package com.smartfoxserver.v2.entities.variables;
/**
 * The<em>BuddyVariable</em>interface defines all the public methods and properties that an object representing a SmartFoxServer Buddy Variable exposes.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSBuddyVariable</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSBuddyVariable
 */
interface BuddyVariable extends UserVariable
{
	/**
	 * Indicates whether the Buddy Variable is persistent or not.
	 * 
	 *<p>By convention any Buddy Variable whose name starts with the dollar sign(<code>$</code>)will be regarded as persistent and stored locally by the server.
	 * Persistent Buddy Variables are also referred to as "offline variables" because they are available to all users
	 * who have the owner in their Buddy Lists, whether that Buddy is online or not.</p>
	 */
	public var isOffline(get, null):Bool;
}