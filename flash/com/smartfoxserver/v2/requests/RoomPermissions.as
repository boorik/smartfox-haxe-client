package com.smartfoxserver.v2.requests
{
	/**
	 * The <em>RoomPermissions</em> class contains a specific subset of the <em>RoomSettings</em> required to create a Room.
	 * It defines which operations users will be able to execute on the Room after its creation.
	 * 
	 * @see RoomSettings#permissions
	 * @see CreateRoomRequest
	 */
	public class RoomPermissions
	{
		private var _allowNameChange:Boolean
		private var _allowPasswordStateChange:Boolean
		private var _allowPublicMessages:Boolean
		private var _allowResizing:Boolean
		//private var _maxRoomVariables:int
		
		/**
		 * Creates a new <em>RoomPermissions</em> instance.
		 * The <em>RoomSettings.permissions</em> property must be set to this instance during Room creation.
		 * 
		 * @see		RoomSettings#permissions
		 */
		public function RoomPermissions()
		{

		}
		
		/**
		 * Indicates whether changing the Room name after its creation is allowed or not.
		 * 
		 * <p>The Room name can be changed by means of the <em>ChangeRoomNameRequest</em> request.</p>
		 * 
		 * @default false
		 * 
		 * @see		ChangeRoomNameRequest
		 */
		public function get allowNameChange():Boolean 
		{ 
			return _allowNameChange
		}
		
		/** @private */
		public function set allowNameChange(value:Boolean):void 
		{ 
			_allowNameChange = value
		}
		
		/**
		 * Indicates whether changing (or removing) the Room password after its creation is allowed or not.
		 * 
		 * <p>The Room password can be changed by means of the <em>ChangeRoomPasswordStateRequest</em> request.</p>
		 * 
		 * @default false
		 * 
		 * @see		ChangeRoomPasswordStateRequest
		 */
		public function get allowPasswordStateChange():Boolean 
		{ 
			return _allowPasswordStateChange
		}
		
		/** @private */
		public function set allowPasswordStateChange(value:Boolean):void 
		{ 
			_allowPasswordStateChange = value
		}
		
		/**
		 * Indicates whether users inside the Room are allowed to send public messages or not.
		 * 
		 * <p>Public messages can be sent by means of the <em>PublicMessageRequest</em> request.</p>
		 * 
		 * @default false
		 * 
		 * @see		PublicMessageRequest
		 */
		public function get allowPublicMessages():Boolean 
		{ 
			return _allowPublicMessages
		}
		
		/** @private */
		public function set allowPublicMessages(value:Boolean):void 
		{ 
			_allowPublicMessages = value
		}
		
		/**
		 * Indicates whether the Room capacity can be changed after its creation or not.
		 * 
		 * <p>The capacity is the maximum number of users and spectators (in Game Rooms) allowed to enter the Room.
		 * It can be changed by means of the <em>ChangeRoomCapacityRequest</em> request.</p>
		 * 
		 * @default false
		 * 
		 * @see		ChangeRoomCapacityRequest
		 */
		public function get allowResizing():Boolean 
		{ 
			return _allowResizing
		}
		
		/** @private */
		public function set allowResizing(value:Boolean):void 
		{ 
			_allowResizing = value
		}
	}
}