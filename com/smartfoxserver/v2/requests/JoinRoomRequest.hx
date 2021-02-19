package com.smartfoxserver.v2.requests;


import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Joins the current user in a Room.
 * 
 *<p>If the operation is successful, the current user receives a<em>roomJoin</em>event;otherwise the<em>roomJoinError</em>event is fired. This
 * usually happens when the Room is full, or the password is wrong in case of password protected Rooms.</p>
 * 
 *<p>Depending on the Room configuration defined upon its creation(see the<em>RoomSettings.events</em>setting), when the current user joins it,
 * the following events might be fired:<em>userEnterRoom</em>, dispatched to the other users inside the Room to warn them that a new user has arrived;
 *<em>userCountChange</em>, dispatched to all clients which subscribed the Group to which the Room belongs, to update the count of users inside the Room.</p>
 * 
 * @example	The following example makes the user join an existing Room:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoined);
 * 	sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);
 * 	
 * 	// Join a Room called "Lobby"
 * 	sfs.send(new JoinRoomRequest("Lobby"));
 * }
 * 
 * private function onRoomJoined(evt:SFSEvent):Void
 * {
 * 	trace("Room joined successfully:" + evt.params.room);
 * }
 * 
 * private function onRoomJoinError(evt:SFSEvent):Void
 * {
 * 	trace("Room joining failed:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:roomJoin roomJoin event
 * @see		com.smartfoxserver.v2.SmartFox#event:roomJoinError roomJoinError event
 * @see		com.smartfoxserver.v2.SmartFox#event:userEnterRoom userEnterRoom event
 * @see		com.smartfoxserver.v2.SmartFox#event:userCountChange userCountChange event
 * @see		RoomSettings#events
 */
class JoinRoomRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM:String = "r";
	
	/** @private */
	public static inline var KEY_USER_LIST:String = "ul";
	
	/** @private */
	public static inline var KEY_ROOM_NAME:String = "n";
	
	/** @private */
	public static inline var KEY_ROOM_ID:String = "i";
	
	/** @private */
	public static inline var KEY_PASS:String = "p";
	
	/** @private */
	public static inline var KEY_ROOM_TO_LEAVE:String = "rl";
	
	/** @private */
	public static inline var KEY_AS_SPECTATOR:String = "sp";
	
	private var _roomId:Int = -1;
	private var _name:String;
	private var _pass:String;
	private var _roomIdToLeave:Int;
	private var _asSpectator:Bool;
	
	/**
	 * Creates a new<em>JoinRoomRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	id				The id or the name of the Room to be joined.
	 * @param	pass			The password of the Room, in case it is password protected.
	 * @param	roomIdToLeave	The id of a previously joined Room that the user should leave when joining the new Room.
	 * 							By default, the last joined Room is left;if a negative number is passed, no previous Room is left.
	 * @param	asSpect			<code>true</code>to join the Room as a spectator(in Game Rooms only).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 */
	public function new(id:Dynamic, pass:String=null, roomIdToLeave:Int=-1, asSpect:Bool=false)
	{
		super(BaseRequest.JoinRoom);

		if(Std.isOfType(id, String))
			_name = id;
		else if(Std.isOfType(id, Float))
			_roomId = id;
		else if(Std.isOfType(id, Room))
			_roomId = cast(id, Room).id;
		
		_pass = pass;
		_roomIdToLeave = roomIdToLeave;
		_asSpectator = asSpect;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// Missing room id
		if(_roomId<0 && _name==null)
			errors.push("Missing Room id or name, you should provide at least one");
			
		if(errors.length>0)
			throw new SFSValidationError("JoinRoom request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		if(_roomId>-1)
			_sfso.putInt(KEY_ROOM_ID, _roomId);
			
		else if(_name !=null)
			_sfso.putUtfString(KEY_ROOM_NAME, _name);
			
		if(_pass !=null)
			_sfso.putUtfString(KEY_PASS, _pass);
		
		/*
		 * If==NaN 	--->>Leave Last Joined Room
		 * If>0 		--->>Leave the Room with that ID
		 * If<0		--->>Do not leave any Room  
		 */	
		//if(!isNaN(_roomIdToLeave))
		_sfso.putInt(KEY_ROOM_TO_LEAVE, _roomIdToLeave);
		
		if(_asSpectator)
			_sfso.putBool(KEY_AS_SPECTATOR, _asSpectator);
	}
}