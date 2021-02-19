package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.Message;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

/** @private */
class BaseRequest implements IRequest
{
	//--- System API Requests -----------------------------------------------------
	
	/** @private */
	public static inline var Handshake:Int = 0;
	
	/** @private */
	public static inline var Login:Int = 1;
	
	/** @private */
	public static inline var Logout:Int = 2;
	
	/** @private */
	public static inline var GetRoomList:Int = 3;
	
	/** @private */
	public static inline var JoinRoom:Int = 4;
	
	/** @private */
	public static inline var AutoJoin:Int = 5;
	
	/** @private */
	public static inline var CreateRoom:Int = 6;
	
	/** @private */
	public static inline var GenericMessage:Int = 7;
	
	/** @private */
	public static inline var ChangeRoomName:Int = 8;
	
	/** @private */
	public static inline var ChangeRoomPassword:Int = 9;
	
	/** @private */
	public static inline var DynamicMessage:Int = 10;
	
	/** @private */
	public static inline var SetRoomVariables:Int = 11;
	
	/** @private */
	public static inline var SetUserVariables:Int = 12;
	
	/** @private */
	public static inline var CallExtension:Int = 13;
	
	/** @private */
	public static inline var LeaveRoom:Int = 14;
	
	/** @private */
	public static inline var SubscribeRoomGroup:Int = 15;
	
	/** @private */
	public static inline var UnsubscribeRoomGroup:Int = 16;
	
	/** @private */
	public static inline var SpectatorToPlayer:Int = 17;
	
	/** @private */
	public static inline var PlayerToSpectator:Int = 18;
	
	/** @private */
	public static inline var ChangeRoomCapacity:Int = 19;
	
	/** @private */
	public static inline var PublicMessage:Int = 20;
	
	/** @private */
	public static inline var PrivateMessage:Int = 21;
	
	/** @private */
	public static inline var ModeratorMessage:Int = 22;
	
	/** @private */
	public static inline var AdminMessage:Int = 23;
	
	/** @private */
	public static inline var KickUser:Int = 24;
	
	/** @private */
	public static inline var BanUser:Int = 25;
	
	/** @private */
	public static inline var ManualDisconnection:Int = 26;
	
	/** @private */
	public static inline var FindRooms:Int = 27;
	
	/** @private */
	public static inline var FindUsers:Int = 28;
	
	/** @private */
	public static inline var PingPong:Int = 29;
		
	/** @private */
	public static inline var SetUserPosition:Int = 30;
		
	//--- Buddy List API Requests -------------------------------------------------
	
	/** @private */
	public static inline var InitBuddyList:Int = 200;
	
	/** @private */
	public static inline var AddBuddy:Int = 201;
	
	/** @private */
	public static inline var BlockBuddy:Int = 202;
	
	/** @private */
	public static inline var RemoveBuddy:Int = 203;
	
	/** @private */
	public static inline var SetBuddyVariables:Int = 204;
	
	/** @private */
	public static inline var GoOnline:Int = 205;
	
	//--- Game API Requests --------------------------------------------------------
	
	/** @private */
	public static inline var InviteUser:Int = 300;
	
	/** @private */
	public static inline var InvitationReply:Int = 301;
	
	/** @private */
	public static inline var CreateSFSGame:Int = 302;
	
	/** @private */
	public static inline var QuickJoinGame:Int = 303;
	
	/** @private */
	public static inline var KEY_ERROR_CODE:String = "ec";
	
	/** @private */
	public static inline var KEY_ERROR_PARAMS:String = "ep";
	
	/** @private */
	private var _sfso:ISFSObject;
	
	/** @private */
	private var _id:Int;
	
	/** @private */
	private var _targetController:Int;
	
	/** @private */
	private var _isEncrypted:Bool;
	
	
	public function new(id:Int)
	{
		_sfso = SFSObject.newInstance();
		_targetController = 0;
		_isEncrypted = false;
		_id = id;
	}

	public var id(get, set):Int;
 	private function get_id():Int
	{
		return _id;
	}
	private function set_id(id:Int):Int
	{
		return _id = id;
	}
	
	public function getMessage():IMessage
	{
		var message:IMessage = new Message();
		message.id = _id;
		message.isEncrypted = _isEncrypted;
		message.targetController = _targetController;
		message.content = _sfso;
			
		/*
		* An extension request carries the useUDP flag
		* Check if this is the case and set the flag on the message object
		* This will tell the bitswarm engine how to handle the socket write(TCP vs UDP)
		*/
		#if !html5
		if(Std.isOfType(this, ExtensionRequest))
			message.isUDP = cast(this,ExtensionRequest).useUDP;
		#end
			
		return message;
	}
	public var targetController(get, set):Int;
 	private function get_targetController():Int
	{
		return _targetController;
	}
	
	private function set_targetController(target:Int):Int
	{
		return _targetController = target;	
	}
	public var isEncrypted(get, set):Bool;
 	private function get_isEncrypted():Bool
	{
		return _isEncrypted;
	}
	
	private function set_isEncrypted(flag:Bool):Bool
	{
		return _isEncrypted = flag;
	}
	
	public function validate(sfs:SmartFox):Void
	{
		// Override in child class
		// Throws exception if invalid request.
	}
	
	public function execute(sfs:SmartFox):Void
	{
		// Override in child class
	}
}
