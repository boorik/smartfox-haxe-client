package com.smartfoxserver.v2.requests.mmo;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.requests.RoomSettings;

/**
 * The<em>MMORoomSettings</em>class is a container for the settings required to create an MMORoom using the<em>CreateRoomRequest</em>request.
 * 
 * @see 	com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
 * @see		com.smartfoxserver.v2.entities.MMORoom MMORoom
 */
class MMORoomSettings extends RoomSettings
{
	private var _defaultAOI:Vec3D;
	private var _mapLimits:MapLimits;
	private var _userMaxLimboSeconds:Int=50;
	private var _proximityListUpdateMillis:Int=250;
	private var _sendAOIEntryPoint:Bool=true;
	
	/**
	 * Creates a new<em>MMORoomSettings</em>instance.
	 * The instance must be passed to the<em>CreateRoomRequest</em>class constructor.
	 * 
	 * @param	name	The name of the MMORoom to be created.
	 * 
	 * @see		com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
	 */
	public function new(name:String)
	{
		super(name);
	}
	
	/**
	 * Defines the Area of Interest(AoI)for the MMORoom.
	 * 
	 *<p>This value represents the area/range around the user that will be affected by server events and other users events.
	 * It is a<em>Vec3D</em>object providing 2D or 3D coordinates.</p>
	 * 
	 *<p>Setting this value is mandatory.</p>
	 * 
	 * @example	A<code>Vec3D(50,50)</code>describes a range of 50 units(e.g. pixels)in all four directions(top, bottom, left, right)with respect to the user position in a 2D coordinates system.<p></p>
	 * 
	 * @example	A<code>Vec3D(120,120,60)</code>describes a range of 120 units in all four directions(top, bottom, left, right)and 60 units along the two Z-axis directions(backward, forward)with respect to the user position in a 3D coordinates system.
	 */
	public var defaultAOI(get, set):Vec3D;
 	private function get_defaultAOI():Vec3D
	{
		return _defaultAOI;
	}
	
	
	/**
	 * Defines the limits of the virtual environment represented by the MMORoom.
	 * 
	 *<p>When specified, this property must contain two non-null<em>Vec3D</em>objects representing the minimum and maximum limits of the 2D/3D coordinates systems.
	 * Any positional value that falls outside the provided limit will be refused by the server.</p>
	 * 
	 *<p>This setting is optional but its usage is highly recommended.</p>
	 */
	public var mapLimits(get, set):MapLimits;
 	private function get_mapLimits():MapLimits
	{
		return _mapLimits;
	}
	
	/**
	 * Defines the time limit before a user without a physical position set inside the MMORoom is kicked from the Room.
	 * 
	 *<p>As soon as the MMORoom is joined, the user still doesn't have a physical position set in the coordinates system, therefore it is
	 * considered in a "limbo" state. At this point the user is expected to set his position(via the<em>SetUserPositionRequest</em>request)within the
	 * amount of seconds expressed by this value.</p>
	 * 
	 * @default	50 seconds
	 */
	public var userMaxLimboSeconds(get, set):Int;
 	private function get_userMaxLimboSeconds():Int
	{
		return _userMaxLimboSeconds;
	}
	
	/**
	 * Configures the speed at which the<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event is sent by the server.
	 * 
	 *<p>In an MMORoom, the regular users list is replaced by a proximity list, which keeps an updated view of the users currently within the Area of Interest 
	 * of the current user. The speed at which these updates are fired by the server is regulated by this parameter, which sets the minimum time between two subsequent updates.</p>
	 * 
	 *<p><b>NOTE:</b>values below the default might be unnecessary for most applications unless they are in realtime.</p>
	 * 
	 * @default	250 milliseconds
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event
	 */
	public var proximityListUpdateMillis(get, set):Int;
 	private function get_proximityListUpdateMillis():Int
	{
		return _proximityListUpdateMillis;
	}
	
	/**
	 * Sets if the users entry points in the current user's Area of Interest should be transmitted in the<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.
	 * 
	 *<p>If this setting is set to<code>true</code>, when a user enters the AoI of another user, the server will also send the coordinates
	 * at which the former "appeared" within the AoI. This option should be turned off in case these coordinates are not needed, in order to save bandwidth.</p>
	 * 
	 * @default true
	 * 
	 * @see		com.smartfoxserver.v2.entities.User#aoiEntryPoint User.aoiEntryPoint
	 * @see		com.smartfoxserver.v2.entities.MMOItem#aoiEntryPoint MMOItem.aoiEntryPoint
	 * @see		com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event
	 */
	public var sendAOIEntryPoint(get, set):Bool;
 	private function get_sendAOIEntryPoint():Bool
	{
		return _sendAOIEntryPoint;
	}
	
	/** @private */
	private function set_defaultAOI(value:Vec3D):Vec3D
	{
		return _defaultAOI=value;
	}
	
	/** @private */
	private function set_mapLimits(value:MapLimits):MapLimits
	{
		return _mapLimits=value;
	}
	
	/** @private */
	private function set_userMaxLimboSeconds(value:Int):Int
	{
		return _userMaxLimboSeconds=value;
	}
	
	/** @private */
	private function set_proximityListUpdateMillis(value:Int):Int
	{
		return _proximityListUpdateMillis=value;
	}
	
	/** @private */
	private function set_sendAOIEntryPoint(value:Bool):Bool
	{
		return _sendAOIEntryPoint=value;
	}
}