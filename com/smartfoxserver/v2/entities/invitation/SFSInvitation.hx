package com.smartfoxserver.v2.entities.invitation;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;

/**
 * The<em>SFSInvitation</em>object contains all the informations about an invitation received by the current user.
 * 
 *<p>An invitation is sent through the<em>InviteUsersRequest</em>request and it is received as an<em>invitation</em>event.
 * Clients can reply to an invitation using the<em>InvitationReplyRequest</em>request.</p>
 * 
 * @see		com.smartfoxserver.v2.requests.game.InviteUsersRequest InviteUsersRequest
 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
 * @see		com.smartfoxserver.v2.SmartFox#event:invitation invitation event
 */
class SFSInvitation implements Invitation
{
	// The id is only used when the Invitation is built from a Server Side Invitation
	/** @private */
	private var _id:Int;
	
	/** @private */
	private var _inviter:User;
	
	/** @private */
	private var _invitee:User;
	
	/** @private */
	private var _secondsForAnswer:Int;
	
	/** @private */
	private var _params:ISFSObject;
	
	/**
	 * Creates a new<em>SFSInvitation</em>instance.
	 * 
	 *<p><b>NOTE</b>:developers never istantiate an<em>SFSInvitation</em>manually:this is done by the SmartFoxServer 2X API Internally.
	 * A reference to an existing instance is always provided by the<em>invitation</em>event.</p>
	 * 
	 * @param	inviter				A<em>User</em>object corresponding to the user who sent the invitation.
	 * @param	invitee				A<em>User</em>object corresponding to the user who received the invitation.
	 * @param	secondsForAnswer	The number of seconds available to the invitee to reply to the invitation.
	 * @param	params				An instance of<em>SFSObject</em>containing a custom set of parameters representing the invitation details.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:invitation invitation event
	 * @see		com.smartfoxserver.v2.entities.User User
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(inviter:User, invitee:User, secondsForAnswer:Int=15, params:ISFSObject=null)
	{
		_inviter = inviter;
		_invitee = invitee;
		_secondsForAnswer = secondsForAnswer;
		_params = params;
	}
	
	/** @inheritDoc */
	public var id(get, set):Int;
 	private function get_id():Int
	{
	 	return _id;
	}
	
	/** @private */
	private function set_id(value:Int):Int
	{
		return _id = value;
	}
	
	/** @inheritDoc */
	public var inviter(get, null):User;
 	private function get_inviter():User
	{
		return _inviter;
	}
	
	/** @inheritDoc */
	public var invitee(get, null):User;
 	private function get_invitee():User
	{
		return _invitee;
	}
	
	/** @inheritDoc */
	public var secondsForAnswer(get, null):Int;
 	private function get_secondsForAnswer():Int
	{
		return _secondsForAnswer;
	}
	
	/** @inheritDoc */
	public var params(get, null):ISFSObject;
 	private function get_params():ISFSObject
	{
		return _params;
	}
}