package com.smartfoxserver.v2.requests.game;

import com.smartfoxserver.v2.entities.invitation.Invitation;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Replies to an invitation received by the current user.
 * 
 *<p>Users who receive an invitation sent by means of the<em>InviteUsersRequest</em>request can either accept or refuse it using this request.
 * The reply causes an<em>invitationReply</em>event to be dispatched to the inviter;if a reply is not sent, or it is sent after the invitation expiration,
 * the system will react as if the invitation was refused.</p>
 * 
 *<p>If an error occurs while the reply is delivered to the inviter user(for example the invitation is already expired),
 * an<em>invitationReplyError</em>event is returned to the current user.</p>
 * 
 * @example	The following example receives an invitation and accepts it automatically;in a real case scenario, the application Interface
 * usually allows the user choosing to accept or refuse the invitation, or even ignore it:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.INVITATION, onInvitationReceived);
 * 	sfs.addEventListener(SFSEvent.INVITATION_REPLY_ERROR, onInvitationReplyError);
 * }
 * 
 * private function onInvitationReceived(evt:SFSEvent):Void
 * {
 * 	// Let's accept this invitation			
 * 	sfs.send(new InvitationReplyRequest(evt.params.invitation, InvitationReply.ACCEPT));
 * }
 * 
 * private function onInvitationReplyError(evt:SFSEvent):Void
 * {
 * 	trace("Failed to reply to invitation due to the following problem:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:invitationReply invitationReply event
 * @see		com.smartfoxserver.v2.SmartFox#event:invitationReplyError invitationReplyError event
 * @see		InviteUsersRequest
 */
class InvitationReplyRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_INVITATION_ID:String = "i";
	
	/** @private */
	public static inline var KEY_INVITATION_REPLY:String = "r";
	
	/** @private */
	public static inline var KEY_INVITATION_PARAMS:String = "p";
	
	private var _invitation:Invitation;
	private var _reply:Int;
	private var _params:ISFSObject;
	
	/**
	 * Creates a new<em>InvitationReplyRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	invitation		An instance of the<em>Invitation</em>class containing the invitation details(inviter, custom parameters, etc).
	 * @param	invitationReply	The answer to be sent to the inviter, among those available as constants in the<em>InvitationReply</em>class.
	 * @param	params			An instance of<em>SFSObject</em>containing custom parameters to be returned to the inviter together with the reply
	 * 							(for example a message describing the reason of refusal).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.invitation.InvitationReply InvitationReply
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(invitation:Invitation, invitationReply:Int, params:ISFSObject=null)
	{
		super(BaseRequest.InvitationReply);
		_invitation = invitation;
		_reply = invitationReply;
		_params = params;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(_invitation==null)
			errors.push("Missing invitation object");
		
		if(errors.length>0)
			throw new SFSValidationError("InvitationReply request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_INVITATION_ID, _invitation.id);
		_sfso.putByte(KEY_INVITATION_REPLY, _reply);
		
		if(_params !=null)
			_sfso.putSFSObject(KEY_INVITATION_PARAMS, _params);
	}
}