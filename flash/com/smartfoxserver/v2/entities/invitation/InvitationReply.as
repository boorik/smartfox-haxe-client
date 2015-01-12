package com.smartfoxserver.v2.entities.invitation
{
	/**
	 * The <em>InvitationReply</em> class contains the constants describing the possible replies to an invitation.
	 * 
	 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
	 */
	public class InvitationReply
	{
		/**
		 * Invitation is accepted.
		 */
		public static const ACCEPT:int = 0
		
		/**
		 * Invitation is refused.
		 */
		public static const REFUSE:int = 1
		
		// For lack of Enum(s) and private constructors we have to prevent object construction this way...
		/** @private */
		public function InvitationReply()
		{
			throw new ArgumentError("This class cannot be instantiated")
		}
	}
}