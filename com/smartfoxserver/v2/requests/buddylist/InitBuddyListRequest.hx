package com.smartfoxserver.v2.requests.buddylist;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Initializes the Buddy List system on the current client.
 * 
 *<p>Buddy List system initialization involves loading any previously stored buddy-specific data from the server, such as the current user's buddies list, his previous state and the persistent Buddy Variables.
 * The initialization request is<b>the first operation to be executed</b>in order to be able to use the Buddy List system features.
 * Once the initialization is completed, the<em>buddyListInit</em>event is fired and the user has access to all his previously set data and can start to Interact with his buddies;
 * if the initialization failed, a<em>buddyError</em>event id fired.</p>
 * 
 * @example	The following example initializes the Buddy List system:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_LIST_INIT, onBuddyListInitialized);
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError)
 * 	
 * 	// Initialize the Buddy List system
 * 	sfs.send(new InitBuddyListRequest());
 * }
 * 
 * private function onBuddyListInitialized(evt:SFSBuddyEvent):Void
 * {
 * 	trace("Buddy List system initialized successfully");
 * 	
 * 	// Retrieve my buddies list
 * 	var buddies:Array<Dynamic>=sfs.buddyManager.buddyList;
 * 	
 * 	// Display the online buddies in a list component in the application Interface
 * 	...
 * }
 * 
 * private function onBuddyError(evt:SFSBuddyEvent):Void
 * {
 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyListInit buddyListInit event
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyError buddyError event
 */
class InitBuddyListRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_BLIST:String = "bl";
	
	/** @private */
	public static inline var KEY_BUDDY_STATES:String = "bs";
	
	/** @private */
	public static inline var KEY_MY_VARS:String = "mv";
	
	/**
	 * Creates a new<em>InitBuddyListRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new()
	{
		super(BaseRequest.InitBuddyList);
	}

	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(sfs.buddyManager.isInited)
			errors.push("Buddy List is already initialized.");
			
		if(errors.length>0)
			throw new SFSValidationError("InitBuddyRequest error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		// no params to add
	}
}