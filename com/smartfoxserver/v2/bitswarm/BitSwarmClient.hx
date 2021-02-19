package com.smartfoxserver.v2.bitswarm;

import com.smartfoxserver.v2.bitswarm.wsocket.WSEvent;
import com.smartfoxserver.v2.bitswarm.wsocket.WSClient;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.bbox.BBClient;
import com.smartfoxserver.v2.bitswarm.bbox.BBEvent;
import com.smartfoxserver.v2.controllers.ExtensionController;
import com.smartfoxserver.v2.controllers.SystemController;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.logging.Logger;
import com.smartfoxserver.v2.util.ClientDisconnectionReason;
import com.smartfoxserver.v2.util.ConnectionMode;
import com.smartfoxserver.v2.util.CryptoKey;
import haxe.CallStack;
import openfl.errors.ArgumentError;
import openfl.utils.Endian;

import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.Socket;
import openfl.utils.ByteArray;

/** @private */
class BitSwarmClient extends EventDispatcher 
{
	private var _socket:Socket;
	private var _wsClient:WSClient;
	private var _bbClient:BBClient;
	private var _ioHandler:IoHandler;
	private var _controllers:Map<Int,IController>;
	private var _compressionThreshold:Int=2000000;
	private var _maxMessageSize:Int = 10000;
	private var _sfs:SmartFox;
	private var _connected:Bool;
	private var _lastIpAddress:String;
	private var _lastTcpPort:Int ;
	private var _reconnectionDelayMillis:Int = 1000;
	private var _reconnectionSeconds:Int = 0;
	private var _attemptingReconnection:Bool = false;
	private var _sysController:SystemController;
	private var _extController:ExtensionController;
	private var _udpManager:IUDPManager;
	private var _controllersInited:Bool = false;
	@:isVar
	public var cryptoKey(get, set):CryptoKey;
	private var _useWebSocket:Bool = false;
	private var _useBlueBox:Bool = false;
	private var _connectionMode:String;
	private var _firstReconnAttempt:Float=-1;
	private var _reconnCounter:Int=1;
		
	public function new(sfs:SmartFox=null)
	{
		super();
		
		_controllers = new Map<Int,IController>();
		_sfs = sfs;
		_connected = false;
		_udpManager = new DefaultUDPManager(sfs);
	}
	
	public var sfs(get, null):SmartFox;

	public var connected(get, null):Bool;
	
	
	
	public var connectionMode(get, never):String;
	private function get_connectionMode():String
	{
		return _connectionMode;
	}
	
	public var ioHandler(get, set):IoHandler;
 	private function get_ioHandler():IoHandler
	{
		return _ioHandler;
	}
	
	private function set_ioHandler(value:IoHandler):IoHandler
	{
		//if(_ioHandler !=null)
			//throw new SFSError("IOHandler is already set!")
			
		return _ioHandler = value;
	}
	
	public var maxMessageSize(get, set):Int;
 	private function get_maxMessageSize():Int
	{
		return _maxMessageSize;
	}
	
	private function set_maxMessageSize(value:Int):Int
	{
		return _maxMessageSize = value;
	}
	
	public var compressionThreshold(get, set):Int;
 	private function get_compressionThreshold():Int
	{
		return _compressionThreshold;
	}
	
	/*
	* Avoid compressing data whose size is<100 bytes
	* Ideal default value should be 300 bytes or more...
	*/
	private function set_compressionThreshold(value:Int):Int
	{
		if(value>100)
			return _compressionThreshold = value;
		else
			throw new ArgumentError("Compression threshold cannot be<100 bytes.");
	}
	
	public var reconnectionDelayMillis(get, set):Int;
 	private function get_reconnectionDelayMillis():Int
	{
		return _reconnectionDelayMillis;
	}

	public var useWSS(get, never):Bool;
	private function get_useWSS():Bool
	{
		return sfs.useWSS;
	}

	public var useWebSocket(get, set):Bool;
	private function get_useWebSocket():Bool
	{
		return _useWebSocket;
	}

	private function set_useWebSocket(value:Bool):Bool
	{
		return _useWebSocket = value;
	}
	
	public var useBlueBox(get, never):Bool;
 	private function get_useBlueBox():Bool
	{
		return _useBlueBox;	
	}
	
	public function forceBlueBox(value:Bool):Void
	{
		if(!connected)
			_useBlueBox = value;
		else
			throw new IllegalOperationError("You can't change the BlueBox mode while the connection is running");
	}
	
	private function set_reconnectionDelayMillis(millis:Int):Int
	{
		return _reconnectionDelayMillis = millis;
	}
	
	public function enableBBoxDebug(value:Bool):Void
	{
		_bbClient.isDebug = value;
	}
	
	public function init():Void
	{
		// Do it once
		if(!_controllersInited)
		{
			initControllers();
			_controllersInited = true;
		}

		_socket = new Socket();
		
		//if(_socket.hasOwnProperty("timeout"))// condition required to avoide FP<10.0 to throw an error at runtime
			//_socket.timeout = 5000;
		
		_socket.addEventListener(Event.CONNECT, onSocketConnect);
		_socket.addEventListener(Event.CLOSE, onSocketClose);
		_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		_socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
		_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
			
		_bbClient = new BBClient();
		_bbClient.addEventListener(BBEvent.CONNECT, onBBConnect);
		_bbClient.addEventListener(BBEvent.DATA, onBBData);
		_bbClient.addEventListener(BBEvent.DISCONNECT, onBBDisconnect);
		_bbClient.addEventListener(BBEvent.IO_ERROR, onBBError);
		_bbClient.addEventListener(BBEvent.SECURITY_ERROR, onBBError);

		_wsClient = new WSClient();
		_wsClient.addEventListener(WSEvent.CONNECT, this.onWSConnect);
		_wsClient.addEventListener(WSEvent.DATA, this.onWSData);
		_wsClient.addEventListener(WSEvent.CLOSED, this.onWSClosed);
		_wsClient.addEventListener(WSEvent.IO_ERROR, this.onWSError);
		_wsClient.addEventListener(WSEvent.SECURITY_ERROR, this.onWSError);
	}

	private function onWSConnect(evt : WSEvent) : Void
	{
		this._connected = true;
		var event : BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
		event.params = {
			success : true
		};
		dispatchEvent(event);
	}

	private function onWSData(evt : WSEvent) : Void
	{
		var buffer : ByteArray = evt.params.data;
		if (buffer != null)
		{
			this._ioHandler.onDataRead(buffer);
		}
	}

	private function onWSClosed(evt : WSEvent) : Void
	{
		_connected = false;

		//TODO: Add reconnect support for WebSocket?
		dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {
			reason : ClientDisconnectionReason.UNKNOWN
		}));
	}

	private function onWSError(evt : WSEvent) : Void
	{
		trace("## WebSocket Error: " + evt.params.message);
		var event : BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
		event.params = {
			message : evt.params.message
		};
		dispatchEvent(event);
	}
	
	public function destroy():Void
	{
		_socket.removeEventListener(Event.CONNECT, onSocketConnect);
		_socket.removeEventListener(Event.CLOSE, onSocketClose);
		_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		_socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
		_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
		
		if(_socket.connected)
			_socket.close();
			
		_socket = null;
	}
	
	public function getController(id:Int):IController
	{
		return _controllers.get(id);
	}
	
	public var systemController(get, null):SystemController;
 	private function get_systemController():SystemController
	{
		return _sysController;
	}
	
	public var extensionController(get, null):ExtensionController;
 	private function get_extensionController():ExtensionController
	{
		return _extController;
	}
	
	public var isReconnecting(get, set):Bool;
 	private function get_isReconnecting():Bool
	{
		return _attemptingReconnection;
	}
	
	private function set_isReconnecting(value:Bool):Bool
	{
		return _attemptingReconnection = value;	
	}
	
	public function getControllerById(id:Int):IController
	{
		return _controllers.get(id);
	}
	
	public var connectionIp(get, null):String;
 	private function get_connectionIp():String
	{
		if(!connected)
			return "Not Connected";
		else
			return _lastIpAddress;
	}
	@:isVar
	public var connectionPort(get, set):Int;

	
	private function addController(id:Int, controller:IController):Void
	{
		if(controller==null)
			throw new ArgumentError("Controller is null, it can't be added.");
		
		if(_controllers.exists(id))
			throw new ArgumentError("A controller with id:" + id + " already exists! Controller can't be added:" + controller);
			
		_controllers.set(id, controller);
	}
	
	public function addCustomController(id:Int, controllerClass:Class<IController>):Void
	{
		var controller:IController = Type.createInstance(controllerClass,[this]);
		addController(id, controller);
	}
	
	public function connect(host:String="127.0.0.1", port:Int=9933):Void
	{
		_lastIpAddress = host;
		_lastTcpPort = port;

		if(_useWebSocket)
		{
			_wsClient.connect(host, port, useWSS);
			_connectionMode = ConnectionMode.WEBSOCKET;
		}
		else if(_useBlueBox)
		{
			_bbClient.pollSpeed=(sfs.config !=null)? sfs.config.blueBoxPollingRate:750;
			_bbClient.connect(host, port);
			_connectionMode = ConnectionMode.HTTP;
		}
		else
		{
			_socket.connect(host, port);
			_connectionMode = ConnectionMode.SOCKET;
		}
	}
	
	public function send(message:IMessage):Void
	{	
		_ioHandler.codec.onPacketWrite(message);
	}
	
	public var socket(get, null):Socket;
	
 	//private function get_socket():Socket
	//{
		//return _socket;
	//}
	
	public var httpSocket(get , never):BBClient;
	
	public function get_httpSocket():BBClient
	{
		return _bbClient;
	}

	public var webSocket(get , never):WSClient;

	public function get_webSocket():WSClient
	{
		return _wsClient;
	}
	
	public function disconnect(reason:String=null):Void
	{
		if(_useBlueBox)
			_bbClient.close();
		else
		{
			if(socket.connected)
				_socket.close();
		}
				
		onSocketClose(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, { reason:reason } ));
	}
	
	public function nextUdpPacketId():Float
	{
		return _udpManager.nextUdpPacketId();
	}
	
	/*
	* Simulates abrupt disconnection
	* For testing/simulations only
	*/
	public function killConnection():Void
	{
		_socket.close();
		onSocketClose(new Event(Event.CLOSE));
	}
	
	public function stopReconnection():Void
	{
		_attemptingReconnection=false;
		_firstReconnAttempt=-1;
		
		if(_socket.connected)
			_socket.close();
		
		executeDisconnection(null);
	}
	
	public var udpManager(get, set):IUDPManager;
 	private function get_udpManager():IUDPManager
	{
		return _udpManager;
	}
	
	private function set_udpManager(manager:IUDPManager):IUDPManager
	{
		return _udpManager = manager;
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Socket handlers
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function initControllers():Void
	{
		_sysController = new SystemController(this);
		_extController = new ExtensionController(this);
		
		addController(0, _sysController);
		addController(1, _extController);
	}
	
	public var reconnectionSeconds(get, set):Int;
 	private function get_reconnectionSeconds():Int
	{
		return _reconnectionSeconds;
	}
	
	private function set_reconnectionSeconds(seconds:Int):Int
	{
		if(seconds<0)
			return _reconnectionSeconds = 0;
		else
			return _reconnectionSeconds = seconds;	
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Socket handlers
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function onSocketConnect(evt:Event):Void
	{
		_connected = true;
		
		var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
		
		// 2nd argument not publicly documented, used Internally
		event.params = { success:true, _isReconnection:_attemptingReconnection } ; 
		
		dispatchEvent(event);
	}
	
	private function onSocketClose(evt:Event):Void
	{
		// Connection is off
		_connected = false;
		
		var isRegularDisconnection:Bool = !_attemptingReconnection && sfs.getReconnectionSeconds() == 0;
		var isManualDisconnection:Bool = (Std.isOfType(evt, BitSwarmEvent)) && cast(evt,BitSwarmEvent).params.reason == ClientDisconnectionReason.MANUAL;

		if(isRegularDisconnection || isManualDisconnection)
		{
			// Reset UDP Manager
			_udpManager.reset();
			_firstReconnAttempt=-1;
			
			executeDisconnection(evt);					
			return;
		}
		
		// Already trying to reconnect...
		else if(_attemptingReconnection)
			reconnect();
		
		// First reconnection attempt
		else
		{
		
			/*
			* If we aren't in any of the above three cases then it's time to attempt a
			* reconnection to the server.
			*/
			_attemptingReconnection = true;
			_firstReconnAttempt=haxe.Timer.stamp();
			_reconnCounter=1;
				
			// Fire event and retry
			dispatchEvent(new BitSwarmEvent(BitSwarmEvent.RECONNECTION_TRY));
			
			reconnect();
		}
	}
	
	private function reconnect():Void
	{
		if(!_attemptingReconnection)
			return;
		
		var reconnectionSeconds:Int=sfs.getReconnectionSeconds()* 1000;
		var now:Float=haxe.Timer.stamp();
		var timeLeft:Float=(_firstReconnAttempt + reconnectionSeconds)- now;
		
		if(timeLeft>0)
		{
			sfs.logger.info('Reconnection attempt:$_reconnCounter - time left: ${Std.int(timeLeft/1000)}sec.');

			// Retry connection:pause 1 second and retry
			haxe.Timer.delay(function():Void { connect(_lastIpAddress, _lastTcpPort); }, _reconnectionDelayMillis);
			_reconnCounter++;
		}
		
		// We are out of time... connection failed:(
		else
		{
			dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason:ClientDisconnectionReason.UNKNOWN}));
		}
	}
	
	private function executeDisconnection(evt:Event):Void
	{
		/*
		* A BitSwarmEvent is passed if the disconnection was requested by the server
		* The event includes a reason for the disconnection(idle, kick, ban...)
		*/
		if(Std.isOfType(evt, BitSwarmEvent))
			dispatchEvent(evt);
			
			/*
			* Disconnection at socket level
			*/
		else
			dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, { reason:ClientDisconnectionReason.UNKNOWN } ));
	}
	
	private function onSocketData(evt:ProgressEvent):Void
	{
		var buffer:ByteArray = new ByteArray();
		buffer.endian = Endian.BIG_ENDIAN;
		try
		{
			
			_socket.readBytes(buffer);
			_ioHandler.onDataRead(buffer);
		}
		catch(error:Dynamic)
		{
			try{
			trace("## SocketDataError:" + error + " " + error.message);
			trace(haxe.CallStack.toString( haxe.CallStack.exceptionStack()));
			trace(buffer.toString());
			var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.DATA_ERROR);
			event.params = { message:error.message, details:error.details };
			
			dispatchEvent(event);
			}catch (e:Dynamic){
				trace(e);
			}
		}
	}
	
	private function onSocketIOError(evt:IOErrorEvent):Void
	{
		trace("## SocketError:" + evt.toString());
		var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
		event.params = { message:evt.toString() };
		
		dispatchEvent(event);
	}
	
	private function onSocketSecurityError(evt:SecurityErrorEvent):Void
	{
		// Reconnection failure
		if(_attemptingReconnection)
		{
			reconnect();
			return;
		}
		
		trace("## SecurityError:" + evt.toString());
		var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.SECURITY_ERROR);
		event.params = { message:evt.text };
		
		dispatchEvent(event);
	}
	
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// BlueBox handlers
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function onBBConnect(evt:BBEvent):Void
	{
		_connected = true;
		
		var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
		event.params = { success:true };
			
		dispatchEvent(event);		
	}
	
	private function onBBData(evt:BBEvent):Void
	{
		var buffer:ByteArray = evt.params.data;
		
		if(buffer !=null)			
			_ioHandler.onDataRead(buffer);
	}
	
	private function onBBDisconnect(evt:BBEvent):Void
	{
		// Connection is off
		_connected = false;
			
		// Fire event
		dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, { reason:ClientDisconnectionReason.UNKNOWN } ));
	}
	
	private function onBBError(evt:BBEvent):Void
	{
		trace("## BlueBox Dynamic:" + evt.params.message);
		var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
		event.params = { message:evt.params.message };
		
		dispatchEvent(event);
	}		
	
	function get_connectionPort():Int 
	{
		if(!connected)
			return -1;
		else
			return _lastTcpPort;
	}
	
	function set_connectionPort(value:Int):Int 
	{
		return connectionPort = value;
	}
	
	function get_sfs():SmartFox 
	{
		return _sfs;
	}
	
	function get_connected():Bool 
	{
		return _connected;
	}
	
	function get_socket():Socket 
	{
		return _socket;
	}
	
	function get_cryptoKey():CryptoKey 
	{
		return cryptoKey;
	}
	
	function set_cryptoKey(value:CryptoKey):CryptoKey 
	{
		return cryptoKey = value;
	}
	
}