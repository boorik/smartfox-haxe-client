package com.smartfoxserver.v2.requests.game;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Sends an invitation to other users/players to join a specific Room.
 *
 * <p>Invited users receive the invitation as an <em>invitation</em> event dispatched to their clients: they can accept or refuse it
 * by means of the <em>InvitationReplyRequest</em> request, which must be sent within the specified amount of time.</p>
 *
 * <p>Depending on the Room's settings the invitation can be sent by the Room's owner only or by any other user.
 * This behavior can be set via the RoomSettings.allowOwnerOnlyInvitation parameter.</p>
 *
 * <p><b>NOTE:</b> spectators in a Game Room are not allowed to invite other users; only players are.</p>
 *
 * <p>An invitation can also specify the amount of time given to each invitee to reply. Default is 30 seconds. A positive answer will attempt to join the user in the designated Room.
 * For Game Rooms the <em>asSpectator</em> flag can be toggled to join the invitee as player or spectator (default = player).</p>
 *
 * <p>There aren't any specific notifications sent back to the inviter after the invitee's response. Users that have accepted the invitation will join the Room while those
 * who didn't reply or turned down the invitation won't generate any event. In order to send specific messages (e.g. chat), just send a private message back to the inviter.</p>
 *
 * @example	The following example invites two more users in the current game:
 * <listing version="3.0">
 *
 * private function inviteMorePeople():void
 * {
 *    sfs.addEventListener(SFSEvent.USER_ENTER_ROOM, onUserJoin);
 *
 * 	  var invitedUsers:Array = ["Fozzie", "Piggy"];
 *    var room:Room = sfs.getRoomByName("The Garden");
 *
 *    var params:ISFSObject = new SFSObject();
 *    params.putUtfString("msg", "You are invited in this Room: " + room.name);
 *
 *    sfs.send( new JoinRoomInvitationRequest(room, invitedUsers, params) );
 * }
 *
 * private function onUserJoin(evt:SFSEvent):void
 * {
 * 	  trace("User joined Room: " + evt.params.user.name);
 * }
 * </listing>
 *
 * @see		com.smartfoxserver.v2.requests.RoomSettings RoomSettings
 */
class JoinRoomInvitationRequest extends BaseRequest
{
	private static inline var KEY_ROOM_ID : String = "r";
	private static inline var KEY_EXPIRY_SECONDS : String = "es";
	private static inline var KEY_INVITED_NAMES : String = "in";
	private static inline var KEY_AS_SPECT : String = "as";
	private static inline var KEY_OPTIONAL_PARAMS : String = "op";

	private var _targetRoom : Room;
	private var _invitedUserNames : Array<Dynamic>;
	private var _expirySeconds : Int;
	private var _asSpectator : Bool;
	private var _params : ISFSObject;

	/**
	 * Creates a new <em>JoinRoomInvitationRequest</em> instance.
	 * The instance must be passed to the <em>SmartFox.send()</em> method for the request to be performed.
	 *
	 * @param	targetRoom			The Room to join (must have free user/player slots).
	 * @param	invitedUserNames	A list of user names to invite.
	 * @param	params				An instance of <em>SFSObject</em> containing any relevant parameter or message to be sent to the invited users (for example an invitation message).
	 * @param	expirySeconds		The time given to the invitee to reply to the invitation.
	 * @param	asSpectator			In Game Rooms only, indicates if the invited user(s) should join as spectator(s) instead of player(s).
	 *
	 * @see		com.smartfoxserver.v2.SmartFox#send() SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function new(targetRoom : Room, invitedUserNames : Array<Dynamic>, params : ISFSObject = null, expirySeconds : Int = 30, asSpectator : Bool = false)
	{
		super(BaseRequest.JoinRoomInvite);

		_targetRoom = targetRoom;
		_invitedUserNames = invitedUserNames;
		_expirySeconds = expirySeconds;
		_asSpectator = asSpectator;

		_params = ((params != null)) ? params : new SFSObject();
	}

	/** @private */
	override public function validate(sfs : SmartFox) : Void
	{
		var errors : Array<Dynamic> = [];

		if (_targetRoom == null)
		{
			errors.push("Missing target room");
		}
		else if (_invitedUserNames == null || _invitedUserNames.length < 1)
		{
			errors.push("No invitees provided");
		}

		if (errors.length > 0)
		{
			throw new SFSValidationError("JoinRoomInvitationRequest request error", errors);
		}
	}

	/** @private */
	override public function execute(sfs : SmartFox) : Void
	{
		_sfso.putInt(KEY_ROOM_ID, _targetRoom.id);
		_sfso.putUtfStringArray(KEY_INVITED_NAMES, _invitedUserNames);
		_sfso.putSFSObject(KEY_OPTIONAL_PARAMS, _params);
		_sfso.putInt(KEY_EXPIRY_SECONDS, _expirySeconds);
		_sfso.putBool(KEY_AS_SPECT, _asSpectator);
	}
}
