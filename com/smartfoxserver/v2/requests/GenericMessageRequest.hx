package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.logging.Logger;
import openfl.errors.ArgumentError;

/** @private */
class GenericMessageRequest extends BaseRequest
{
	/** @exclude */
	public static inline var KEY_ROOM_ID:String="r";					// The room id
	
	/** @exclude */
	public static inline var KEY_USER_ID:String="u";					// The sender(????????????????????????)
	
	/** @exclude */
	public static inline var KEY_MESSAGE:String="m";					// The actual message
	
	/** @exclude */
	public static inline var KEY_MESSAGE_TYPE:String="t";				// The message type
	
	/** @exclude */
	public static inline var KEY_RECIPIENT:String="rc";				// The recipient(for sendObject and sendPrivateMessage)
	
	/** @exclude */
	public static inline var KEY_RECIPIENT_MODE:String="rm";			// For admin/mod messages, indicate toUser, toRoom, toGroup, toZone
	
	/** @exclude */ 
	public static inline var KEY_XTRA_PARAMS:String="p";				// Extra custom parameters(mandatory for sendObject)
	
	/** @exclude */ 
	public static inline var KEY_SENDER_DATA:String="sd";				// The sender User data(when cross room message)
	
	/** @exclude */ 
	public static inline var KEY_AOI:String="aoi";						// Custom AOI for MMO messages
	
	/** @exclude */ 
	private var _type:Int = -1;
	
	/** @exclude */ 
	private var _room:Room;
	
	/** @exclude */ 
	private var _user:User;
	
	/** @exclude */ 
	private var _message:String;
	
	/** @exclude */  									
	private var _params:ISFSObject;
	
	/** @exclude */ 
	private var _recipient:Dynamic;
	
	/** @exclude */ 
	private var _sendMode:Int = -1;
	
	/** @exclude */ 
	private var _aoi:Vec3D;
	
	
	public function new()
	{
		super(BaseRequest.GenericMessage);
	}
	
	/*
	 * NOTE:
	 * Validation is performed by the specific Message class, e.g. PublicMessageRequest, PrivateMessageRequest, SendObjectRequest 
	 */
	 
	/** @exclude */ 
	override public function validate(sfs:SmartFox):Void
	{
		// Check for a valid type			
		if(_type<0)
			throw new SFSValidationError("PublicMessage request error", ["Unsupported message type:" + _type]);
			
		var errors:Array<String> = [];
		
		switch(_type)
		{
			case GenericMessageType.PUBLIC_MSG:
				validatePublicMessage(sfs, errors);

			case GenericMessageType.PRIVATE_MSG:
				validatePrivateMessage(sfs, errors);
				
			case GenericMessageType.OBJECT_MSG:
				validateObjectMessage(sfs, errors);
				
			case GenericMessageType.BUDDY_MSG:
				validateBuddyMessage(sfs, errors);
				
			default:
				validateSuperUserMessage(sfs, errors);
		}
		
		if(errors.length>0)
			throw new SFSValidationError("Request error - ", errors);
	}
	
	/** @exclude */ 
	override public function execute(sfs:SmartFox):Void
	{
		// Set the message type
		_sfso.putByte(KEY_MESSAGE_TYPE, _type);
		
		switch(_type)
		{
			case GenericMessageType.PUBLIC_MSG:
				executePublicMessage(sfs);
				
			case GenericMessageType.PRIVATE_MSG:
				executePrivateMessage(sfs);
				
			case GenericMessageType.OBJECT_MSG:
				executeObjectMessage(sfs);
			
			case GenericMessageType.BUDDY_MSG:
				executeBuddyMessage(sfs);
				
			default:
				executeSuperUserMessage(sfs);
		}
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Specialized validators
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function validatePublicMessage(sfs:SmartFox, errors:Array<Dynamic>):Void
	{
		if(_message==null || _message.length==0)
			errors.push("Public message is empty!");
			
		if(_room !=null && sfs.joinedRooms.indexOf(_room)<0)
			errors.push("You are not joined in the target Room:" + _room);
	}
	
	private function validatePrivateMessage(sfs:SmartFox, errors:Array<Dynamic>):Void
	{
		if(_message==null || _message.length==0)
			errors.push("Private message is empty!");
		
		if(_recipient<0)
			errors.push("Invalid recipient id:" + _recipient);
	}
	
	private function validateObjectMessage(sfs:SmartFox, errors:Array<Dynamic>):Void
	{
		if(_params==null)
			errors.push("Object message is null!");
	}
	
	private function validateBuddyMessage(sfs:SmartFox, errors:Array<Dynamic>):Void
	{
		if(!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
			
		if(sfs.buddyManager.myOnlineState==false)
			errors.push("Can't send messages while off-line");
			
		if(_message==null || _message.length==0)
			errors.push("Buddy message is empty!");

		var recipientId:Int = switch Std.parseInt("" + _recipient) {
			case null: 0;
			case v: v;
		}

		if(recipientId<0)
			errors.push("Recipient is not online or not in your buddy list");
	}
	
	private function validateSuperUserMessage(sfs:SmartFox, errors:Array<Dynamic>):Void
	{
		if(_message==null || _message.length==0)
			errors.push("Moderator message is empty!");
			
		switch(_sendMode)
		{
			case MessageRecipientMode.TO_USER:
				if(!(Std.is(_recipient, User)))
					errors.push("TO_USER expects a User object as recipient");
				
			case MessageRecipientMode.TO_ROOM:
				if(!(Std.is(_recipient, Room)))
					errors.push("TO_ROOM expects a Room object as recipient");
			
			case MessageRecipientMode.TO_GROUP:
				if(!(Std.is(_recipient, String)))
					errors.push("TO_GROUP expects a String object(the groupId)as recipient");
		}
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Specialized executors
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function executePublicMessage(sfs:SmartFox):Void
	{
		// No room was passed, let's use the last joined one
		if(_room==null)
			_room = sfs.lastJoinedRoom;
		
		// If it doesn't exist we have a problem
		if(_room==null)
			throw new SFSError("User should be joined in a room in order to send a public message");
		
		_sfso.putInt(KEY_ROOM_ID, _room.id);
		_sfso.putInt(KEY_USER_ID, sfs.mySelf.id);
		_sfso.putUtfString(KEY_MESSAGE, _message);
		
		if(_params !=null)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);
	}
	
	private function executePrivateMessage(sfs:SmartFox):Void
	{
		_sfso.putInt(KEY_RECIPIENT,cast _recipient);
		_sfso.putUtfString(KEY_MESSAGE, _message);
		
		if(_params !=null)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);
	}
	
	private function executeBuddyMessage(sfs:SmartFox):Void
	{
		// Id of the recipient buddy
		_sfso.putInt(KEY_RECIPIENT, cast _recipient);
		
		// Message
		_sfso.putUtfString(KEY_MESSAGE, _message);
		
		// Params
		if(_params !=null)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);
	}
	
	private function executeSuperUserMessage(sfs:SmartFox):Void
	{
		_sfso.putUtfString(KEY_MESSAGE, _message);
	
		if(_params !=null)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);
		
		_sfso.putInt(KEY_RECIPIENT_MODE, _sendMode);
		
		switch(_sendMode)
		{
			// Put the User.id as Int
			case MessageRecipientMode.TO_USER:
				_sfso.putInt(KEY_RECIPIENT, _recipient.id);
				
			// Put the Room.id as Int
			case MessageRecipientMode.TO_ROOM:
				_sfso.putInt(KEY_RECIPIENT, _recipient.id);
				
			// Put the Room Group as String
			case MessageRecipientMode.TO_GROUP:
				_sfso.putUtfString(KEY_RECIPIENT, _recipient);
				
			// the TO_ZONE case does not need to pass any other params
		}
	}
	
	private function executeObjectMessage(sfs:SmartFox):Void
	{
		// No room aws passed, let's use the last joined one
		if(_room==null)
			_room = sfs.lastJoinedRoom;
			
		// Populate a recipient list, no duplicates allowed
		var recipients:Map<Int,Bool> = new Map<Int,Bool>();
		
		if(Std.is(_recipient, Array))
		{
			var potentialRecipients:Array<Dynamic> = cast(_recipient, Array<Dynamic>);
			
			// Check that recipient list is not bigger than the Room capacity 
			if(potentialRecipients.length>_room.capacity)
				throw new ArgumentError("The number of recipients is bigger than the target Room capacity:" + potentialRecipients.length);
				
			// Filter out potential wrong elements
			for(item in potentialRecipients)
			{
				if(Std.is(item, User))
					recipients.set(item.id,true);
				else
					sfs.logger.warn("Bad recipient in DynamicMessage recipient list:" +Type.typeof(item) + ", expected type:User");
			}
			
		}
		
		_sfso.putInt(KEY_ROOM_ID, _room.id);
		_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);
		
		var r = [];
		for (k in recipients.keys())
		{
			r.push(k);
		}
		
		// Optional user list
		if(r.length>0)
			_sfso.putIntArray(KEY_RECIPIENT, r);
	}
}