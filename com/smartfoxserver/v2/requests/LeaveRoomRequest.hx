package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Leaves one of the Rooms joined by the current user.
 * 
 *<p>Depending on the Room configuration defined upon its creation(see the<em>RoomSettings.events</em>setting), when the current user leaves it,
 * the following events might be fired:<em>userExitRoom</em>, dispatched to all the users inside the Room(including the current user then)to warn them that a user has gone away;
 *<em>userCountChange</em>, dispatched to all clients which subscribed the Group to which the Room belongs, to update the count of users inside the Room.</p>
 * 
 * @example	The following example makes the user leave the currently joined Room and handles the respective event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitRoom);
 * 	
 * 	// Leave the last joined Room
 * 	sfs.send(new LeaveRoomRequest());
 * }
 * 
 * private function onUserExitRoom(evt:SFSEvent):Void
 * {
 * 	var room:Room=evt.params.room;
 * 	var user:User=evt.params.user;
 * 	
 * 	trace("User " + user.name + " just left Room " + room.name);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:userExitRoom userExitRoom event
 * @see		com.smartfoxserver.v2.SmartFox#event:userCountChange userCountChange event
 * @see		RoomSettings#events
 */
class LeaveRoomRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM_ID:String = "r";
	
	private var _room:Room;
	
	/**
	 * Creates a new<em>LeaveRoomRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	theRoom	The<em>Room</em>object corresponding to the Room that the current user must leave. If<code>null</code>, the last Room joined by the user is left.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function new(theRoom:Room=null)
	{
		super(BaseRequest.LeaveRoom);
		_room = theRoom;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];

		// no validation needed
		if(sfs.joinedRooms.length<1)
			errors.push("You are not joined in any rooms");
			
		if(errors.length>0)
			throw new SFSValidationError("LeaveRoom request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		if(_room !=null)
			_sfso.putInt(KEY_ROOM_ID, _room.id);
	}
}