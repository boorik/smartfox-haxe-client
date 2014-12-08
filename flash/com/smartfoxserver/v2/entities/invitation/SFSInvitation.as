package com.smartfoxserver.v2.entities.invitation
{
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	
	/**
	 * The <em>SFSInvitation</em> object contains all the informations about an invitation received by the current user.
	 * 
	 * <p>An invitation is sent through the <em>InviteUsersRequest</em> request and it is received as an <em>invitation</em> event.
	 * Clients can reply to an invitation using the <em>InvitationReplyRequest</em> request.</p>
	 * 
	 * @see		com.smartfoxserver.v2.requests.game.InviteUsersRequest InviteUsersRequest
	 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
	 * @see		com.smartfoxserver.v2.SmartFox#event:invitation invitation event
	 */
	public class SFSInvitation implements Invitation
	{
		// The id is only used when the Invitation is built from a Server Side Invitation
		/** @private */
		protected var _id:int
		
		/** @private */
		protected var _inviter:User
		
		/** @private */
		protected var _invitee:User
		
		/** @private */
		protected var _secondsForAnswer:int
		
		/** @private */
		protected var _params:ISFSObject
		
		/**
		 * Creates a new <em>SFSInvitation</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never istantiate an <em>SFSInvitation</em> manually: this is done by the SmartFoxServer 2X API internally.
		 * A reference to an existing instance is always provided by the <em>invitation</em> event.</p>
		 * 
		 * @param	inviter				A <em>User</em> object corresponding to the user who sent the invitation.
		 * @param	invitee				A <em>User</em> object corresponding to the user who received the invitation.
		 * @param	secondsForAnswer	The number of seconds available to the invitee to reply to the invitation.
		 * @param	params				An instance of <em>SFSObject</em> containing a custom set of parameters representing the invitation details.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#event:invitation invitation event
		 * @see		com.smartfoxserver.v2.entities.User User
		 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
		 */
		public function SFSInvitation(inviter:User, invitee:User, secondsForAnswer:int = 15, params:ISFSObject = null)
		{
			_inviter = inviter
			_invitee = invitee
			_secondsForAnswer = secondsForAnswer
			_params = params	
		}
		
		/** @inheritDoc */
		public function get id():int
		{
		 	return _id
		}
		
		/** @private */
		public function set id(value:int):void
		{
			_id = value
		}
		
		/** @inheritDoc */
		public function get inviter():User
		{
			return _inviter
		}
		
		/** @inheritDoc */
		public function get invitee():User
		{
			return _invitee
		}
		
		/** @inheritDoc */
		public function get secondsForAnswer():int
		{
			return _secondsForAnswer
		}
		
		/** @inheritDoc */
		public function get params():ISFSObject
		{
			return _params
		}
	}
}