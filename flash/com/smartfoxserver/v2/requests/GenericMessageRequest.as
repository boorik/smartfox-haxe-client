package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.Vec3D;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.exceptions.SFSValidationError;
	import com.smartfoxserver.v2.logging.Logger;
	
	import de.polygonal.ds.ListSet;
	
	/** @private */
	public class GenericMessageRequest extends BaseRequest
	{
		/** @exclude */
		public static const KEY_ROOM_ID:String = "r";					// The room id
		
		/** @exclude */
		public static const KEY_USER_ID:String = "u";					// The sender ( ???????????????????????? )
		
		/** @exclude */
		public static const KEY_MESSAGE:String = "m";					// The actual message
		
		/** @exclude */
		public static const KEY_MESSAGE_TYPE:String = "t";				// The message type
		
		/** @exclude */
		public static const KEY_RECIPIENT:String = "rc";				// The recipient (for sendObject and sendPrivateMessage)
		
		/** @exclude */
		public static const KEY_RECIPIENT_MODE:String = "rm";			// For admin/mod messages, indicate toUser, toRoom, toGroup, toZone
		
		/** @exclude */ 
		public static const KEY_XTRA_PARAMS:String = "p";				// Extra custom parameters (mandatory for sendObject)
		
		/** @exclude */ 
		public static const KEY_SENDER_DATA:String = "sd";				// The sender User data (when cross room message)
		
		/** @exclude */ 
		public static const KEY_AOI:String = "aoi";						// Custom AOI for MMO messages
		
		/** @exclude */ 
		protected var _type:int = -1
		
		/** @exclude */ 
		protected var _room:Room
		
		/** @exclude */ 
		protected var _user:User
		
		/** @exclude */ 
		protected var _message:String
		
		/** @exclude */  									
		protected var _params:ISFSObject
		
		/** @exclude */ 
		protected var _recipient:*
		
		/** @exclude */ 
		protected var _sendMode:int = -1
		
		/** @exclude */ 
		protected var _aoi:Vec3D
		
		
		public function GenericMessageRequest()
		{
			super(BaseRequest.GenericMessage)
		}
		
		/*
		 * NOTE:
		 * Validation is performed by the specific Message class, e.g. PublicMessageRequest, PrivateMessageRequest, SendObjectRequest 
		 */
		 
		/** @exclude */ 
		override public function validate(sfs:SmartFox):void
		{
			// Check for a valid type			
			if (_type < 0)
				throw new SFSValidationError("PublicMessage request error", ["Unsupported message type: " + _type])
				
			var errors:Array = []
			
			switch (_type)
			{
				case GenericMessageType.PUBLIC_MSG:
					validatePublicMessage(sfs, errors)
					break
					
				case GenericMessageType.PRIVATE_MSG:
					validatePrivateMessage(sfs, errors)
					break
					
				case GenericMessageType.OBJECT_MSG:
					validateObjectMessage(sfs, errors)
					break
					
				case GenericMessageType.BUDDY_MSG:
					validateBuddyMessage(sfs, errors)
					break
					
				default:
					validateSuperUserMessage(sfs, errors)
			}
			
			if (errors.length > 0)
				throw new SFSValidationError("Request error - ", errors)
		}
		
		/** @exclude */ 
		override public function execute(sfs:SmartFox):void
		{
			// Set the message type
			_sfso.putByte(KEY_MESSAGE_TYPE, _type)
			
			switch (_type)
			{
				case GenericMessageType.PUBLIC_MSG:
					executePublicMessage(sfs)
					break
					
				case GenericMessageType.PRIVATE_MSG:
					executePrivateMessage(sfs)
					break
					
				case GenericMessageType.OBJECT_MSG:
					executeObjectMessage(sfs)
					break
				
				case GenericMessageType.BUDDY_MSG:
					executeBuddyMessage(sfs)
					break
					
				default:
					executeSuperUserMessage(sfs)
			}
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Specialized validators
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function validatePublicMessage(sfs:SmartFox, errors:Array):void
		{
			if (_message == null || _message.length == 0)
				errors.push("Public message is empty!")
				
			if (_room != null && sfs.joinedRooms.indexOf(_room) < 0)
				errors.push("You are not joined in the target Room: " + _room)
		}
		
		private function validatePrivateMessage(sfs:SmartFox, errors:Array):void
		{
			if (_message == null || _message.length == 0)
				errors.push("Private message is empty!")
			
			if (_recipient < 0)
				errors.push("Invalid recipient id: " + _recipient)
		}
		
		private function validateObjectMessage(sfs:SmartFox, errors:Array):void
		{
			if (_params == null)
				errors.push("Object message is null!")
		}
		
		private function validateBuddyMessage(sfs:SmartFox, errors:Array):void
		{
			if (!sfs.buddyManager.isInited)
				errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.")
				
			if (sfs.buddyManager.myOnlineState == false)
				errors.push("Can't send messages while off-line")
				
			if (_message == null || _message.length == 0)
				errors.push("Buddy message is empty!")
				
			var recipientId:int = Number(_recipient)
			if (recipientId < 0)
				errors.push("Recipient is not online or not in your buddy list")
		}
		
		private function validateSuperUserMessage(sfs:SmartFox, errors:Array):void
		{
			if (_message == null || _message.length == 0)
				errors.push("Moderator message is empty!")
				
			switch (_sendMode)
			{
				case MessageRecipientMode.TO_USER:
					if (!(_recipient is User))
						errors.push("TO_USER expects a User object as recipient")
					break
					
				case MessageRecipientMode.TO_ROOM:
					if (!(_recipient is Room))
						errors.push("TO_ROOM expects a Room object as recipient")
					break
				
				case MessageRecipientMode.TO_GROUP:
					if (!(_recipient is String))
						errors.push("TO_GROUP expects a String object (the groupId) as recipient")
					break
			}
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Specialized executors
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function executePublicMessage(sfs:SmartFox):void
		{
			// No room was passed, let's use the last joined one
			if (_room == null)
				_room = sfs.lastJoinedRoom
			
			// If it doesn't exist we have a problem
			if (_room == null)
				throw new SFSError("User should be joined in a room in order to send a public message")
			
			_sfso.putInt(KEY_ROOM_ID, _room.id)
			_sfso.putInt(KEY_USER_ID, sfs.mySelf.id)
			_sfso.putUtfString(KEY_MESSAGE, _message)
			
			if (_params != null)
				_sfso.putSFSObject(KEY_XTRA_PARAMS, _params)
		}
		
		private function executePrivateMessage(sfs:SmartFox):void
		{
			_sfso.putInt(KEY_RECIPIENT, _recipient as int)
			_sfso.putUtfString(KEY_MESSAGE, _message)
			
			if (_params != null)
				_sfso.putSFSObject(KEY_XTRA_PARAMS, _params)
		}
		
		private function executeBuddyMessage(sfs:SmartFox):void
		{
			// Id of the recipient buddy
			_sfso.putInt(KEY_RECIPIENT, _recipient as int)
			
			// Message
			_sfso.putUtfString(KEY_MESSAGE, _message)
			
			// Params
			if (_params != null)
				_sfso.putSFSObject(KEY_XTRA_PARAMS, _params)
		}
		
		private function executeSuperUserMessage(sfs:SmartFox):void
		{
			_sfso.putUtfString(KEY_MESSAGE, _message)
		
			if (_params != null)
				_sfso.putSFSObject(KEY_XTRA_PARAMS, _params)
			
			_sfso.putInt(KEY_RECIPIENT_MODE, _sendMode)
			
			switch (_sendMode)
			{
				// Put the User.id as Int
				case MessageRecipientMode.TO_USER:
					_sfso.putInt(KEY_RECIPIENT, _recipient.id)
					break
					
				// Put the Room.id as Int
				case MessageRecipientMode.TO_ROOM:
					_sfso.putInt(KEY_RECIPIENT, _recipient.id)
					break
					
				// Put the Room Group as String
				case MessageRecipientMode.TO_GROUP:
					_sfso.putUtfString(KEY_RECIPIENT, _recipient)
					break
					
				// the TO_ZONE case does not need to pass any other params
			}
		}
		
		private function executeObjectMessage(sfs:SmartFox):void
		{
			// No room aws passed, let's use the last joined one
			if (_room == null)
				_room = sfs.lastJoinedRoom
				
			// Populate a recipient list, no duplicates allowed
			var recipients:ListSet = new ListSet()
			
			if (_recipient is Array)
			{
				var potentialRecipients:Array = _recipient as Array
				
				// Check that recipient list is not bigger than the Room capacity 
				if (potentialRecipients.length > _room.capacity)
					throw new ArgumentError("The number of recipients is bigger than the target Room capacity: " + potentialRecipients.length)
					
				// Filter out potential wrong elements
				for each (var item:* in potentialRecipients)
				{
					if (item is User)
						recipients.set(item.id)
					else
						sfs.logger.warn("Bad recipient in ObjectMessage recipient list: " + (typeof item) + ", expected type: User")
				}
				
			}
			
			_sfso.putInt(KEY_ROOM_ID, _room.id)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params)
			
			// Optional user list
			if (recipients.size() > 0)
				_sfso.putIntArray(KEY_RECIPIENT, recipients.toDA().getArray())
		}
	}
}