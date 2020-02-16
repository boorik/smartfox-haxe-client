package com.smartfoxserver.v2.requests.buddylist;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Removes a buddy from the current user's buddies list.
 * 
 *<p>In order to remove a buddy, the current user must be online in the Buddy List system. If the buddy is removed successfully, the operation is confirmed by a<em>buddyRemove</em>event;
 * otherwise the<em>buddyError</em>event is fired.</p>
 * 
 *<p><b>NOTE</b>:this request can be sent if the Buddy List system was previously initialized only(see the<em>InitBuddyListRequest</em>request description).</p>
 * 
 * @example	The following example sends a request to remove a buddy:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_REMOVE, onBuddyRemoved);
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
 * 	
 * 	// Remove Jack from my buddies list
 * 	sfs.send(new RemoveBuddyRequest("Jack"));
 * }
 * 
 * private function onBuddyRemoved(evt:SFSBuddyEvent):Void
 * {
 * 	trace("This buddy was removed:", evt.params.buddy.name);
 * }
 * 
 * private function onBuddyError(evt:SFSBuddyEvent):Void
 * {
 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyRemove buddyRemove event
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyError buddyError event
 * @see		AddBuddyRequest
 * @see		InitBuddyListRequest
 */
class RemoveBuddyRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_BUDDY_NAME:String = "bn";
	
	private var _name:String;
	
	/**
	 * Creates a new<em>RemoveBuddyRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	buddyName	The name of the buddy to be removed from the user's buddies list.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(buddyName:String)
	{
		super(BaseRequest.RemoveBuddy);
		_name = buddyName;
	}

	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
		
		if(sfs.buddyManager.myOnlineState==false)
			errors.push("Can't remove buddy while off-line");
			
		if(!sfs.buddyManager.containsBuddy(_name))
			errors.push("Can't remove buddy, it's not in your list:" + _name);
		
		if(errors.length>0)
			throw new SFSValidationError("BuddyList request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putUtfString(KEY_BUDDY_NAME, _name);
	}
}