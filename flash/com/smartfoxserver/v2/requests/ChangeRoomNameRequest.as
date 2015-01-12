package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.exceptions.SFSValidationError;
	
	/**
	 * Changes the name of a Room.
	 * 
	 * <p>If the renaming operation is successful, the <em>roomNameChange</em> event is dispatched to all the users
	 * who subscribed the Group to which the target Room belongs, including the user who renamed it.
	 * If the user is not the creator (owner) of the Room, or if the Room was configured so that renaming is not allowed
	 * (see the <em>RoomSettings.permissions</em> parameter), the <em>roomNameChangeError</em> event is fired.
	 * An administrator or moderator can override the first constrain (he is not requested to be the Room's owner).</p>
	 * 
	 * @example	The following example renames an existing Room:
	 * <listing version="3.0">
	 * 
	 * private function someMethod():void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_NAME_CHANGE, onRoomNameChanged);
	 * 	sfs.addEventListener(SFSEvent.ROOM_NAME_CHANGE_ERROR, onRoomNameChangeError);
	 * 	
	 * 	var theRoom:Room = sfs.getRoomByName("Gonzo's Room");
	 * 	sfs.send(new ChangeRoomNameRequest(theRoom, "Gonzo The Great's Room"));
	 * }
	 * 
	 * private function onRoomNameChanged(evt:SFSEvent):void
	 * {
	 * 	trace("Room " + evt.params.oldName + " was successfully renamed to " + evt.params.room.name);
	 * }
	 * 
	 * private function onRoomNameChangeError(evt:SFSEvent):void
	 * {
	 * 	trace("Room name change failed: " + evt.params.errorMessage);
	 * }
	 * </listing>
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomNameChange roomNameChange event
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomNameChangeError roomNameChangeError event
	 * @see		RoomSettings#permissions RoomSettings.permissions
	 */
	public class ChangeRoomNameRequest extends BaseRequest
	{
		/** @private */
		public static const KEY_ROOM:String = "r"
		
		/** @private */
		public static const KEY_NAME:String = "n"
		
		private var _room:Room
		private var _newName:String
		
		/**
		 * Creates a new <em>ChangeRoomNameRequest</em> instance.
		 * The instance must be passed to the <em>SmartFox.send()</em> method for the request to be performed.
		 * 
		 * @param	room	The <em>Room</em> object corresponding to the Room whose name should be changed.
		 * @param	newName	The new name to be assigned to the Room.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#send() SmartFox.send()
		 */
		public function ChangeRoomNameRequest(room:Room, newName:String)
		{
			super(BaseRequest.ChangeRoomName)
			
			_room = room
			_newName = newName	
		}

		/** @private */
		override public function validate(sfs:SmartFox):void
		{
			var errors:Array = []
			
			// Missing room id
			if (_room == null)
				errors.push("Provided room is null")
			
			if (_newName == null || _newName.length == 0)
				errors.push("Invalid new room name. It must be a non-null and non-empty string.")
				
			if (errors.length > 0)
				throw new SFSValidationError("ChangeRoomName request error", errors)
		}
		
		/** @private */
		override public function execute(sfs:SmartFox):void
		{
			_sfso.putInt(KEY_ROOM, _room.id)
			_sfso.putUtfString(KEY_NAME, _newName)
		}
	}
}