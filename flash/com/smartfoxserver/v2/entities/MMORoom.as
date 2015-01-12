package com.smartfoxserver.v2.entities
{
	import com.smartfoxserver.v2.entities.data.Vec3D;
	import com.smartfoxserver.v2.kernel;
	import com.smartfoxserver.v2.util.ArrayUtil;
	
	/**
	 * The <em>MMORoom</em> object represents a specialized type of Room entity on the client.
	 * 
	 * <p>The MMORoom is ideal for huge virtual worlds and MMO games because it works with proximity lists instead of "regular" users lists.
	 * This allows thousands of users to interact with each other based on their Area of Interest (AoI). The AoI represents a range around the user
	 * that is affected by server and user events, outside which no other events are received.</p>
	 * 
	 * <p>The size of the AoI is set at Room creation time and it is the same for all users who joined it.
	 * Supposing that the MMORoom hosts a 3D virtual world, setting an AoI of (x=100, y=100, z=40) for the Room tells the server to transmit updates and broadcast
	 * events to and from those users that fall within the AoI range around the current user; this means the area within +/- 100 units on the X axis, +/- 100 units on the Y axis
	 * and +/- 40 units on the Z axis.</p>
	 * 
	 * <p>As the user moves around in the virtual environment, he can update his position in the corresponding MMORoom and thus continuously receive events
	 * about other users (and items - see below) entering and leaving his AoI.
	 * The player will be able to update his position via the <em>SetUserPositionRequest</em> request and receive updates on his current proximity list by means of the
	 * <em>SFSEvent.PROXIMITY_LIST_UPDATE</em> event.</p>
	 * 
	 * <p>Finally, MMORooms can also host any number of "MMOItems" which represent dynamic non-player objects that users can interact with.
	 * They are handled by the MMORoom using the same rules of visibility described before.</p>
	 * 
	 * @see	com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
	 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings MMORoomSettings
	 * @see	com.smartfoxserver.v2.requests.mmo.SetUserPositionRequest SetUserPositionRequest
	 * @see com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event
	 * @see	com.smartfoxserver.v2.entities.MMOItem MMOItem
	 */ 
	public class MMORoom extends SFSRoom
	{
		private var _defaultAOI:Vec3D;
		private var _lowerMapLimit:Vec3D;
		private var _higherMapLimit:Vec3D;
		private var _itemsById:Object = {};
		
		/** @inheritDoc */
		public function MMORoom(id:int, name:String, groupId:String="default")
		{
			super(id, name, groupId);
		}
		
		/**
		 * Returns the default Area of Interest (AoI) of this MMORoom.
		 * 
		 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings#defaultAOI MMORoomSettings.defaultAOI
		 */
		public function get defaultAOI():Vec3D
		{
			return _defaultAOI;
		}
		
		/**
		 * Returns the lower coordinates limit of the virtual environment represented by the MMORoom along the X,Y,Z axes.
		 * If <code>null</code> is returned, no limits were set at Room creation time.
		 * 
		 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings#mapLimits MMORoomSettings.mapLimits
		 */
		public function get lowerMapLimit():Vec3D
		{
			return _lowerMapLimit;	
		}
		
		/**
		 * Returns the higher coordinates limit of the virtual environment represented by the MMORoom along the X,Y,Z axes.
		 * If <code>null</code> is returned, no limits were set at Room creation time.
		 * 
		 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings#mapLimits MMORoomSettings.mapLimits
		 */
		public function get higherMapLimit():Vec3D
		{
			return _higherMapLimit;
		}
		
		/** @private */
		public function set defaultAOI(value:Vec3D):void
		{
			if (_defaultAOI != null)
				throw new ArgumentError("This value is read-only")
				
			_defaultAOI = value;
		}
		
		/** @private */
		public function set lowerMapLimit(value:Vec3D):void
		{
			if (_lowerMapLimit != null)
				throw new ArgumentError("This value is read-only")

			_lowerMapLimit = value;
		}
		
		/** @private */
		public function set higherMapLimit(value:Vec3D):void
		{
			if (_higherMapLimit != null)
				throw new ArgumentError("This value is read-only")
			
			_higherMapLimit = value;
		}
		
		/**
		 * Retrieves an <em>MMOItem</em> object from its <em>id</em> property.
		 * The item is available to the current user if it falls within his Area of Interest only.
		 * 
		 * @param	id	The id of the item to be retrieved.
		 * 
		 * @return	An <em>MMOItem</em> object, or <code>null</code> if the item with the passed id is not in proximity of the current user.
		 */ 
		public function getMMOItem(id:int):IMMOItem
		{
			return _itemsById[id];
		}
		
		/**
		 * Retrieves all <em>MMOItem</em> object in the MMORoom that fall within the current user's Area of Interest. 
		 * 
		 * @return	A list of <em>MMOItem</em> objects, or an empty list if no item is in proximity of the current user.
		 * 
		 * @see	com.smartfoxserver.v2.entities.MMOItem MMOItem
		 */
		public function getMMOItems():Array
		{
			return ArrayUtil.objToArray(_itemsById);	
		}
		
		
		// ::: Hidden methods :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		kernel function addMMOItem(item:IMMOItem):void
		{
			_itemsById[item.id] = item;
		}
		
		kernel function removeItem(id:int):void
		{
			delete _itemsById[id];
		}
	}
}