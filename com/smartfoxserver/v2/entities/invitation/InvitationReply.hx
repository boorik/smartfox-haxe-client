package com.smartfoxserver.v2.entities.invitation;
import openfl.errors.ArgumentError;

/**
 * The<em>InvitationReply</em>class contains the constants describing the possible replies to an invitation.
 * 
 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
 */
class InvitationReply
{
	/**
	 * Invitation is accepted.
	 */
	public static inline var ACCEPT:Int = 0;
	
	/**
	 * Invitation is refused.
	 */
	public static inline var REFUSE:Int = 1;
	
	// For lack of Enum(s)and private constructors we have to prevent object construction this way...
	/** @private */
	public function new()
	{
		throw new ArgumentError("This class cannot be instantiated");
	}
}