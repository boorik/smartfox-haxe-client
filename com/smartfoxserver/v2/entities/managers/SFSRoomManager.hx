package com.smartfoxserver.v2.entities.managers;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.util.ArrayUtil;
import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * The<em>SFSRoomManager</em>class is the entity in charge of managing the client-side Rooms list.
 * It keeps track of all the Rooms available in the client-side Rooms list and of subscriptions to multiple Room Groups.
 * It also provides various utility methods to look for Rooms by name and id, retrieve Rooms belonging to a specific Group, etc.
 * 
 * @see		com.smartfoxserver.v2.SmartFox#roomManager SmartFox.roomManager
 */
class SFSRoomManager implements IRoomManager
{
	private var _ownerZone:String;
	private var _groups:Array<String>;
	private var _roomsById:IntMap<Room>;
	private var _roomsByName:StringMap<Room>;
	
	/** @private */
	private var _smartFox:SmartFox ;
	
	/**
	 * Creates a new<em>SFSRoomManager</em>instance.
	 * 
	 *<p><b>NOTE</b>:developers never instantiate a<em>SFSRoomManager</em>manually:this is done by the SmartFoxServer 2X API Internally.
	 * A reference to the existing instance can be retrieved using the<em>SmartFox.roomManager</em>property.</p>
	 *  
	 * @param 	sfs		An instance of the SmartFoxServer 2X client API main<em>SmartFox</em>class.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#roomManager SmartFox.roomManager
	 */
	public function new(sfs:SmartFox)
	{
		_groups = new Array();
		_roomsById = new IntMap<Room>();
		_roomsByName = new StringMap();
	}
	
	/** @private */
	public var ownerZone(get, set):String;
 	private function get_ownerZone():String
	{
		return _ownerZone;
	}
	
	/** @private */
	private function set_ownerZone(value:String):String
	{
		return _ownerZone = value;
	}
	
	/** @private */
	public var smartFox(get, null):SmartFox;
 	private function get_smartFox():SmartFox
	{
		return _smartFox;
	}
	
	/** @private */
	public function addRoom(room:Room, addGroupIfMissing:Bool=true):Void
	{
		_roomsById.set(room.id, room);
		_roomsByName.set(room.name, room);
		
		// If group is not known, add it to the susbscribed list
		if(addGroupIfMissing)
		{
			if(!containsGroup(room.groupId))
				addGroup(room.groupId);
		}
		
		/*
		* We don't add a group that was not subscribed
		* Instead we mark the Room as *NOT MANAGED* which means that it will be removed from the local
		* RoomList as soon as we leave it
		*/
		else
			room.isManaged = false	;
	}
	
	/** @private */
	public function replaceRoom(room:Room, addToGroupIfMissing:Bool=true):Room
	{
		// Take the Room object that should be replaced
		var oldRoom:Room = getRoomById(room.id);
			
		/*
		* If found, the Room is already in the RoomList and we don't want 
		* to replace the object, only update it
		*/
		if(oldRoom !=null)
		{
			cast(oldRoom,SFSRoom).merge(room);
			return oldRoom;
		}
				
		// There's no previous instance, just add it			
		else
		{
			addRoom(room, addToGroupIfMissing);
			return room;
		}
	}
	
	/** @private */
	public function changeRoomName(room:Room, newName:String):Void
	{
		var oldName:String = room.name;
		room.name = newName;
		
		// Update keys in the byName collection
		_roomsByName.set(newName, room);
		_roomsByName.remove(oldName);
	}
	
	/** @private */
	public function changeRoomPasswordState(room:Room, isPassProtected:Bool):Void
	{
		room.setPasswordProtected(isPassProtected);
	}
	
	/** @private */
	public function changeRoomCapacity(room:Room, maxUsers:Int, maxSpect:Int):Void
	{
		room.maxUsers = maxUsers;
		room.maxSpectators = maxSpect;
	}
	
	/** @inheritDoc */
	public function getRoomGroups():Array<String>
	{
		return _groups;
	}
	
	/** @private */
	public function addGroup(groupId:String):Void
	{
		_groups.push(groupId);
	}
	
	/** @private */
	public function removeGroup(groupId:String):Void
	{
		// Remove group
		ArrayUtil.removeElement(_groups, groupId);
		
		var roomsInGroup:Array<Room> = getRoomListFromGroup(groupId);
		
		/*
		* We remove all rooms from the Group with the exception
		* of those that are joined. The joined Rooms must remain in the local Room List
		* but they are marked as unmanaged because we no longer subscribe to their Group
		*
		* The unmanaged Room(s)will be removed as soon as we leave it 
		*/
		for(room in roomsInGroup)
		{
			if(!room.isJoined)
				removeRoom(room);
			else
				room.isManaged = false;
		}
		
	}
	
	/** @inheritDoc */
	public function containsGroup(groupId:String):Bool
	{
		return(_groups.indexOf(groupId) > -1);
	}
	
	/** @inheritDoc */
	public function containsRoom(idOrName:Dynamic):Bool
	{
		if(Std.isOfType(idOrName,Int))
			return _roomsById.exists(idOrName);
		else
			return _roomsByName.exists(idOrName);
	}
	
	/** @inheritDoc */
	public function containsRoomInGroup(idOrName:Dynamic, groupId:String):Bool
	{
		var roomList:Array<Room> = getRoomListFromGroup(groupId);
		var found:Bool = false;	
		var searchById:Bool = (Std.isOfType(idOrName,Float));
		
		for(room in roomList)
		{
			if(searchById)
			{
				if(room.id==idOrName)
				{
					found = true;
					break;
				}
			}
			else
			{
				if(room.name==idOrName)
				{
					found = true;
					break;
				}	
			}
		}
		
		return found;
	}
	
	/** @inheritDoc */
	public function getRoomById(id:Int):Room
	{
		return cast _roomsById.get(id);
	}
	
	/** @inheritDoc */
	public function getRoomByName(name:String):Room
	{
	 	return cast _roomsByName.get(name);
	}
	
	/** @inheritDoc */
	public function getRoomList():Array<Room>
	{
		return Lambda.array(_roomsById);
	}
	
	/** @inheritDoc */
	public function getRoomCount():Int
	{
		return Lambda.count(_roomsById);
	}
	
	/** @inheritDoc */
	public function getRoomListFromGroup(groupId:String):Array<Room>
	{
		var roomList:Array<Room> = new Array();
		for(room in _roomsById)
		{

			if(room.groupId==groupId)
				roomList.push(room);
		}
		
		return roomList;
	}
	
	/** @private */
	public function removeRoom(room:Room):Void
	{
		_removeRoom(room.id, room.name);
	}
	
	/** @private */
	public function removeRoomById(id:Int):Void
	{
		var room:Room = _roomsById.get(id);
		
		if(room !=null)
			_removeRoom(id, room.name);
	}
	
	/** @private */
	public function removeRoomByName(name:String):Void
	{
		var room:Room = _roomsByName.get(name);
		
		if(room !=null)
			_removeRoom(room.id, name);
	}
	
	// Return rooms joined by local user
	/** @inheritDoc */
	public function getJoinedRooms():Array<Room>
	{
		var rooms:Array<Room> = [];
		for(room in _roomsById)
		{		
			if(room.isJoined)
				rooms.push(room);
		}
		
		return rooms;
	}
	
	/** @inheritDoc */
	public function getUserRooms(user:User):Array<Room>
	{
		var rooms:Array<Room> = [];
		
		// Cycle through all Rooms
		for (room in _roomsById)
		{
			if(room.containsUser(user))
				rooms.push(room);
		}	
		
		return rooms;
	}
	
	/** @private */
	public function removeUser(user:User):Void
	{
		
		// Cycle through all Rooms
		for (room in _roomsById)
		{
			if(room.containsUser(user))
				room.removeUser(user);
		}	
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Private methods
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function _removeRoom(id:Int, name:String):Void
	{
		_roomsById.remove(id);
		_roomsByName.remove(name);
	}
}