package com.smartfoxserver.v2.entities;

import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.IMMOItem;
import com.smartfoxserver.v2.util.ArrayUtil;
import haxe.ds.IntMap;

/**
 * The<em>MMORoom</em>object represents a specialized type of Room entity on the client.
 * 
 *<p>The MMORoom is ideal for huge virtual worlds and MMO games because it works with proximity lists instead of "regular" users lists.
 * This allows thousands of users to Interact with each other based on their Area of Interest(AoI). The AoI represents a range around the user
 * that is affected by server and user events, outside which no other events are received.</p>
 * 
 *<p>The size of the AoI is set at Room creation time and it is the same for all users who joined it.
 * Supposing that the MMORoom hosts a 3D virtual world, setting an AoI of(x=100, y=100, z=40)for the Room tells the server to transmit updates and broadcast
 * events to and from those users that fall within the AoI range around the current user;this means the area within +/- 100 units on the X axis, +/- 100 units on the Y axis
 * and +/- 40 units on the Z axis.</p>
 * 
 *<p>As the user moves around in the virtual environment, he can update his position in the corresponding MMORoom and thus continuously receive events
 * about other users(and items - see below)entering and leaving his AoI.
 * The player will be able to update his position via the<em>SetUserPositionRequest</em>request and receive updates on his current proximity list by means of the
 *<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.</p>
 * 
 *<p>Finally, MMORooms can also host any number of "MMOItems" which represent dynamic non-player objects that users can Interact with.
 * They are handled by the MMORoom using the same rules of visibility described before.</p>
 * 
 * @see	com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings MMORoomSettings
 * @see	com.smartfoxserver.v2.requests.mmo.SetUserPositionRequest SetUserPositionRequest
 * @see com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event
 * @see	com.smartfoxserver.v2.entities.MMOItem MMOItem
 */ 
class MMORoom extends SFSRoom
{
	private var _defaultAOI:Vec3D;
	private var _lowerMapLimit:Vec3D;
	private var _higherMapLimit:Vec3D;
	private var _itemsById:IntMap<IMMOItem>;
	
	/** @inheritDoc */
	public function new(id:Int, name:String, groupId:String="default")
	{
		super(id, name, groupId);
		_itemsById = new IntMap();
	}
	
	/**
	 * Returns the default Area of Interest(AoI)of this MMORoom.
	 * 
	 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings#defaultAOI MMORoomSettings.defaultAOI
	 */
	public var defaultAOI(get, set):Vec3D;
 	private function get_defaultAOI():Vec3D
	{
		return _defaultAOI;
	}
	
	/**
	 * Returns the lower coordinates limit of the virtual environment represented by the MMORoom along the X,Y,Z axes.
	 * If<code>null</code>is returned, no limits were set at Room creation time.
	 * 
	 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings#mapLimits MMORoomSettings.mapLimits
	 */
	public var lowerMapLimit(get, set):Vec3D;
 	private function get_lowerMapLimit():Vec3D
	{
		return _lowerMapLimit;	
	}
	
	/**
	 * Returns the higher coordinates limit of the virtual environment represented by the MMORoom along the X,Y,Z axes.
	 * If<code>null</code>is returned, no limits were set at Room creation time.
	 * 
	 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings#mapLimits MMORoomSettings.mapLimits
	 */
	public var higherMapLimit(get, set):Vec3D;
 	private function get_higherMapLimit():Vec3D
	{
		return _higherMapLimit;
	}
	
	/** @private */
	private function set_defaultAOI(value:Vec3D):Vec3D
	{
		if(_defaultAOI !=null)
			throw "This value is read-only";
			
		return _defaultAOI=value;
	}
	
	/** @private */
	private function set_lowerMapLimit(value:Vec3D):Vec3D
	{
		if(_lowerMapLimit !=null)
			throw "This value is read-only";

		return _lowerMapLimit=value;
	}
	
	/** @private */
	private function set_higherMapLimit(value:Vec3D):Vec3D
	{
		if(_higherMapLimit !=null)
			throw "This value is read-only";
		
		return _higherMapLimit=value;
	}
	
	/**
	 * Retrieves an<em>MMOItem</em>object from its<em>id</em>property.
	 * The item is available to the current user if it falls within his Area of Interest only.
	 * 
	 * @param	id	The id of the item to be retrieved.
	 * 
	 * @return	An<em>MMOItem</em>object, or<code>null</code>if the item with the passed id is not in proximity of the current user.
	 */ 
	public function getMMOItem(id:Int):IMMOItem
	{
		return _itemsById.get(id);
	}
	
	/**
	 * Retrieves all<em>MMOItem</em>object in the MMORoom that fall within the current user's Area of Interest. 
	 * 
	 * @return	A list of<em>MMOItem</em>objects, or an empty list if no item is in proximity of the current user.
	 * 
	 * @see	com.smartfoxserver.v2.entities.MMOItem MMOItem
	 */
	public function getMMOItems():Array<IMMOItem>
	{
		return Lambda.array(_itemsById);	
	}
	
	
	//:::Hidden methods:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	public function addMMOItem(item:IMMOItem):Void
	{
		_itemsById.set(item.id,item);
	}
	
	public function removeItem(id:Int):Void
	{
		_itemsById.remove(id);
	}
}