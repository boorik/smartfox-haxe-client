package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Kicks a user out of the server.
 * 
 *<p>The current user must have administration or moderation privileges in order to be able to kick another user(see the<em>User.privilegeId</em>property).
 * The request allows sending a message to the kicked user(to make clear the reason of the following disconnection)which is delivered by means of the<em>moderatorMessage</em>event.</p>
 * 
 *<p>Differently from the user being banned(see the<em>BanUserRequest</em>request), a kicked user will be able to reconnect to the SmartFoxServer instance immediately.</p>
 * 
 * @example	The following example kicks the user Jack from the system:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	var userToKick:User=sfs.userManager.getUserByName("Jack");
 * 	sfs.send(new KickUserRequest(userToKick.id));
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:moderatorMessage moderatorMessage event
 * @see		com.smartfoxserver.v2.entities.User#privilegeId User.privilegeId
 * @see		BanUserRequest
 */
class KickUserRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_USER_ID:String = "u";
	
	/** @private */
	public static inline var KEY_MESSAGE:String = "m";
	
	/** @private */
	public static inline var KEY_DELAY:String = "d";
	
	private var _userId:Int;
	private var _message:String;
	private var _delay:Int;
	
	/**
	 * Creates a new<em>KickUserRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	userId			The id of the user to be kicked.
	 * @param	message			A custom message to be delivered to the user before kicking him;
	 * 							if<code>null</code>, the default message configured in the SmartFoxServer 2X Administration Tool is used.
	 * @param	delaySeconds	The number of seconds after which the user is kicked after receiving the kick message.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(userId:Int, message:String=null, delaySeconds:Int=5)
	{
		super(BaseRequest.KickUser);
		
		_userId = userId;
		_message = message;
		_delay = delaySeconds;
		
		// avoid negatives
		if(_delay<0)
			_delay = 0;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// no validation needed
		if(!sfs.mySelf.isModerator()&& !sfs.mySelf.isAdmin())
			errors.push("You don't have enough permissions to execute this request.");
			
		if(errors.length>0)
			throw new SFSValidationError("KickUser request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_USER_ID, _userId);
		_sfso.putInt(KEY_DELAY, _delay);
		
		if(_message !=null && _message.length>0)
			_sfso.putUtfString(KEY_MESSAGE, _message);
	}
}