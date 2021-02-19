package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import openfl.errors.Error;

/**
 * Changes the password of a Room.
 * This request not only changes the password of a Room, but also its "password state", which indicates if the Room is password protected or not.
 * 
 *<p>If the operation is successful, the<em>roomPasswordStateChange</em>event is dispatched to all the users
 * who subscribed the Group to which the target Room belongs, including the requester user himself.
 * If the user is not the creator(owner)of the Room, or if the Room was configured so that password changing is not allowed
 *(see the<em>RoomSettings.permissions</em>parameter), the<em>roomPasswordStateChangeError</em>event is fired.
 * An administrator or moderator can override the first constrain(Std.isOfType(he, not) requested to be the Room's owner).</p>
 * 
 * @example	The following example changes the password of an existing Room:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_PASSWORD_STATE_CHANGE, onRoomPasswordStateChanged);
 * 	sfs.addEventListener(SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR, onRoomPasswordStateChangeError);
 * 	
 * 	var theRoom:Room=sfs.getRoomByName("Gonzo's Room");
 * 	sfs.send(new ChangeRoomPasswordStateRequest(theRoom, "mammamia"));
 * }
 * 
 * private function onRoomPasswordStateChanged(evt:SFSEvent):Void
 * {
 * 	trace("The password of Room " + evt.params.room.name + " was changed successfully");
 * }
 * 
 * private function onRoomPasswordStateChangeError(evt:SFSEvent):Void
 * {
 * 	trace("Room password change failed:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:roomPasswordStateChange roomPasswordStateChange event
 * @see		com.smartfoxserver.v2.SmartFox#event:roomPasswordStateChangeError roomPasswordStateChangeError event
 * @see		RoomSettings#permissions RoomSettings.permissions
 */
class ChangeRoomPasswordStateRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM:String = "r";
	
	/** @private */
	public static inline var KEY_PASS:String = "p";
	
	private var _room:Room;
	private var _newPass:String;
	
	/**
	 * Creates a new<em>ChangeRoomPasswordStateRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	room	The<em>Room</em>object corresponding to the Room whose password should be changed.
	 * @param	newPass	The new password to be assigned to the Room;an empty string or the<code>null</code>value can be passed to remove the Room's password.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(room:Room, newPass:String)
	{
		super(BaseRequest.ChangeRoomPassword);
		
		_room = room;
		_newPass = newPass	;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// Missing room id
		if(_room==null)
			errors.push("Provided room is null");
		
		if(_newPass==null)
			errors.push("Invalid new room password. It must be a non-null string.");
			
		if(errors.length>0)
			throw new SFSValidationError("ChangePassState request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_ROOM, _room.id);
		_sfso.putUtfString(KEY_PASS, _newPass);
	}
}