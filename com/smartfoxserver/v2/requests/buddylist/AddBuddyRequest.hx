package com.smartfoxserver.v2.requests.buddylist;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Adds a new buddy to the current user's buddies list.
 * 
 *<p>In order to add a buddy, the current user must be online in the Buddy List system. If the buddy is added successfully, the operation is confirmed by a<em>buddyAdd</em>event;
 * otherwise the<em>buddyError</em>event is fired.</p>
 * 
 *<p><b>NOTE</b>:this request can be sent if the Buddy List system was previously initialized only(see the<em>InitBuddyListRequest</em>request description).</p>
 * 
 * @example	The following example sends a request to add a buddy:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ADD, onBuddyAdded);
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
 * 	
 * 	// Add Jack as a new buddy to my buddies list
 * 	sfs.send(new AddBuddyRequest("Jack"));
 * }
 * 
 * private function onBuddyAdded(evt:SFSBuddyEvent):Void
 * {
 * 	trace("This buddy was added:", evt.params.buddy.name);
 * }
 * 
 * private function onBuddyError(evt:SFSBuddyEvent):Void
 * {
 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyAdd buddyAdd event
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyError buddyError event
 * @see		RemoveBuddyRequest
 * @see		InitBuddyListRequest
 */
class AddBuddyRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_BUDDY_NAME:String = "bn";
	
	private var _name:String;
	
	/**
	 * Creates a new<em>AddBuddyRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	buddyName	The name of the user to be added as a buddy.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(buddyName:String)
	{
		super(BaseRequest.AddBuddy);
		_name = buddyName;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
		
		if(_name==null || _name.length<1)
			errors.push("Invalid buddy name:" + _name);
		
		if(sfs.buddyManager.myOnlineState==false)
			errors.push("Can't add buddy while off-line");
		
		// Duplicate buddy only allowed if the existing buddy is temp
		var buddy:Buddy = sfs.buddyManager.getBuddyByName(_name);
		if(buddy !=null && !buddy.isTemp)
			errors.push("Can't add buddy, it is already in your list:" + _name);
			
		if(errors.length>0)
			throw new SFSValidationError("BuddyList request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putUtfString(KEY_BUDDY_NAME, _name);
	}
}