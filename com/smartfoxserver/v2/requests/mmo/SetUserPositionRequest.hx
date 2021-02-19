package com.smartfoxserver.v2.requests.mmo;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.MMOItem;
import com.smartfoxserver.v2.entities.MMORoom;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;
/**
 * Updates the User position inside an MMORoom.
 * 
 *<p>MMORooms represent virtual environments and can host any number of users. Based on their position, the system allows users within a certain range
 * from each other(Area of Interest, or AoI)to Interact.
 * This request allows the current user to update his position inside the MMORoom, which in turn will trigger a<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event
 * for all users that fall within his AoI.</p>
 * 
 * @example	The following example changes the position of the user in a 2D coordinates space:
 *<listing version="3.0">
 * 
 * private function updatePlayerPosition(px:Int, py:Int):Void
 * {
 * 	var newPos:Vec3D=new Vec3D(px, py);
 * 	sfs.send(new SetUserPositionRequest(newPos));
 * }
 *</listing>
 * 
 * @see com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event 
 * @see	com.smartfoxserver.v2.entities.MMORoom MMORoom
 */
class SetUserPositionRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM:String="r";
	
	/** @private */
	public static inline var KEY_VEC3D:String="v";
	
	/** @private */
	public static inline var KEY_PLUS_USER_LIST:String="p";
	
	/** @private */
	public static inline var KEY_MINUS_USER_LIST:String="m";
	
	/** @private */
	public static inline var KEY_PLUS_ITEM_LIST:String="q";
	
	/** @private */
	public static inline var KEY_MINUS_ITEM_LIST:String="n";
	
	
	private var _pos:Vec3D;
	private var _room:Room;
	
	/**
	 * Creates a new<em>SetUserPositionRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	pos			The user position.
	 * @param	theRoom		The<em>MMORoom</em>object corresponding to the Room where the position should be set;if<code>null</code>, the last Room joined by the user is used.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see 	com.smartfoxserver.v2.entities.data.Vec3D Vec3D
	 */
	public function new(pos:Vec3D, theRoom:Room=null)
	{
		super(BaseRequest.SetUserPosition);
		
		_pos=pos;
		_room=theRoom;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// Missing room id
		if(_pos==null)
			errors.push("Position must be a Vec3D instance");
		
		if(_room==null)
			_room=sfs.lastJoinedRoom;
				
		if(_room==null)
			errors.push("You are not joined in any room");
				
		if(!(Std.isOfType(_room, MMORoom)))
			errors.push("Selected Room is not an MMORoom");
		
		if(errors.length>0)
			throw new SFSValidationError("SetUserPosition request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_ROOM, _room.id);
		
		if(_pos.isFloat())
			_sfso.putFloatArray(KEY_VEC3D, _pos.toArray());
		
		else 
			_sfso.putIntArray(KEY_VEC3D, _pos.toIntArray());
	}
}