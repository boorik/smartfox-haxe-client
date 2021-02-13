package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Sets one or more custom Room Variables in a Room.
 * 
 *<p>When a Room Variable is set, the<em>roomVariablesUpdate</em>event is dispatched to all the users in the target Room, including the user who updated it.
 * Also, if the Room Variable is global(see the<em>SFSRoomVariable</em>class description), the event is dispatched to all users who subscribed the Group to which the target Room is associated.</p>
 * 
 * @example	The following example sets a number of Room Variables and handles the respective update event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, onRoomVarsUpdate);
 * 	
 * 	// Create some Room Variables
 * 	var roomVars:Array<Dynamic>=[];
 * 	roomVars.push(new SFSRoomVariable("gameStarted", false));
 * 	roomVars.push(new SFSRoomVariable("gameType", "Snooker"));
 * 	roomVars.push(new SFSRoomVariable("minRank", 10));
 * 	
 * 	sfs.send(new SetRoomVariablesRequest(roomVars));
 * }
 * 
 * private function onRoomVarsUpdate(evt:SFSEvent):Void
 * {
 * 	var changedVars:Array<Dynamic>=evt.params.changedVars as Array<Dynamic>;
 * 	var room:Room=evt.params.room as Room;
 * 	
 * 	// Check if the "gameStarted" variable was changed
 * 	if(changedVars.indexOf("gameStarted")!=-1)
 * 	{
 * 		if(room.getVariable("gameStarted").getBoolValue()==true)
 * 			trace("Game started");
 * 		else
 * 			trace("Game stopped");
 * 	}
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:roomVariablesUpdate roomVariablesUpdate event
 * @see		com.smartfoxserver.v2.entities.variables.SFSRoomVariable SFSRoomVariable
 */
class SetRoomVariablesRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_VAR_ROOM:String = "r";
	
	/** @private */
	public static inline var KEY_VAR_LIST:String = "vl";
	
	private var _roomVariables:Array<RoomVariable>;
	private var _room:Room;
	
	/**
	 * Creates a new<em>SetRoomVariablesRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	roomVariables	A list of<em>RoomVariable</em>objects representing the Room Variables to be set.
	 * @param	room			A<em>Room</em>object representing the Room where to set the Room Variables;if<code>null</code>, the last Room joined by the current user is used.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.variables.RoomVariable RoomVariable
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function new(roomVariables:Array<RoomVariable>, room:Room=null)
	{
		super(BaseRequest.SetRoomVariables);
		
		_roomVariables = roomVariables;
		_room = room	;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// Make sure that the user is joined in the room where variables are going to be set
		if(_room !=null)
		{
			if(!_room.containsUser(sfs.mySelf))
				errors.push("You are not joined in the target room");
		}
		else
		{
			if(sfs.lastJoinedRoom==null)
				errors.push("You are not joined in any rooms");
		}
		
		if(_roomVariables==null || _roomVariables.length==0)
			errors.push("No variables were specified");
		
		if(errors.length>0)
			throw new SFSValidationError("SetRoomVariables request error", errors);
		
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		var varList:ISFSArray = SFSArray.newInstance();
		 
		for(rv in _roomVariables)
		{
			varList.addSFSArray(rv.toSFSArray());		
		}
		
		if(_room==null)
			_room = sfs.lastJoinedRoom ;
		
		_sfso.putSFSArray(KEY_VAR_LIST, varList);
		_sfso.putInt(KEY_VAR_ROOM, _room.id);
	}
}