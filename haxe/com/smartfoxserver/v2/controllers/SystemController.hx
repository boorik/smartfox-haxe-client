package com.smartfoxserver.v2.controllers;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.BaseController;
import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.core.SFSBuddyEvent;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.IMMOItem;
import com.smartfoxserver.v2.entities.MMOItem;
import com.smartfoxserver.v2.entities.MMORoom;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.SFSBuddy;
import com.smartfoxserver.v2.entities.SFSRoom;
import com.smartfoxserver.v2.entities.SFSUser;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray<Dynamic>;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.invitation.Invitation;
import com.smartfoxserver.v2.entities.invitation.SFSInvitation;
import com.smartfoxserver.v2.entities.managers.IRoomManager;
import com.smartfoxserver.v2.entities.managers.IUserManager;
import com.smartfoxserver.v2.entities.managers.SFSGlobalUserManager;
import com.smartfoxserver.v2.entities.variables.BuddyVariable;
import com.smartfoxserver.v2.entities.variables.IMMOItemVariable;
import com.smartfoxserver.v2.entities.variables.MMOItemVariable;
import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.kernel;
import com.smartfoxserver.v2.requests.BaseRequest;
import com.smartfoxserver.v2.requests.ChangeRoomCapacityRequest;
import com.smartfoxserver.v2.requests.ChangeRoomNameRequest;
import com.smartfoxserver.v2.requests.ChangeRoomPasswordStateRequest;
import com.smartfoxserver.v2.requests.CreateRoomRequest;
import com.smartfoxserver.v2.requests.FindRoomsRequest;
import com.smartfoxserver.v2.requests.FindUsersRequest;
import com.smartfoxserver.v2.requests.GenericMessageRequest;
import com.smartfoxserver.v2.requests.GenericMessageType;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.LogoutRequest;
import com.smartfoxserver.v2.requests.PlayerToSpectatorRequest;
import com.smartfoxserver.v2.requests.SetRoomVariablesRequest;
import com.smartfoxserver.v2.requests.SetUserVariablesRequest;
import com.smartfoxserver.v2.requests.SpectatorToPlayerRequest;
import com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest;
import com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest;
import com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest;
import com.smartfoxserver.v2.requests.buddylist.BlockBuddyRequest;
import com.smartfoxserver.v2.requests.buddylist.GoOnlineRequest;
import com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest;
import com.smartfoxserver.v2.requests.buddylist.RemoveBuddyRequest;
import com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest;
import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
import com.smartfoxserver.v2.requests.mmo.SetMMOItemVariables;
import com.smartfoxserver.v2.requests.mmo.SetUserPositionRequest;
import com.smartfoxserver.v2.util.BuddyOnlineState;
import com.smartfoxserver.v2.util.ClientDisconnectionReason;
import com.smartfoxserver.v2.util.SFSErrorCodes;

/** @private */
class SystemController extends BaseController
{
	private var sfs:SmartFox;
	private var bitSwarm:BitSwarmClient;
	private var requestHandlers:Dynamic;
					
	public function new(bitSwarm:BitSwarmClient)
	{
		super(bitSwarm);
		this.bitSwarm = bitSwarm;
		this.sfs = bitSwarm.sfs;
		
		requestHandlers = new Dynamic();
		initRequestHandlers();
	}
	
	private function initRequestHandlers():Void
	{
		// Request codes
		requestHandlers[BaseRequest.Handshake] = { name:"Handshake", handler:this["fnHandshake"] };
		requestHandlers[BaseRequest.Login] = { name:"Login", handler:this["fnLogin"] };
		requestHandlers[BaseRequest.Logout] = { name:"Logout", handler:this["fnLogout"] };
		requestHandlers[BaseRequest.JoinRoom] = { name:"JoinRoom", handler:this["fnJoinRoom"] };
		requestHandlers[BaseRequest.CreateRoom] = { name:"CreateRoom", handler:this["fnCreateRoom"] };
		requestHandlers[BaseRequest.GenericMessage] = { name:"GenericMessage", handler:this["fnGenericMessage"] };
		requestHandlers[BaseRequest.ChangeRoomName] = { name:"ChangeRoomName", handler:this["fnChangeRoomName"] };
		requestHandlers[BaseRequest.ChangeRoomPassword] = { name:"ChangeRoomPassword", handler:this["fnChangeRoomPassword"] };
		requestHandlers[BaseRequest.ChangeRoomCapacity] = { name:"ChangeRoomCapacity", handler:this["fnChangeRoomCapacity"] };
		requestHandlers[BaseRequest.SetRoomVariables] = { name:"SetRoomVariables", handler:this["fnSetRoomVariables"] };
		requestHandlers[BaseRequest.SetUserVariables] = { name:"SetUserVariables", handler:this["fnSetUserVariables"] };
		requestHandlers[BaseRequest.SubscribeRoomGroup] = { name:"SubscribeRoomGroup", handler:this["fnSubscribeRoomGroup"] };
		requestHandlers[BaseRequest.UnsubscribeRoomGroup] = { name:"UnsubscribeRoomGroup", handler:this["fnUnsubscribeRoomGroup"] };
		requestHandlers[BaseRequest.SpectatorToPlayer] = { name:"SpectatorToPlayer", handler:this["fnSpectatorToPlayer"] };
		requestHandlers[BaseRequest.PlayerToSpectator] = { name:"PlayerToSpectator", handler:this["fnPlayerToSpectator"] };
		requestHandlers[BaseRequest.InitBuddyList] = { name:"InitBuddyList", handler:this["fnInitBuddyList"] };
		requestHandlers[BaseRequest.AddBuddy] = { name:"AddBuddy", handler:this["fnAddBuddy"] };
		requestHandlers[BaseRequest.RemoveBuddy] = { name:"RemoveBuddy", handler:this["fnRemoveBuddy"] };
		requestHandlers[BaseRequest.BlockBuddy] = { name:"BlockBuddy", handler:this["fnBlockBuddy"] };
		requestHandlers[BaseRequest.GoOnline] = { name:"GoOnline", handler:this["fnGoOnline"] };
		requestHandlers[BaseRequest.SetBuddyVariables] = { name:"SetBuddyVariables", handler:this["fnSetBuddyVariables"] };
		requestHandlers[BaseRequest.FindRooms] = { name:"FindRooms", handler:this["fnFindRooms"] };
		requestHandlers[BaseRequest.FindUsers] = { name:"FindUsers", handler:this["fnFindUsers"] };
		requestHandlers[BaseRequest.InviteUser] = { name:"InviteUser", handler:this["fnInviteUsers"] };
		requestHandlers[BaseRequest.InvitationReply] = { name:"InvitationReply", handler:this["fnInvitationReply"] };
		requestHandlers[BaseRequest.QuickJoinGame] = { name:"QuickJoinGame", handler:this["fnQuickJoinGame"] };
		requestHandlers[BaseRequest.PingPong] = { name:"PingPong", handler:this["fnPingPong"] };
		requestHandlers[BaseRequest.SetUserPosition] = { name:"SetUserPosition", handler:this["fnSetUserPosition"] };
		
		// Response only codes
		requestHandlers[1000] = { name:"UserEnterRoom", handler:this["fnUserEnterRoom"] };
		requestHandlers[1001] = { name:"UserCountChange", handler:this["fnUserCountChange"] };
		requestHandlers[1002] = { name:"UserLost", handler:this["fnUserLost"] };
		requestHandlers[1003] = { name:"RoomLost", handler:this["fnRoomLost"] };
		requestHandlers[1004] = { name:"UserExitRoom", handler:this["fnUserExitRoom"] };
		requestHandlers[1005] = { name:"ClientDisconnection", handler:this["fnClientDisconnection"] };
		requestHandlers[1006] = { name:"ReconnectionFailure", handler:this["fnReconnectionFailure"] };
		requestHandlers[1007] = { name:"SetMMOItemVariables", handler:this["fnSetMMOItemVariables"] };
	}
	
	public override function handleMessage(message:IMessage):Void
	{
		var command:Dynamic = requestHandlers[message.id];
			
		if(command !=null)
		{
			if(sfs.debug)
				log.info(command.name + ", " + message);
					
			// Execute
			command.handler(message);
		}
		else
			log.warn("Unknown message id:" + message.id);
	}
	
	/*
	* New for Grid support
	* Allows wrapping API to inject new SystemController Request handlers
	*/
	kernel function addRequestHandler(code:Int, command:Dynamic):Void
	{
		requestHandlers[code] = command;
	}
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Handlers
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function fnHandshake(msg:IMessage):Void
	{
		var evtParams:Dynamic = { message:msg };
		sfs.dispatchEvent(new SFSEvent(SFSEvent.HANDSHAKE, evtParams));
	}
	
	private function fnLogin(msg:IMessage):Void
	{
		var obj:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		// Success
		if(obj.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			// Populate room list
			populateRoomList(obj.getSFSArray(LoginRequest.KEY_ROOMLIST));
			
			// create local user
			sfs.mySelf=new SFSUser
			(
				obj.getInt(LoginRequest.KEY_ID), 
				obj.getUtfString(LoginRequest.KEY_USER_NAME), 
				true
			)
			
			sfs.mySelf.userManager = sfs.userManager;
			sfs.mySelf.privilegeId = obj.getShort(LoginRequest.KEY_PRIVILEGE_ID);
			sfs.userManager.addUser(sfs.mySelf);
			
			// set the reconnection seconds
			sfs.setReconnectionSeconds(obj.getShort(LoginRequest.KEY_RECONNECTION_SECONDS));
			
			// Fire success event
			evtParams.zone = obj.getUtfString(LoginRequest.KEY_ZONE_NAME);
			evtParams.user = sfs.mySelf;
			evtParams.data = obj.getSFSObject(LoginRequest.KEY_PARAMS);
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN, evtParams));
		}
		
		// Failure
		else
		{
			var errorCd:Int = obj.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, obj.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN_ERROR, evtParams));
		}
	}
	
	private function fnCreateRoom(msg:IMessage):Void
	{
		var obj:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		// Success
		if(obj.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var roomManager:IRoomManager = sfs.roomManager;
			var newRoom:Room = SFSRoom.fromSFSArray(obj.getSFSArray(CreateRoomRequest.KEY_ROOM));
			newRoom.roomManager = sfs.roomManager;
			
			// Add room to room manager
			roomManager.addRoom(newRoom);

			evtParams.room = newRoom;
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_ADD, evtParams));
		}
		
		// Failure
		else
		{
			var errorCd:Int = obj.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, obj.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CREATION_ERROR, evtParams));
		}
	}
	
	private function fnJoinRoom(msg:IMessage):Void
	{
		var roomManager:IRoomManager = sfs.roomManager;
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		// set flag off
		sfs.isJoining = false;
		
		// Success
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var roomObj:ISFSArray<Dynamic> = sfso.getSFSArray(JoinRoomRequest.KEY_ROOM);
			var userList:ISFSArray<Dynamic> = sfso.getSFSArray(JoinRoomRequest.KEY_USER_LIST);
			
			// Get the joined Room data
			var room:Room = SFSRoom.fromSFSArray(roomObj);
			room.roomManager = sfs.roomManager;
			
			/*
			* We make sure that the associated Group is checked against the subscribed group list
			* If the Room group is not found, we mark this room as NOT managed.
			* This means that the Room shall be removed from the local Room List when we leave it
			* without the need for server notifications
			*
			* In other words all Rooms that are NOT managed belong to Group(s)to which the User
			* is not subscribed, therefore the server does not keep us updated.
			*/
			room = roomManager.replaceRoom(room, roomManager.containsGroup(room.groupId));
			
			// Populate room's user list
			for(var j:Int=0;j<userList.size();j++)
			{
				var userObj:ISFSArray<Dynamic> = userList.getSFSArray(j);
				
				// Get user if exist from main UserManager or create a new one
				var user:User = getOrCreateUser(userObj, true, room);
				
				// Set the playerId
				user.setPlayerId(userObj.getShort(3), room);
				
				room.addUser(user);
			}
			
			// Set as joined
			room.isJoined = true;
			
			// Set as the last joined Room
			sfs.lastJoinedRoom = room;

			evtParams.room = room;
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN, evtParams));
		}
		
		// Failure
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR, evtParams));
		}
	}
	
	private function fnUserEnterRoom(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };

		var room:Room = sfs.roomManager.getRoomById(sfso.getInt("r"));
		
		if(room !=null)
		{
			var userObj:ISFSArray<Dynamic> = sfso.getSFSArray("u");
			var user:User = getOrCreateUser(userObj, true, room);
			
			room.addUser(user);
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_ENTER_ROOM, {user:user, room:room}));	
		} 
	}
	
	private function fnUserCountChange(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var room:Room = sfs.roomManager.getRoomById(sfso.getInt("r"));
		
		if(room !=null)
		{
			var uCount:Int = sfso.getShort("uc");
			var sCount:Int = 0;
			
			// Check for optional spectator count
			if (sfso.containsKey("sc"))
				sCount = sfso.getShort("sc");

			room.userCount = uCount;
			room.spectatorCount = sCount;
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_COUNT_CHANGE, { room:room, uCount:uCount, sCount:sCount } ));
		}
	}
	
	/*
	* Server tells client that a certain user got disconnected
	* This could be used to trigger a buddy-is-offline event as well... 
	*/
	private function fnUserLost(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		
		var uId:Int = sfso.getInt("u");
		var user:User = sfs.userManager.getUserById(uId);
		
		if(user !=null)
		{
			// keep a copy of the rooms joined by this user
			var joinedRooms:Array<Dynamic> = sfs.roomManager.getUserRooms(user);
			
			// remove from all rooms
			sfs.roomManager.removeUser(user);
			
			// remove from global user manager
			var globalUserMan:SFSGlobalUserManager = cast sfs.userManager;
			globalUserMan.removeUserReference(user, true);
				
			// Fire one event in each room
			for(var room:Room in joinedRooms)
			{
				sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM, { user:user, room:room } ));
			}
		}
	}
	
	private function fnRoomLost(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var rId:Int = sfso.getInt("r");
		var room:Room = sfs.roomManager.getRoomById(rId);
		var globalUserManager:IUserManager = sfs.userManager ;
		
		if(room !=null)
		{
			// remove from all rooms
			sfs.roomManager.removeRoom(room);
			
			// remove users in this room from user manager
			for(var user:User in room.userList)
				globalUserManager.removeUser(user);
			
			// Fire event			
			evtParams.room = room;
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_REMOVE, evtParams));
		}
	}
	
	private function checkIfIamLastPlayer(room:Room):Bool
	{
		var count:Int=room.isGame ?(room.userCount + room.spectatorCount):room.userCount;
		return(count == 1 && room.containsUser(sfs.mySelf));
	}
	
	private function fnGenericMessage(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var msgType:Int = sfso.getByte(GenericMessageRequest.KEY_MESSAGE_TYPE);
		
		switch(msgType)
		{
			case GenericMessageType.PUBLIC_MSG:
				handlePublicMessage(sfso);
				
			case GenericMessageType.PRIVATE_MSG:
				handlePrivateMessage(sfso);
				
			case GenericMessageType.BUDDY_MSG:
				handleBuddyMessage(sfso);
				
			case GenericMessageType.MODERATOR_MSG:
				handleModMessage(sfso);
				
			case GenericMessageType.ADMING_MSG:
				handleAdminMessage(sfso);
				
			case GenericMessageType.OBJECT_MSG:
				handleObjectMessage(sfso);
		}
	}
	
	private function handlePublicMessage(sfso:ISFSObject):Void
	{
		var evtParams:Dynamic = { };
		
		var rId:Int = sfso.getInt(GenericMessageRequest.KEY_ROOM_ID);
		var room:Room = sfs.roomManager.getRoomById(rId);

		if(room !=null)
		{
			evtParams.room = room;
			evtParams.sender = sfs.userManager.getUserById(sfso.getInt(GenericMessageRequest.KEY_USER_ID));
			evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
			evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
			
			 // Fire event
			sfs.dispatchEvent(new SFSEvent(SFSEvent.PUBLIC_MESSAGE, evtParams));
		}
		else
			log.warn("Unexpected, PublicMessage target room doesn't exist. RoomId:" + rId);
		
	}
	
	public function handlePrivateMessage(sfso:ISFSObject):Void
	{
		var evtParams:Dynamic = { };
		var senderId:Int = sfso.getInt(GenericMessageRequest.KEY_USER_ID);
		
		// See if user exists locally
		var sender:User = sfs.userManager.getUserById(senderId);
		
		// Not found locally, see if user details where passed by the Server
		if(sender==null)
		{
			if(!sfso.containsKey(GenericMessageRequest.KEY_SENDER_DATA))
			{
				log.warn("Unexpected. Private message has no Sender details!");
				return;
			}
			
			sender = SFSUser.fromSFSArray(sfso.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
		}
		
		evtParams.sender = sender;
		evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
		evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
		
		 // Fire event
		sfs.dispatchEvent(new SFSEvent(SFSEvent.PRIVATE_MESSAGE, evtParams));
	}
	
	public function handleBuddyMessage(sfso:ISFSObject):Void
	{
		var evtParams:Dynamic = { };
		var senderId:Int = sfso.getInt(GenericMessageRequest.K; EY_USER_ID);
		
		/*
		* Look for Buddy
		* NOTE:There is a possible situation in which this could result null.
		* 
		* When there's no mutual Buddy adding(default)and the receiver doesn't have the sender in his BList
		* If your turn on the useTempBuddy feature, a Temp Buddy will be added to the BList before the message arrives
		*/
		var senderBuddy:Buddy = sfs.buddyManager.getBuddyById(senderId);
		
		evtParams.isItMe = sfs.mySelf.id == senderId;
		evtParams.buddy = senderBuddy;
		evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
		evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
		
		 // Fire event
		sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_MESSAGE, evtParams));
	}
	
	public function handleModMessage(sfso:ISFSObject):Void
	{
		var evtParams:Dynamic = { };
		
		evtParams.sender = SFSUser.fromSFSArray(sfso.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
		evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
		evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
		
		 // Fire event
		sfs.dispatchEvent(new SFSEvent(SFSEvent.MODERATOR_MESSAGE, evtParams));
	}
	
	public function handleAdminMessage(sfso:ISFSObject):Void
	{
		var evtParams:Dynamic = { };
		
		evtParams.sender = SFSUser.fromSFSArray(sfso.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
		evtParams.message = sfso.getUtfString(GenericMessageRequest.KEY_MESSAGE);
		evtParams.data = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
		
		 // Fire event
		sfs.dispatchEvent(new SFSEvent(SFSEvent.ADMIN_MESSAGE, evtParams));
	}
	
	public function handleObjectMessage(sfso:ISFSObject):Void
	{
		var evtParams:Dynamic = { };
		var senderId:Int = sfso.getInt(GenericMessageRequest.KEY_USER_ID);
		
		evtParams.sender = sfs.userManager.getUserById(senderId);
		evtParams.message = sfso.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
		
		 // Fire event
		sfs.dispatchEvent(new SFSEvent(SFSEvent.OBJECT_MESSAGE, evtParams));
	}
	
	private function fnUserExitRoom(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var rId:Int = sfso.getInt("r");
		var uId:Int = sfso.getInt("u");
		var room:Room = sfs.roomManager.getRoomById(rId);
		var user:User = sfs.userManager.getUserById(uId);
			
		if(room !=null && user !=null)
		{
			room.removeUser(user);
			sfs.userManager.removeUser(user);
			
			// If I have left a room I need to mark the room as NOT JOINED
			if(user.isItMe && room.isJoined)
			{
				// Turn of the Room's joined flag
				room.isJoined = false;
				
				// Reset the lastJoinedRoom reference if no Room is currently joined
				if(sfs.joinedRooms.length==0)
					sfs.lastJoinedRoom = null;
				
				/*
				* Room is NOT managed, we need to remove it
				*/	
				if(!room.isManaged)
					sfs.roomManager.removeRoom(room);
			}
			
			evtParams.user = user;
			evtParams.room = room;
			
			// Fire event
			sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM, evtParams));
		}
		else
			log.debug("Failed to handle UserExit event. Room:" + room + ", User:" + user);
	}
	
	private function fnClientDisconnection(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var reasonId:Int = sfso.getByte("dr");
			
		sfs.kernel::handleClientDisconnection(ClientDisconnectionReason.getReason(reasonId));
	}
	
	private function fnReconnectionFailure(msg:IMessage):Void
	{
		sfs.kernel::handleReconnectionFailure();
	}
	
	private function fnSetRoomVariables(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var rId:Int = sfso.getInt(SetRoomVariablesRequest.KEY_VAR_ROOM);
		var varListData:ISFSArray<Dynamic> = sfso.getSFSArray(SetRoomVariablesRequest.KEY_VAR_LIST);
		
		var targetRoom:Room = sfs.roomManager.getRoomById(rId);
		var changedVarNames:Array<Dynamic> = [];
		
		if(targetRoom !=null)
		{
			for(var j:Int=0;j<varListData.size();j++)
			{
				var roomVar:RoomVariable = SFSRoomVariable.fromSFSArray(varListData.getSFSArray(j));
				targetRoom.setVariable(roomVar);
				
				changedVarNames.push(roomVar.name);
			}
			
			evtParams.changedVars = changedVarNames;
			evtParams.room = targetRoom;
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_VARIABLES_UPDATE, evtParams));
		} 
		
		else
			log.warn("RoomVariablesUpdate, unknown Room id=" + rId);
	}
	
	private function fnSetUserVariables(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var uId:Int = sfso.getInt(SetUserVariablesRequest.KEY_USER);
		var varListData:ISFSArray<Dynamic> = sfso.getSFSArray(SetUserVariablesRequest.KEY_VAR_LIST);
		
		var user:User = sfs.userManager.getUserById(uId);
		var changedVarNames:Array<Dynamic> = [];
		
		if(user !=null)
		{
			for(var j:Int=0;j<varListData.size();j++)
			{
				var userVar:UserVariable = SFSUserVariable.fromSFSArray(varListData.getSFSArray(j));
				user.setVariable(userVar);
				
				changedVarNames.push(userVar.name);
			}
			
			evtParams.changedVars = changedVarNames;
			evtParams.user = user;
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_VARIABLES_UPDATE, evtParams));
		}
		else
			log.warn("UserVariablesUpdate:unknown user id=" + uId);
	}
	
	private function fnSubscribeRoomGroup(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::Success::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var groupId:String = sfso.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
			var roomListData:ISFSArray<Dynamic> = sfso.getSFSArray(SubscribeRoomGroupRequest.KEY_ROOM_LIST);
			
			// Integrity Check
			if(sfs.roomManager.containsGroup(groupId))
				log.warn("SubscribeGroup Dynamic. Group:", groupId, "already subscribed!");
				
			populateRoomList(roomListData);
			
			// Pass the groupId
			evtParams.groupId = groupId;
			
			// Pass the new rooms that are present in the subscribed group
			evtParams.newRooms = sfs.roomManager.getRoomListFromGroup(groupId);
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE, evtParams));
		}
		
		//:::Failure:::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR, evtParams));
		}
	}
	
	private function fnUnsubscribeRoomGroup(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var groupId:String = sfso.getUtfString(UnsubscribeRoomGroupRequest.KEY_GROUP_ID);
			
			// Integrity Check
			if(!sfs.roomManager.containsGroup(groupId))
				log.warn("UnsubscribeGroup Dynamic. Group:", groupId, "is not subscribed!");
				
			sfs.roomManager.removeGroup(groupId);
			
			// Pass the groupId
			evtParams.groupId = groupId;
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE, evtParams));
		}
		
		//:::FAILURE:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR, evtParams));
		}
	}
	
	
	private function fnChangeRoomName(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			// Obtain the target Room
			var roomId:Int = sfso.getInt(ChangeRoomNameRequest.KEY_ROOM);
			var targetRoom:Room = sfs.roomManager.getRoomById(roomId);

			if(targetRoom !=null)
			{
				evtParams.oldName = targetRoom.name;
				sfs.roomManager.changeRoomName(targetRoom, sfso.getUtfString(ChangeRoomNameRequest.KEY_NAME));
				
				evtParams.room = targetRoom;
				sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE, evtParams));	
			}
			
			// Room not found locally, log error
			else
			{
				log.warn("Room not found, ID:", roomId, ", Room name change failed.");	
			}
		}
		
		//:::FAILURE:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE_ERROR, evtParams));
		}
		
	}
	
	private function fnChangeRoomPassword(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			// Obtain the target Room
			var roomId:Int = sfso.getInt(ChangeRoomPasswordStateRequest.KEY_ROOM);
			var targetRoom:Room = sfs.roomManager.getRoomById(roomId);
			
			if(targetRoom !=null)
			{
				sfs.roomManager.changeRoomPasswordState(targetRoom, sfso.getBool(ChangeRoomPasswordStateRequest.KEY_PASS));
				evtParams.room = targetRoom;
				sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE, evtParams));
			}
			
			else
			{
				log.warn("Room not found, ID:", roomId, ", Room password change failed.");
			}
			
		}
		
		//:::FAILURE:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR, evtParams));
		}
	}
	
	private function fnChangeRoomCapacity(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			// Obtain the target Room
			var roomId:Int = sfso.getInt(ChangeRoomCapacityRequest.KEY_ROOM);
			var targetRoom:Room = sfs.roomManager.getRoomById(roomId);
			
			if(targetRoom !=null)
			{
				sfs.roomManager.changeRoomCapacity
				(
					targetRoom,
					sfso.getInt(ChangeRoomCapacityRequest.KEY_USER_SIZE), 
					sfso.getInt(ChangeRoomCapacityRequest.KEY_SPEC_SIZE)
				)
				
				evtParams.room = targetRoom;
				sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE, evtParams));
			}
			
			else
			{
				log.warn("Room not found, ID:", roomId, ", Room capacity change failed.");
			}
			
		}
		
		//:::FAILURE:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE_ERROR, evtParams));
		}
	}
	
	private function fnLogout(msg:IMessage):Void
	{
		sfs.handleLogout();
		
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		evtParams.zoneName = sfso.getUtfString(LogoutRequest.KEY_ZONE_NAME);
		sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGOUT, evtParams));
		
	}
	
	private function fnSpectatorToPlayer(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			// Obtain the target Room
			var roomId:Int = sfso.getInt(SpectatorToPlayerRequest.KEY_ROOM_ID);
			var userId:Int = sfso.getInt(SpectatorToPlayerRequest.KEY_USER_ID);
			var playerId:Int = sfso.getShort(SpectatorToPlayerRequest.KEY_PLAYER_ID);
			
			var user:User = sfs.userManager.getUserById(userId);
			var targetRoom:Room = sfs.roomManager.getRoomById(roomId);
			
			if(targetRoom !=null)
			{
				if(user !=null)
				{
					if(user.isJoinedInRoom(targetRoom))
					{
						// Update the playerId
						user.setPlayerId(playerId, targetRoom);
													
						evtParams.room = targetRoom	;		// where it happened
						evtParams.user = user;				// who did it
						evtParams.playerId = playerId;		// the new playerId
						
						sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER, evtParams));
					}
					else
						log.warn("User:" + user + " not joined in Room:", targetRoom, ", SpectatorToPlayer failed.");
				}
				else
					log.warn("User not found, ID:", userId, ", SpectatorToPlayer failed.");
			}
			
			else
				log.warn("Room not found, ID:", roomId, ", SpectatorToPlayer failed.");
		}
		
		//:::FAILURE:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER_ERROR, evtParams));
		}
	}
	
	private function fnPlayerToSpectator(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			// Obtain the target Room
			var roomId:Int = sfso.getInt(PlayerToSpectatorRequest.KEY_ROOM_ID);
			var userId:Int = sfso.getInt(PlayerToSpectatorRequest.KEY_USER_ID);
			
			var user:User = sfs.userManager.getUserById(userId);
			var targetRoom:Room = sfs.roomManager.getRoomById(roomId);
			
			if(targetRoom !=null)
			{
				if(user !=null)
				{
					if(user.isJoinedInRoom(targetRoom))
					{
						// Update the playerId
						user.setPlayerId( -1, targetRoom);
						
						evtParams.room = targetRoom;			// where it happened
						evtParams.user = user;				// who did it
						
						sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR, evtParams));
					}
					else
						log.warn("User:" + user + " not joined in Room:", targetRoom, ", PlayerToSpectator failed.");
				}
				else
					log.warn("User not found, ID:", userId, ", PlayerToSpectator failed.");
			}
			else
				log.warn("Room not found, ID:", roomId, ", PlayerToSpectator failed.");
		}
		
		//:::FAILURE:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
				
			sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR_ERROR, evtParams));
		}
	}
	
	
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// BuddyList Handlers
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function fnInitBuddyList(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			//var buddyList:Array<Dynamic>=[]
			var bListData:ISFSArray<Dynamic> = sfso.getSFSArray(InitBuddyListRequest.KEY_BLIST);
			var myVarsData:ISFSArray<Dynamic> = sfso.getSFSArray(InitBuddyListRequest.KEY_MY_VARS);
			var buddyStates:Array<Dynamic> = sfso.getUtfStringArray(InitBuddyListRequest.KEY_BUDDY_STATES);
			
			// Clear BuddyManager
			sfs.buddyManager.clearAll();
			
			// Populate the BuddyList
			for(i in 0...bListData.size())
			{
				var b:Buddy = SFSBuddy.fromSFSArray(bListData.getSFSArray(i));
				sfs.buddyManager.addBuddy(b);
			}
			
			// Set the buddy states
			if(buddyStates !=null)
				sfs.buddyManager.setBuddyStates(buddyStates);
			
			// Populate MyBuddyVariables
			var myBuddyVariables:Array<Dynamic> = [];
			
			for(i in 0...myVarsData.size())
			{
				myBuddyVariables.push(SFSBuddyVariable.fromSFSArray(myVarsData.getSFSArray(i)));
			}
			
			sfs.buddyManager.setMyVariables(myBuddyVariables);
			sfs.buddyManager.setInited(true);
			
			// Fire event
			evtParams.buddyList = sfs.buddyManager.buddyList;
			evtParams.myVariables = sfs.buddyManager.myVariables;
						
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_LIST_INIT, evtParams));

		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, evtParams));
		}
	}

	
	private function fnAddBuddy(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var buddy:Buddy = SFSBuddy.fromSFSArray(sfso.getSFSArray(AddBuddyRequest.KEY_BUDDY_NAME));
			sfs.buddyManager.addBuddy(buddy);
			
			// Fire event
			evtParams.buddy = buddy;
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ADD, evtParams));
		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, evtParams));
		}
	}
	
	private function fnRemoveBuddy(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var buddyName:String = sfso.getUtfString(RemoveBuddyRequest.KEY_BUDDY_NAME);
			var buddy:Buddy = sfs.buddyManager.removeBuddyByName(buddyName);
			
			if(buddy !=null)
			{
				// Fire event
				evtParams.buddy = buddy;
				sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_REMOVE, evtParams));
			}
			else
				log.warn("RemoveBuddy failed, buddy not found:" + buddyName);
		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, evtParams));
		}
	}
	
	private function fnBlockBuddy(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var buddyName:String = sfso.getUtfString(BlockBuddyRequest.KEY_BUDDY_NAME);
			var buddy:Buddy = sfs.buddyManager.getBuddyByName(buddyName);
			
			if(buddy !=null)
			{
				// Set the BuddyBlock State
				buddy.setBlocked(sfso.getBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE));
				
				// Fire event
				evtParams.buddy = buddy;
				sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_BLOCK, evtParams));
			}
			else
				log.warn("BlockBuddy failed, buddy not found:" + buddyName + ", in local BuddyList");
		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, evtParams));
		}
	}
	
	private function fnGoOnline(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var buddyName:String = sfso.getUtfString(GoOnlineRequest.KEY_BUDDY_NAME);
			var buddy:Buddy = sfs.buddyManager.getBuddyByName(buddyName);
			var isItMe:Bool = buddyName == sfs.mySelf.name;
			var onlineValue:Int = sfso.getByte(GoOnlineRequest.KEY_ONLINE);
			var onlineState:Bool = onlineValue == BuddyOnlineState.ONLINE ;
			
			var fireEvent:Bool = true;
			
			if(isItMe)
			{
				/*
				* This code should never run
				* The state was already updated when the request was sent, if they don't match something wrong
				* is happening.
				*/
				if(sfs.buddyManager.myOnlineState !=onlineState)
				{
					log.warn("Unexpected:MyOnlineState is not in synch with the server. Resynching:" + onlineState);
					sfs.buddyManager.setMyOnlineState(onlineState);
				}
			}
			
			// Another buddy in my list went online/offline
			else if(buddy !=null)
			{
				// Set the BuddyBlock State
				buddy.setId(sfso.getInt(GoOnlineRequest.KEY_BUDDY_ID));
				buddy.setVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE, onlineState));
				
				/*
				* Did the buddy leave the server?
				* If so we need to remove the volatile buddy variables(not persistent)
				*/
				if(onlineValue==BuddyOnlineState.LEFT_THE_SERVER)
					buddy.clearVolatileVariables();
					
				/*
				* Event is NOT fired if a buddy goes on/offline while I am off-line
				* This is equivalent to checking(buddy !=null && sfs.buddyManager.myOnlineState)before firing the event
				*/
				fireEvent = sfs.buddyManager.myOnlineState;
			}
			
			// Buddy not found, it's not me... something is wrong
			else
			{
				// Log and Exit
				log.warn("GoOnline error, buddy not found:" + buddyName + ", in local BuddyList.");
				return;
			}
			
			if(fireEvent)
			{
				evtParams.buddy = buddy;
				evtParams.isItMe = isItMe;
				sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, evtParams));
			} 
		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, evtParams));
		}
	}
	
	private function fnSetBuddyVariables(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var buddyName:String = sfso.getUtfString(SetBuddyVariablesRequest.KEY_BUDDY_NAME);
			var buddyVarsData:ISFSArray<Dynamic> = sfso.getSFSArray(SetBuddyVariablesRequest.KEY_BUDDY_VARS);
			
			var buddy:Buddy = sfs.buddyManager.getBuddyByName(buddyName);
			
			var isItMe:Bool = buddyName == sfs.mySelf.name;
			
			var changedVarNames:Array<Dynamic> = [];
			var variables:Array<Dynamic> = [];
			
			var fireEvent:Bool = true;
			
			// Rebuild variables
			for(var j:Int=0;j<buddyVarsData.size();j++)
			{
				var buddyVar:BuddyVariable = SFSBuddyVariable.fromSFSArray(buddyVarsData.getSFSArray(j));
				
				variables.push(buddyVar);
				changedVarNames.push(buddyVar.name);
			}
			
			// If it's my user, change my local variables
			if(isItMe)
			{
				sfs.buddyManager.setMyVariables(variables);
			}
			
			// or ... change the variables of one of my buddies
			else if(buddy !=null)
			{
				buddy.setVariables(variables);
				
				// See GoOnline handler for more details on this
				fireEvent = sfs.buddyManager.myOnlineState;
			}
			
			// Unexpected:it's not me, it's not one of my buddies. Log and quit
			else
			{
				log.warn("Unexpected. Target of BuddyVariables update not found:" + buddyName);
				return;
			}
			
			if(fireEvent)
			{
				evtParams.isItMe = isItMe;
				evtParams.changedVars = changedVarNames;
				evtParams.buddy = buddy;
				
				sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_VARIABLES_UPDATE, evtParams));
			}
		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, evtParams));
		}
	}
	
	private function fnFindRooms(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var roomListData:ISFSArray<Dynamic> = sfso.getSFSArray(FindRoomsRequest.KEY_FILTERED_ROOMS);
		var roomList:Array<Dynamic> = [];
		
		for(var i:Int=0;i<roomListData.size();i++)
		{
			var theRoom:Room = SFSRoom.fromSFSArray(roomListData.getSFSArray(i));
				
			// Flag Rooms that are joined locally
			var localRoom:Room=sfs.roomManager.getRoomById(theRoom.id);
			
			if(localRoom !=null)
				theRoom.isJoined=localRoom.isJoined;
			
			roomList.push(theRoom);	
		}
		
		evtParams.rooms = roomList;
		sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_FIND_RESULT, evtParams));
	}
	
	private function fnFindUsers(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var userListData:ISFSArray<Dynamic> = sfso.getSFSArray(FindUsersRequest.KEY_FILTERED_USERS);
		var userList:Array<Dynamic> = [];
		var mySelf:User = sfs.mySelf;
			
		for(var i:Int=0;i<userListData.size();i++)
		{
			var u:User = SFSUser.fromSFSArray(userListData.getSFSArray(i));
			
			/*
			* Since 0.9.6
			* Swap the original object, this way we have the isItMe flag correctly populated
			*/
			if(u.id==mySelf.id)
				u = mySelf;
					
			userList.push(u);
		}
		
		evtParams.users = userList;
		sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_FIND_RESULT, evtParams));
	}
	
	private function fnInviteUsers(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		var inviter:User = null;
		
		// Determine if the user is local(id was sent)or not(whole User object was sent)
		if(sfso.containsKey(InviteUsersRequest.KEY_USER_ID))
			inviter = sfs.userManager.getUserById(sfso.getInt(InviteUsersRequest.KEY_USER_ID));
		else
			inviter = SFSUser.fromSFSArray(sfso.getSFSArray(InviteUsersRequest.KEY_USER));
			
		var expiryTime:Int = sfso.getShort(InviteUsersRequest.KEY_TIME);
		var invitationId:Int = sfso.getInt(InviteUsersRequest.KEY_INVITATION_ID);
		var invParams:ISFSObject = sfso.getSFSObject(InviteUsersRequest.KEY_PARAMS);
		var invitation:Invitation = new SFSInvitation(inviter, sfs.mySelf, expiryTime, invParams);
		invitation.id = invitationId;
		
		evtParams.invitation = invitation;
		sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION, evtParams));
	}
	
	private function fnInvitationReply(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::SUCCESS:::
		if(sfso.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			var invitee:User = null;
			
			// Determine if the invitee is local(id was sent)or not(whole User object was sent)
			if(sfso.containsKey(InviteUsersRequest.KEY_USER_ID))
				invitee = sfs.userManager.getUserById(sfso.getInt(InviteUsersRequest.KEY_USER_ID));
			else
				invitee = SFSUser.fromSFSArray(sfso.getSFSArray(InviteUsersRequest.KEY_USER));
				
			var reply:Int = sfso.getUnsignedByte(InviteUsersRequest.KEY_REPLY_ID);
			var data:ISFSObject = sfso.getSFSObject(InviteUsersRequest.KEY_PARAMS);
			
			evtParams.invitee = invitee;
			evtParams.reply = reply;
			evtParams.data = data;
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY, evtParams));
			
		}
		
		//:::FAILURE:::
		else
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY_ERROR, evtParams));
		}
	}
	
	private function fnQuickJoinGame(msg:IMessage):Void
	{
		// NOTE:this is called only in case of error, when no Games to join where found
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		//:::GRAB ERROR:::
		if(sfso.containsKey(BaseRequest.KEY_ERROR_CODE))
		{
			var errorCd:Int = sfso.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, sfso.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			evtParams = { errorMessage:errorMsg, errorCode:errorCd };
			
			sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR, evtParams));
		}
	}
	
	private function fnPingPong(msg:IMessage):Void
	{
		var avg:Int=sfs.kernel::lagMonitor.onPingPong();

		// Redispatch at the user level
		var newEvt:SFSEvent = new SFSEvent(SFSEvent.PING_PONG, { lagValue:avg } );
		sfs.dispatchEvent(newEvt);
	}
	
	/*
	* Handles User Position updates, including Users and MMOItems that have entered or left the Player's AOI
	*/
	private function fnSetUserPosition(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
		
		var roomId:Int = sfso.getInt(SetUserPositionRequest.KEY_ROOM);	
		var minusUserList:Array<Dynamic>=sfso.getIntArray(SetUserPositionRequest.KEY_MINUS_USER_LIST);
		var plusUserList:ISFSArray<Dynamic>=sfso.getSFSArray(SetUserPositionRequest.KEY_PLUS_USER_LIST);
		
		var minusItemList:Array<Dynamic>=sfso.getIntArray(SetUserPositionRequest.KEY_MINUS_ITEM_LIST);
		var plusItemList:ISFSArray<Dynamic>=sfso.getSFSArray(SetUserPositionRequest.KEY_PLUS_ITEM_LIST);
		
		var theRoom:Room=sfs.roomManager.getRoomById(roomId);
		
		var addedUsers:Array<Dynamic> = [];
		var removedUsers:Array<Dynamic>=[];
		var addedItems:Array<Dynamic>=[];
		var removedItems:Array<Dynamic>=[];
		var i:Int;
		
		// Remove users that no longer are in proximity
		if(minusUserList !=null && minusUserList.length>0)
		{
			for(var uid:Int in minusUserList)
			{
				var removedUser:User=theRoom.getUserById(uid);
				if(removedUser !=null)
				{
					theRoom.removeUser(removedUser);
					removedUsers.push(removedUser);
				}
			}
		}
		
		// Add new users that are now in proximity
		if(plusUserList !=null)
		{
			for(i in 0...plusUserList.size())
			{
				var encodedUser:ISFSArray<Dynamic>=plusUserList.getSFSArray(i);
				
				var newUser:User=getOrCreateUser(encodedUser, true, theRoom);
				addedUsers.push(newUser);
				theRoom.addUser(newUser);
				
				/*
				* From the encoded User(as SFSArray)we extract the 5th extra/optional parameter 
				* which contains his location on the map, or the AOIEntryPoint as we will refer to it
				*/
				var userEntryPos:Array<Dynamic>=encodedUser.getElementAt(5);
				
				if(userEntryPos !=null)
					(newUser as SFSUser).aoiEntryPoint=Vec3D.fromArray(encodedUser.getElementAt(5));
			}
		}
		
		var mmoRoom:MMORoom=cast(theRoom, MMORoom);
		
		// If there are items to remove simply pass the list of MMOItem ids
		if(minusItemList !=null)
		{
			for(i=0;i<minusItemList.length;i++)
			{
				var itemId:Int=minusItemList[i];
				var mmoItem:IMMOItem=mmoRoom.getMMOItem(itemId);
				
				if(mmoItem !=null)
				{
					// Remove from Room Item list
					mmoRoom.kernel::removeItem(itemId);
					
					// Add to event list
					removedItems.push(mmoItem);	
				}
			}
		}
			
		// Prepare a list of new MMOItems in view
		if(plusItemList !=null)
		{
			for(i=0;i<plusItemList.size();i++)
			{
				var encodedItem:ISFSArray<Dynamic>=plusItemList.getSFSArray(i);
				
				// Create the MMO Item with the server side ID(Index=0 of the SFSArray)
				var newItem:IMMOItem=MMOItem.fromSFSArray(encodedItem);
				
				// Add to event list
				addedItems.push(newItem);
				
				// Add to Room Item List
				mmoRoom.kernel::addMMOItem(newItem);
				
				/*
				* From the encoded Item(as SFSArray)we extract the 2nd extra/optional parameter 
				* which contains its location on the map, or the AOIEntryPoint as we will refer to it
				*/
				var itemEntryPos:Array<Dynamic>=encodedItem.getElementAt(2);
				
				if(itemEntryPos !=null)
					(newItem as MMOItem).aoiEntryPoint=Vec3D.fromArray(encodedItem.getElementAt(2));
			}
		}
		
		evtParams.addedItems=addedItems;
		evtParams.removedItems=removedItems;
		evtParams.removedUsers=removedUsers;
		evtParams.addedUsers=addedUsers;
		evtParams.room=cast(theRoom, MMORoom);
		
		sfs.dispatchEvent(new SFSEvent(SFSEvent.PROXIMITY_LIST_UPDATE, evtParams));
	}
	
	private function fnSetMMOItemVariables(msg:IMessage):Void
	{
		var sfso:ISFSObject = msg.content;
		var evtParams:Dynamic = { };
			
		var roomId:Int=sfso.getInt(SetMMOItemVariables.KEY_ROOM_ID);
		var mmoItemId:Int=sfso.getInt(SetMMOItemVariables.KEY_ITEM_ID);
		var varList:ISFSArray<Dynamic>=sfso.getSFSArray(SetMMOItemVariables.KEY_VAR_LIST);
		
		var mmoRoom:MMORoom= cast sfs.getRoomById(roomId);
		var changedVarNames:Array<Dynamic>=[];
			
		if(mmoRoom !=null)
		{
			var mmoItem:IMMOItem=mmoRoom.getMMOItem(mmoItemId);
			
			if(mmoItem !=null)
			{
				for(var j:Int=0;j<varList.size();j++)
				{
					var itemVar:IMMOItemVariable=MMOItemVariable.fromSFSArray(varList.getSFSArray(j));
					mmoItem.setVariable(itemVar);
					
					changedVarNames.push(itemVar.name);
				}
				
				evtParams.changedVars=changedVarNames;
				evtParams.mmoItem=mmoItem;
				evtParams.room=mmoRoom;
				
				sfs.dispatchEvent(new SFSEvent(SFSEvent.MMOITEM_VARIABLES_UPDATE, evtParams));					
			}
		}
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function populateRoomList(roomList:ISFSArray):Void
	{
		var roomManager:IRoomManager = sfs.roomManager;
		
		// Cycle through each room object
		for(var j:Int=0;j<roomList.size();j++)
		{
			var roomObj:ISFSArray<Dynamic> = roomList.getSFSArray(j);
			var newRoom:Room = SFSRoom.fromSFSArray(roomObj);
			
			roomManager.replaceRoom(newRoom);
		}
	}
	
	private function getOrCreateUser(userObj:ISFSArray, addToGlobalManager:Bool=false, room:Room=null):User
	{
		// Get id
		var uId:Int = userObj.getInt(0);
		var user:User = sfs.userManager.getUserById(uId);
		
		// User is not managed, build the object from Server data
		if(user==null)
		{
			user = SFSUser.fromSFSArray(userObj, room);
			user.userManager = sfs.userManager;
		}
		
		// User is already managed, make sure to update the playerId
		//
		// Since 0.9.9:
		// Also the user could have updated his variables, so change them as well
		else if(room !=null)
		{
			user.setPlayerId(userObj.getShort(3), room);
			
			var uVars:ISFSArray<Dynamic> = userObj.getSFSArray(4);
			for(var i:Int=0;i<uVars.size();i++)
			{
				user.setVariable(SFSUserVariable.fromSFSArray(uVars.getSFSArray(i)));
			}
		}
			
		// Add if new
		if(addToGlobalManager)
			sfs.userManager.addUser(user);
		
		return user
	}
	
	
	/*
	private function populateRoomVariables(room:Room, varsList:ISFSArray):Void
	{
		var vars:Array<Dynamic>=new Array()
		
		for(var j:Int=0;j<varsList.size();j++)
		{
			var roomVarObj:ISFSArray<Dynamic>=varsList.getSFSArray(j)
			var roomVariable:RoomVariable=new SFSRoomVariable(
																	roomVarObj.getUtfString(0), 	// name
																	roomVarObj.getElementAt(2),		// typed value
																	roomVarObj.getByte(1)			// type id
																)
			vars.push(roomVariable)	
		}
		
		room.setVariables(vars)
	}
	*/
}