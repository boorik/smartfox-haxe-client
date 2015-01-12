package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.bitswarm.IMessage;
	import com.smartfoxserver.v2.bitswarm.Message;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	/** @private */
	public class BaseRequest implements IRequest
	{
		//--- System API Requests -----------------------------------------------------
		
		/** @private */
		public static const Handshake:int = 0
		
		/** @private */
		public static const Login:int = 1
		
		/** @private */
		public static const Logout:int = 2
		
		/** @private */
		public static const GetRoomList:int = 3
		
		/** @private */
		public static const JoinRoom:int = 4
		
		/** @private */
		public static const AutoJoin:int = 5
		
		/** @private */
		public static const CreateRoom:int = 6
		
		/** @private */
		public static const GenericMessage:int = 7
		
		/** @private */
		public static const ChangeRoomName:int = 8
		
		/** @private */
		public static const ChangeRoomPassword:int = 9
		
		/** @private */
		public static const ObjectMessage:int = 10
		
		/** @private */
		public static const SetRoomVariables:int = 11
		
		/** @private */
		public static const SetUserVariables:int = 12
		
		/** @private */
		public static const CallExtension:int = 13
		
		/** @private */
		public static const LeaveRoom:int = 14
		
		/** @private */
		public static const SubscribeRoomGroup:int = 15
		
		/** @private */
		public static const UnsubscribeRoomGroup:int = 16
		
		/** @private */
		public static const SpectatorToPlayer:int = 17
		
		/** @private */
		public static const PlayerToSpectator:int = 18
		
		/** @private */
		public static const ChangeRoomCapacity:int = 19
		
		/** @private */
		public static const PublicMessage:int = 20
		
		/** @private */
		public static const PrivateMessage:int = 21
		
		/** @private */
		public static const ModeratorMessage:int = 22
		
		/** @private */
		public static const AdminMessage:int = 23
		
		/** @private */
		public static const KickUser:int = 24
		
		/** @private */
		public static const BanUser:int = 25
		
		/** @private */
		public static const ManualDisconnection:int = 26
		
		/** @private */
		public static const FindRooms:int = 27
		
		/** @private */
		public static const FindUsers:int = 28
		
		/** @private */
		public static const PingPong:int = 29
			
		/** @private */
		public static const SetUserPosition:int = 30
			
		//--- Buddy List API Requests -------------------------------------------------
		
		/** @private */
		public static const InitBuddyList:int = 200
		
		/** @private */
		public static const AddBuddy:int = 201
		
		/** @private */
		public static const BlockBuddy:int = 202
		
		/** @private */
		public static const RemoveBuddy:int = 203
		
		/** @private */
		public static const SetBuddyVariables:int = 204
		
		/** @private */
		public static const GoOnline:int = 205
		
		//--- Game API Requests --------------------------------------------------------
		
		/** @private */
		public static const InviteUser:int = 300
		
		/** @private */
		public static const InvitationReply:int = 301
		
		/** @private */
		public static const CreateSFSGame:int = 302
		
		/** @private */
		public static const QuickJoinGame:int = 303
		
		/** @private */
		public static const KEY_ERROR_CODE:String = "ec"
		
		/** @private */
		public static const KEY_ERROR_PARAMS:String = "ep"
		
		/** @private */
		protected var _sfso:ISFSObject
		
		/** @private */
		private var _id:int
		
		/** @private */
		protected var _targetController:int
		
		/** @private */
		private var _isEncrypted:Boolean 
		
		
		public function BaseRequest(id:int)
		{
			_sfso = SFSObject.newInstance()
			_targetController = 0
			_isEncrypted = false
			_id = id
		}
		
		public function get id():int
		{
			return _id
		}
		
		public function set id(id:int):void
		{
			_id = id
		}
		
		public function getMessage():IMessage
		{
			var message:IMessage = new Message()
			message.id = _id
			message.isEncrypted = _isEncrypted
			message.targetController = _targetController
			message.content = _sfso
				
			/*
			* An extension request carries the useUDP flag
			* Check if this is the case and set the flag on the message object
			* This will tell the bitswarm engine how to handle the socket write (TCP vs UDP)
			*/
			if (this is ExtensionRequest)
				message.isUDP = (this as ExtensionRequest).useUDP
			
			return message
		}
		
		public function get targetController():int
		{
			return _targetController 	
		}
		
		public function set targetController(target:int):void
		{
			_targetController = target	
		}
		
		public function get isEncrypted():Boolean
		{
			return _isEncrypted	
		}
		
		public function set isEncrypted(flag:Boolean):void
		{
			_isEncrypted = flag
		}
		
		public function validate(sfs:SmartFox):void
		{
			// Override in child class
			// Throws exception if invalid request.
		}
		
		public function execute(sfs:SmartFox):void
		{
			// Override in child class
		}
	}
}