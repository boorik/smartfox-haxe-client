package com.smartfoxserver.v2.requests
{
	/**
	 * The <em>MessageRecipientMode</em> class is used to specify the recipient/s of moderator and administrator messages.
	 * Read the constants descriptions for more informations.
	 * 
	 * @see		ModeratorMessageRequest
	 * @see		AdminMessageRequest
	 */
	public class MessageRecipientMode
	{
		/**
		 * The moderator/administrator message will be sent to a specific user.
		 * A <em>User</em> instance must be passed as <em>target</em> parameter to the class constructor.
		 * 
		 * @see		com.smartfoxserver.v2.entities.User User
		 */
		public static const TO_USER:int = 0
		
		/**
		 * The moderator/administrator message will be sent to all the users in a specific Room.
		 * A <em>Room</em> instance must be passed as <em>target</em> parameter to the class constructor.
		 * 
		 * @see		com.smartfoxserver.v2.entities.Room Room
		 */
		public static const TO_ROOM:int = 1
		
		/**
		 * The moderator/administrator message will be sent to all the clients who subscribed a specific Room Group.
		 * A Group id must be passed as <em>target</em> parameter to the class constructor.
		 * 
		 * @see		com.smartfoxserver.v2.entities.Room#groupId Room.groupId
		 */
		public static const TO_GROUP:int = 2
		
		/**
		 * The moderator/administrator message will be sent to all the users in the Zone.
		 * <code>null</code> can be passed as <em>target</em> parameter, in fact it will be ignored.
		 */
		public static const TO_ZONE:int = 3
		
		private var _target:*
		private var _mode:int
		
		/**
		 * Creates a new <em>MessageRecipientMode</em> instance.
		 * The instance must be passed as <em>recipientMode</em> parameter to the <em>ModeratorMessageRequest()</em> and <em>AdminMessageRequest()</em> classes constructors.
		 * 
		 * @param	mode	One of the constants contained in this class, describing the recipient mode.
		 * @param	target	The moderator/administrator message recipient/s, according to the selected recipient mode.
		 * 
		 * @see		ModeratorMessageRequest
		 * @see		AdminMessageRequest
		 */
		public function MessageRecipientMode(mode:int, target:*)
		{
			if (mode < TO_USER || mode > TO_ZONE)
				throw new ArgumentError("Illegal recipient mode: " + mode)
				
			_mode = mode
			_target = target
		}
		
		/**
		 * Returns the selected recipient mode.
		 */
		public function get mode():int
		{
			return _mode
		}

		/**
		 * Returns the moderator/administrator message target, according to the selected recipient mode.
		 */
		public function get target():*
		{
			return _target
		}
	}
}