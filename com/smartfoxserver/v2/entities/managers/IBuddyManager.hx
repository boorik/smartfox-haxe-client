package com.smartfoxserver.v2.entities.managers;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.variables.BuddyVariable;

/**
 * The BuddyList Manager Interface
 */
/**
 * The<em>IBuddyManager</em>interface defines all the methods and properties exposed by the client-side manager of the SmartFoxServer<b>Buddy List</b>system.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSBuddyManager</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSBuddyManager
 */
interface IBuddyManager
{
	/**
	 * Indicates whether the client's Buddy List system is initialized or not.
	 * If not, an<em>InitBuddyListRequest</em>request should be sent to the server in order to retrieve the persistent Buddy List data.
	 * 
	 *<p>No Buddy List related operations are allowed until the system is initialized.</p>
	 * 
	 * @see com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest InitBuddyListRequest
	 */
	var isInited(get, null):Bool;
	//function get isInited():Bool
	
	/** @private */
	function setInited(flag:Bool):Void;
	
	/** @private */
	function addBuddy(buddy:Buddy):Void;
	
	/** @private */
	function removeBuddyById(id:Int):Buddy;
	
	/** @private */
	function removeBuddyByName(name:String):Buddy;
	
	/**
	 * Indicates whether a buddy exists in user's buddies list or not.
	 * 
	 * @param	name	The name of the buddy whose presence in the buddies list is to be tested.
	 * 
	 * @return	<code>true</code>if the specified buddy exists in the buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#name Buddy.name
	 */
	function containsBuddy(name:String):Bool;
	
	/**
	 * Retrieves a<em>Buddy</em>object from its<em>id</em>property.
	 * 
	 * @param	id	The id of the buddy to be found.
	 * 
	 * @return	The<em>Buddy</em>object representing the buddy, or<code>null</code>if no buddy with the passed id exists in the buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#id Buddy.id
	 * @see		#getBuddyByName()
	 * @see		#getBuddyByNickName()
	 */ 
	function getBuddyById(id:Int):Buddy;
	
	/**
	 * Retrieves a<em>Buddy</em>object from its<em>name</em>property.
	 * 
	 * @param	name	The name of the buddy to be found.
	 * 
	 * @return	The<em>Buddy</em>object representing the buddy, or<code>null</code>if no buddy with the passed name exists in the buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#name Buddy.name
	 * @see		#getBuddyById()
	 * @see		#getBuddyByNickName()
	 */ 
	function getBuddyByName(name:String):Buddy;
	
	/**
	 * Retrieves a<em>Buddy</em>object from its<em>nickName</em>property(if set).
	 * 
	 * @param	nickName	The nickName of the buddy to be found.
	 * 
	 * @return	The<em>Buddy</em>object representing the buddy, or<code>null</code>if no buddy with the passed nickName exists in the buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#nickName Buddy.nickName
	 * @see		#getBuddyById()
	 * @see		#getBuddyByName()
	 */ 
	function getBuddyByNickName(nickName:String):Buddy;
	
	/**
	 * Returns a list of<em>Buddy</em>objects representing all the offline buddies in the user's buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#isOnline Buddy.isOnline
	 */
	var offlineBuddies(get, null):Array<Buddy>;
	//function get offlineBuddies():Array
	
	/**
	 * Returns a list of<em>Buddy</em>objects representing all the online buddies in the user's buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#isOnline Buddy.isOnline
	 */
	var  onlineBuddies(get, null):Array<Buddy>;
	
	/**
	 * Returns a list of<em>Buddy</em>objects representing all the buddies in the user's buddies list.
	 * The list is<code>null</code>if the Buddy List system is not initialized.
	 * 
	 * @see #isInited
	 */
	var buddyList(get, null):Array<Buddy>;
	//function get buddyList():Array
	
	/**
	 * Returns a list of strings representing the available custom buddy states.
	 * The custom states are received by the client upon initialization of the Buddy List system. They can be configured by means of the SmartFoxServer 2X Administration Tool.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#state Buddy.state
	 */
	//function get buddyStates():Array
	var buddyStates(get, null):Array<String>;
	
	/**
	 * Retrieves a Buddy Variable from its name.
	 * 
	 * @param	varName	The name of the Buddy Variable to be retrieved.
	 * 
	 * @return	The<em>BuddyVariable</em>object representing the Buddy Variable, or<code>null</code>if no Buddy Variable with the passed name is associated with the current user.
	 * 
	 * @see		#myVariables
	 * @see 	com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest SetBuddyVariablesRequest
	 */ 
	function getMyVariable(varName:String):BuddyVariable;
	
	/**
	 * Returns all the Buddy Variables associated with the current user.
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
	 * @see		#getMyVariable()
	 */ 
	var myVariables(get, null):Array<BuddyVariable>;
	//function get myVariables():Array
	
	/**
	 * Returns the current user's online/offline state.
	 * If<code>true</code>, the user appears to be online in the buddies list of other users who have him as a buddy.
	 *<p>The online state of a user in a buddy list is handled by means of a reserved Buddy Variable(see<em>ReservedBuddyVariables</em>class);
	 * it can be changed using the dedicated<em>GoOnlineRequest</em>request.</p>
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#isOnline Buddy.isOnline
	 * @see		com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables ReservedBuddyVariables
	 * @see 	com.smartfoxserver.v2.requests.buddylist.GoOnlineRequest GoOnlineRequest
	 */
	var myOnlineState(get, null):Bool;
	//function get myOnlineState():Bool
	
	/**
	 * Returns the current user's nickname(if set).
	 * If the nickname was never set before,<code>null</code>is returned.
	 *<p>As the nickname of a user in a buddy list is handled by means of a reserved Buddy Variable(see<em>ReservedBuddyVariables</em>class),
	 * it can be set using the<em>SetBuddyVariablesRequest</em>request.</p>
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#nickName Buddy.nickName
	 * @see		com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables ReservedBuddyVariables
	 * @see 	com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest SetBuddyVariablesRequest
	 */
	var myNickName(get, null):String;
	//function get myNickName():String
	
	/**
	 * Returns the current user's custom state(if set).
	 * Examples of custom states are "Available", "Busy", "Be right back", etc. If the custom state was never set before,<code>null</code>is returned.
	 *<p>As the custom state of a user in a buddy list is handled by means of a reserved Buddy Variable(see<em>ReservedBuddyVariables</em>class),
	 * it can be set using the<em>SetBuddyVariablesRequest</em>request.</p>
	 * 
	 * @see		com.smartfoxserver.v2.entities.Buddy#state Buddy.state
	 * @see		com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables ReservedBuddyVariables
	 * @see 	com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest SetBuddyVariablesRequest
	 */
	var myState(get, null):String;
	//function get myState():String
	
	/** @private */
	function setMyVariable(bVar:BuddyVariable):Void;
	
	/** @private */
	function setMyVariables(variables:Array<BuddyVariable>):Void;
	
	/** @private */
	function setMyOnlineState(isOnline:Bool):Void;
	
	/** @private */
	function setMyNickName(nickName:String):Void;
	
	/** @private */
	function setMyState(state:String):Void;
	
	/** @private */
	function setBuddyStates(states:Array<String>):Void;
	
	/** @private */
	function clearAll():Void;
}