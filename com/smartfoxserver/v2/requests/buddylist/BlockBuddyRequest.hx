
package com.smartfoxserver.v2.requests.buddylist;
#if html5
@:native('SFS2X.BlockBuddyRequest')
extern class BlockBuddyRequest{
	public function new(buddyName:String,blocked:Bool);
}
#else
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Blocks or unblocks a buddy in the current user's buddies list.
 * Blocked buddies won't be able to send messages or requests to that user. 
 * 
 *<p>In order to block a buddy, the current user must be online in the Buddy List system. If the operation is successful, a<em>buddyBlock</em>confirmation event is dispatched;
 * otherwise the<em>buddyError</em>event is fired.</p>
 * 
 *<p><b>NOTE</b>:this request can be sent if the Buddy List system was previously initialized only(see the<em>InitBuddyListRequest</em>request description).</p>
 * 
 * @example	The following example sends a request to block a buddy:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_BLOCK, onBuddyBlock);
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
 * 	
 * 	// Block Jack in my buddies list
 * 	sfs.send(new BlockBuddyRequest("Jack", true));
 * }
 * 
 * private function onBuddyBlock(evt:SFSBuddyEvent):Void
 * {
 * 	var isBlocked:Bool=evt.params.buddy.isBlocked;
 * 	trace("Buddy " + evt.params.buddy.name + " is now " +(isBlocked ? "blocked":"unblocked"));
 * }
 * 
 * private function onBuddyError(evt:SFSBuddyEvent):Void
 * {
 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyBlock buddyBlock event
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyError buddyError event
 * @see		InitBuddyListRequest
 */
class BlockBuddyRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_BUDDY_NAME:String = "bn";
	
	/** @private */
	public static inline var KEY_BUDDY_BLOCK_STATE:String = "bs";
	
	private var _buddyName:String;
	private var _blocked:Bool;
	
	/**
	 * Creates a new<em>BlockBuddyRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	buddyName	The name of the buddy to be blocked or unblocked.
	 * @param	blocked		<code>true</code>if the buddy must be blocked;<code>false</code>if he must be unblocked.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(buddyName:String, blocked:Bool)
	{
		super(BaseRequest.BlockBuddy);
		
		_buddyName = buddyName;
		_blocked = blocked;
	}

	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
		
		if(_buddyName==null || _buddyName.length<1)
			errors.push("Invalid buddy name:" + _buddyName);
			
		if(sfs.buddyManager.myOnlineState==false)
			errors.push("Can't block buddy while off-line");
		
		var buddy:Buddy = sfs.buddyManager.getBuddyByName(_buddyName);
		
		if(buddy==null)
			errors.push("Can't block buddy, it's not in your list:" + _buddyName);
		
		else if(buddy.isBlocked==_blocked)
			errors.push("BuddyBlock flag is already in the requested state:" + _blocked + ", for buddy:" + buddy);
			
		if(errors.length>0)
			throw new SFSValidationError("BuddyList request error", errors)	;
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putUtfString(BlockBuddyRequest.KEY_BUDDY_NAME, _buddyName);
		_sfso.putBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE, _blocked);
	}
}
#end