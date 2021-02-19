/* ---------------------------------------
 *<><><><><>SmartFoxServer 2X<><><><><>
 * ---------------------------------------
 * Actionscript 3.0 Client API
 * 
 * www.smartfoxserver.com
 *(c)2009-2013 gotoAndPlay()
 */

package com.smartfoxserver.v2;
import com.smartfoxserver.v2.entities.managers.IBuddyManager;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.managers.IRoomManager;
import com.smartfoxserver.v2.util.ConnectionMode;

import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.bitswarm.BitSwarmEvent;
import com.smartfoxserver.v2.bitswarm.DefaultUDPManager;
import com.smartfoxserver.v2.bitswarm.IMessage;
import com.smartfoxserver.v2.bitswarm.IUDPManager;
import com.smartfoxserver.v2.bitswarm.IoHandler;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.core.SFSIOHandler;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.managers.IUserManager;
import com.smartfoxserver.v2.entities.managers.SFSBuddyManager;
import com.smartfoxserver.v2.entities.managers.SFSGlobalUserManager;
import com.smartfoxserver.v2.entities.managers.SFSRoomManager;
import com.smartfoxserver.v2.exceptions.SFSCodecError;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.logging.Logger;
import com.smartfoxserver.v2.requests.BaseRequest;
import com.smartfoxserver.v2.requests.HandshakeRequest;
import com.smartfoxserver.v2.requests.IRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.ManualDisconnectionRequest;
import com.smartfoxserver.v2.util.ClientDisconnectionReason;
import com.smartfoxserver.v2.util.ConfigData;
import com.smartfoxserver.v2.util.ConfigLoader;
import com.smartfoxserver.v2.util.CryptoInitializer;
import com.smartfoxserver.v2.util.LagMonitor;
import com.smartfoxserver.v2.util.SFSErrorCodes;
import openfl.errors.ArgumentError;

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.system.Capabilities;

//--------------------------------------
//  Connection events
//--------------------------------------

/**
 * Dispatched when a connection between the client and a SmartFoxServer 2X instance is attempted.
 * This event is fired in response to a call to the<em>connect()</em>method.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONNECTION
 * 
 * @see		#connect()
 */ 
//[Event(name="connection", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the connection between the client and the SmartFoxServer 2X instance is Interrupted.
 * This event is fired in response to a call to the<em>disconnect()</em>method.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONNECTION_LOST
 * 
 * @see		#disconnect()
 * @see		#event:connectionRetry connectionRetry event
 */ 
//[Event(name="connectionLost", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the connection between the client and the SmartFoxServer 2X instance is Interrupted abruptly
 * while the SmartFoxServer 2X HRC system is available in the Zone.
 * 
 *<p>The HRC system allows a broken connection to be re-established transparently within a certain amount of time, without loosing any of the current
 * application state. For example this allows any player to get back to a game without loosing the match because of a sloppy Internet connection.</p>
 * 
 *<p>When this event is dispatched the API enter a "freeze" mode where no new requests can be sent until the reconnection is successfully performed.
 * It is highly recommended to handle this event and freeze the application Interface accordingly until the<em>connectionResume</em>event is fired,
 * or the reconnection fails and the user is definitely disconnected and the<em>connectionLost</em>event is fired.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONNECTION_RETRY
 * 
 * @see		#event:connectionResume connectionResume event
 * @see		#event:connectionLost connectionLost event
 */ 
//[Event(name="connectionRetry", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the connection between the client and the SmartFoxServer 2X instance is re-established after a temporary disconnection,
 * while the SmartFoxServer 2X HRC system is available in the Zone.
 * 
 *<p>The HRC system allows a broken connection to be re-established transparently within a certain amount of time, without loosing any of the current
 * application state. For example this allows any player to get back to a game without loosing the match because of a sloppy Internet connection.</p>
 * 
 *<p>When this event is dispatched the application Interface should be reverted to the state it had before the disconnection.
 * In case the reconnection attempt fails, the<em>connectionLost</em>event is fired.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONNECTION_RESUME
 * 
 * @see		#event:connectionResume connectionRetry event
 * @see		#event:connectionLost connectionLost event
 */ 
//[Event(name="connectionResume", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the client cannot establish a socket connection to the server and the<em>useBlueBox</em>parameter is active in the configuration.
 * 
 *<p>The event can be used to notify the user that a second connection attempt is running, using the BlueBox(HTTP tunnelling).</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONNECTION_ATTEMPT_HTTP
 */
//[Event(name="connectionAttemptHttp", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the result of the UDP handshake is notified.
 * This event is fired in response to a call to the<em>initUDP()</em>method.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.UDP_INIT
 * 
 * @see		#initUDP()
 */ 
//[Event(name="udpInit", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the external client configuration file is loaded successfully.
 * This event is fired in response to a call to the<em>loadConfig()</em>method,
 * but only if the<em>connectOnSuccess</em>argument of the<em>loadConfig()</em>method is set to<code>false</code>;
 * otherwise the connection is attempted and the related<em>SFSEvent.CONNECTION</em>event type is fired.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONFIG_LOAD_SUCCESS
 * 
 * @see		#loadConfig()
 */ 
//[Event(name="configLoadSuccess", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched if an error occurs while loading the external client configuration file.
 * This event is fired in response to a call to the<em>loadConfig()</em>method,
 * typically when the configuration file is not found or it isn't accessible(no read permissions).
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CONFIG_LOAD_FAILURE
 * 
 * @see		#loadConfig()
 */ 
//[Event(name="configLoadFailure", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched in return to the initialization of an encrypted connection.
 * This event is fired in response to a call to the <em>initCrypto()</em> method.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.CRYPTO_INIT
 * 
 * @see		#initCrypto()
 */ 
//[Event(name = "udpInit", type = "com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Login events
//--------------------------------------

/**
 * Dispatched when the current user performs a successful login in a server Zone.
 * This event is fired in response to the<em>LoginRequest</em>request.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.LOGIN
 * 
 * @see		com.smartfoxserver.v2.requests.LoginRequest LoginRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="login", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched if an error occurs while the user login is being performed.
 * This event is fired in response to the<em>LoginRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.LOGIN_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.LoginRequest LoginRequest
 */ 
//[Event(name="loginError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the current user performs logs out of the server Zone.
 * This event is fired in response to the<em>LogoutRequest</em>request.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.LOGOUT
 * 
 * @see		com.smartfoxserver.v2.requests.LogoutRequest LogoutRequest
 */ 
//[Event(name="logout", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Room events
//--------------------------------------

/**
 * Dispatched when a new Room is created inside the Zone under any of the Room Groups that the client subscribed.
 * This event is fired in response to the<em>CreateRoomRequest</em>and<em>CreateSFSGameRequest</em>requests in case the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_ADD
 * 
 * @see		com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
 * @see		com.smartfoxserver.v2.requests.game.CreateSFSGameRequest CreateSFSGameRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomAdd", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched if an error occurs while creating a new Room.
 * This event is fired in response to the<em>CreateRoomRequest</em>and<em>CreateSFSGameRequest</em>requests in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_CREATION_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.CreateRoomRequest CreateRoomRequest
 * @see		com.smartfoxserver.v2.requests.game.CreateSFSGameRequest CreateSFSGameRequest
 */ 
//[Event(name="roomCreationError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a Room belonging to one of the Groups subscribed by the client is removed from the Zone.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_REMOVE
 * 
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomRemove", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a Room is joined by the current user.
 * This event is fired in response to the<em>JoinRoomRequest</em>and<em>QuickJoinGameRequest</em>
 * requests in case the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_JOIN
 * 
 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
 * @see		com.smartfoxserver.v2.requests.game.QuickJoinGameRequest QuickJoinGameRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomJoin", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while the current user is trying to join a Room.
 * This event is fired in response to the<em>JoinRoomRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_JOIN_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
 */ 
//[Event(name="roomJoinError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when one of the Rooms joined by the current user is entered by another user.
 * This event is caused by a<em>JoinRoomRequest</em>request;it might be fired or not depending
 * on the Room configuration defined upon its creation(see the<em>RoomSettings.events</em>setting).
 * 
 *<p><b>NOTE</b>:if the Room is of type MMORoom, this event is never fired and it is substituted by the<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.USER_ENTER_ROOM
 * 
 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
 * @see		com.smartfoxserver.v2.requests.RoomSettings#events RoomSettings#events
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.Room Room
 * @see		com.smartfoxserver.v2.entities.MMORoom MMORoom
 */ 
//[Event(name="userEnterRoom", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when one of the Rooms joined by the current user is left by another user, or by the current user himself.
 * This event is caused by a<em>LeaveRoomRequest</em>request;it  might be fired or not depending
 * on the Room configuration defined upon its creation(see the<em>RoomSettings.events</em>setting).
 * 
 *<p><b>NOTE</b>:if the Room is of type MMORoom, this event is fired when the current user leaves the Room only.
 * For the other users leaving the Room it is substituted by the<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.USER_EXIT_ROOM
 * 
 * @see		com.smartfoxserver.v2.requests.LeaveRoomRequest LeaveRoomRequest
 * @see		com.smartfoxserver.v2.requests.RoomSettings#events RoomSettings#events
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="userExitRoom", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the number of users/players or spectators inside a Room changes.
 * This event is caused by a<em>JoinRoomRequest</em>request or a<em>LeaveRoomRequest</em>request.
 * The Room must belong to one of the Groups subscribed by the current client;also
 * this event might be fired or not depending on the Room configuration defined upon its
 * creation(see the<em>RoomSettings.events</em>setting).
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.USER_COUNT_CHANGE
 * 
 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
 * @see		com.smartfoxserver.v2.requests.LeaveRoomRequest LeaveRoomRequest
 * @see		com.smartfoxserver.v2.requests.RoomSettings#events RoomSettings#events
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="userCountChange", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a player is turned to a spectator inside a Game Room.
 * This event is fired in response to the<em>PlayerToSpectatorRequest</em>>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.PLAYER_TO_SPECTATOR
 * 
 * @see		com.smartfoxserver.v2.requests.PlayerToSpectatorRequest PlayerToSpectatorRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="playerToSpectator", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while the current user is being turned from player to spectator in a Game Room.
 * This event is fired in response to the<em>PlayerToSpectatorRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.PLAYER_TO_SPECTATOR_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.PlayerToSpectatorRequest PlayerToSpectatorRequest
 */ 
//[Event(name="playerToSpectatorError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a spectator is turned to a player inside a Game Room.
 * This event is fired in response to the<em>SpectatorToPlayerRequest</em>>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.SPECTATOR_TO_PLAYER
 * 
 * @see		com.smartfoxserver.v2.requests.SpectatorToPlayerRequest SpectatorToPlayerRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="spectatorToPlayer", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while the current user is being turned from spectator to player in a Game Room.
 * This event is fired in response to the<em>SpectatorToPlayerRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.SPECTATOR_TO_PLAYER_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.SpectatorToPlayerRequest SpectatorToPlayerRequest
 */ 
//[Event(name="spectatorToPlayerError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the name of a Room is changed.
 * This event is fired in response to the<em>ChangeRoomNameRequest</em>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_NAME_CHANGE
 * 
 * @see		com.smartfoxserver.v2.requests.ChangeRoomNameRequest ChangeRoomNameRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomNameChange", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while attempting to change the name of a Room.
 * This event is fired in response to the<em>ChangeRoomNameRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_NAME_CHANGE_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.ChangeRoomNameRequest ChangeRoomNameRequest
 */ 
//[Event(name="roomNameChangeError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the password of a Room is set, changed or removed.
 * This event is fired in response to the<em>ChangeRoomPasswordStateRequest</em>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_PASSWORD_STATE_CHANGE
 * 
 * @see		com.smartfoxserver.v2.requests.ChangeRoomPasswordStateRequest ChangeRoomPasswordStateRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomPasswordStateChange", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while attempting to set, change or remove the password of a Room.
 * This event is fired in response to the<em>ChangeRoomPasswordStateRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.ChangeRoomPasswordStateRequest ChangeRoomPasswordStateRequest
 */ 
//[Event(name="roomPasswordStateChangeError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the capacity of a Room is changed.
 * This event is fired in response to the<em>ChangeRoomCapacityRequest</em>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_CAPACITY_CHANGE
 * 
 * @see		com.smartfoxserver.v2.requests.ChangeRoomCapacityRequest ChangeRoomCapacityRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomCapacityChange", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while attempting to change the capacity of a Room.
 * This event is fired in response to the<em>ChangeRoomCapacityRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_CAPACITY_CHANGE_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.ChangeRoomCapacityRequest ChangeRoomCapacityRequest
 */ 
//[Event(name="roomCapacityChangeError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when one more users or one or more MMOItem objects enter/leave the current user's Area of Interest in MMORooms.
 * This event is fired after an MMORoom is joined and the<em>SetUserPositionRequest</em>request is sent at least one time. 
 * 
 *<p><b>NOTE</b>:this event substitutes the default<em>SFSEvent.USER_ENTER_ROOM</em>and<em>SFSEvent.USER_EXIT_ROOM</em>events available in regular Rooms.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.PROXIMITY_LIST_UPDATE
 * 
 * @see		com.smartfoxserver.v2.requests.mmo.SetUserPositionRequest SetUserPositionRequest
 * @see		com.smartfoxserver.v2.entities.MMORoom MMORoom
 * @see		com.smartfoxserver.v2.entities.MMOItem MMOItem
 */ 
//[Event(name="proximityListUpdate", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Message events
//--------------------------------------

/**
 * Dispatched when a public message is received by the current user.
 * This event is caused by a<em>PublicMessageRequest</em>request sent by any user in the target Room, including the current user himself.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.PUBLIC_MESSAGE
 * 
 * @see		com.smartfoxserver.v2.requests.PublicMessageRequest PublicMessageRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="publicMessage", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a private message is received by the current user.
 * This event is caused by a<em>PrivateMessageRequest</em>request sent by any user in the Zone.
 * 
 *<p><b>NOTE</b>:the same event is fired by the sender's client too, so that the user is aware that the message was delivered successfully to the recipient,
 * and it can be displayed in the private chat area keeping the correct message ordering. In this case there is no default way to know who the message was originally sent to.
 * As this information can be useful in scenarios where the sender is chatting privately with more than one user at the same time in separate windows or tabs
 *(and we need to write his own message in the proper one), the<em>data</em>parameter can be used to store, for example, the id of the recipient user.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.PRIVATE_MESSAGE
 * 
 * @see		com.smartfoxserver.v2.requests.PrivateMessageRequest PrivateMessageRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="privateMessage", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an object containing custom data is received by the current user.
 * This event is caused by an<em>ObjectMessageRequest</em>request sent by any user in the target Room.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.OBJECT_MESSAGE
 * 
 * @see		com.smartfoxserver.v2.requests.ObjectMessageRequest DynamicMessageRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="objectMessage", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the current user receives a message from a moderator user.
 * This event can be caused by either the<em>ModeratorMessageRequest</em>,<em>KickUserRequest</em>or
 *<em>BanUserRequest</em>requests sent by a user with at least moderation privileges.
 * Also, this event can be caused by a kick/ban action performed through the SmartFoxServer 2X Administration Tool.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.MODERATOR_MESSAGE
 * 
 * @see		com.smartfoxserver.v2.requests.ModeratorMessageRequest ModeratorMessageRequest
 * @see		com.smartfoxserver.v2.requests.KickUserRequest KickUserRequest
 * @see		com.smartfoxserver.v2.requests.BanUserRequest BanUserRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="moderatorMessage", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the current user receives a message from an administrator user.
 * This event is caused by the<em>AdminMessageRequest</em>request sent by a user with administration privileges.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ADMIN_MESSAGE
 * 
 * @see		com.smartfoxserver.v2.requests.AdminMessageRequest AdminMessageRequest
 * @see		com.smartfoxserver.v2.entities.User User
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="adminMessage", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when data coming from a server-side Extension is received by the current user.
 * Data is usually sent by the server to one or more clients in response to an<em>ExtensionRequest</em>request, but not necessarily.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.EXTENSION_RESPONSE
 * 
 * @see		com.smartfoxserver.v2.requests.ExtensionRequest ExtensionRequest
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */ 
//[Event(name="extensionResponse", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Variables events
//--------------------------------------

/**
 * Dispatched when a Room Variable is updated.
 * This event is caused by the<em>SetRoomVariablesRequest</em>request. The request could have been sent by a user in the same Room of the current user or,
 * in case of a global Room Variable, by a user in a Room belonging to one of the Groups subscribed by the current client.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_VARIABLES_UPDATE
 * 
 * @see		com.smartfoxserver.v2.requests.SetRoomVariablesRequest SetRoomVariablesRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */ 
//[Event(name="roomVariablesUpdate", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a User Variable is updated.
 * This event is caused by the<em>SetUserVariablesRequest</em>request sent by a user in one of the Rooms joined by the current user.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.USER_VARIABLES_UPDATE
 * 
 * @see		com.smartfoxserver.v2.requests.SetUserVariablesRequest SetUserVariablesRequest
 * @see		com.smartfoxserver.v2.entities.User User
 */ 
//[Event(name="userVariablesUpdate", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an MMOItem Variable is updated in an MMORoom.
 * This event is caused by an MMOItem Variable being set, updated or deleted in a server side Extension, and it is received only if the current user
 * has the related MMOItem in his Area of Interest.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.MMOITEM_VARIABLES_UPDATE
 * 
 * @see		com.smartfoxserver.v2.entities.MMORoom MMORoom
 * @see		com.smartfoxserver.v2.entities.variables.MMOItemVariable MMOItemVariable
 * @see		com.smartfoxserver.v2.entities.MMOItem MMOItem
 */ 
//[Event(name="mmoItemVariablesUpdate", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Group subscription events
//--------------------------------------

/**
 * Dispatched when a Group is subscribed by the current user.
 * This event is fired in response to the<em>SubscribeRoomGroupRequest</em>>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_GROUP_SUBSCRIBE
 * 
 * @see		com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest SubscribeRoomGroupRequest
 * @see		com.smartfoxserver.v2.entities.Room Room
 */
//[Event(name="roomGroupSubscribe", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while a Room Group is being subscribed.
 * This event is fired in response to the<em>SubscribeRoomGroupRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest SubscribeRoomGroupRequest
 */ 
//[Event(name="roomGroupSubscribeError", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a Group is unsubscribed by the current user.
 * This event is fired in response to the<em>UnsubscribeRoomGroupRequest</em>>request if the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_GROUP_UNSUBSCRIBE
 * 
 * @see		com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest UnsubscribeRoomGroupRequest
 */
//[Event(name="roomGroupUnsubscribe", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while a Room Group is being unsubscribed.
 * This event is fired in response to the<em>UnsubscribeRoomGroupRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest UnsubscribeRoomGroupRequest
 */ 
//[Event(name="roomGroupUnsubscribeError", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Find events
//--------------------------------------

/**
 * Dispatched when a Rooms search is completed.
 * This event is fired in response to the<em>FindRoomsRequest</em>request to return the search result.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.ROOM_FIND_RESULT
 * 
 * @see		com.smartfoxserver.v2.requests.FindRoomsRequest FindRoomsRequest
 */
//[Event(name="roomFindResult", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a users search is completed.
 * This event is fired in response to the<em>FindUsersRequest</em>request to return the search result.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.USER_FIND_RESULT
 * 
 * @see		com.smartfoxserver.v2.requests.FindUsersRequest FindUsersRequest
 */
//[Event(name="userFindResult", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Invitation events
//--------------------------------------

/**
 * Dispatched when the current user receives an invitation from another user.
 * This event is caused by the<em>InviteUsersRequest</em>request;the user is supposed to reply
 * using the<em>InvitationReplyRequest</em>request.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.INVITATION
 * 
 * @see		com.smartfoxserver.v2.requests.game.InviteUsersRequest InviteUsersRequest
 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
 * @see		com.smartfoxserver.v2.entities.invitation.Invitation Invitation
 */
//[Event(name="invitation", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when the current user receives a reply to an invitation he sent previously.
 * This event is caused by the<em>InvitationReplyRequest</em>request sent by the invitee.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.INVITATION_REPLY
 * 
 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
 * @see		com.smartfoxserver.v2.entities.invitation.InvitationReply InvitationReply
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 */
//[Event(name="invitationReply", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when an error occurs while the current user is sending a reply to an invitation he received.
 * This event is fired in response to the<em>InvitationReplyRequest</em>request in case the operation failed.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.INVITATION_REPLY_ERROR
 * 
 * @see		com.smartfoxserver.v2.requests.game.InvitationReplyRequest InvitationReplyRequest
 */
//[Event(name="invitationReplyError", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Buddy events
//--------------------------------------

/**
 * Dispatched if the Buddy List system is successfully initialized.
 * This event is fired in response to the<em>InitBuddyListRequest</em>request in case the operation is executed successfully.
 * 
 *<p>After the Buddy List system initialization, the user returns to his previous custom state(if any - see<em>IBuddyManager.myState</em>property).
 * His online/offline state, his nickname and his persistent Buddy Variables are all loaded and broadcast in the system.
 * In particular, the online state(see<em>IBuddyManager.myOnlineState</em>property)determines if the user will appear online or not to other users who have him in their buddies list.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_LIST_INIT
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest InitBuddyListRequest
 * @see		com.smartfoxserver.v2.entities.managers.IBuddyManager IBuddyManager
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
 */ 
//[Event(name="buddyListInit", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched when a buddy is added successfully to the current user's buddies list.
 * This event is fired in response to the<em>AddBuddyRequest</em>request in case the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_ADD
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest AddBuddyRequest
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 */ 
//[Event(name="buddyAdd", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched when a buddy is blocked or unblocked successfully by the current user.
 * This event is fired in response to the<em>BlockBuddyRequest</em>request in case the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_BLOCK
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.BlockBuddyRequest BlockBuddyRequest
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 */ 
//[Event(name="buddyBlock", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched when a buddy is removed successfully from the current user's buddies list.
 * This event is fired in response to the<em>RemoveBuddyRequest</em>request in case the operation is executed successfully.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_REMOVE
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.RemoveBuddyRequest RemoveBuddyRequest
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 */ 
//[Event(name="buddyRemove", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched if an error occurs while executing a request related to the Buddy List system.
 * For example, this event is fired in response to the<em>AddBuddyRequest</em>request, the<em>BlockBuddyRequest</em>, etc.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_ERROR
 */ 
//[Event(name="buddyError", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched when a message from a buddy is received by the current user.
 * This event is fired in response to the<em>BuddyMessageRequest</em>request.
 * 
 *<p><b>NOTE</b>:the same event is fired by the sender's client too, so that the user is aware that the message was delivered successfully to the recipient,
 * and it can be displayed in the chat area keeping the correct message ordering. As in this case the value of the<em>buddy</em>parameter is<code>null</code>
 *(because, being the sender, the user is not buddy to himself of course), there is no default way to know who the message was originally sent to.
 * As this information can be useful in scenarios where the sender is chatting with more than one buddy at the same time in separate windows or tabs
 *(and we need to write his own message in the proper one), the<em>data</em>parameter can be used to store, for example, the id of the recipient buddy.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_MESSAGE
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.BuddyMessageRequest BuddyMessageRequest
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 */ 
//[Event(name="buddyMessage", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched when a buddy in the current user's buddies list changes his online state in the Buddy List system.
 * This event is fired in response to the<em>GoOnlineRequest</em>request.
 * 
 *<p><b>NOTE</b>:this event is dispatched to those who have the user as a buddy, but also to the user himself.
 * As in this case the value of the<em>buddy</em>parameter is<code>null</code>(because the user is not buddy to himself of course),
 * the<em>isItMe</em>parameter should be used to check if the current user is the one who changed his own online state.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.GoOnlineRequest GoOnlineRequest
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 */ 
//[Event(name="buddyOnlineStateChange", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

/**
 * Dispatched when a buddy in the current user's buddies list updates one or more Buddy Variables.
 * This event is fired in response to the<em>SetBuddyVariablesRequest</em>request.
 * 
 *<p><b>NOTE</b>:this event is dispatched to those who have the user as a buddy, but also to the user himself.
 * As in this case the value of the<em>buddy</em>parameter is<code>null</code>(because the user is not buddy to himself of course),
 * the<em>isItMe</em>parameter should be used to check if the current user is the one who updated his own Buddy Variables.</p>
 * 
 * @eventType com.smartfoxserver.v2.core.SFSBuddyEvent.BUDDY_VARIABLES_UPDATE
 * 
 * @see		com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest SetBuddyVariablesRequest
 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 */ 
//[Event(name="buddyVariablesUpdate", type="com.smartfoxserver.v2.core.SFSBuddyEvent")]

//--------------------------------------
//  Other events
//--------------------------------------

/**
 * Dispatched when a new lag value measurement is available.
 * This event is fired when the automatic lag monitoring is turned on by passing<code>true</code>to the<em>enableLagMonitor()</em>method.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.PING_PONG
 * 
 * @see		#enableLagMonitor()
 */ 
//[Event(name="pingPong", type="com.smartfoxserver.v2.core.SFSEvent")]

/**
 * Dispatched when a low level socket error is detected, for example bad/inconsistent data.
 * 
 * @eventType com.smartfoxserver.v2.core.SFSEvent.SOCKET_ERROR
 */ 
//[Event(name="socketError", type="com.smartfoxserver.v2.core.SFSEvent")]

//--------------------------------------
//  Class
//--------------------------------------

/**
 *<em>SmartFox</em>is the main class of the SmartFoxServer 2X API.
 * It is responsible for connecting the client to a SmartFoxServer instance and for dispatching all asynchronous events.
 * Developers always Interact with SmartFoxServer through this class.
 * 
 *<p><b>NOTE</b>:in the provided examples,<code>sfs</code>always indicates a<em>SmartFox</em>instance.</p>
 * 
 * @see		http://www.smartfoxserver.com 
 * 
 * @version	1.2.x
 * 
 * @author	The gotoAndPlay()Team
 * 			http://www.smartfoxserver.com
 * 			http://www.gotoandplay.it
 */
class SmartFox extends EventDispatcher
{	
	private static inline var DEFAULT_HTTP_PORT:Int = 8080;
	private static inline var CLIENT_TYPE_SEPARATOR:String = ":";
		
	// Current version
	private var _majVersion:Int = 1;
	private var _minVersion:Int = 6;
	private var _subVersion:Int = 0;

	
	// The socket engine
	private var _bitSwarm:BitSwarmClient;
	
	private var _lagMonitor:LagMonitor;
	
	// If true the client will fall back to BlueBox if no socket connection is available
	private var _useBlueBox:Bool = true;

    //https WebSocket protocol (Adobe AIR Target may does not support WSS protocol)
    public var useWSS:Bool = true;
	
	// If true the client is connected
	private var _isConnected:Bool = false;
	
	// If true the client is in the middle of a join transaction
	private var _isJoining:Bool = false;
	
	// References the client's User object
	private var _mySelf:User;
	
	// A unique session token, sent by the server during the handshake
	private var _sessionToken:String;
	
	// Last joined room
	private var _lastJoinedRoom:Room;
	
	// The logger
	private var _log:Logger;
	
	// API initialization flag
	private var _inited:Bool = false;
	
	// Protocol debug flag
	private var _debug:Bool = false;
	
	// Connection attempt flag
	private var _isConnecting:Bool = false;
	
	// The global user manager
	private var _userManager:IUserManager;
	
	// The global room manager
	private var _roomManager:IRoomManager;
	
	// The global buddy manager
	private var _buddyManager:IBuddyManager;
	
	private var _config:ConfigData;
	
	// The name of the currently joined Zone
	private var _currentZone:String;
	
	// When true ->starts the connection right after successful config loading
	private var _autoConnectOnConfig:Bool = false;
		
	// Last ip address used for connection, used when falling back to BlueBox
	private var _lastIpAddress:String;
	
	// Client details passed to setClientDetails method
	private var _clientDetails:String =
	#if flash
 	"Flash"
	#elseif neko
	"Neko"
	#elseif linux
	"Linux"
	#elseif windows
	"Windows"
	#elseif html5
	"JavaScript"
	#else
	"Unknown"
	#end
	;	
	
	/**
	 * Creates a new<em>SmartFox</em>instance.
	 * 
	 * @param	debug	If<code>true</code>, the SmartFoxServer API debug messages are logged.
	 *
	 * @example	The following example instantiates the<em>SmartFox</em>class while enabling the debug messages:
	 *<listing version="3.0">
	 * 
	 * var sfs:SmartFox=new SmartFox(true);
	 *</listing>
	 * 
	 * @see		#debug
	 */
	public function new(debug:Bool=false)
	{
		super();
		
		_log = @:privateAccess new Logger();
		_log.enableEventDispatching = true;
		_debug = debug;
		
		initialize();
	}
	
	// This is done ONCE in the whole life cycle
	private function initialize():Void
	{
		if(_inited)
			return;
			
		_bitSwarm = new BitSwarmClient(this);
		_bitSwarm.ioHandler = new SFSIOHandler(_bitSwarm);
		
		_bitSwarm.init();
		
		_bitSwarm.addEventListener(BitSwarmEvent.CONNECT, onSocketConnect);
		_bitSwarm.addEventListener(BitSwarmEvent.DISCONNECT, onSocketClose);
		_bitSwarm.addEventListener(BitSwarmEvent.RECONNECTION_TRY, onSocketReconnectionTry);
		_bitSwarm.addEventListener(BitSwarmEvent.IO_ERROR, onSocketIOError);
		_bitSwarm.addEventListener(BitSwarmEvent.SECURITY_ERROR, onSocketSecurityError);
		_bitSwarm.addEventListener(BitSwarmEvent.DATA_ERROR, onSocketDataError);
		
		addEventListener(SFSEvent.HANDSHAKE, handleHandShake);
		addEventListener(SFSEvent.LOGIN, handleLogin);
		
		_inited = true;
			
		reset();
	}
	
	private function reset():Void
	{
		_userManager = new SFSGlobalUserManager(this);
		_roomManager = new SFSRoomManager(this);
		_buddyManager = new SFSBuddyManager(this);
		
		// Remove previous lag monitor, if any.
		if(_lagMonitor !=null)
			_lagMonitor.destroy();
			
		_isConnected = false;
		_isJoining = false;
		_currentZone = null;
		_lastJoinedRoom = null;
		_sessionToken = null;
		_mySelf = null;
	}
	
	/*
	* addController(controller:BaseController):Void 
	* allows developers to add new custom, client side controllers to talk to their respective server side controllers
	*/
	
	/** @private */
	public function enableFullPacketDump(b:Bool):Void
	{
		cast(_bitSwarm.ioHandler,SFSIOHandler).enableFullPacketDump(b);
	}
	
	/**
	 * Allows to specify custom client details that will be used to gather statistics about the client platform via the AdminTool's Analytics Module.
	 * By default the generic "Flash" label is used as platform, without specifying the version.
	 *  
	 *<p><b>NOTE</b>:this method must be called before the connection is started. The length of the two strings combined must be less than 512 characters.</p>
	 * 
	 * @param	platformId	An identification string for the client runtime platform:for example "Flash PlugIn" or "iOS".
	 * @param	version 	An additional string to specify the version of the runtime platform:for example "2.0.0".
	 */
	public function setClientDetails(platformId:String, version:String):Void
	{
		if(_isConnected)
		{
			logger.warn("SetClientDetails must be called before the connection is started");
			return;
		}
		
		_clientDetails = (platformId != null ? StringTools.replace(platformId, CLIENT_TYPE_SEPARATOR, " "):"");
		_clientDetails +=CLIENT_TYPE_SEPARATOR;
		_clientDetails += (version != null ? StringTools.replace(version, CLIENT_TYPE_SEPARATOR, " "):"");
	}
	
	/**
	 * Enables the automatic realtime monitoring of the lag between the client and the server(round robin).
	 * When turned on, the<em>SFSEvent.PING_PONG</em>event type is dispatched continuously, providing the average of the last ten measured lag values.
	 * The lag monitoring is automatically halted when the user logs out of a Zone or gets disconnected.
	 *  
	 *<p><b>NOTE</b>:the lag monitoring can be enabled after the login has been performed successfully only.</p>
	 * 
	 * @param	enabled		The lag monitoring status:<code>true</code>to start the monitoring,<code>false</code>to stop it.
	 * @param	interval 	An optional amount of seconds to wait between each query(recommended 3-4s).
	 * @param	queueSize	The amount of values stored temporarily and used to calculate the average lag.
	 * 
	 * @see		#event:pingPong pingPong event
	 */
	public function enableLagMonitor(enabled:Bool, Interval:Int=4, queueSize:Int=10):Void
	{
		if(_mySelf==null)
		{
			logger.warn("Lag Monitoring requires that you are logged in a Zone!");
			return;
		}
		
		if(enabled)
		{
			_lagMonitor=new LagMonitor(this, Interval, queueSize);
			_lagMonitor.start();
		}
		else
			_lagMonitor.stop();
	}
	
	/**
	 * @private
	 * 
	 * Available under the kernel namespace
	 */
	function setAlternateIOHandler(ioHandler:IoHandler):Void
	{
		if(!_isConnected && !_isConnecting)
			_bitSwarm.ioHandler = ioHandler;
		else
			throw new IllegalOperationError("This operation must be executed before connecting!");
	}


	// WebSocket support
	public var _useWebSocket:Bool = false;

	public var useWebSocket(get, set):Bool;
 	private function get_useWebSocket():Bool
	{
		return _useWebSocket;
	}

	private function set_useWebSocket(value:Bool):Bool
	{
		if(this._isConnecting || this.isConnected)
		{
			_log.warn("A connection attempt is already in progress");
			return _useWebSocket;
		}
		return _useWebSocket = value;
	}
	
	/**
	 * @private
	 * 
	 * Available under the kernel namespace
	 */
	public var socketEngine(get, null):BitSwarmClient;
 	private function get_socketEngine():BitSwarmClient
	{
		return _bitSwarm;
	}
	
	
	/**
	 * @private
	 * 
	 * Available under the Kernel namespace
	 */
	@:allow(com.smartfoxserver.v2.controllers)
	var lagMonitor(get, null):LagMonitor;
 	private function get_lagMonitor():LagMonitor
	{
		return _lagMonitor;
	}
	
	/**
	 * Indicates whether the client is connected to the server or not.
	 * 
	 * @example	The following example checks the connection status:
	 *<listing version="3.0">
	 * 
	 * trace("Am I connected?", sfs.isConnected);
	 *</listing>
	 */
	public var isConnected(get, null):Bool;
 	private function get_isConnected():Bool
	{
		var value:Bool = false;
		
		if(_bitSwarm !=null)
			value = _bitSwarm.connected;
		
		return value;
	}
	
	/**
	 * Returns the current connection mode after a connection has been successfully established.
	 * Possible values are defined as constants in the<em>ConnectionMode</em>class.
	 * 
	 * @example	The following example traces the current connection mode:
	 *<listing version="3.0">
	 * 
	 * trace("Connection mode:", sfs.connectionMode);
	 *</listing>
	 * 
	 * @see	com.smartfoxserver.v2.util.ConnectionMode ConnectionMode
	 */
	public var connectionMode(get, null):String;
 	private function get_connectionMode():String
	{
		return _bitSwarm.connectionMode;
	}
	
	/**
	 * Returns the current version of the SmartFoxServer 2X ActionScript 3 API.
	 * 
	 * @example	The following example traces the SmartFoxServer API version to the console:
	 *<listing version="3.0">
	 * 
	 * trace("Current API version:", sfs.version);
	 *</listing>
	 */
	public var version(get, null):String;
 	private function get_version():String
	{
		return "" + _majVersion + "." + _minVersion + "." + _subVersion;
	}
	
	/**
	 * Returns the HTTP URI that can be used to upload files to SmartFoxServer 2X, using regular HTTP POST.
	 * For more details on how to use this functionality, see the<a href='http://docs2x.smartfoxserver.com/AdvancedTopics/file-uploads' target='_blank'>Upload File</a>tutorial.
	 * 
	 *<p><b>NOTE</b>:this property returns<code>null</code>if no API configuration has been set or the current user is not already logged in the server.</p>
	 * 
	 * @example	The following example shows how to upload a file to the server:
	 *<listing version="3.0">
	 * 
	 * private var fileRef:FileReference=new FileReference();
	 * 
	 * private function someMethod():Void
	 * {
	 * 	fileRef.addEventListener(Event.SELECT, onFileRefSelect);
	 * 	fileRef.addEventListener(Event.COMPLETE, onFileRefComplete);
	 * }
	 * 
	 * private function onFileRefSelect(evt:Event):Void
	 * {
	 *	 trace("File selected:" + fileRef.name);
	 *	  
	 *	 var req:URLRequest=new URLRequest(sfs.httpUploadURI);
	 *	 req.method=URLRequestMethod.POST;
	 *	  
	 *	 fileRef.upload(req);
	 * }
	 *  
	 * private function onFileRefComplete(evt:Event):Void
	 * {
	 *	 trace("Upload completed!")
	 * }
	 *</listing>
	 */
	public var httpUploadURI(get, null):String;
 	private function get_httpUploadURI():String
	{
		if(config==null || mySelf==null)
			return null;
		
		return "http://" + config.host + ":" + config.httpPort + "/BlueBox/SFS2XFileUpload?sessHashId=" + sessionToken;
	}
	
	/** 
	 * Returns the client configuration details.
	 * If the configuration hasn't been loaded yet, or passed to the<em>connectWithConfig()</em>method, a<code>null</code>object is returned.
	 * 
	 * @see		#loadConfig()
	 * @see		#connectWithConfig()
	 */
	public var config(get, null):ConfigData;
 	private function get_config():ConfigData
	{
		return _config;
	}
	
	/**
	 * Returns the current compression threshold.
	 *<p>This value represents the maximum message size(in bytes)before the protocol compression is activated. 
	 * It is determined by the server configuration.</p>
	 */
	public var compressionThreshold(get, null):Int;
 	private function get_compressionThreshold():Int
	{
		return _bitSwarm.compressionThreshold;
	}
	
	/**
	 * Returns the maximum size of messages allowed by the server.
	 *<p>Any request exceeding this size will not be sent.
	 * The value is determined by the server configuration.</p>
	 */
	public var maxMessageSize(get, null):Int;
 	private function get_maxMessageSize():Int
	{
		return _bitSwarm.maxMessageSize;
	}
	
	/**
	 * Retrieves a<em>Room</em>object from its id.
	 * 
	 *<p><b>NOTE</b>:the same object is returned by the<em>IRoomManager.getRoomById()</em>method, accessible through the<em>roomManager</em>getter;
	 * this was replicated on the<em>SmartFox</em>class for handy access due to its usually frequent usage.</p>
	 * 
	 * @param	id	The id of the Room.
	 * 
	 * @return	An object representing the requested Room;<code>null</code>if no<em>Room</em>object with the passed id exists in the Rooms list.
	 * 
	 * @example	The following example retrieves a<em>Room</em>object and traces its name:
	 *<listing version="3.0">
	 * 
	 * var roomId:Int=3;
	 * var room:Room=sfs.getRoomById(roomId);
	 * trace("The name of Room", roomId, "is", room.name);
	 *</listing>
	 * 
	 * @see		#getRoomByName()
	 * @see		#roomList
	 * @see		#roomManager
	 */
	public function getRoomById(id:Int):Room
	{
		return roomManager.getRoomById(id);
	}
	
	/**
	 * Retrieves a<em>Room</em>object from its name.
	 * 
	 *<p><b>NOTE</b>:the same object is returned by the<em>IRoomManager.getRoomByName()</em>method, accessible through the<em>roomManager</em>getter;
	 * this was replicated on the<em>SmartFox</em>class for handy access due to its usually frequent usage.</p>
	 * 
	 * @param	name	The name of the Room.
	 * 
	 * @return	An object representing the requested Room;<code>null</code>if no<em>Room</em>object with the passed name exists in the Rooms list.
	 * 
	 * @example	The following example retrieves a<em>Room</em>object and traces its id:
	 *<listing version="3.0">
	 * 
	 * var roomName:String="The Lobby";
	 * var room:Room=sfs.getRoomByName(roomName);
	 * trace("The ID of Room '", roomName, "' is", room.id);
	 *</listing>
	 * 
	 * @see		#getRoomById()
	 * @see		#roomList
	 * @see		#roomManager
	 */
	public function getRoomByName(name:String):Room
	{
		return roomManager.getRoomByName(name);
	}
	
	/**
	 * Retrieves the list of Rooms which are part of the specified Room Group.
	 * 
	 *<p><b>NOTE</b>:the same list is returned by the<em>IRoomManager.getRoomListFromGroup()</em>method, accessible through the<em>roomManager</em>getter;
	 * this was replicated on the<em>SmartFox</em>class for handy access due to its usually frequent usage.</p>
	 * 
	 * @param	groupId	The name of the Group.
	 * 
	 * @return	The list of<em>Room</em>objects belonging to the passed Group.
	 * 
	 * @see		#roomManager
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function getRoomListFromGroup(groupId:String):Array<Room>
	{
		return roomManager.getRoomListFromGroup(groupId);
	}
	
	/**
	 * Simulates an abrupt disconnection from the server.
	 * This method should be used for testing and simulations only, otherwise use the<em>disconnect()</em>method.
	 * 
	 * @see		#disconnect()
	 */
	public function killConnection():Void
	{
		_bitSwarm.killConnection();
	}
	
	/**
	 * Establishes a connection between the client and a SmartFoxServer 2X instance.
	 * If no argument is passed, the client will use the settings loaded via<em>loadConfig()</em>method.
	 * In order to pass full connection settings without loading them from the external configuration file, use the<em>connectWithConfig()</em>method.
	 * 
	 *<p>The client usually connects to a SmartFoxServer instance through a socket connection. In case a socket connection can't be established,
	 * and the<em>useBlueBox</em>property is set to<code>true</code>, a tunnelled http connection through the BlueBox module is attempted.
	 * When a successful connection is established, the<em>connectionMode</em>property can be used to check the current connection mode.</p>
	 * 
	 * @param	host	The address of the server to connect to.
	 * @param	port	The TCP port to connect to.
	 * 
	 * @throws	ArgumentError If an invalid host/address or port is passed, and it can't be found in the loaded settings.
	 * 
	 * @example	The following example connects to a local SmartFoxServer 2X instance:
	 *<listing version="3.0">
	 * 
	 * sfs.connect("127.0.0.1", 9933);
	 *</listing>
	 * 
	 * @see		#loadConfig()
	 * @see		#connectWithConfig()
	 * @see		#useBlueBox
	 * @see		#connectionMode
	 * @see		#disconnect()
	 * @see		#event:connection connection event
	 */

	public function connect(host:String=null, port:Int=-1):Void
	{
		if(isConnected)
		{
			_log.warn("Already connected");
			return;
		}

		// Skip attempt, if already trying to connect
		if(_isConnecting)
		{
			_log.warn("A connection attempt is already in progress");
			return;
		}
		
		// Attempt to use external config(if exist)for missing params
		if(config !=null)
		{
			if(host==null)
				host = config.host;
				
			if(port==-1)
				port = config.port;
		}	
		
		// Apply basic validation
		if(host==null || host.length==0)
			throw new ArgumentError("Invalid connection host/address");
		
		if(port<0 || port>65535)
			throw new ArgumentError("Invalid connection port");

		_bitSwarm.useWebSocket = useWebSocket;

		// All fine and dandy, let's proceed with the connection
		#if html5
			_bitSwarm.useWebSocket = true;
		#end

		_lastIpAddress = host;
		_isConnecting = true;
		_bitSwarm.connect(host, port);	
	}
	
	/**
	 * Establishes a connection between the client and a SmartFoxServer 2X instance.
	 * The connection details(IP, port, etc)are contained in the passed object.
	 * 
	 *<p>This is an alternative version of the<em>connect()</em>method. Read the method description for more informations.</p>
	 * 
	 * @param 	cfg 	The configuration object.
	 * 
	 * @see		#connect()
	 * @see		#disconnect()
	 * @see		#event:connection connection event
	 * @see		com.smartfoxserver.v2.util.ConfigData ConfigData
	 */
	public function connectWithConfig(cfg:ConfigData):Void
	{
		// Validate and store configuration
		validateAndStoreConfig(cfg);
		
		// Connect
		connect();
	}
	
	/**
	 * Closes the connection between the client and the SmartFoxServer 2X instance.
	 * 
	 * @see		#connect()
	 * @see		#event:connectionLost connectionLost event
	 */
	public function disconnect():Void
	{
		if(isConnected)
		{
			// If reconnection is active we need to tell the server that we don't want to reconnect
			if(_bitSwarm.reconnectionSeconds>0)
				send(new ManualDisconnectionRequest());
			
			// Disconnect the socket
			haxe.Timer.delay
			(
				function():Void
				{
					_bitSwarm.disconnect(ClientDisconnectionReason.MANUAL);
				},
				100
			);
		}
		else
			_log.info("You are not connected");
	}
	
	/**
	 * Indicates whether the client-server messages debug is enabled or not.
	 * If set to<code>true</code>, detailed debugging informations for all the incoming and outgoing messages are provided.
	 *<p>Debugging can be enabled when instantiating the<em>SmartFox</em>class too.</p>
	 */
	public var debug(get, set):Bool;
 	private function get_debug():Bool
	{
		return _debug;
	}
	
	/** @private */
	private function set_debug(value:Bool):Bool
	{
		return _debug = value;
	}
	
	/** 
	 * Returns the IP address of the SmartFoxServer 2X instance to which the client is connected.
	 * 
	 * @see		#currentPort
	 * @see		#connect()
	 * @see		#loadConfig()
	 */
	public var currentIp(get, null):String;
 	private function get_currentIp():String
	{
		return _bitSwarm.connectionIp;
	}
	
	/** 
	 * Returns the TCP port of the SmartFoxServer 2X instance to which the client is connected.
	 * 
	 * @see		#currentIp
	 * @see		#connect()
	 * @see		#loadConfig()
	 */
	public var currentPort(get, null):Int;
 	private function get_currentPort():Int
	{
		return _bitSwarm.connectionPort;
	}
	
	/** 
	 * Returns the Zone currently in use, if the user is already logged in.
	 * 
	 * @see		#loadConfig()
	 * @see		com.smartfoxserver.v2.requests.LoginRequest LoginRequest
	 */
	public var currentZone(get, null):String;
 	private function get_currentZone():String
	{
		return _currentZone;
	}
	
	/**
	 * Returns the<em>User</em>object representing the client when connected to a SmartFoxServer 2X instance.
	 * This object is generated upon successful login only, so it is<code>null</code>if login was not performed yet.
	 * 
	 *<p><b>NOTE</b>:setting the<em>mySelf</em>property manually can disrupt the API functioning.</p>
	 * 
	 * @see		com.smartfoxserver.v2.entities.User#isItMe User.isItMe
	 * @see		com.smartfoxserver.v2.requests.LoginRequest LoginRequest
	 */
	public var mySelf(get, set):User;
 	private function get_mySelf():User
	{
		return _mySelf;
	}
	
	/** @private */
	private function set_mySelf(value:User):User
	{
		return _mySelf = value;
	}
	
	/**
	 * Indicates whether the client should attempt a tunnelled http connection through the BlueBox in case a socket connection can't be established.
	 * 
	 *<p><b>NOTE</b>:this property must be set<b>before</b>the<em>connect()</em>method is called.
	 * Also, after a connection is established, this property does not return the current connection mode(socket or http);for this purpose use the<em>connectionMode</em>property.</p>
	 * 
	 * @see #connectionMode connectionMode
	 * @see #loadConfig()
	 */ 
	public var useBlueBox(get, set):Bool;
 	private function get_useBlueBox():Bool
	{
		return _useBlueBox;
	}
	
	/** @private */
	private function set_useBlueBox(value:Bool):Bool
	{
		return _useBlueBox = value;
	}
	
	/**
	 * Returns a reference to the Internal<em>Logger</em>instance used by SmartFoxServer 2X.
	 */
	public var logger(get, null):Logger;
 	private function get_logger():Logger
	{
		return _log;
	}
	
	/**
	 * Returns the object representing the last Room joined by the client, if any.
	 * This property is<code>null</code>if no Room was joined.
	 * 
	 *<p><b>NOTE</b>:setting the<em>lastJoinedRoom</em>property manually can disrupt the API functioning.
	 * Use the<em>JoinRoomRequest</em>request to join a new Room instead.</p>
	 * 
	 * @see		#joinedRooms()
	 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
	 */
	public var lastJoinedRoom(get, set):Room;
 	private function get_lastJoinedRoom():Room
	{
		return _lastJoinedRoom;
	}
	
	/** @private */
	private function set_lastJoinedRoom(value:Room):Room
	{
		return _lastJoinedRoom = value;	
	}
	
	/**
	 * Returns a list of<em>Room</em>objects representing the Rooms currently joined by the client.
	 * 
	 *<p><b>NOTE</b>:the same list is returned by the<em>IRoomManager.getJoinedRooms()</em>method, accessible through the<em>roomManager</em>getter;
	 * this was replicated on the<em>SmartFox</em>class for handy access due to its usually frequent usage.</p>
	 * 
	 * @see		#lastJoinedRoom()
	 * @see		#roomManager
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
	 */
	public var joinedRooms(get, null):Array<Room>;
 	private function get_joinedRooms():Array<Room>
	{
		return roomManager.getJoinedRooms();
	}
	
	/**
	 * Returns a list of<em>Room</em>objects representing the Rooms currently "watched" by the client.
	 * The list contains all the Rooms that are currently joined and all the Rooms belonging to the Room Groups that have been subscribed.
	 * 
	 *<p><b>NOTE 1</b>:at login time, the client automatically subscribes all the Room Groups specified in the Zone's<b>Default Room Groups</b>setting.</p>
	 * 
	 *<p><b>NOTE 2</b>:the same list is returned by the<em>IRoomManager.getRoomList()</em>method, accessible through the<em>roomManager</em>getter;
	 * this was replicated on the<em>SmartFox</em>class for handy access due to its usually frequent usage.</p>
	 * 
	 * @see		#roomManager
	 * @see 	com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
	 * @see 	com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest SubscribeRoomGroupRequest
	 * @see 	com.smartfoxserver.v2.requests.UnsubscribeRoomGroupRequest UnsubscribeRoomGroupRequest
	 */
	public var roomList(get, null):Array<Room>;
 	private function get_roomList():Array<Room>
	{
		return _roomManager.getRoomList();
	}
	
	/**
	 * Returns a reference to the Room Manager.
	 * This manager is used Internally by the SmartFoxServer 2X API;the reference returned by this property
	 * gives access to the Rooms list and Groups, allowing Interaction with<em>Room</em>objects.
	 */
	public var roomManager(get, null):IRoomManager;
 	private function get_roomManager():IRoomManager
	{
		return _roomManager;
	}
	
	/**
	 * Returns a reference to the User Manager.
	 * This manager is used Internally by the SmartFoxServer 2X API;the reference returned by this property
	 * gives access to the users list, allowing Interaction with<em>User</em>objects.
	 */
	public var userManager(get, set):IUserManager;
 	private function get_userManager():IUserManager
	{
		return _userManager;
	}
	
	private function set_userManager(value:IUserManager):IUserManager
	{
		return _userManager = value;
	}
	
	/**
	 * Returns a reference to the Buddy Manager.
	 * This manager is used Internally by the SmartFoxServer 2X API;the reference returned by this property
	 * gives access to the buddies list, allowing Interaction with<em>Buddy</em>and<em>BuddyVariable</em>objects and access to user properties in the<b>Buddy List</b>system.
	 */
	public var buddyManager(get, set):IBuddyManager;
 	private function get_buddyManager():IBuddyManager
	{
		return _buddyManager;
	}
	private function set_buddyManager(value:IBuddyManager):IBuddyManager
	{
		return _buddyManager = value;
	}
	
	/**
	 * Indicates whether the UPD protocol is available or not in the current runtime.
	 * UPD is available in a ActionScript 3 client if it is executed in the Adobe AIR 2.0(or higher)runtime only.
	 * 
	 *<p>Using the UDP protocol in an application requires that a handshake is performed between the client and the server. 
	 * By default this is NOT done by the SmartFoxServer 2X API, to avoid allocating resources that might never be used.
	 * In order to activate the UDP support, the<em>initUDP()</em>method must be invoked explicitly.</p>
	 * 
	 * @see		#initUDP()
	 */
	public var udpAvailable(get, null):Bool;
 	private function get_udpAvailable():Bool
	{
		return isAirRuntime();
	}
	
	/**
	 * Indicates whether the UDP handshake has been performed successfully or not.
	 * 
	 * @see		#udpAvailable
	 * @see		#initUDP()
	 */
	public var udpInited(get, null):Bool;
 	private function get_udpInited():Bool
	{
		return _bitSwarm.udpManager.inited;
	}
	
	
	
	/**
	 * Initializes the UDP protocol by performing an handshake with the server.
	 * In ActionScript 3, the UDP protocol is available exclusively if the client is executed in the Adobe AIR 2.0(or higher)runtime.
	 * In order to properly activate the UDP support for the AIR runtime, an instance of the<em>AirUDPManager</em>class contained in the SmartFoxServer 2X ActionScript 3 API must be provided.
	 * Also, if<em>udpHost</em>or<em>udpPort</em>arguments are not passed, the client will use the settings loaded via<em>loadConfig()</em>method.
	 * 
	 *<p>This method needs to be called only once. It can be executed at any moment provided that a connection to the server has already been established.
	 * After a successful initialization, UDP requests can be sent to the server-side Extension at any moment.</p>
	 * 
	 *<p><b>MTU note</b></p>
	 * 
	 *<p>The<em>Maximum Transmission Unit</em>(MTU), represents the largest amount of bytes that can be sent at once before packet fragmentation occurs.
	 * Since the UDP protocol uses a "nothing-or-all" approach to the transmission, it is important to keep in mind that, on average,
	 * a message size of 1100-1200 bytes is probably the maximum you can reach. If you exceed the MTU size the data will be "lost in hyperspace"(the Internet).</p>
	 * 
	 *<p>Another Interesting matter is that there is no fixed size for the MTU, because each operating system uses a slightly different value. 
	 * Because of this we suggest a conservative data size of 1000-1200 bytes per packet, to avoid packet loss.
	 * The SFS2X protocol compression allows to send 2-3KBytes of uncompressed data, which usually is squeezed down to a size of ~1000 bytes.
	 * If you have a larger amount of data to send, we suggest you to organize it in smaller chunks so that they don't exceed the suggested MTU size.</p>
	 * 
	 *<p>More details about the MTU can be found at the page linked below.</p>
	 * 
	 * @param	manager		An instance of the<em>AirUDPManager</em>class.
	 * @param	udpHost		The IP address of the server to connect to.
	 * @param	udpPort:	The UDP port to connect to.
	 * 
	 * @throws	ArgumentError If an invalid address or port is passed, and it can't be found in the loaded settings.
	 * 
	 * @example	The following example initializes the UDP communication, sends a request to an Extension and handles the related events:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.UDP_INIT, onUDPInit);
	 * 	sfs.initUDP(new AirUDPManager());
	 * }
	 * 
	 * private function onUDPInit(evt:SFSEvent):Void
	 * {
	 * 	if(evt.params.success)
	 * 	{
	 * 		// Connection successful:execute an Extension call via UDP
	 * 		sfs.send(new ExtensionRequest("udpTest", new SFSObject(), null, true));
	 * 	}
	 * 	else
	 * 	{
	 * 		trace("UDP initialization failed!");
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @see		#udpAvailable
	 * @see 	#event:udpInit udpInit event
	 * @see		com.smartfoxserver.v2.bitswarm.AirUDPManager AirUDPManager
	 * @see		#loadConfig()
	 * @see		http://en.wikipedia.org/wiki/Maximum_transmission_unit
	 */
	public function initUDP(manager:IUDPManager, udpHost:String=null, udpPort:Int=-1):Void
	{
		// Check the we are running under the AIR runtime
		if(isAirRuntime())
		{
			if(!isConnected)
			{
				_log.warn("Cannot initialize UDP protocol until the client is connected to SFS2X.");
				return;
			}
			
			// Attempt to use external config(if exist)for missing params
			if(config !=null)
			{
				if(udpHost==null)
					udpHost = config.udpHost;
				
				if(udpPort==-1)
					udpPort = config.udpPort;
			}	
			
			// Apply basic validation
			if(udpHost==null || udpHost.length==0)
				throw new ArgumentError("Invalid UDP host/address");
			
			if(udpPort<0 || udpPort>65535)
				throw new ArgumentError("Invalid UDP port range");
			
			/*
			* If it's already inited with success we don't allow re-assigning a new UDP manager
			* Also we make sure that we overwrite the class only if it's the default type(==DefaultUDPManager)
			*/
			if(!_bitSwarm.udpManager.inited && Std.isOfType(_bitSwarm.udpManager,DefaultUDPManager))
			{
				manager.sfs = this;
				_bitSwarm.udpManager = manager;
			}
			
			// Attempt initialization
			_bitSwarm.udpManager.initialize(udpHost, udpPort);
		}
		
		else
			_log.warn("UDP Failure:the protocol is available only for the AIR 2.0 runtime.");
	}
	
	// Checks if application is running as a standalone Adobe Air application
	private function isAirRuntime():Bool
	{
		return Capabilities.playerType.toLowerCase() == "desktop";
	}
	
	/**
	 * Initialized the connection cryptography. Once this process is successfully completed all of the server's data
	 * will be encrypted using standard AES 128-bit algorithm, using a secure key served over HTTPS.
	 * 
	 * @example This call must be executed right after a successful connection, like in this example:
	 * 
	 * <listing version="3.0">
	 * var sfs:SmartFox = new SmartFox();
	 * sfs.addEventListener(SFSEvent.CONNECTION, onConnect);
	 * sfs.addEventListener(SFSEvent.CRYPTO_INIT, onCryptInit);
	 * 
	 * sfs.connect("mysecuredomain.com", 9933);
	 * 
	 * function onConnect(evt:SFSEvent):void
	 * {
	 * 	if (evt.param.success)
	 * 		sfs.initCrypto();
	 * 		
	 * 	else
	 * 		trace("Sorry, connection failed");
	 * }
	 * 
	 * function onCryptInit(evt:SFSEvent):void
	 * {
	 * 	ta_data.text = evt.params.success;
	 * 	
	 * 	if (evt.params.success)
	 * 		sfs.send(new LoginRequest("MyName", "MyPassword", "MyZone"));
	 * 
	 * 	else
	 * 		trace("Crypto init failed. Caused by: " + evt.params.errorMsg)
	 * }
	 * </listing>
	 * 
	 * @see #event:cryptoInit cryptoInit event
	 */
	public function initCrypto():Void
	{
		new CryptoInitializer(this);			
	}
	
	/** @private */
	public var isJoining(get, set):Bool;
 	private function get_isJoining():Bool
	{
		return _isJoining;
	}
	
	/** @private */
	private function set_isJoining(value:Bool):Bool
	{
		return _isJoining = value;
	}
	
	/**
	 * Returns the unique session token of the client.
	 * The session token is a string sent by the server to the client after the initial handshake.
	 * It is required as mean of identification when uploading files to the server.
	 * 
	 * @see		#httpUploadURI
	 */
	public var sessionToken(get, null):String;
 	private function get_sessionToken():String
	{
		return _sessionToken;
	}
	
	// No public docs for this, we use it Internally for starting a reconnection
	/** @private */
	public function getReconnectionSeconds():Int
	{
		return _bitSwarm.reconnectionSeconds;
	}
	
	// No public docs for this, we use it Internally for starting a reconnection
	/** @private */
	public function setReconnectionSeconds(seconds:Int):Void
	{
		_bitSwarm.reconnectionSeconds = seconds;	
	}
	
	/**
	 * Sends a request to the server.  
	 * All the available request objects can be found in the<em>requests</em>package. 
	 * 
	 * @param	request	A request object.
	 * 
	 * @example	The following example sends a login request:
	 *<listing version="3.0">
	 * 
	 * sfs.send(new LoginRequest("KermitTheFrog", "KermitPass", "TheMuppetZone"));
	 *</listing>
	 * 
	 * @example	The following example sends a "join room" request:
	 *<listing version="3.0">
	 * 
	 * sfs.send(new JoinRoomRequest("Lobby"));
	 *</listing>
	 * 
	 * @example	The following example creates an object containing some parameters and sends it to the server-side Extension:
	 *<listing version="3.0">
	 * 
	 * var params:ISFSObject=new SFSObject();
	 * params.putInt("x", 10);
	 * params.putInt("y", 37);
	 * 
	 * sfs.send(new ExtensionRequest("setPosition", params));
	 *</listing>
	 * 
	 * @see		com.smartfoxserver.v2.requests
	 * @see		com.smartfoxserver.v2.requests.buddylist
	 * @see		com.smartfoxserver.v2.requests.game
	 */
	public function send(request:IRequest):Void
	{
		// Handshake is an exception, during a reconnection attempt
		if(!isConnected)
		{
			_log.warn("You are not connected. Request cannot be sent:" + request.getMessage());
			return;
		}
		
		try
		{
			// Activate joining flag
			if(Std.isOfType(request, JoinRoomRequest))
			{
				if(_isJoining)
					return;
				
				else
					_isJoining = true	;
			}
			
			// Validate Request parameters
			request.validate(this);
			
			// Execute Request logic
			request.execute(this);
			
			// Send request to SmartFoxServer2X
			_bitSwarm.send(request.getMessage());
		}
		
		catch(problem:SFSValidationError)
		{
			var errMsg:String = problem.message;
			
			for(errorItem in problem.errors)
			{
				errMsg += "\t" + errorItem + "\n";
			}
			
			_log.warn(errMsg);
		}
		
		catch(error:SFSCodecError)
		{
			_log.warn(error.message);
		}
	}
	
	/**
	 * Loads the client configuration file.
	 * 
	 *<p>The<em>SmartFox</em>instance can be configured through an external XML configuration file loaded at run-time.
	 * By default, the<em>loadConfig()</em>method loads a file named "sfs-config.xml", placed in the same folder of the application swf file.
	 * If the<em>connectOnSuccess</em>argument is set to<code>true</code>, on loading completion the<em>connect()</em>method is automatically called by the API,
	 * otherwise the<em>SFSEvent.CONFIG_LOAD_SUCCESS</em>event type is dispatched. In case of loading error, the<em>SFSEvent.CONFIG_LOAD_FAILURE</em>event type id fired.</p>
	 * 
	 *<p>In order to pass full connection settings without loading them from the external configuration file, use the<em>connectWithConfig()</em>method.</p>
	 * 
	 *<p>The external XML configuration file has the following structure;ip, port and zone parameters are mandatory, all other parameters are optional:</p>
	 *<listing>
	 * 
	 * &lt;!-- SFS2X Client Configuration file --&gt;
	 * &lt;SmartFoxConfig&gt;
	 * 	&lt;ip&gt;127.0.0.1&lt;/ip&gt;
	 * 	&lt;port&gt;9933&lt;/port&gt;
	 * 	&lt;zone&gt;SimpleChat&lt;/zone&gt;
	 * 	
	 * 	&lt;debug&gt;true&lt;/debug&gt;
	 * 	
	 * 	&lt;udpIp&gt;127.0.0.1&lt;/udpIp&gt;
	 * 	&lt;udpPort&gt;9934&lt;/udpPort&gt;
	 * 	
	 * 	&lt;httpPort&gt;8080&lt;/httpPort&gt;
	 * 	&lt;useBlueBox&gt;true&lt;/useBlueBox&gt;
	 * 	&lt;blueBoxPollingRate&gt;500&lt;/blueBoxPollingRate&gt;
	 * &lt;/SmartFoxConfig&gt;
	 *</listing>
	 * 
	 * @param	filePath			Filename of the external XML configuration, including its path relative to the folder of the application swf file.
	 * @param	connectOnSuccess	A flag indicating if the connection to SmartFoxServer must be attempted upon configuration loading completion.
	 * 
	 * @example	The following example loads an external configuration file and, on loading completion, connects to the server:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	var sfs:SmartFox=new SmartFox();
	 * 	
	 * 	sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoaded);
	 * 	sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailed);
	 * 	
	 * 	sfs.loadConfig("testConfig.xml", false);
	 * }
	 * 
	 * private function onConfigLoaded(evt:SFSEvent):Void
	 * {
	 * 	// Configuration loaded successfully, now connect
	 * 	sfs.connect();
	 * }
	 * 
	 * private function onConfigLoadFailed(evt:SFSEvent):Void
	 * {
	 * 	trace("Failed loading configuration file");
	 * }
	 *</listing>
	 * 
	 * @see 	#connect()
	 * @see		#connectWithConfig()
	 * @see 	#event:configLoadSuccess configLoadSuccess event
	 * @see 	#event:configLoadFailure configLoadFailure event
	 */
	public function loadConfig(filePath:String="sfs-config.xml", connectOnSuccess:Bool=true):Void
	{
		var configLoader:ConfigLoader = new ConfigLoader();
		configLoader.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess);
		configLoader.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure);
		
		_autoConnectOnConfig = connectOnSuccess;
		configLoader.loadConfig(filePath);
	}
	
	/** @private */
	public function addJoinedRoom(room:Room):Void
	{
		if(!roomManager.containsRoom(room.id))
		{
			roomManager.addRoom(room);
			_lastJoinedRoom = room;
		}
		
		// TODO:this is just for debugging
		else
			throw new SFSError("Unexpected:joined room already exists for this User:" + mySelf.name + ", Room:" + room);
	}

	/** @private */
	public function removeJoinedRoom(room:Room):Void
	{
		roomManager.removeRoom(room);
		
		// remove room id
		// delete _playerIdByRoomId[room.id]
		
		// point to the previous room, if any
		if(joinedRooms.length>0)
			_lastJoinedRoom = joinedRooms[joinedRooms.length - 1];
		
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Event handlers
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function onSocketConnect(evt:BitSwarmEvent):Void
	{
		if(evt.params.success)
		{
			sendHandshakeRequest(evt.params._isReconnection);
		}
		
		else
		{
			_log.warn("Connection attempt failed");
			handleConnectionProblem(evt);
		}
	}
	
	private function onSocketClose(evt:BitSwarmEvent):Void
	{
		reset();
		dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_LOST, { reason:evt.params.reason } ));
	}
	
	private function onSocketReconnectionTry(evt:BitSwarmEvent):Void
	{
		dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RETRY, { } ));
	}
	
	private function onSocketDataError(evt:BitSwarmEvent):Void
	{
		dispatchEvent(new SFSEvent(SFSEvent.SOCKET_ERROR, { errorMessage:evt.params.message, details:evt.params.details } ));
	}
	
	private function onSocketIOError(evt:BitSwarmEvent):Void
	{
		if(_isConnecting)
			handleConnectionProblem(evt);
	}
	
	private function onSocketSecurityError(evt:BitSwarmEvent):Void
	{
		if(_isConnecting)
			handleConnectionProblem(evt);
	}
	
	private function onConfigLoadSuccess(evt:SFSEvent):Void
	{
		var cfgLoader:ConfigLoader = cast evt.target;
		var cfgData:ConfigData = cast evt.params.cfg;
		
		// Remove listeners
		cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess);
		cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure);
		
		// Validate and store configuration
		validateAndStoreConfig(cfgData);
		
		// Fire event
		var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS, { config:cfgData } );
		dispatchEvent(sfsEvt);
		
		// AutoConnect?
		if(_autoConnectOnConfig)
		{
			connect(_config.host, _config.port);
		}
	}
	
	private function onConfigLoadFailure(evt:SFSEvent):Void
	{
		var cfgLoader:ConfigLoader = cast evt.target;
		
		// remove listeners
		cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess);
		cfgLoader.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure);
		
		// Fire event;
		var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE, { } );
		dispatchEvent(sfsEvt);
	}
	
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Public handlers methods(used by SystemController)
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function handleHandShake(evt:SFSEvent):Void
	{
		var msg:IMessage = evt.params.message;
		var obj:ISFSObject = msg.content;
		
		// Success
		if(obj.isNull(BaseRequest.KEY_ERROR_CODE))
		{
			_sessionToken = obj.getUtfString(HandshakeRequest.KEY_SESSION_TOKEN);
			_bitSwarm.compressionThreshold = obj.getInt(HandshakeRequest.KEY_COMPRESSION_THRESHOLD);
			_bitSwarm.maxMessageSize = obj.getInt(HandshakeRequest.KEY_MAX_MESSAGE_SIZE);

			if(_bitSwarm.isReconnecting)
			{
				_bitSwarm.isReconnecting = false;
				
				/*
				* Reconnection success
				* We can safely assume that reconnection was performed correctly at this point
				* In case of failure the server will disconnect the temp socket.
				*/
				
				dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RESUME, { } ));
			}
			else
			{
				/*
				* Regular connection success
				*/
				_isConnecting = false; // reset flag
				dispatchEvent(new SFSEvent(SFSEvent.CONNECTION, { success:true } ));
			}
		}
		
		// Failure(via socket)
		else
		{
			var errorCd:Int = obj.getShort(BaseRequest.KEY_ERROR_CODE);
			var errorMsg:String = SFSErrorCodes.getErrorMessage(errorCd, obj.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
			var params:Dynamic = { success:false, errorMessage:errorMsg, errorCode:errorCd };
			
			dispatchEvent(new SFSEvent(SFSEvent.CONNECTION, params));
		}			
	}
	
	private function handleLogin(evt:SFSEvent):Void
	{
		_currentZone = evt.params.zone;
	}
	
	/** @private */
	public function handleClientDisconnection(reason:String):Void
	{
		// no reconnections
		_bitSwarm.reconnectionSeconds = 0;
		_bitSwarm.disconnect(reason);
		
		reset();
	}
	
	/** @private */
	public function handleLogout():Void
	{
		// TODO:Hide with custom namespace?
		if(_lagMonitor !=null && _lagMonitor.isRunning)
			_lagMonitor.stop();
				
		_userManager = new SFSGlobalUserManager(this);
		_roomManager = new SFSRoomManager(this);
		_isJoining = false;
		_lastJoinedRoom = null;
		_currentZone = null;
		_mySelf = null;
			
		// Clear Buddy Manager
		buddyManager.clearAll();
		buddyManager.setInited(false);
	}
	
	/** @private */
	public function handleReconnectionFailure():Void
	{
		// Reset reconnection seconds, this way no more reconnections will be available in this session.
		setReconnectionSeconds(0);
		
		// Stop running reconnection
		_bitSwarm.stopReconnection();
	}
		
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Private methods
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function handleConnectionProblem(evt:BitSwarmEvent):Void
	{
		// Socket failed, attempt using the BBox
		if(_bitSwarm.connectionMode==ConnectionMode.SOCKET && _useBlueBox)
		{
			_bitSwarm.forceBlueBox(true);
			var bbPort:Int = config != null ? config.httpPort:DEFAULT_HTTP_PORT;
				
			_bitSwarm.connect(_lastIpAddress, bbPort);
				
			dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_ATTEMPT_HTTP, { } ));
		}
		
		// Connection failed
		else
		{
			var params:Dynamic = { success:false, errorMessage:evt.params.message };
			dispatchEvent(new SFSEvent(SFSEvent.CONNECTION, params));
			_isConnecting = _isConnected = false;
		}
		
	}
	
	private function sendHandshakeRequest(isReconnection:Bool=false):Void
	{
		var req:IRequest = new HandshakeRequest(this.version, _clientDetails, isReconnection ? _sessionToken:null);
		send(req);
	}
	
	private function validateAndStoreConfig(cfgData:ConfigData):Void
	{
		// Validate mandatory params
		if(cfgData.host==null || cfgData.host.length==0)
			throw new ArgumentError("Invalid Host/IpAddress in external config file");
		
		if(cfgData.port<0 || cfgData.port>65535)
			throw new ArgumentError("Invalid TCP port in external config file");
		
		if(cfgData.zone==null || cfgData.zone.length==0)
			throw new ArgumentError("Invalid Zone name in external config file");
		
		// Activate debug
		_debug = cfgData.debug;
		
		// Enable BlueBox
		_useBlueBox = cfgData.useBlueBox;

		//Enable WebSocket
		useWebSocket = cfgData.useWebSocket;
		
		// Store globally
		_config = cfgData;
	}
}