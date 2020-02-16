package com.smartfoxserver.v2.requests;
/**
 * The<em>RoomPermissions</em>class contains a specific subset of the<em>RoomSettings</em>required to create a Room.
 * It defines which operations users will be able to execute on the Room after its creation.
 * 
 * @see RoomSettings#permissions
 * @see CreateRoomRequest
 */
class RoomPermissions
{
	private var _allowNameChange:Bool;
	private var _allowPasswordStateChange:Bool;
	private var _allowPublicMessages:Bool;
	private var _allowResizing:Bool;
	//private var _maxRoomVariables:Int
	
	/**
	 * Creates a new<em>RoomPermissions</em>instance.
	 * The<em>RoomSettings.permissions</em>property must be set to this instance during Room creation.
	 * 
	 * @see		RoomSettings#permissions
	 */
	public function new()
	{

	}
	
	/**
	 * Indicates whether changing the Room name after its creation is allowed or not.
	 * 
	 *<p>The Room name can be changed by means of the<em>ChangeRoomNameRequest</em>request.</p>
	 * 
	 * @default false
	 * 
	 * @see		ChangeRoomNameRequest
	 */
	public var allowNameChange(get, set):Bool;
 	private function get_allowNameChange():Bool 
	{ 
		return _allowNameChange;
	}
	
	/** @private */
	private function set_allowNameChange(value:Bool):Bool 
	{ 
		return _allowNameChange = value;
	}
	
	/**
	 * Indicates whether changing(or removing)the Room password after its creation is allowed or not.
	 * 
	 *<p>The Room password can be changed by means of the<em>ChangeRoomPasswordStateRequest</em>request.</p>
	 * 
	 * @default false
	 * 
	 * @see		ChangeRoomPasswordStateRequest
	 */
	public var allowPasswordStateChange(get, set):Bool;
 	private function get_allowPasswordStateChange():Bool 
	{ 
		return _allowPasswordStateChange;
	}
	
	/** @private */
	private function set_allowPasswordStateChange(value:Bool):Bool 
	{ 
		return _allowPasswordStateChange = value;
	}
	
	/**
	 * Indicates whether users inside the Room are allowed to send public messages or not.
	 * 
	 *<p>Public messages can be sent by means of the<em>PublicMessageRequest</em>request.</p>
	 * 
	 * @default false
	 * 
	 * @see		PublicMessageRequest
	 */
	public var allowPublicMessages(get, set):Bool;
 	private function get_allowPublicMessages():Bool 
	{ 
		return _allowPublicMessages;
	}
	
	/** @private */
	private function set_allowPublicMessages(value:Bool):Bool 
	{ 
		return _allowPublicMessages = value;
	}
	
	/**
	 * Indicates whether the Room capacity can be changed after its creation or not.
	 * 
	 *<p>The capacity is the maximum number of users and spectators(in Game Rooms)allowed to enter the Room.
	 * It can be changed by means of the<em>ChangeRoomCapacityRequest</em>request.</p>
	 * 
	 * @default false
	 * 
	 * @see		ChangeRoomCapacityRequest
	 */
	public var allowResizing(get, set):Bool;
 	private function get_allowResizing():Bool 
	{ 
		return _allowResizing;
	}
	
	/** @private */
	private function set_allowResizing(value:Bool):Bool 
	{ 
		return _allowResizing = value;
	}
}