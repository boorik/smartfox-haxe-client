package com.smartfoxserver.v2.entities;
import com.smartfoxserver.v2.entities.variables.BuddyVariable;

/**
 * The<em>Buddy</em>interface defines all the methods and properties that an object representing a SmartFoxServer Buddy entity exposes.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSBuddy</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSBuddy
 */
interface Buddy
{
	/**
	 * Indicates the id of this buddy.
	 * This is equal to the id assigned by SmartFoxServer to the corresponding user.
	 * 
	 * @see		User#id
	 */
	public var id(get, null):Int;
	
	/**
	 * Indicates the name of this buddy.
	 * This is equal to the name of the corresponding user.
	 * 
	 * @see		User#name
	 */
	var  name(get,null):String;
	
	/**
	 * Indicates whether this buddy is blocked in the current user's buddies list or not.
	 * A buddy can be blocked by means of a<em>BlockBuddyRequest</em>request.
	 * 
	 * @see 	com.smartfoxserver.v2.requests.buddylist.BlockBuddyRequest BlockBuddyRequest
	 */
	var isBlocked(get,null):Bool;
	
	/**
	 * Indicates whether this buddy is online in the Buddy List system or not.
	 */
	var isOnline(get,null):Bool;
	
	/**
	 * Indicates whether this buddy is temporary(non-persistent)in the current user's buddies list or not.
	 */
	var isTemp(get,null):Bool;
	
	/**
	 * Returns the custom state of this buddy.
	 * Examples of custom states are "Available", "Busy", "Be right back", etc. If the custom state is not set,<code>null</code>is returned.
	 * 
	 *<p>The list of available custom states is returned by the<em>IBuddyManager.buddyStates</em>property.</p>
	 * 
	 * @see		com.smartfoxserver.v2.entities.managers.IBuddyManager#buddyStates IBuddyManager.buddyStates
	 */
	var state(get,null):String;
	
	/**
	 * Returns the nickname of this buddy.
	 * If the nickname is not set,<code>null</code>is returned.
	 */
	var nickName(get,null):String;
	
	/**
	 * Returns a list of<em>BuddyVariable</em>objects associated with the buddy.
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
	 * @see		#getVariable()
	 */ 
	var variables(get,null):Array<BuddyVariable>;
	
	/**
	 * Retrieves a Buddy Variable from its name.
	 * 
	 * @param	varName	The name of the Buddy Variable to be retrieved.
	 * 
	 * @return	The<em>BuddyVariable</em>object representing the Buddy Variable, or<code>null</code>if no Buddy Variable with the passed name is associated with this buddy.
	 * 
	 * @see		#variables
	 * @see 	com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest SetBuddyVariablesRequest
	 */ 
	function getVariable(varName:String):BuddyVariable;
	
	/**
	 * Return true if a BuddyVariable with the provided name exists
	 */
	/**
	 * Indicates whether this buddy has the specified Buddy Variable set or not.
	 * 
	 * @param	name	The name of the Buddy Variable whose existance must be checked.
	 * 
	 * @return	<code>true</code>if a Buddy Variable with the passed name is set for this buddy.
	 */
	function containsVariable(varName:String):Bool;
	
	/**
	 * Retrieves the list of persistent Buddy Variables of this buddy.
	 * 
	 * @return	An array of<em>BuddyVariable</em>objects.
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable#isOffline BuddyVariable.isOffline
	 */
	function getOfflineVariables():Array<BuddyVariable>;
	
	/**
	 * Retrieves the list of non-persistent Buddy Variables of this buddy.
	 * 
	 * @return	An array of<em>BuddyVariable</em>objects.
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable#isOffline BuddyVariable.isOffline
	 */
	function getOnlineVariables():Array<BuddyVariable>;
	
	/** @private */
	function setVariable(bVar:BuddyVariable):Void;
	
	/** @private */
	function setVariables(variables:Array<BuddyVariable>):Void;
	
	/** @private */
	function setId(id:Int):Void;
	
	/** @private */
	function setBlocked(value:Bool):Void;
	
	/** @private */
	function removeVariable(varName:String):Void;
	
	/** @private */
	function clearVolatileVariables():Void;
}