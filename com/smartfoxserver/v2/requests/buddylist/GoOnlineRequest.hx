package com.smartfoxserver.v2.requests.buddylist;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Toggles the current user's online/offline state as buddy in other users' buddies lists.
 * 
 *<p>All clients who have the current user as buddy in their buddies list will receive the<em>buddyOnlineStateChange</em>event and see the<em>Buddy.isOnline</em>property change accordingly.
 * The same event is also dispatched to the current user, who sent the request, so that the application Interface can be updated accordingly.
 * Going online/offline as buddy doesn't affect the user connection, the currently joined Zone and Rooms, etc.</p>
 * 
 *<p>The online state of a user in a buddy list is handled by means of a reserved and persistent Buddy Variable.</p>
 * 
 *<p><b>NOTE</b>:this request can be sent if the Buddy List system was previously initialized only(see the<em>InitBuddyListRequest</em>request description).</p>
 * 
 * @example	The following example changes the user online state in the Buddy List system:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, onBuddyOnlineStateUpdated);
 * 	
 * 	// Put myself offline in the Buddy List system
 * 	sfs.send(new GoOnlineRequest(false));
 * }
 * 
 * private function onBuddyOnlineStateUpdated(evt:SFSBuddyEvent):Void
 * {
 * 	// As the state change event is dispatched to me too,
 * 	// I have to check if I am the one who changed his state
 * 	
 * 	var isItMe:Bool=evt.params.isItMe;
 * 	
 * 	if(isItMe)
 * 		trace("I'm now",(sfs.buddyManager.myOnlineState ? "online":"offline"));
 * 	else
 * 		trace("My buddy " + evt.params.buddy.name + " is now",(evt.params.buddy.isOnline ? "online":"offline"));
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.entities.managers.IBuddyManager#myOnlineState IBuddyManager.myOnlineState
 * @see		com.smartfoxserver.v2.entities.Buddy#isOnline Buddy.isOnline
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyOnlineStateChange buddyOnlineStateChange event
 * @see		InitBuddyListRequest
 */
class GoOnlineRequest extends BaseRequest 
{
	/** @private */
	public static inline var KEY_ONLINE:String = "o";
	
	/** @private */
	public static inline var KEY_BUDDY_NAME:String = "bn";
	
	/** @private */
	public static inline var KEY_BUDDY_ID:String = "bi";
	
	private var _online:Bool;
	
	/**
	 * Creates a new<em>GoOnlineRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	online	<code>true</code>to make the current user available(online)in the Buddy List system;<code>false</code>to make him not available(offline).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(online:Bool)
	{
		super(BaseRequest.GoOnline);
		_online = online;
	}

	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
			
		if(errors.length>0)
			throw new SFSValidationError("GoOnline request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		/*
		* Locally we already set the flag without the need of a server response
		* There's no need to fire an asynchronous event for this request. 
		* As soon as the command is sent the local flag is set
		*/
		sfs.buddyManager.setMyOnlineState(_online);
		
		_sfso.putBool(KEY_ONLINE, _online);
	}
}