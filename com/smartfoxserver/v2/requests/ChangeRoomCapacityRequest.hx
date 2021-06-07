package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Changes the maximum number of users and/or spectators who can join a Room.
 * 
 *<p>If the operation is successful, the<em>roomCapacityChange</em>event is dispatched to all the users
 * who subscribed the Group to which the target Room belongs, including the requester user himself.
 * If the user is not the creator(owner)of the Room, or if the Room was configured so that capacity changing is not allowed
 *(see the<em>RoomSettings.permissions</em>parameter), the<em>roomCapacityChangeError</em>event is fired.
 * An administrator or moderator can override the first constrain(Std.isOfType(he, not) requested to be the Room's owner).</p>
 * 
 *<p>In case the Room's capacity is reduced to a value less than the current number of users/spectators inside the Room, exceeding users are NOT disconnected.</p>
 * 
 * @example	The following example changes the capacity of an existing Room:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_CAPACITY_CHANGE, onRoomCapacityChanged);
 * 	sfs.addEventListener(SFSEvent.ROOM_CAPACITY_CHANGE_ERROR, onRoomCapacityChangeError);
 * 	
 * 	var theRoom:Room=sfs.getRoomByName("Gonzo's Room");
 * 	
 * 	// Resize the Room so that it allows a maximum of 100 users and zero spectators
 * 	sfs.send(new ChangeRoomCapacityRequest(theRoom, 100, 0));
 * }
 * 
 * private function onRoomCapacityChanged(evt:SFSEvent):Void
 * {
 * 	trace("The capacity of Room " + evt.params.room.name + " was changed successfully");
 * }
 * 
 * private function onRoomCapacityChangeError(evt:SFSEvent):Void
 * {
 * 	trace("Room capacity change failed:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:roomCapacityChange roomCapacityChange event
 * @see		com.smartfoxserver.v2.SmartFox#event:roomCapacityChangeError roomCapacityChangeError event
 * @see		RoomSettings#permissions RoomSettings.permissions
 */
class ChangeRoomCapacityRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM:String = "r";
	
	/** @private */
	public static inline var KEY_USER_SIZE:String = "u";
	
	/** @private */
	public static inline var KEY_SPEC_SIZE:String = "s";
	
	private var _room:Room;
	private var _newMaxUsers:Int;
	private var _newMaxSpect:Int;
	
	/**
	 * Creates a new<em>ChangeRoomCapacityRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	room		The<em>Room</em>object corresponding to the Room whose capacity should be changed.
	 * @param	newMaxUsers	The new maximum number of users/players who can join the Room;the<code>-1</code>value can be passed not to change the<em>Room.maxUsers</em>property.
	 * @param	newMaxSpect	The new maximum number of spectators who can join the Room(for Game Rooms only);the<code>-1</code>value can be passed not to change the<em>Room.maxSpectators</em>property.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.Room#maxUsers Room.maxUsers
	 */
	public function new(room:Room, newMaxUsers:Int, newMaxSpect:Int)
	{
		super(BaseRequest.ChangeRoomCapacity);
		
		_room = room;
		_newMaxUsers = newMaxUsers;
		_newMaxSpect = newMaxSpect;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// Missing room id
		if(_room==null)
			errors.push("Provided room is null");
			
		if(errors.length>0)
			throw new SFSValidationError("ChangeRoomCapacity request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_ROOM, _room.id);
		_sfso.putInt(KEY_USER_SIZE, _newMaxUsers);
		_sfso.putInt(KEY_SPEC_SIZE, _newMaxSpect);
	}
}