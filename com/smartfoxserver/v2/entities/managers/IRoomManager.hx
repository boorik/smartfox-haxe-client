package com.smartfoxserver.v2.entities.managers;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;

/**
 * The<em>IRoomManager</em>interface defines all the methods and properties exposed by the client-side manager of the SmartFoxServer Room entities.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSRoomManager</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSRoomManager
 */
interface IRoomManager
{
	/** @private */
	var ownerZone(get, null):String;
	//function get ownerZone():String
	
	/** @private */
	function addRoom(room:Room, addGroupIfMissing:Bool = true):Void;
	
	/** @private */
	function addGroup(groupId:String):Void;
	
	/** @private */
	function replaceRoom(room:Room, addToGroupIfMissing:Bool = true):Room;
	
	/** @private */
	function removeGroup(groupId:String):Void;
	
	/**
	 * Indicates whether the specified Group has been subscribed by the client or not.
	 * 
	 * @param	groupId	The name of the Group.
	 * 
	 * @return	<code>true</code>if the client subscribed the passed Group.
	 */
	function containsGroup(groupId:String):Bool;
	
	/**
	 * Indicates whether a Room exists in the Rooms list or not.
	 * 
	 * @param	idOrName	The id or name of the<em>Room</em>object whose presence in the Rooms list is to be tested.
	 * 
	 * @return	<code>true</code>if the passed Room exists in the Rooms list.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Room#id Room.id
	 * @see		com.smartfoxserver.v2.entities.Room#name Room.name
	 */
	function containsRoom(idOrName:Dynamic):Bool;
	
	/**
	 * Indicates whether the Rooms list contains a Room belonging to the specified Group or not.
	 * 
	 * @param	idOrName	The id or name of the<em>Room</em>object whose presence in the Rooms list is to be tested.
	 * @param	groupId		The name of the Group to which the specified Room must belong.
	 * 
	 * @return	<code>true</code>if the Rooms list contains the passed Room and it belongs to the specified Group.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Room#id Room.id
	 * @see		com.smartfoxserver.v2.entities.Room#name Room.name
	 * @see		com.smartfoxserver.v2.entities.Room#groupId Room.groupId
	 */
	function containsRoomInGroup(idOrName:Dynamic, groupId:String):Bool;
	
	/** @private */
	function changeRoomName(room:Room, newName:String):Void;
	
	/** @private */
	function changeRoomPasswordState(room:Room, isPassProtected:Bool):Void;
	
	/** @private */
	function changeRoomCapacity(room:Room, maxUsers:Int, maxSpect:Int):Void;
	
	/**
	 * Retrieves a<em>Room</em>object from its id.
	 * 
	 * @param	id	The id of the Room.
	 * 
	 * @return	An object representing the requested Room;<code>null</code>if no<em>Room</em>object with the passed id exists in the Rooms list.
	 * 
	 * @example	The following example retrieves a<em>Room</em>object and traces its name:
	 *<listing version="3.0">
	 * 
	 * var roomId:Int=3;
	 * var room:Room=sfs.getRoomById(roomId);
	 * trace("The name of Room", roomId, "is", room.name);
	 *</listing>
	 * 
	 * @see		#getRoomByName()
	 */
	function getRoomById(id:Int):Room;
	
	/**
	 * Retrieves a<em>Room</em>object from its name.
	 * 
	 * @param	name	The name of the Room.
	 * 
	 * @return	An object representing the requested Room;<code>null</code>if no<em>Room</em>object with the passed name exists in the Rooms list.
	 * 
	 * @example	The following example retrieves a<em>Room</em>object and traces its id:
	 *<listing version="3.0">
	 * 
	 * var roomName:String="The Lobby";
	 * var room:Room=sfs.getRoomByName(roomName);
	 * trace("The ID of Room '", roomName, "' is", room.id);
	 *</listing>
	 * 
	 * @see		#getRoomById()
	 */
	function getRoomByName(name:String):Room;
	
	/**
	 * Returns a list of Rooms currently "known" by the client.
	 * The list contains all the Rooms that are currently joined and all the Rooms belonging to the Room Groups that have been subscribed.
	 * 
	 *<p><b>NOTE</b>:at login time, the client automatically subscribes all the Room Groups specified in the Zone's<b>Default Room Groups</b>setting.</p>
	 * 
	 * @return	The list of the available<em>Room</em>objects.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 * @see 	com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
	 * @see 	com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest SubscribeRoomGroupRequest
	 * @see 	com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest UnsubscribeRoomGroupRequest
	 */
	function getRoomList():Array<Room>;
	
	/**
	 * Returns the current number of Rooms in the Rooms list.
	 * 
	 * @return	The number of Rooms in the Rooms list.
	 */
	function getRoomCount():Int;
	
	/**
	 * Returns the names of Room Groups currently subscribed by the client.
	 * 
	 *<p><b>NOTE</b>:at login time, the client automatically subscribes all the Room Groups specified in the Zone's<b>Default Room Groups</b>setting.</p>
	 * 
	 * @return	A list of Room Group names.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Room#groupId Room.groupId
	 * @see 	com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest SubscribeRoomGroupRequest
	 * @see 	com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest UnsubscribeRoomGroupRequest
	 */
	function getRoomGroups():Array<String>;
	
	/**
	 * Retrieves the list of Rooms which are part of the specified Room Group.
	 * 
	 * @param	groupId	The name of the Group.
	 * 
	 * @return	The list of<em>Room</em>objects belonging to the passed Group.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	function getRoomListFromGroup(groupId:String):Array<Room>;
	
	/**
	 * Returns a list of Rooms currently joined by the client.
	 * 
	 * @return	The list of<em>Room</em>objects representing the Rooms currently joined by the client.
	 * 
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
	 */
	function getJoinedRooms():Array<Room>;
	
	/**
	 * Retrieves a list of Rooms joined by the specified user.
	 * The list contains only those Rooms "known" by the Room Manager;the user might have joined others the client is not aware of.
	 * 
	 * @param	user	A<em>User</em>object representing the user to look for in the current Rooms list.
	 * 
	 * @return	The list of Rooms joined by the passed user.
	 */
	function getUserRooms(user:User):Array<Room>;
	
	/** @private */
	function removeRoom(room:Room):Void;
	
	/** @private */
	function removeRoomById(id:Int):Void;
	
	/** @private */
	function removeRoomByName(name:String):Void;
	
	/** @private */
	function removeUser(user:User):Void;
	
	/** @private */
	var smartFox(get, null):SmartFox;
	//function get smartFox():SmartFox
}