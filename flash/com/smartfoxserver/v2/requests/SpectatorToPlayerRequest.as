package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.exceptions.SFSValidationError;
	
	/**
	 * Turns the current user from spectator to player in a Game Room.
	 * 
	 * <p>If the operation is successful, all the users in the target Room are notified with the <em>spectatorToPlayer</em> event.
	 * The operation could fail if no player slots are available in the Game Room at the time of the request; in this case
	 * the <em>spectatorToPlayerError</em> event is dispatched to the requester's client.</p>
	 * 
	 * @example	The following example turns the current user from spectator to player in the last joined Game Room:
	 * <listing version="3.0">
	 * 
	 * private function someMethod():void
	 * {
	 * 	sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER, onSpectatorToPlayerSwitch);
	 * 	sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER_ERROR, onSpectatorToPlayerSwitchError);
	 * 	
	 * 	// Switch spectator to player
	 * 	sfs.send(new SpectatorToPlayerRequest());
	 * }
	 * 
	 * private function onSpectatorToPlayerSwitch(evt:SFSEvent):void
	 * {
	 * 	trace("Spectator " + evt.params.user + " is now a player");
	 * }
	 * 
	 * private function onSpectatorToPlayerSwitchError(evt:SFSEvent):void
	 * {
	 * 	trace("Unable to become a player due to the following error: " + evt.params.errorMessage);
	 * }
	 * </listing>
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:spectatorToPlayer spectatorToPlayer event
	 * @see		com.smartfoxserver.v2.SmartFox#event:spectatorToPlayerError spectatorToPlayerError event
	 * @see		PlayerToSpectatorRequest
	 */
	public class SpectatorToPlayerRequest extends BaseRequest
	{
		/** @private */
		public static const KEY_ROOM_ID:String = "r"
		
		/** @private */
		public static const KEY_USER_ID:String = "u"
		
		/** @private */
		public static const KEY_PLAYER_ID:String = "p"
		
		private var _room:Room
		
		/**
		 * Creates a new <em>SpectatorToPlayerRequest</em> instance.
		 * The instance must be passed to the <em>SmartFox.send()</em> method for the request to be performed.
		 * 
		 * @param	targetRoom	The <em>Room</em> object corresponding to the Room in which the spectator should be turned to player. If <code>null</code>, the last Room joined by the user is used.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#send() SmartFox.send()
		 * @see		com.smartfoxserver.v2.entities.Room Room
		 */
		public function SpectatorToPlayerRequest(targetRoom:Room = null)
		{
			super(BaseRequest.SpectatorToPlayer)
			_room = targetRoom
		}
		
		/** @private */
		override public function validate(sfs:SmartFox):void
		{
			var errors:Array = []
			
			if (sfs.joinedRooms.length < 1)
				errors.push("You are not joined in any rooms")
				
			if (errors.length > 0)
				throw new SFSValidationError("SpectatorToPlayer request error", errors)
		}
		
		/** @private */
		override public function execute(sfs:SmartFox):void
		{
			if (_room == null)
				_room = sfs.lastJoinedRoom
				
			_sfso.putInt(KEY_ROOM_ID, _room.id)
		}
	}
}