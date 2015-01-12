package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.exceptions.SFSValidationError;
	
	/**
	 * Unsubscribes the current user to Room-related events occurring in the specified Group.
	 * This allows the user to stop being notified of specific Room events occurring in Rooms belonging to the unsubscribed Group.
	 * 
	 * <p>If the operation is successful, the current user receives a <em>roomGroupUnsubscribe</em> event; otherwise the <em>roomGroupUnsubscribeError</em> event is fired.</p>
	 * 
	 * @example	The following example makes the current user unsubscribe a Group:
	 * <listing version="3.0">
	 * 
	 * private function someMethod():void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_UNSUBSCRIBE, onGroupUnsubscribed);
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR, onGroupUnsubscribeError);
	 * 	
	 * 	// Unsubscribe the "cardGames" group
	 * 	sfs.send(new UnsubscribeRoomGroupRequest("cardGames"));
	 * }
	 * 
	 * private function onGroupUnsubscribed(evt:SFSEvent):void
	 * {
	 * 	trace("Group unsubscribed: " + evt.params.groupId);
	 * }
	 * 
	 * private function onGroupUnsubscribeError(evt:SFSEvent):void
	 * {
	 * 	trace("Group unsubscribing failed: " + evt.params.errorMessage);
	 * }
	 * </listing>
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomGroupUnsubscribe roomGroupUnsubscribe event
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomGroupUnsubscribeError roomGroupUnsubscribeError event
	 * @see		SubscribeRoomGroupRequest
	 */
	public class UnsubscribeRoomGroupRequest extends BaseRequest
	{
		/** @private */
		public static const KEY_GROUP_ID:String = "g"
		
		private var _groupId:String
		
		/**
		 * Creates a new <em>UnsubscribeRoomGroupRequest</em> instance.
		 * The instance must be passed to the <em>SmartFox.send()</em> method for the request to be performed.
		 * 
		 * @param	groupId	The name of the Room Group to unsubscribe.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#send() SmartFox.send()
		 * @see		com.smartfoxserver.v2.entities.Room#groupId Room.groupId
		 */
		public function UnsubscribeRoomGroupRequest(groupId:String)
		{
			super(BaseRequest.UnsubscribeRoomGroup)
			_groupId = groupId
		}
		
		/** @private */
		override public function validate(sfs:SmartFox):void
		{
			var errors:Array = []
			
			// no validation needed
			if (_groupId == null || _groupId.length == 0)
				errors.push("Invalid groupId. Must be a string with at least 1 character.")
				
			if (errors.length > 0)
				throw new SFSValidationError("UnsubscribeGroup request error", errors)
		}
		
		/** @private */
		override public function execute(sfs:SmartFox):void
		{
			_sfso.putUtfString(KEY_GROUP_ID, _groupId)
		}
	}
}