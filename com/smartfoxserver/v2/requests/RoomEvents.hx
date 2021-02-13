package com.smartfoxserver.v2.requests;
/**
 * The<em>RoomEvents</em>class contains a specific subset of the<em>RoomSettings</em>required to create a Room.
 * It defines which events related to the Room will be fired by the<em>SmartFox</em>client.
 * 
 * @see RoomSettings#events
 * @see CreateRoomRequest
 */
class RoomEvents
{
	private var _allowUserEnter:Bool;
	private var _allowUserExit:Bool;
	private var _allowUserCountChange: Bool;
	private var _allowUserVariablesUpdate:Bool;

	/**
	 * Creates a new<em>RoomEvents</em>instance.
	 * The<em>RoomSettings.events</em>property must be set to this instance during Room creation.
	 * 
	 * @see		RoomSettings#events
	 */
	public function new()
	{
		_allowUserCountChange = false;
		_allowUserEnter = false;
		_allowUserExit = false;
		_allowUserVariablesUpdate = false;
	}
	
	/**
	 * Indicates whether the<em>userEnterRoom</em>event should be dispatched whenever a user joins the Room or not.
	 * 
	 * @default false
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:userEnterRoom userEnterRoom event
	 */
	public var allowUserEnter(get, set):Bool;
 	private function get_allowUserEnter():Bool 
	{ 
		return _allowUserEnter;
	}
	
	/** @private */
	private function set_allowUserEnter(value:Bool):Bool 
	{ 
		return _allowUserEnter = value;
	}
	
	/**
	 * Indicates whether the<em>userExitRoom</em>event should be dispatched whenever a user leaves the Room or not.
	 * 
	 * @default false
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:userExitRoom userExitRoom event
	 */
	public var allowUserExit(get, set):Bool;
 	private function get_allowUserExit():Bool 
	{ 
		return _allowUserExit;
	}
	
	/** @private */
	private function set_allowUserExit(value:Bool):Bool 
	{ 
		return _allowUserExit = value;
	}
	
	/**
	 * Indicates whether or not the<em>userCountChange</em>event should be dispatched whenever the users(or players+spectators)count changes in the Room.
	 * 
	 * @default false
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:userCountChange userCountChange event
	 */
	public var allowUserCountChange(get, set):Bool;
 	private function get_allowUserCountChange():Bool 
	{ 
		return _allowUserCountChange;
	}
	
	/** @private */
	private function set_allowUserCountChange(value:Bool):Bool 
	{ 
		return _allowUserCountChange = value;
	}
	
	/**
	 * Indicates whether or not the<em>userVariablesUpdate</em>event should be dispatched whenever a user in the Room updates his User Variables.
	 * 
	 * @default false
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:userVariablesUpdate userVariablesUpdate event
	 */
	public var allowUserVariablesUpdate(get, set):Bool;
 	private function get_allowUserVariablesUpdate():Bool 
	{ 
		return _allowUserVariablesUpdate;
	}
	
	/** @private */
	private function set_allowUserVariablesUpdate(value:Bool):Bool 
	{ 
		return _allowUserVariablesUpdate = value;
	}
}