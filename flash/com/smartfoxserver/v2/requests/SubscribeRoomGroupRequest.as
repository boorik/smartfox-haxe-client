package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.exceptions.SFSValidationError;
	
	/**
	 * Subscribes the current user to Room-related events occurring in the specified Group.
	 * This allows the user to be notified of specific Room events even if he didn't join the Room from which the events originated, provided the Room belongs to the subscribed Group.
	 * 
	 * <p>If the subscription operation is successful, the current user receives a <em>roomGroupSubscribe</em> event; otherwise the <em>roomGroupSubscribeError</em> event is fired.</p>
	 * 
	 * @example	The following example makes the current user subscribe a Group:
	 * <listing version="3.0">
	 * 
	 * private function someMethod():void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE, onGroupSubscribed);
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR, onGroupSubscribeError);
	 * 	
	 * 	// Subscribe the "cardGames" group
	 * 	sfs.send(new SubscribeRoomGroupRequest("cardGames"));
	 * }
	 * 
	 * private function onGroupSubscribed(evt:SFSEvent):void
	 * {
	 * 	trace("Group subscribed. The following rooms are now accessible: " + evt.params.newRooms);
	 * }
	 * 
	 * private function onGroupSubscribeError(evt:SFSEvent):void
	 * {
	 * 	trace("Group subscription failed: " + evt.params.errorMessage);
	 * }
	 * </listing>
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomGroupSubscribe roomGroupSubscribe event
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomGroupSubscribeError roomGroupSubscribeError event
	 * @see		UnsubscribeRoomGroupRequest
	 */
	public class SubscribeRoomGroupRequest extends BaseRequest
	{
		/** @private */
		public static const KEY_GROUP_ID:String = "g"
		
		/** @private */
		public static const KEY_ROOM_LIST:String = "rl"
		
		private var _groupId:String
		
		/**
		 * Creates a new <em>SubscribeRoomGroupRequest</em> instance.
		 * The instance must be passed to the <em>SmartFox.send()</em> method for the request to be performed.
		 * 
		 * @param	groupId	The name of the Room Group to subscribe.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#send() SmartFox.send()
		 * @see		com.smartfoxserver.v2.entities.Room#groupId Room.groupId
		 */
		public function SubscribeRoomGroupRequest(groupId:String)
		{
			super(BaseRequest.SubscribeRoomGroup)
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
				throw new SFSValidationError("SubscribeGroup request error", errors)
		}
		
		/** @private */
		override public function execute(sfs:SmartFox):void
		{
			_sfso.putUtfString(KEY_GROUP_ID, _groupId)
		}
	}
}