package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Banishes a user from the server.
 * 
 *<p>The current user must have administration or moderation privileges in order to be able to ban another user(see the<em>User.privilegeId</em>property).
 * The user can be banned by name or by IP address(see the<em>BanMode</em>class). Also, the request allows sending a message to the banned user
 *(to make clear the reason of the following disconnection)which is delivered by means of the<em>moderatorMessage</em>event.</p>
 * 
 *<p>Differently from the user being kicked(see the<em>KickUserRequest</em>request), a banned user won't be able to connect to the SmartFoxServer instance until
 * the banishment expires(after 24 hours for client-side banning)or an administrator removes his name/IP address from the list of banned users
 * by means of the SmartFoxServer 2X Administration Tool.</p>
 * 
 * @example	The following example bans the user Jack from the system:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	var userToBan:User=sfs.userManager.getUserByName("Jack");
 * 	sfs.send(new BanUserRequest(userToBan.id));
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:moderatorMessage moderatorMessage event
 * @see		com.smartfoxserver.v2.entities.User#privilegeId User.privilegeId
 * @see		BanMode
 * @see		KickUserRequest
 */
class BanUserRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_USER_ID:String = "u";
	
	/** @private */
	public static inline var KEY_MESSAGE:String = "m";
	
	/** @private */
	public static inline var KEY_DELAY:String = "d";
	
	/** @private */
	public static inline var KEY_BAN_MODE:String = "b";
		
	/** @private */
	public static inline var KEY_BAN_DURATION_HOURS:String = "dh";
			
	
	private var _userId:Int;
	private var _message:String;
	private var _delay:Int;
	private var _banMode:Int;
	private var _durationHours:Int;
	
	/**
	 * Creates a new<em>BanUserRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	userId				The id of the user to be banned.
	 * @param	message				A custom message to be delivered to the user before banning him;
	 * 								if<code>null</code>, the default message configured in the SmartFoxServer 2X Administration Tool is used.
	 * @param	banMode				One of the ban modes defined in the<em>BanMode</em>class.
	 * @param	delaySeconds		The number of seconds after which the user is banned after receiving the ban message.
	 * @param	durationHours		The duration of the banishment, expressed in hours.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		BanMode
	 */
	public function new(userId:Int, message:String=null, banMode:Int=1, delaySeconds:Int=5, durationHours:Int=24)
	{
		super(BaseRequest.BanUser);
		
		_userId = userId;
		_message = message;
		_banMode = banMode;
		_delay = delaySeconds;
		_durationHours = durationHours;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// no validation needed
		if(!sfs.mySelf.isModerator()&& !sfs.mySelf.isAdmin())
			errors.push("You don't have enough permissions to execute this request.");
			
		if(errors.length>0)
			throw new SFSValidationError("BanUser request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_USER_ID, _userId);
		_sfso.putInt(KEY_DELAY, _delay);
		_sfso.putInt(KEY_BAN_MODE, _banMode);
		_sfso.putInt(KEY_BAN_DURATION_HOURS, _durationHours);
		
		if(_message !=null && _message.length>0)
			_sfso.putUtfString(KEY_MESSAGE, _message);
	}
}