package com.smartfoxserver.v2.requests
{
	/**
	 * The <em>RoomEvents</em> class contains a specific subset of the <em>RoomSettings</em> required to create a Room.
	 * It defines which events related to the Room will be fired by the <em>SmartFox</em> client.
	 * 
	 * @see RoomSettings#events
	 * @see CreateRoomRequest
	 */
	public class RoomEvents
	{
		private var _allowUserEnter:Boolean
		private var _allowUserExit:Boolean
		private var _allowUserCountChange:Boolean
		private var _allowUserVariablesUpdate:Boolean

		/**
		 * Creates a new <em>RoomEvents</em> instance.
		 * The <em>RoomSettings.events</em> property must be set to this instance during Room creation.
		 * 
		 * @see		RoomSettings#events
		 */
		public function RoomEvents()
		{
			_allowUserCountChange = false
			_allowUserEnter = false
			_allowUserExit = false
			_allowUserVariablesUpdate = false
		}
		
		/**
		 * Indicates whether the <em>userEnterRoom</em> event should be dispatched whenever a user joins the Room or not.
		 * 
		 * @default false
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#event:userEnterRoom userEnterRoom event
		 */
		public function get allowUserEnter():Boolean 
		{ 
			return _allowUserEnter
		}
		
		/** @private */
		public function set allowUserEnter(value:Boolean):void 
		{ 
			_allowUserEnter = value
		}
		
		/**
		 * Indicates whether the <em>userExitRoom</em> event should be dispatched whenever a user leaves the Room or not.
		 * 
		 * @default false
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#event:userExitRoom userExitRoom event
		 */
		public function get allowUserExit():Boolean 
		{ 
			return _allowUserExit
		}
		
		/** @private */
		public function set allowUserExit(value:Boolean):void 
		{ 
			_allowUserExit = value
		}
		
		/**
		 * Indicates whether or not the <em>userCountChange</em> event should be dispatched whenever the users (or players+spectators) count changes in the Room.
		 * 
		 * @default false
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#event:userCountChange userCountChange event
		 */
		public function get allowUserCountChange():Boolean 
		{ 
			return _allowUserCountChange
		}
		
		/** @private */
		public function set allowUserCountChange(value:Boolean):void 
		{ 
			_allowUserCountChange = value
		}
		
		/**
		 * Indicates whether or not the <em>userVariablesUpdate</em> event should be dispatched whenever a user in the Room updates his User Variables.
		 * 
		 * @default false
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#event:userVariablesUpdate userVariablesUpdate event
		 */
		public function get allowUserVariablesUpdate():Boolean 
		{ 
			return _allowUserVariablesUpdate
		}
		
		/** @private */
		public function set allowUserVariablesUpdate(value:Boolean):void 
		{ 
			_allowUserVariablesUpdate = value
		}
	}
}