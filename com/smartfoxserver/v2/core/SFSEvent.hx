package com.smartfoxserver.v2.core;

import com.smartfoxserver.v2.events.Event;

/**
 *<em>SFSEvent</em>is the class representing most of the events dispatched by the SmartFoxServer 2X ActionScript 3 API.
 * 
 *<p>The<em>SFSEvent</em>parent class provides a public property called<em>params</em>which contains specific parameters depending on the event type.</p>
 * 
 * @example	The following example shows a generic usage of a<em>SFSEvent</em>;please refer to the specific event types for the<em>params</em>object content:
 *<listing version="3.0">
 * 
 * package sfsTest
 * {
 * 	import com.smartfoxserver.v2.SmartFox;
 * 	import com.smartfoxserver.v2.core.SFSEvent;
 * 	
 * 	class MyTest
 * 	{
 * 		private var sfs:SmartFox;
 * 		
 * 		public function new()
 * 		{
 * 			// Create a SmartFox instance
 * 			sfs=new SmartFox();
 * 			
 * 			// Add event handler for connection 
 * 			sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
 * 			
 * 			// Connect to server
 * 			sfs.connect("127.0.0.1", 9933);	
 * 		}
 * 		
 * 		// Handle connection event
 * 		private function onConnection(evt:SFSEvent):Void
 * 		{
 * 			// Retrieve event parameters
 * 			var params:Dynamic=evt.params;
 * 			
 * 			if(params.success)
 * 				trace("Connection established");
 * 			else
 * 				trace("Connection failed");
 * 		}	
 * 	}
 * }
 *</listing>
 * 
 * @see 	SFSBuddyEvent
 */
class SFSEvent extends BaseEvent
{
	/** @private */
	public static inline var HANDSHAKE:String = "handshake";
	
	/**
	 * The<em>SFSEvent.UDP_INIT</em>constant defines the value of the<em>type</em>property of the event object for a<em>udpInit</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>success</td><td><em>Boolean</em></td><td>The connection result:<code>true</code>if a connection was established,<code>false</code>otherwise.</td></tr>
	 *</table>
	 * 
	 * @example	The following example initializes the UDP communication and sends a custom UDP request to an Extension:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.UDP_INIT, onUDPInit);
	 * 	
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
	 * @eventType	udpInit
	 */
	public static inline var UDP_INIT:String = "udpInit";
	
	/**
	 * The<em>SFSEvent.CONNECTION</em>constant defines the value of the<em>type</em>property of the event object for a<em>connection</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>success</td><td><em>Boolean</em></td><td>The connection result:<code>true</code>if a connection was established,<code>false</code>otherwise.</td></tr>
	 *</table>
	 * 
	 * @example	The following example starts a connection:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	var sfs:SmartFox=new SmartFox();
	 * 	sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
	 * 	
	 * 	sfs.connect();
	 * }
	 * 
	 * private function onConnection(evt:SFSEvent):Void
	 * {
	 * 	if(evt.params.success)
	 * 		trace("Connection established");
	 * 	else
	 * 		trace("Connection failed");
	 * }
	 *</listing>
	 * 
	 * @eventType	connection
	 * 
	 * @see		#CONNECTION_RETRY
	 * @see		#CONNECTION_RESUME
	 * @see		#CONNECTION_LOST
	 */
	public static inline var CONNECTION:String = "connection";
	
	/**
	 * The<em>SFSEvent.PING_PONG</em>constant defines the value of the<em>type</em>property of the event object for a<em>pingPong</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>lagValue</td><td><em>int</em></td><td>The average of the last ten measured lag values, expressed in milliseconds.</td></tr>
	 *</table>
	 */
	public static inline var PING_PONG:String = "pingPong";
		
	/**
	 * The<em>SFSEvent.SOCKET_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>socketError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>The description of the error.</td></tr>
	 *</table>
	 */
	public static inline var SOCKET_ERROR:String = "socketError";
		
	/**
	 * The<em>SFSEvent.CONNECTION_LOST</em>constant defines the value of the<em>type</em>property of the event object for a<em>connectionLost</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>reason</td><td><em>String</em></td><td>The reason of the disconnection, among those available in the<em>ClientDisconnectionReason</em>class.</td></tr>
	 *</table>
	 * 
	 * @example	The following example handles a disconnection event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
	 * }
	 * 
	 * private function onConnectionLost(evt:SFSEvent):Void
	 * {
	 * 	var reason:String=evt.params.reason;
	 * 	
	 * 	if(reason !=ClientDisconnectionReason.MANUAL)
	 * 	{
	 * 		if(reason==ClientDisconnectionReason.IDLE)
	 * 			trace("A disconnection occurred due to inactivity");
	 * 		else if(reason==ClientDisconnectionReason.KICK)
	 * 			trace("You have been kicked by the moderator");
	 * 		else if(reason==ClientDisconnectionReason.BAN)
	 * 			trace("You have been banned by the moderator");
	 * 		else
	 * 			trace("A disconnection occurred due to unknown reason;please check the server log");
	 * 	}
	 * 	else
	 * 	{
	 * 		// Manual disconnection is usually ignored
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @eventType	connectionLost
	 * 
	 * @see		com.smartfoxserver.v2.util.ClientDisconnectionReason
	 * @see		#CONNECTION
	 * @see		#CONNECTION_RETRY
	 */
	public static inline var CONNECTION_LOST:String = "connectionLost";
	
	/**
	 * The<em>SFSEvent.CONNECTION_RETRY</em>constant defines the value of the<em>type</em>property of the event object for a<em>connectionRetry</em>event.
	 * 
	 *<p>No parameters are available for this event object.</p>
	 * 
	 * @example	The following example handles a temporary disconnection event and the following connection resuming:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.CONNECTION_RETRY, onConnectionRetry);
	 * 	sfs.addEventListener(SFSEvent.CONNECTION_RESUME, onConnectionResumed);
	 * 	sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
	 * }
	 * 
	 * private function onConnectionRetry(evt:SFSEvent):Void
	 * {
	 * 	// Freeze the GUI and provide some feedback to the player
	 * 	...
	 * }
	 * 
	 * private function onConnectionResumed(evt:SFSEvent):Void
	 * {
	 * 	// Unfreeze the GUI and let the player continue with the game
	 * 	...
	 * }
	 * 
	 * private function onConnectionLost(evt:SFSEvent):Void
	 * {
	 * 	trace("Ouch, connection was lost. Reason:" + evt.params.reason);
	 * }
	 *</listing>
	 * 
	 * @eventType	connectionRetry
	 * 
	 * @see		#CONNECTION_RESUME
	 * @see		#CONNECTION_LOST
	 */
	public static inline var CONNECTION_RETRY:String = "connectionRetry";
	
	/**
	 * The<em>SFSEvent.CONNECTION_RESUME</em>constant defines the value of the<em>type</em>property of the event object for a<em>connectionResume</em>event.
	 * 
	 *<p>No parameters are available for this event object.</p>
	 * 
	 * @example	See the example provided in the<em>CONNECTION_RETRY</em>constant description.
	 * 
	 * @eventType	connectionResume
	 * 
	 * @see		#CONNECTION_RETRY
	 * @see		#CONNECTION_LOST
	 */
	public static inline var CONNECTION_RESUME:String = "connectionResume";
		
	/**
	 * The<em>SFSEvent.CONNECTION_ATTEMPT_HTTP</em>constant defines the value of the<em>type</em>property of the event object for a<em>connectionAttemptHttp</em>event.
	 * 
	 *<p>No parameters are available for this event object.</p>
	 * 
	 * @example	See the example provided in the<em>CONNECTION_ATTEMPT_HTTP</em>constant description.
	 * 
	 * @eventType	connectionAttemptHttp
	 * 
	 * @see		#CONNECTION
	 * @see		#CONNECTION_LOST
	 */	
	public static inline var CONNECTION_ATTEMPT_HTTP:String = "connectionAttemptHttp";
	
	/**
	 * The<em>SFSEvent.CONFIG_LOAD_SUCCESS</em>constant defines the value of the<em>type</em>property of the event object for a<em>configLoadSuccess</em>event.
	 * 
	 *<p>No parameters are available for this event object.</p>
	 * 
	 * @example	The following example loads an external configuration file:
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
	 * @eventType	configLoadSuccess
	 * 
	 * @see		#CONFIG_LOAD_FAILURE
	 */
	public static inline var CONFIG_LOAD_SUCCESS:String = "configLoadSuccess";
	
	/**
	 * The<em>SFSEvent.CONFIG_LOAD_FAILURE</em>constant defines the value of the<em>type</em>property of the event object for a<em>configLoadFailure</em>event.
	 * 
	 *<p>No parameters are available for this event object.</p>
	 * 
	 * @example	See the example provided in the<em>CONFIG_LOAD_SUCCESS</em>constant description.
	 * 
	 * @eventType	configLoadFailure
	 * 
	 * @see		#CONFIG_LOAD_SUCCESS
	 */
	public static inline var CONFIG_LOAD_FAILURE:String = "configLoadFailure";
	
	/**
	 * The<em>SFSEvent.LOGIN</em>constant defines the value of the<em>type</em>property of the event object for a<em>login</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>user</td><td><em>User</em></td><td>An object representing the user who performed the login.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An object containing custom parameters returned by a custom login system, if any.</td></tr>
	 *</table>
	 * 
	 * @example	The following example performs a login in the "SimpleChat" Zone:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.LOGIN, onLogin);
	 * 	sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
	 * 	
	 * 	// Login
	 * 	sfs.send(new LoginRequest("FozzieTheBear", "", "SimpleChat"));
	 * }
	 * 
	 * private function onLogin(evt:SFSEvent):Void
	 * {
	 * 	trace("Login successful!");
	 * }
	 * 
	 * private function onLoginError(evt:SFSEvent):Void
	 * {
	 * 	trace("Login failure:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	login
	 * 
	 * @see		#LOGIN_ERROR
	 * @see		#LOGOUT
	 */
	public static inline var LOGIN:String = "login";
	
	/**
	 * The<em>SFSEvent.LOGIN_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>loginError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>LOGIN</em>constant description.
	 * 
	 * @eventType	loginError
	 * 
	 * @see		#LOGIN
	 */
	public static inline var LOGIN_ERROR:String = "loginError";
	
	/**
	 * The<em>SFSEvent.LOGOUT</em>constant defines the value of the<em>type</em>property of the event object for a<em>logout</em>event.
	 * 
	 *<p>No parameters are available for this event object.</p>
	 * 
	 * @example	The following example performs a logout from the current Zone:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.LOGOUT, onLogout);
	 * 	
	 * 	// Logout
	 * 	sfs.send(new LogoutRequest());
	 * }
	 * 
	 * private function onLogout(evt:SFSEvent):Void
	 * {
	 * 	trace("Logout executed!");
	 * }
	 *</listing>
	 * 
	 * @eventType	logout
	 * 
	 * @see		#LOGIN
	 */
	public static inline var LOGOUT:String = "logout";
	
	/**
	 * The<em>SFSEvent.ROOM_ADD</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomAdd</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room that was created.</td></tr>
	 *</table>
	 * 
	 * @example	The following example creates a new chat Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomCreated);
	 * 	sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomCreationError);
	 * 	
	 * 	// Define the settings of a new chat Room
	 * 	var settings:RoomSettings=new RoomSettings("My Chat Room");
	 * 	settings.maxUsers=40;
	 * 	settings.groupId="chats";
	 * 	
	 * 	// Create the Room
	 * 	sfs.send(new CreateRoomRequest(settings));
	 * }
	 * 
	 * private function onRoomCreated(evt:SFSEvent):Void
	 * {
	 * 	trace("Room created:" + evt.params.room);
	 * }
	 * 
	 * private function onRoomCreationError(evt:SFSEvent):Void
	 * {
	 * 	trace("Room creation failure:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomAdd
	 * 
	 * @see		#ROOM_REMOVE
	 * @see		#ROOM_CREATION_ERROR
	 */
	public static inline var ROOM_ADD:String = "roomAdd";
	
	/**
	 * The<em>SFSEvent.ROOM_REMOVE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomRemove</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room that was removed.</td></tr>
	 *</table>
	 * 
	 * @example	The following example shows how to handle this event type:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_REMOVE, onRoomRemoved);
	 * }
	 * 
	 * private function onRoomRemoved(evt:SFSEvent):Void
	 * {
	 * 	trace("The following Room was removed:" + evt.params.room);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomRemove
	 * 
	 * @see		#ROOM_ADD
	 */
	public static inline var ROOM_REMOVE:String = "roomRemove";
	
	/**
	 * The<em>SFSEvent.ROOM_CREATION_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomCreationError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_ADD</em>constant description.
	 * 
	 * @eventType	roomCreationError
	 * 
	 * @see		#ROOM_ADD
	 */
	public static inline var ROOM_CREATION_ERROR:String = "roomCreationError";
	
	//public static var ROOM_LIST_UPDATE:String="roomListUpdate"
	
	/**
	 * The<em>SFSEvent.ROOM_JOIN</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomJoin</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room that was joined.</td></tr>
	 *</table>
	 * 
	 * @example	The following example makes the user join an existing Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoined);
	 * 	sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);
	 * 	
	 * 	// Join a Room called "Lobby"
	 * 	sfs.send(new JoinRoomRequest("Lobby"));
	 * }
	 * 
	 * private function onRoomJoined(evt:SFSEvent):Void
	 * {
	 * 	trace("Room joined successfully:" + evt.params.room);
	 * }
	 * 
	 * private function onRoomJoinError(evt:SFSEvent):Void
	 * {
	 * 	trace("Room joining failed:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomJoin
	 * 
	 * @see		#ROOM_JOIN_ERROR
	 */
	public static inline var ROOM_JOIN:String = "roomJoin";
	
	/**
	 * The<em>SFSEvent.ROOM_JOIN_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomJoinError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_JOIN</em>constant description.
	 * 
	 * @eventType	roomJoinError
	 * 
	 * @see		#ROOM_JOIN
	 */
	public static inline var ROOM_JOIN_ERROR:String = "roomJoinError";
	
	/**
	 * The<em>SFSEvent.USER_ENTER_ROOM</em>constant defines the value of the<em>type</em>property of the event object for a<em>userEnterRoom</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>user</td><td><em>User</em></td><td>An object representing the user who joined the Room.</td></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room that was joined by a user.</td></tr>
	 *</table>
	 * 
	 * @example	The following example shows how to handle this event type:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnterRoom);
	 * }
	 * 
	 * private function onUserEnterRoom(evt:SFSEvent):Void
	 * {
	 * 	var room:Room=evt.params.room;
	 * 	var user:User=evt.params.user;
	 * 	
	 * 	trace("User " + user.name + " just joined Room " + room.name);
	 * }
	 *</listing>
	 * 
	 * @eventType	userEnterRoom
	 * 
	 * @see		#USER_EXIT_ROOM
	 * @see		#USER_COUNT_CHANGE
	 */
	public static inline var USER_ENTER_ROOM:String = "userEnterRoom";
	
	/**
	 * The<em>SFSEvent.USER_EXIT_ROOM</em>constant defines the value of the<em>type</em>property of the event object for a<em>userExitRoom</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>user</td><td><em>User</em></td><td>An object representing the user who left the Room.</td></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room that was left by a user.</td></tr>
	 *</table>
	 * 
	 * @example	The following example shows how to handle this event type:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitRoom);
	 * }
	 * 
	 * private function onUserExitRoom(evt:SFSEvent):Void
	 * {
	 * 	var room:Room=evt.params.room;
	 * 	var user:User=evt.params.user;
	 * 	
	 * 	trace("User " + user.name + " just left Room " + room.name);
	 * }
	 *</listing>
	 * 
	 * @eventType	userExitRoom
	 * 
	 * @see		#USER_ENTER_ROOM
	 * @see		#USER_COUNT_CHANGE
	 */
	public static inline var USER_EXIT_ROOM:String = "userExitRoom";
	
	/**
	 * The<em>SFSEvent.USER_COUNT_CHANGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>userCountChange</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room in which the users count changed.</td></tr>
	 *<tr><td>uCount</td><td><em>int</em></td><td>The new users count(players in case of Game Room).</td></tr>
	 *<tr><td>sCount</td><td><em>int</em></td><td>The new spectators count(Game Room only).</td></tr>
	 *</table>
	 * 
	 * @example	The following example shows how to handle this event type:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.USER_COUNT_CHANGE, onUserCountChanged);
	 * }
	 * 
	 * private function onUserCountChanged(evt:SFSEvent):Void
	 * {
	 * 	var room:Room=evt.params.room;
	 * 	var uCount:Int=evt.params.uCount;
	 * 	var sCount:Int=evt.params.sCount;
	 * 	
	 * 	trace("Room:" + room.name + " now contains " + uCount + " users and " + sCount + " spectators");
	 * }
	 *</listing>
	 * 
	 * @eventType	userCountChange
	 * 
	 * @see		#USER_ENTER_ROOM
	 * @see		#USER_EXIT_ROOM
	 */
	public static inline var USER_COUNT_CHANGE:String = "userCountChange";
	
	/**
	 * The<em>SFSEvent.PUBLIC_MESSAGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>publicMessage</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room at which the message is targeted.</td></tr>
	 *<tr><td>sender</td><td><em>User</em></td><td>An object representing the user who sent the message.</td></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The message sent by the user.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An object containing custom parameters which might accompany the message.</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends a public message and handles the respective event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessage);
	 * 	
	 * 	// Send a public message
	 * 	sfs.send(new PublicMessageRequest("Hello everyone!"));
	 * }
	 * 
	 * private function onPublicMessage(evt:SFSEvent):Void
	 * {
	 * 	// As messages are forwarded to the sender too,
	 * 	// I have to check if I am the sender
	 * 	
	 * 	var sender:User=evt.params.sender;
	 * 	
	 * 	if(sender==sfs.mySelf)
	 * 		trace("I said:", evt.params.message);
	 * 	else
	 * 		trace("User " + sender.name + " said:", evt.params.message);
	 * }
	 *</listing>
	 * 
	 * @eventType	publicMessage
	 * 
	 * @see		#PRIVATE_MESSAGE
	 */
	public static inline var PUBLIC_MESSAGE:String = "publicMessage";
	
	/**
	 * The<em>SFSEvent.PRIVATE_MESSAGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>privateMessage</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>sender</td><td><em>User</em></td><td>An object representing the user who sent the message.</td></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The message sent by the user.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An object containing custom parameters which might accompany the message.</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends a private message and handles the respective event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE, onPrivateMessage);
	 * 	
	 * 	// Send a private message to Jack
	 * 	var user:User=sfs.usermanager.getUserByName("Jack");
	 * 	sfs.send(new PrivateMessageRequest("Hello my friend!", user.id));
	 * }
	 * 
	 * private function onPrivateMessage(evt:SFSEvent):Void
	 * {
	 * 	// As messages are forwarded to the sender too,
	 * 	// I have to check if I am the sender
	 * 	
	 * 	var sender:User=evt.params.sender;
	 * 	
	 * 	if(sender !=sfs.mySelf)
	 * 		trace("User " + sender.name + " sent me this PM:", evt.params.message);
	 * }
	 *</listing>
	 * 
	 * @eventType	privateMessage
	 * 
	 * @see		#PUBLIC_MESSAGE
	 */
	public static inline var PRIVATE_MESSAGE:String = "privateMessage";
	
	/**
	 * The<em>SFSEvent.OBJECT_MESSAGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>objectMessage</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>sender</td><td><em>User</em></td><td>An object representing the user who sent the message.</td></tr>
	 *<tr><td>message</td><td><em>SFSObject</em></td><td>The content of the message:an object containing the custom parameters sent by the sender.</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends the player's character movement coordinates and handles the respective event
	 *(note:the<em>myCharacter</em>instance is supposed to be the user sprite on the stage, while the<em>getUserCharacter</em>method retrieves the sprite of other users' characters):
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.OBJECT_MESSAGE, onObjectMessage);
	 * 	
	 * 	// Send my movement to all players
	 * 	var dataObj:ISFSObject=new SFSObject();
	 * 	dataObj.putInt("x", myCharacter.x);
	 * 	dataObj.putInt("y", myCharacter.y);
	 * 	
	 * 	sfs.send(new DynamicMessageRequest(dataObj));
	 * }
	 * 
	 * private function onObjectMessage(evt:SFSEvent):Void
	 * {
	 * 	var dataObj:ISFSObject=evt.params.message as SFSObject;
	 * 	
	 * 	var sender:User=evt.params.sender;
	 * 	var character:Sprite=getUserCharacter(sender.id);
	 * 	
	 * 	character.x=dataObj.getInt("x");
	 * 	character.y=dataObj.getInt("y");
	 * }
	 *</listing>
	 * 
	 * @eventType	objectMessage
	 */
	public static inline var OBJECT_MESSAGE:String = "objectMessage";
	
	/**
	 * The<em>SFSEvent.MODERATOR_MESSAGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>moderatorMessage</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>sender</td><td><em>User</em></td><td>An object representing the moderator user who sent the message.</td></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The message sent by the moderator.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An object containing custom parameters which might accompany the message.</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends a moderator message to all the users in the last joned Room;it also shows how to handle the related event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.MODERATOR_MESSAGE, onModeratorMessage);
	 * 	
	 * 	// Set the message recipients:all users in the current Room
	 * 	var recipMode:MessageRecipientMode=new MessageRecipientMode(MessageRecipientMode.TO_ROOM, sfs.lastJoinedRoom);
	 * 	
	 * 	// Send the moderator message
	 * 	sfs.send(new ModeratorMessageRequest("Hello everybody, I'm the Moderator!", recipMode));
	 * }
	 * 
	 * private function onModeratorMessage(evt:SFSEvent):Void
	 * {
	 * 	trace("The moderator sent the following message:" + evt.params.message);
	 * }
	 *</listing>
	 * 
	 * @eventType	moderatorMessage
	 * 
	 * @see		#ADMIN_MESSAGE
	 */
	public static inline var MODERATOR_MESSAGE:String = "moderatorMessage";
	
	/**
	 * The<em>SFSEvent.ADMIN_MESSAGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>adminMessage</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>sender</td><td><em>User</em></td><td>An object representing the administrator user who sent the message.</td></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The message sent by the administrator.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An object containing custom parameters which might accompany the message.</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends an administration message to all the users in the Zone;it also shows how to handle the related event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ADMIN_MESSAGE, onAdminMessage);
	 * 	
	 * 	// Set the message recipients:all users in the Zone
	 * 	var recipMode:MessageRecipientMode=new MessageRecipientMode(MessageRecipientMode.TO_ZONE, null);
	 * 	
	 * 	// Send the administrator message
	 * 	sfs.send(new AdminMessageRequest("Hello to everybody from the Administrator!", recipMode));
	 * }
	 * 
	 * private function onAdminMessage(evt:SFSEvent):Void
	 * {
	 * 	trace("The administrator sent the following message:" + evt.params.message);
	 * }
	 *</listing>
	 * 
	 * @eventType	adminMessage
	 * 
	 * @see		#MODERATOR_MESSAGE
	 */
	public static inline var ADMIN_MESSAGE:String = "adminMessage";
	
	/**
	 * The<em>SFSEvent.EXTENSION_RESPONSE</em>constant defines the value of the<em>type</em>property of the event object for a<em>extensionResponse</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>cmd</td><td><em>String</em></td><td>The name of the command which identifies an action that should be executed by the client.
	 * 												If this event is fired in response to a request sent by the client, it is a common practice
	 * 												to use the same command name passed to the request also in the response.</td></tr>
	 *<tr><td>params</td><td><em>ISFSObject</em></td><td>An object containing custom data sent by the Extension.</td></tr>
	 *<tr><td>sourceRoom</td><td><em>Number</em></td><td>The id of the Room which the Extension is attached to(for Room Extensions only).</td></tr>
	 *<tr><td>packetId</td><td><em>Number</em></td><td>The id of the packet when the UDP protocol is used. As this is an auto-increment value generated by the server,
	 * 													it can be useful to detect UDP packets received in the wrong order.</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends a command to the Zone Extension;it also handles responses coming from the
	 * Extension by implementing the<em>extensionResponse</em>listener(the same command name is used in both the request and the response):
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
	 * 	
	 * 	// Send two Integers to the Zone extension and get their sum in return
	 * 	var params:ISFSObject=new SFSObject();
	 * 	params.putInt("n1", 26);
	 * 	params.putInt("n2", 16);
	 * 	
	 * 	sfs.send(new ExtensionRequest("add", params));
	 * }
	 * 
	 * private function onExtensionResponse(evt:SFSEvent):Void
	 * {
	 * 	if(evt.params.cmd=="add")
	 * 	{
	 * 		var responseParams:ISFSObject=evt.params.params as SFSObject;
	 * 		
	 * 		// We expect an Int parameter called "sum"
	 * 		trace("The sum is:" + responseParams.getInt("sum"));
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @eventType	extensionResponse
	 */
	public static inline var EXTENSION_RESPONSE:String = "extensionResponse";
	
	/**
	 * The<em>SFSEvent.ROOM_VARIABLES_UPDATE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomVariablesUpdate</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room where the Room Variable update occurred.</td></tr>
	 *<tr><td>changedVars</td><td><em>Array</em></td><td>The list of names of the Room Variables that were changed(or created for the first time).</td></tr>
	 *</table>
	 * 
	 * @example	The following example sets a number of Room Variables and handles the respective update event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.ROOM_VARIABLES_UPDATE, onRoomVarsUpdate);
	 * 	
	 * 	// Create some Room Variables
	 * 	var roomVars:Array<Dynamic>=[];
	 * 	roomVars.push(new SFSRoomVariable("gameStarted", false));
	 * 	roomVars.push(new SFSRoomVariable("gameType", "Snooker"));
	 * 	roomVars.push(new SFSRoomVariable("minRank", 10));
	 * 	
	 * 	sfs.send(new SetRoomVariablesRequest(roomVars));
	 * }
	 * 
	 * private function onRoomVarsUpdate(evt:SFSEvent):Void
	 * {
	 * 	var changedVars:Array<Dynamic>=evt.params.changedVars as Array<Dynamic>;
	 * 	var room:Room=evt.params.room as Room;
	 * 	
	 * 	// Check if the "gameStarted" variable was changed
	 * 	if(changedVars.indexOf("gameStarted")!=-1)
	 * 	{
	 * 		if(room.getVariable("gameStarted").getBoolValue()==true)
	 * 			trace("Game started");
	 * 		else
	 * 			trace("Game stopped");
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @eventType	roomVariablesUpdate
	 */
	public static inline var ROOM_VARIABLES_UPDATE:String = "roomVariablesUpdate";
	
	/**
	 * The<em>SFSEvent.USER_VARIABLES_UPDATE</em>constant defines the value of the<em>type</em>property of the event object for a<em>userVariablesUpdate</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>user</td><td><em>User</em></td><td>An object representing the user who updated his own User Variables.</td></tr>
	 *<tr><td>changedVars</td><td><em>Array</em></td><td>The list of names of the User Variables that were changed(or created for the first time).</td></tr>
	 *</table>
	 * 
	 * @example	The following example sets a number of User Variables and handles the respective update event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
	 * 	
	 * 	// Create some User Variables
	 * 	var userVars:Array<Dynamic>=[];
	 * 	userVars.push(new SFSUserVariable("avatarType", "SwedishCook"));
	 * 	userVars.push(new SFSUserVariable("country", "Sweden"));
	 * 	userVars.push(new SFSUserVariable("x", 10));
	 * 	userVars.push(new SFSUserVariable("y", 5));
	 * 	
	 * 	sfs.send(new SetUserVariablesRequest(userVars));
	 * }
	 * 
	 * private function onUserVarsUpdate(evt:SFSEvent):Void
	 * {
	 * 	var changedVars:Array<Dynamic>=evt.params.changedVars as Array<Dynamic>;
	 * 	var user:User=evt.params.user as User;
	 * 	
	 * 	// Check if the user changed his x and y user variables
	 * 	if(changedVars.indexOf("x")!=-1 || changedVars.indexOf("y")!=-1)
	 * 	{
	 * 		// Move the user avatar to a new position
	 * 		...
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @eventType	userVariablesUpdate
	 */
	public static inline var USER_VARIABLES_UPDATE:String = "userVariablesUpdate";
	
	/**
	 * The<em>SFSEvent.ROOM_GROUP_SUBSCRIBE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomGroupSubscribe</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>groupId</td><td><em>String</em></td><td>The name of the Group that was subscribed.</td></tr>
	 *<tr><td>newRooms</td><td><em>Array</em></td><td>A list of<em>Room</em>objects representing the Rooms belonging to the subscribed Group.</td></tr>
	 *</table>
	 * 
	 * @example	The following example makes the current user subscribe a Group:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE, onGroupSubscribed);
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR, onGroupSubscribeError);
	 * 	
	 * 	// Subscribe the "cardGames" group
	 * 	sfs.send(new SubscribeRoomGroupRequest("cardGames"));
	 * }
	 * 
	 * private function onGroupSubscribed(evt:SFSEvent):Void
	 * {
	 * 	trace("Group subscribed. The following rooms are now accessible:" + evt.params.newRooms);
	 * }
	 * 
	 * private function onGroupSubscribeError(evt:SFSEvent):Void
	 * {
	 * 	trace("Group subscription failed:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomGroupSubscribe
	 * 
	 * @see		#ROOM_GROUP_SUBSCRIBE_ERROR
	 * @see		#ROOM_GROUP_UNSUBSCRIBE
	 */
	public static inline var ROOM_GROUP_SUBSCRIBE:String = "roomGroupSubscribe";
	
	/**
	 * The<em>SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomGroupSubscribeError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_GROUP_SUBSCRIBE</em>constant description.
	 * 
	 * @eventType	roomGroupSubscribeError
	 * 
	 * @see		#ROOM_GROUP_SUBSCRIBE
	 */
	public static inline var ROOM_GROUP_SUBSCRIBE_ERROR:String = "roomGroupSubscribeError";
	
	/**
	 * The<em>SFSEvent.ROOM_GROUP_UNSUBSCRIBE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomGroupUnsubscribe</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>groupId</td><td><em>String</em></td><td>The name of the Group that was unsubscribed.</td></tr>
	 *</table>
	 * 
	 * @example	The following example makes the current user unsubscribe a Group:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_UNSUBSCRIBE, onGroupUnsubscribed);
	 * 	sfs.addEventListener(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR, onGroupUnsubscribeError);
	 * 	
	 * 	// Unsubscribe the "cardGames" group
	 * 	sfs.send(new UnsubscribeRoomGroupRequest("cardGames"));
	 * }
	 * 
	 * private function onGroupUnsubscribed(evt:SFSEvent):Void
	 * {
	 * 	trace("Group unsubscribed:" + evt.params.groupId);
	 * }
	 * 
	 * private function onGroupUnsubscribeError(evt:SFSEvent):Void
	 * {
	 * 	trace("Group unsubscribing failed:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomGroupUnsubscribe
	 * 
	 * @see		#ROOM_GROUP_UNSUBSCRIBE_ERROR
	 * @see		#ROOM_GROUP_SUBSCRIBE
	 */
	public static inline var ROOM_GROUP_UNSUBSCRIBE:String = "roomGroupUnsubscribe";
	
	/**
	 * The<em>SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomGroupUnsubscribeError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_GROUP_UNSUBSCRIBE</em>constant description.
	 * 
	 * @eventType	roomGroupUnsubscribeError
	 * 
	 * @see		#ROOM_GROUP_UNSUBSCRIBE
	 */
	public static inline var ROOM_GROUP_UNSUBSCRIBE_ERROR:String = "roomGroupUnsubscribeError";
	
	/**
	 * The<em>SFSEvent.PLAYER_TO_SPECTATOR</em>constant defines the value of the<em>type</em>property of the event object for a<em>playerToSpectator</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room in which the player is turned to spectator.</td></tr>
	 *<tr><td>user</td><td><em>User</em></td><td>An object representing the player who was turned to spectator.</td></tr>
	 *</table>
	 * 
	 * @example	The following example turns the current user from player to spectator in the last joined Game Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.PLAYER_TO_SPECTATOR, onPlayerToSpectatorSwitch);
	 * 	sfs.addEventListener(SFSEvent.PLAYER_TO_SPECTATOR_ERROR, onPlayerToSpectatorSwitchError);
	 * 	
	 * 	// Switch player to spectator
	 * 	sfs.send(new PlayerToSpectatorRequest());
	 * }
	 * 
	 * private function onPlayerToSpectatorSwitch(evt:SFSEvent):Void
	 * {
	 * 	trace("Player " + evt.params.user + " is now a spectator");
	 * }
	 * 
	 * private function onPlayerToSpectatorSwitchError(evt:SFSEvent):Void
	 * {
	 * 	trace("Unable to become a spectator due to the following error:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	playerToSpectator
	 * 
	 * @see		#PLAYER_TO_SPECTATOR_ERROR
	 * @see		#SPECTATOR_TO_PLAYER
	 */
	public static inline var PLAYER_TO_SPECTATOR:String = "playerToSpectator";
	
	/**
	 * The<em>SFSEvent.PLAYER_TO_SPECTATOR_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>playerToSpectatorError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>PLAYER_TO_SPECTATOR</em>constant description.
	 * 
	 * @eventType	playerToSpectatorError
	 * 
	 * @see		#PLAYER_TO_SPECTATOR
	 */
	public static inline var PLAYER_TO_SPECTATOR_ERROR:String = "playerToSpectatorError";
	
	/**
	 * The<em>SFSEvent.SPECTATOR_TO_PLAYER</em>constant defines the value of the<em>type</em>property of the event object for a<em>spectatorToPlayer</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room in which the spectator is turned to player.</td></tr>
	 *<tr><td>user</td><td><em>User</em></td><td>An object representing the spectator who was turned to player.</td></tr>
	 *<tr><td>playerId</td><td><em>int</em></td><td>The player id of the user.</td></tr>
	 *</table>
	 * 
	 * @example	The following example turns the current user from spectator to player in the last joined Game Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER, onSpectatorToPlayerSwitch);
	 * 	sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER_ERROR, onSpectatorToPlayerSwitchError);
	 * 	
	 * 	// Switch spectator to player
	 * 	sfs.send(new SpectatorToPlayerRequest());
	 * }
	 * 
	 * private function onSpectatorToPlayerSwitch(evt:SFSEvent):Void
	 * {
	 * 	trace("Spectator " + evt.params.user + " is now a player");
	 * }
	 * 
	 * private function onSpectatorToPlayerSwitchError(evt:SFSEvent):Void
	 * {
	 * 	trace("Unable to become a player due to the following error:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	spectatorToPlayer
	 * 
	 * @see		#SPECTATOR_TO_PLAYER_ERROR
	 * @see		#PLAYER_TO_SPECTATOR
	 */
	public static inline var SPECTATOR_TO_PLAYER:String = "spectatorToPlayer";
	
	/**
	 * The<em>SFSEvent.SPECTATOR_TO_PLAYER_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>spectatorToPlayerError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>SPECTATOR_TO_PLAYER</em>constant description.
	 * 
	 * @eventType	spectatorToPlayerError
	 * 
	 * @see		#SPECTATOR_TO_PLAYER
	 */
	public static inline var SPECTATOR_TO_PLAYER_ERROR:String = "spectatorToPlayerError";
	
	/**
	 * The<em>SFSEvent.ROOM_NAME_CHANGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomNameChange</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room which was renamed.</td></tr>
	 *<tr><td>oldName</td><td><em>String</em></td><td>The previous name of the Room.</td></tr>
	 *</table>
	 * 
	 * @example	The following example renames an existing Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_NAME_CHANGE, onRoomNameChanged);
	 * 	sfs.addEventListener(SFSEvent.ROOM_NAME_CHANGE_ERROR, onRoomNameChangeError);
	 * 	
	 * 	var theRoom:Room=sfs.getRoomByName("Gonzo's Room");
	 * 	sfs.send(new ChangeRoomNameRequest(theRoom, "Gonzo The Great's Room"));
	 * }
	 * 
	 * private function onRoomNameChanged(evt:SFSEvent):Void
	 * {
	 * 	trace("Room " + evt.params.oldName + " was successfully renamed to " + evt.params.room.name);
	 * }
	 * 
	 * private function onRoomNameChangeError(evt:SFSEvent):Void
	 * {
	 * 	trace("Room name change failed:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomNameChange
	 * 
	 * @see		#ROOM_NAME_CHANGE_ERROR
	 */
	public static inline var ROOM_NAME_CHANGE:String = "roomNameChange";
	
	/**
	 * The<em>SFSEvent.ROOM_NAME_CHANGE_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomNameChangeError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_NAME_CHANGE</em>constant description.
	 * 
	 * @eventType	roomNameChangeError
	 * 
	 * @see		#ROOM_NAME_CHANGE
	 */
	public static inline var ROOM_NAME_CHANGE_ERROR:String = "roomNameChangeError";
	
	/**
	 * The<em>SFSEvent.ROOM_PASSWORD_STATE_CHANGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomPasswordStateChange</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room whose password was changed.</td></tr>
	 *</table>
	 * 
	 * @example	The following example changes the password of an existing Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_PASSWORD_STATE_CHANGE, onRoomPasswordStateChanged);
	 * 	sfs.addEventListener(SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR, onRoomPasswordStateChangeError);
	 * 	
	 * 	var theRoom:Room=sfs.getRoomByName("Gonzo's Room");
	 * 	sfs.send(new ChangeRoomPasswordStateRequest(theRoom, "mammamia"));
	 * }
	 * 
	 * private function onRoomPasswordStateChanged(evt:SFSEvent):Void
	 * {
	 * 	trace("The password of Room " + evt.params.room.name + " was changed successfully");
	 * }
	 * 
	 * private function onRoomPasswordStateChangeError(evt:SFSEvent):Void
	 * {
	 * 	trace("Room password change failed:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomPasswordStateChange
	 * 
	 * @see		#ROOM_PASSWORD_STATE_CHANGE_ERROR
	 */
	public static inline var ROOM_PASSWORD_STATE_CHANGE:String = "roomPasswordStateChange";
	
	/**
	 * The<em>SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomPasswordStateChangeError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_PASSWORD_STATE_CHANGE</em>constant description.
	 * 
	 * @eventType	roomPasswordStateChangeError
	 * 
	 * @see		#ROOM_PASSWORD_STATE_CHANGE
	 */
	public static inline var ROOM_PASSWORD_STATE_CHANGE_ERROR:String = "roomPasswordStateChangeError";
	
	/**
	 * The<em>SFSEvent.ROOM_CAPACITY_CHANGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomCapacityChange</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>An object representing the Room whose capacity was changed.</td></tr>
	 *</table>
	 * 
	 * @example	The following example changes the capacity of an existing Room:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_CAPACITY_CHANGE, onRoomCapacityChanged);
	 * 	sfs.addEventListener(SFSEvent.ROOM_CAPACITY_CHANGE_ERROR, onRoomCapacityChangeError);
	 * 	
	 * 	var theRoom:Room=sfs.getRoomByName("Gonzo's Room");
	 * 	
	 * 	// Resize the Room so that it allows a maximum of 100 users and zero spectators
	 * 	sfs.send(new ChangeRoomCapacityRequest(theRoom, 100, 0));
	 * }
	 * 
	 * private function onRoomCapacityChanged(evt:SFSEvent):Void
	 * {
	 * 	trace("The capacity of Room " + evt.params.room.name + " was changed successfully");
	 * }
	 * 
	 * private function onRoomCapacityChangeError(evt:SFSEvent):Void
	 * {
	 * 	trace("Room capacity change failed:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomCapacityChange
	 * 
	 * @see		#ROOM_CAPACITY_CHANGE_ERROR
	 */
	public static inline var ROOM_CAPACITY_CHANGE:String = "roomCapacityChange";
	
	/**
	 * The<em>SFSEvent.ROOM_CAPACITY_CHANGE_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomCapacityChangeError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>ROOM_CAPACITY_CHANGE</em>constant description.
	 * 
	 * @eventType	roomCapacityChangeError
	 * 
	 * @see		#ROOM_CAPACITY_CHANGE
	 */
	public static inline var ROOM_CAPACITY_CHANGE_ERROR:String = "roomCapacityChangeError";
	
	/**
	 * The<em>SFSEvent.ROOM_FIND_RESULT</em>constant defines the value of the<em>type</em>property of the event object for a<em>roomFindResult</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>rooms</td><td><em>Array</em></td><td>A list of<em>Room</em>objects representing the Rooms matching the search criteria. If no Room is found, the list is empty.</td></tr>
	 *</table>
	 * 
	 * @example	The following example looks for all the server Rooms whose "country" Room Variable is set to "Sweden":
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.ROOM_FIND_RESULT, onRoomFindResult);
	 * 	
	 * 	// Create a matching expression to find Rooms with a "country" variable equal to "Sweden"
	 * 	var exp:MatchExpression=new MatchExpression("country", StringMatch.EQUALS, "Sweden");
	 * 	
	 * 	// Find the Rooms
	 * 	sfs.send(new FindRoomRequest(exp));
	 * }
	 * 
	 * private function onRoomFindResult(evt:SFSEvent):Void
	 * {
	 * 	trace("Rooms found:" + evt.params.rooms);
	 * }
	 *</listing>
	 * 
	 * @eventType	roomFindResult
	 */
	public static inline var ROOM_FIND_RESULT:String = "roomFindResult";
	
	/**
	 * The<em>SFSEvent.USER_FIND_RESULT</em>constant defines the value of the<em>type</em>property of the event object for a<em>userFindResult</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>users</td><td><em>Array</em></td><td>A list of<em>User</em>objects representing the users matching the search criteria. If no user is found, the list is empty.</td></tr>
	 *</table>
	 * 
	 * @example	The following example looks for all the users whose "age" User Variable is greater than<code>29</code>:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.USER_FIND_RESULT, onUserFindResult);
	 * 	
	 * 	// Create a matching expression to find users with an "age" variable greater than 29:
	 * 	var exp:MatchExpression=new MatchExpression("age", FloatMatch.GREATER_THAN, 29);
	 * 	
	 * 	// Find the users
	 * 	sfs.send(new FindUserRequest(exp));
	 * }
	 * 
	 * private function onUserFindResult(evt:SFSEvent):Void
	 * {
	 * 	trace("Users found:" + evt.params.users);
	 * }
	 *</listing>
	 * 
	 * @eventType	userFindResult
	 */
	public static inline var USER_FIND_RESULT:String = "userFindResult";
	
	/**
	 * The<em>SFSEvent.INVITATION</em>constant defines the value of the<em>type</em>property of the event object for a<em>invitation</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>invitation</td><td><em>Invitation</em></td><td>An object representing the invitation received by the current user.</td></tr>
	 *</table>
	 * 
	 * @example	The following example receives an invitation and accepts it automatically;in a real case scenario, the application Interface
	 * usually allows the user choosing to accept or refuse the invitation, or even ignore it:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSEvent.INVITATION, onInvitationReceived);
	 * 	sfs.addEventListener(SFSEvent.INVITATION_REPLY_ERROR, onInvitationReplyError);
	 * }
	 * 
	 * private function onInvitationReceived(evt:SFSEvent):Void
	 * {
	 * 	// Let's accept this invitation			
	 * 	sfs.send(new InvitationReplyRequest(evt.params.invitation, InvitationReply.ACCEPT));
	 * }
	 * 
	 * private function onInvitationReplyError(evt:SFSEvent):Void
	 * {
	 * 	trace("Failed to reply to invitation due to the following problem:" + evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	invitation
	 * 
	 * @see		#INVITATION_REPLY
	 */
	public static inline var INVITATION:String = "invitation";
	
	/**
	 * The<em>SFSEvent.INVITATION_REPLY</em>constant defines the value of the<em>type</em>property of the event object for a<em>invitationReply</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>invitee</td><td><em>User</em></td><td>An object representing the user who replied to the invitation.</td></tr>
	 *<tr><td>reply</td><td><em>int</em></td><td>The answer to the invitation among those available as constants in the<em>InvitationReply</em>class.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An object containing custom parameters, for example a message describing the reason of refusal.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>INVITATION</em>constant description.
	 * 
	 * @eventType	invitationReply
	 * 
	 * @see		com.smartfoxserver.v2.entities.invitation.InvitationReply InvitationReply
	 * @see		#INVITATION
	 * @see		#INVITATION_REPLY_ERROR
	 */
	public static inline var INVITATION_REPLY:String = "invitationReply";
	
	/**
	 * The<em>SFSEvent.INVITATION_REPLY_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>invitationReplyError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>A message containing the description of the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>INVITATION</em>constant description.
	 * 
	 * @eventType	invitationReplyError
	 * 
	 * @see		#INVITATION_REPLY
	 * @see		#INVITATION
	 */
	public static inline var INVITATION_REPLY_ERROR:String = "invitationReplyError";
	
	/**
	 * The<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>constant defines the value of the<em>type</em>property of the event object for a<em>proximityListUpdate</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>Room</em></td><td>The Room in which the event occurred.</td></tr>
	 *<tr><td>addedUsers</td><td><em>Array</em></td><td>A list of<em>User</em>objects representing the users who entered the current user's Area of Interest.</td></tr>
	 *<tr><td>removedUsers</td><td><em>Array</em></td><td>A list of<em>User</em>objects representing the users who left the current user's Area of Interest.</td></tr>
	 *<tr><td>addedItems</td><td><em>Array</em></td><td>A list of<em>MMOItem</em>objects which entered the current user's Area of Interest.</td></tr>
	 *<tr><td>removedItems</td><td><em>Array</em></td><td>A list of<em>MMOItem</em>objects which left the current user's Area of Interest.</td></tr>
	 *</table>
	 * 
	 * @example The following example shows how to handle the<i>proximity user list</i>provided by the event in order to add new avatars on the stage
	 * and remove those who left the current user's proximity range:
	 *<listing version="3.0">
	 * 
	 * private function onProximityListUpdate(evt:SFSEvent):Void
	 * {
	 * 	var added:Array<Dynamic>=evt.params.addedUsers;
	 * 	var removed:Array<Dynamic>=evt.params.removedUsers;
	 * 
	 * 	// Add users that entered the proximity list
	 * 	for(var user:User in added)
	 * 	{
	 * 		// Obtain the coordinates at which the user "appeared" in our range
	 * 		var entryPoint:Vec3D=user.aoiEntryPoint;
	 * 	
	 * 		// Add new avatar on screen
	 * 		var avatarSprite:AvatarSprite=new AvatarSprite();
	 * 		avatarSprite.x=entryPoint.px;
	 * 		avatarSprite.y=entryPoint.py;
	 * 		...
	 * 	}
	 * 
	 * 	// Remove users that left the proximity list
	 * 	for(var user:User in removed)
	 * 	{
	 * 		// Remove the avatar from stage
	 * 		...
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @eventType	proximityListUpdate
	 */
	public static inline var PROXIMITY_LIST_UPDATE:String = "proximityListUpdate";
	
	/**
	 * The<em>SFSEvent.MMOITEM_VARIABLES_UPDATE</em>constant defines the value of the<em>type</em>property of the event object for a<em>mmoItemVariablesUpdate</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>room</td><td><em>MMORoom</em></td><td>The MMORoom where the MMOItem whose Variables have been updated is located.</td></tr>
	 *<tr><td>mmoItem</td><td><em>MMOItem</em></td><td>The MMOItem whose variables have been updated.</td></tr>
	 *<tr><td>changedVars</td><td><em>Array</em></td><td>The list of names of the MMOItem Variables that were changed(or created for the first time).</td></tr>
	 *</table>
	 * 
	 * @example	The following example shows how to handle the MMOItem Variable update:
	 *<listing version="3.0">
	 *
	 * private function onMMOItemVarsUpdate(evt:SFSEvent):Void
	 * {
	 * 	var changedVars:Array<Dynamic>=evt.params.changedVars;
	 * 	var item:IMMOItem=evt.params.mmoItem;
	 * 	
	 * 	// Check if the MMOItem was moved 
	 * 	if(changedVars.indexOf("x")!=-1 || changedVars.indexOf("y")!=-1)
	 * 	{
	 * 		// Move the sprite representing the MMOItem on the stage
	 * 		...
	 * 	}
	 * }
	 *</listing>
	 * 
	 * @eventType	mmoItemVariablesUpdate
	 */ 
	public static inline var MMOITEM_VARIABLES_UPDATE:String = "mmoItemVariablesUpdate";
	
	/**
	 * The <em>SFSEvent.CRYPTO_INIT</em> constant defines the value of the <em>type</em> property of the event object for a <em>cryptoInit</em> call.
	 * 
	 * <p>The properties of the <em>params</em> object contained in the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 * <tr><td>success</td><td><em>Boolean</em></td><td><code>true</code> if a unique encryption key was successfully retrieved via HTTPS, <code>false</code> if the transaction failed.</td></tr>
	 * <tr><td>errorMsg</td><td><em>Boolean</em></td><td>May contain further details if an error occurred (success==false)</td></tr>
	 * </table>
	 * 
	 * @example	The following example initializes the socket cryptography. <b>Always makes sure to initialize cryptography right after having connected</b>.
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
	 * @eventType	cryptoInit
	 */
	 public static inline var CRYPTO_INIT:String = "CryptoInit";

	//==========================================================================================================
	
	
	/**
	 * Creates a new<em>SFSEvent</em>instance.
	 * 
	 * @param	type	The type of event.
	 * @param	params	An object containing the parameters of the event.
	 */
	public function new(type:String, params:Dynamic)
	{
		super(type);
		this.params = params;
	}
	
	/**
	 * Duplicates the instance of the<em>SFSEvent</em>object.
	 * 
	 * @return		A new<em>SFSEvent</em>object that is identical to the original.
	 */
	public override function clone():Event
	{
		return new SFSEvent(this.type, this.params);
	}
	
	/**
	 * Generates a string containing all the properties of the<em>SFSEvent</em>object.
	 * 
	 * @return		A string containing all the properties of the<em>SFSEvent</em>object.
	 */
	//public override function toString():String
	//{
		//return formatToString("SFSEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
	//}
	
	public var parameters(get, null):Dynamic;
	function get_parameters():Dynamic 
	{
		return this.params;
	}
}