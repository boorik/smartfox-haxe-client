package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Turns the current user from player to spectator in a Game Room.
 * 
 *<p>If the operation is successful, all the users in the target Room are notified with the<em>playerToSpectator</em>event.
 * The operation could fail if no spectator slots are available in the Game Room at the time of the request;in this case
 * the<em>playerToSpectatorError</em>event is dispatched to the requester's client.</p>
 * 
 * @example	The following example turns the current user from player to spectator in the last joined Game Room:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.PLAYER_TO_SPECTATOR, onPlayerToSpectatorSwitch);
 * 	sfs.addEventListener(SFSEvent.PLAYER_TO_SPECTATOR_ERROR, onPlayerToSpectatorSwitchError);
 * 	
 * 	// Switch player to spectator
 * 	sfs.send(new PlayerToSpectatorRequest());
 * }
 * 
 * private function onPlayerToSpectatorSwitch(evt:SFSEvent):Void
 * {
 * 	trace("Player " + evt.params.user + " is now a spectator");
 * }
 * 
 * private function onPlayerToSpectatorSwitchError(evt:SFSEvent):Void
 * {
 * 	trace("Unable to become a spectator due to the following error:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:playerToSpectator playerToSpectator event
 * @see		com.smartfoxserver.v2.SmartFox#event:playerToSpectatorError playerToSpectatorError event
 * @see		SpectatorToPlayerRequest
 */
class PlayerToSpectatorRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM_ID:String = "r";
	
	/** @private */
	public static inline var KEY_USER_ID:String = "u";
	
	private var _room:Room;
	
	/**
	 * Creates a new<em>PlayerToSpectatorRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	targetRoom	The<em>Room</em>object corresponding to the Room in which the player should be turned to spectator. If<code>null</code>, the last Room joined by the user is used.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function new(targetRoom:Room=null)
	{
		super(BaseRequest.PlayerToSpectator);
		_room = targetRoom;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(sfs.joinedRooms.length<1)
			errors.push("You are not joined in any rooms");
			
		if(errors.length>0)
			throw new SFSValidationError("PlayerToSpectator request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		if(_room==null)
			_room = sfs.lastJoinedRoom;
			
		_sfso.putInt(KEY_ROOM_ID, _room.id);
	}
}