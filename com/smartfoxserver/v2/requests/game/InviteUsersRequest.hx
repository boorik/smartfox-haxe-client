package com.smartfoxserver.v2.requests.game;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Sends a generic invitation to a list of users.
 * 
 *<p>Invitations can be used for different purposes, such as requesting users to join a game or visit a specific Room, asking the permission to add them as buddies, etc.
 * Invited users receive the invitation as an<em>invitation</em>event dispatched to their clients:they can accept or refuse it
 * by means of the<em>InvitationReplyRequest</em>request, which must be sent within the specified amount of time.</p>
 * 
 * @example	The following example sends an invitation to join the current user in his private Room;the invitation contains a custom message and the Room name and password,
 * so that the recipient clients can join the Room if the users accept the invitation:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	// Add a listener to the invitation reply
 * 	sfs.addEventListener(SFSEvent.INVITATION_REPLY, onInvitationReply);
 * 	
 * 	// Choose the invitation recipients
 * 	var friend1:User=sfs.userManager.getUserByName("Piggy");
 * 	var friend2:User=sfs.userManager.getUserByName("Gonzo");
 * 	
 * 	// Set the custom invitation details
 * 	var params:ISFSObject=new SFSObject();
 * 	params.putUtfString("msg", "Would you like to join me in my private room?");
 * 	params.putUtfString("roomName", "Kermit's room");
 * 	params.putUtfString("roomPwd", "drowssap");
 * 	
 * 	// Send the invitation;recipients have 20 seconds to reply before the invitation expires
 * 	sfs.send(new InviteUsersRequest([friend1, friend2], 20, params));
 * }
 * 
 * private function onInvitationReply(evt:SFSEvent):Void
 * {
 * 	// If at least one recipient accepted the invitation, make me join my private Room to meet him there
 * 	if(evt.params.reply==InvitationReply.ACCEPT)
 * 	{
 * 		var currentRoom:Room=sfs.lastJoinedRoom;
 * 		
 * 		if(currentRoom.name !="Kermit's room")
 * 			sfs.send(new JoinRoomRequest("Kermit's room"));
 * 	}
 * 	else
 * 	{
 * 		trace(evt.params.invitee + " refused the invitation")
 * 	}
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:invitation invitation event
 * @see		InvitationReplyRequest
 */
class InviteUsersRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_USER:String="u";
	
	/** @private */
	public static inline var KEY_USER_ID:String="ui";
	
	/** @private */
	public static inline var KEY_INVITATION_ID:String="ii";
	
	/** @private */
	public static inline var KEY_TIME:String="t";
	
	/** @private */
	public static inline var KEY_PARAMS:String="p";
	
	/** @private */
	public static inline var KEY_INVITEE_ID:String="ee";
	
	/** @private */
	public static inline var KEY_INVITED_USERS:String="iu";
	
	/** @private */
	public static inline var KEY_REPLY_ID:String="ri";
	
	/** @private */
	public static inline var MAX_INVITATIONS_FROM_CLIENT_SIDE:Int = 8;
	
	/** @private */
	public static inline var MIN_EXPIRY_TIME:Int = 5;
	
	/** @private */
	public static inline var MAX_EXPIRY_TIME:Int = 300;
	
	private var _invitedUsers:Array<User>;
	private var _secondsForAnswer:Int;
	private var _params:ISFSObject;
	
	/**
	 * Creates a new<em>InviteUsersRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	invitedUsers		A list of<em>User</em>objects representing the users to send the invitation to.
	 * @param	secondsForAnswer	The number of seconds available to each invited user to reply to the invitation(recommended range:15 to 40 seconds).
	 * @param	params				An instance of<em>SFSObject</em>containing custom parameters which specify the invitation details.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.User User
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(invitedUsers:Array<User>, secondsForAnswer:Int, params:ISFSObject=null)
	{
		super(BaseRequest.InviteUser);
		
		_invitedUsers = invitedUsers;
		_secondsForAnswer = secondsForAnswer;
		_params = params;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(_invitedUsers==null || _invitedUsers.length<1)
			errors.push("No invitation(s)to send");
					
		else if(_invitedUsers.length>MAX_INVITATIONS_FROM_CLIENT_SIDE)
			errors.push("Too many invitations. Max allowed from client side is:" + MAX_INVITATIONS_FROM_CLIENT_SIDE);
			
		else if(_secondsForAnswer<MIN_EXPIRY_TIME || _secondsForAnswer>MAX_EXPIRY_TIME)
			errors.push("SecondsForAnswer value is out of range(" + MIN_EXPIRY_TIME + "-" + MAX_EXPIRY_TIME + ")");

		if(errors.length>0)
			throw new SFSValidationError("InvitationReply request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		var invitedUserIds:Array<Int> = [];
		
		// Check items validity, accept any User or Buddy object(s)
		for(item in _invitedUsers)
		{
			if(Std.isOfType(item, User) || Std.isOfType(item,Buddy))
			{
				// Can't invite myself!
				if(item==sfs.mySelf)
					continue;
					
				invitedUserIds.push(item.id);
			}
		}
		
		// List of invited people
		_sfso.putIntArray(KEY_INVITED_USERS, invitedUserIds);
		
		// Time to answer
		_sfso.putShort(KEY_TIME, _secondsForAnswer);
		
		// Custom params
		if(_params !=null)
			_sfso.putSFSObject(KEY_PARAMS, _params);
	}
}