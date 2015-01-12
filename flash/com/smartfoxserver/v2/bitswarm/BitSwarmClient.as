package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.bitswarm.bbox.BBClient;
	import com.smartfoxserver.v2.bitswarm.bbox.BBEvent;
	import com.smartfoxserver.v2.controllers.ExtensionController;
	import com.smartfoxserver.v2.controllers.SystemController;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.logging.Logger;
	import com.smartfoxserver.v2.util.ClientDisconnectionReason;
	import com.smartfoxserver.v2.util.ConnectionMode;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/** @private */
	public class BitSwarmClient extends EventDispatcher 
	{
		private var _socket:Socket
		private var _bbClient:BBClient
		private var _ioHandler:IoHandler
		private var _controllers:Object
		private var _compressionThreshold:int = 2000000; 
		private var _maxMessageSize:int = 10000
		private var _sfs:SmartFox
		private var _connected:Boolean
		private var _lastIpAddress:String
		private var _lastTcpPort:int 
		private var _reconnectionDelayMillis:int = 1000
		private var _reconnectionSeconds:int = 0
		private var _attemptingReconnection:Boolean = false
		private var _sysController:SystemController
		private var _extController:ExtensionController
		private var _udpManager:IUDPManager
		private var _controllersInited:Boolean = false
		
		private var _useBlueBox:Boolean = false
		private var _connectionMode:String
		private var _firstReconnAttempt:Number = -1;
		private var _reconnCounter:int = 1;
			
		public function BitSwarmClient(sfs:SmartFox = null)
		{
			_controllers = {}
			_sfs = sfs
			_connected = false
			_udpManager = new DefaultUDPManager(sfs)
		}
		
		public function get sfs():SmartFox
		{
			return _sfs
		}
		
		public function get connected():Boolean
		{
			return _connected
		}
		
		public function get connectionMode():String
		{
			return _connectionMode
		}
		
		public function get ioHandler():IoHandler
		{
			return _ioHandler
		}
		
		public function set ioHandler(value:IoHandler):void
		{
			//if (_ioHandler != null)
				//throw new SFSError("IOHandler is already set!")
				
			_ioHandler = value
		}
		
		public function get maxMessageSize():int
		{
			return _maxMessageSize
		}
		
		public function set maxMessageSize(value:int):void
		{
			_maxMessageSize = value
		}
		
		public function get compressionThreshold():int
		{
			return _compressionThreshold	
		}
		
		/*
		* Avoid compressing data whose size is < 100 bytes
		* Ideal default value should be 300 bytes or more...
		*/
		public function set compressionThreshold(value:int):void
		{
			if (value > 100)
				_compressionThreshold = value
			else
				throw new ArgumentError("Compression threshold cannot be < 100 bytes.")
		}
		
		public function get reconnectionDelayMillis():int
		{
			return _reconnectionDelayMillis	
		}
		
		public function get useBlueBox():Boolean
		{
			return _useBlueBox	
		}
		
		public function forceBlueBox(value:Boolean):void
		{
			if (!connected)
				_useBlueBox = value
			else
				throw new IllegalOperationError("You can't change the BlueBox mode while the connection is running");
		}
		
		public function set reconnectionDelayMillis(millis:int):void
		{
			_reconnectionDelayMillis = millis
		}
		
		public function enableBBoxDebug(value:Boolean):void
		{
			_bbClient.isDebug = value
		}
		
		public function init():void
		{
			// Do it once
			if (!_controllersInited)
			{
				initControllers()
				_controllersInited = true
			}

			_socket = new Socket()
			
			if (_socket.hasOwnProperty("timeout")) // condition required to avoide FP < 10.0 to throw an error at runtime
				_socket.timeout = 5000
			
			_socket.addEventListener(Event.CONNECT, onSocketConnect)
			_socket.addEventListener(Event.CLOSE, onSocketClose)
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData)
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError)
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError)
				
			_bbClient = new BBClient()
			_bbClient.addEventListener(BBEvent.CONNECT, onBBConnect)
			_bbClient.addEventListener(BBEvent.DATA, onBBData)
			_bbClient.addEventListener(BBEvent.DISCONNECT, onBBDisconnect)
			_bbClient.addEventListener(BBEvent.IO_ERROR, onBBError)
			_bbClient.addEventListener(BBEvent.SECURITY_ERROR, onBBError)
		}
		
		public function destroy():void
		{
			_socket.removeEventListener(Event.CONNECT, onSocketConnect)
			_socket.removeEventListener(Event.CLOSE, onSocketClose)
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData)
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketIOError)
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError)
			
			if (_socket.connected)
				_socket.close()
				
			_socket = null
		}
		
		public function getController(id:int):IController
		{
			return _controllers[id] as IController
		}
		
		public function get systemController():SystemController
		{
			return _sysController
		}
		
		public function get extensionController():ExtensionController
		{
			return _extController
		}
		
		public function get isReconnecting():Boolean
		{
			return _attemptingReconnection
		}
		
		public function set isReconnecting(value:Boolean):void
		{
			_attemptingReconnection = value	
		}
		
		public function getControllerById(id:int):IController
		{
			return _controllers[id]	
		}
		
		public function get connectionIp():String
		{
			if (!connected)
				return "Not Connected"
			else
				return _lastIpAddress
		}
		
		public function get connectionPort():int
		{
			if (!connected)
				return -1
			else
				return _lastTcpPort
		}
		
		private function addController(id:int, controller:IController):void
		{
			if (controller == null)
				throw new ArgumentError("Controller is null, it can't be added.")
			
			if (_controllers[id] != null)
				throw new ArgumentError("A controller with id: " + id + " already exists! Controller can't be added: " + controller)
				
			_controllers[id] = controller	
		}
		
		public function addCustomController(id:int, controllerClass:Class):void
		{
			var controller:IController = controllerClass(this)
			addController(id, controller)
		}
		
		public function connect(host:String = "127.0.0.1", port:int = 9933):void
		{
			_lastIpAddress = host
			_lastTcpPort = port
				
			if (_useBlueBox)
			{
				_bbClient.pollSpeed = (sfs.config != null) ? sfs.config.blueBoxPollingRate : 750;
				_bbClient.connect(host, port)
				_connectionMode = ConnectionMode.HTTP
			}
			else
			{
				_socket.connect(host, port)
				_connectionMode = ConnectionMode.SOCKET
			}
		}
		
		public function send(message:IMessage):void
		{	
			_ioHandler.codec.onPacketWrite(message)
		}
		
		public function get socket():Socket
		{
			return _socket
		}
		
		public function get httpSocket():BBClient
		{
			return _bbClient
		}
		
		public function disconnect(reason:String = null):void
		{
			if (_useBlueBox)
				_bbClient.close()
			else
			{
				if (socket.connected)
					_socket.close()
			}
					
			onSocketClose(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason:reason}))
		}
		
		public function nextUdpPacketId():Number
		{
			return _udpManager.nextUdpPacketId()
		}
		
		/*
		* Simulates abrupt disconnection
		* For testing/simulations only
		*/
		public function killConnection():void
		{
			_socket.close()
			onSocketClose(new Event(Event.CLOSE))
		}
		
		public function stopReconnection():void
		{
			_attemptingReconnection = false;
			_firstReconnAttempt = -1;
			
			if (_socket.connected)
				_socket.close();
			
			executeDisconnection(null);
		}
		
		public function get udpManager():IUDPManager
		{
			return _udpManager
		}
		
		public function set udpManager(manager:IUDPManager):void
		{
			_udpManager = manager
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Socket handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function initControllers():void
		{
			_sysController = new SystemController(this)
			_extController = new ExtensionController(this)
			
			addController(0, _sysController)
			addController(1, _extController)
		}
		
		public function get reconnectionSeconds():int
		{
			return _reconnectionSeconds
		}
		
		public function set reconnectionSeconds(seconds:int):void
		{
			if (seconds < 0)
				_reconnectionSeconds = 0
			else
				_reconnectionSeconds = seconds	
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Socket handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function onSocketConnect(evt:Event):void
		{
			_connected = true
			
			var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT)
			
			// 2nd argument not publicly documented, used internally
			event.params = {success:true, _isReconnection:_attemptingReconnection}  
			
			dispatchEvent(event)
		}
		
		private function onSocketClose(evt:Event):void
		{
			// Connection is off
			_connected = false
			
			var isRegularDisconnection:Boolean = !_attemptingReconnection && sfs.getReconnectionSeconds() == 0
			var isManualDisconnection:Boolean = (evt is BitSwarmEvent) && (evt as BitSwarmEvent).params.reason == ClientDisconnectionReason.MANUAL

			if (isRegularDisconnection || isManualDisconnection)
			{
				// Reset UDP Manager
				_udpManager.reset()
				_firstReconnAttempt = -1;
				
				executeDisconnection(evt);					
				return
			}
			
			// Already trying to reconnect...
			else if (_attemptingReconnection)
				reconnect();
			
			// First reconnection attempt
			else
			{
			
				/*
				* If we aren't in any of the above three cases then it's time to attempt a
				* reconnection to the server.
				*/
				_attemptingReconnection = true
				_firstReconnAttempt = getTimer();
				_reconnCounter = 1;
					
				// Fire event and retry
				dispatchEvent(new BitSwarmEvent(BitSwarmEvent.RECONNECTION_TRY));
				
				reconnect();
			}
		}
		
		private function reconnect():void
		{
			if (!_attemptingReconnection)
				return;
			
			var reconnectionSeconds:int = sfs.getReconnectionSeconds() * 1000;
			var now:int = getTimer();
			var timeLeft:int = (_firstReconnAttempt + reconnectionSeconds) - now;
			
			if (timeLeft > 0)
			{
				sfs.logger.info("Reconnection attempt:", _reconnCounter, " - time left:", int(timeLeft/1000), "sec.");
	
				// Retry connection: pause 1 second and retry
				setTimeout(function():void {connect(_lastIpAddress, _lastTcpPort)}, _reconnectionDelayMillis);
				_reconnCounter++;
			}
			
			// We are out of time... connection failed :(
			else
			{
				dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason: ClientDisconnectionReason.UNKNOWN}));
			}
		}
		
		private function executeDisconnection(evt:Event):void
		{
			/*
			* A BitSwarmEvent is passed if the disconnection was requested by the server
			* The event includes a reason for the disconnection (idle, kick, ban...)
			*/
			if (evt is BitSwarmEvent)
				dispatchEvent(evt)
				
				/*
				* Disconnection at socket level
				*/
			else
				dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason: ClientDisconnectionReason.UNKNOWN}))
		}
		
		private function onSocketData(evt:ProgressEvent):void
		{
			try
			{
				var buffer:ByteArray = new ByteArray()
				_socket.readBytes(buffer)
			
				_ioHandler.onDataRead(buffer)
			}
			catch (error:SFSError)
			{
				trace("## SocketDataError: " + error.message)
				
				var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.DATA_ERROR)
				event.params = {message:error.message, details: error.details}
				
				dispatchEvent(event)
			}
		}
		
		private function onSocketIOError(evt:IOErrorEvent):void
		{
			trace("## SocketError: " + evt.toString())
			var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR)
			event.params = {message:evt.toString()}
			
			dispatchEvent(event)
		}
		
		private function onSocketSecurityError(evt:SecurityErrorEvent):void
		{
			// Reconnection failure
			if (_attemptingReconnection)
			{
				reconnect();
				return;
			}
			
			trace("## SecurityError: " + evt.toString())
			var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.SECURITY_ERROR)
			event.params = {message:evt.text}
			
			dispatchEvent(event)
		}
		
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// BlueBox handlers
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function onBBConnect(evt:BBEvent):void
		{
			_connected = true
			
			var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT)
			event.params = {success:true}
				
			dispatchEvent(event)		
		}
		
		private function onBBData(evt:BBEvent):void
		{
			var buffer:ByteArray = evt.params.data
			
			if (buffer != null)			
				_ioHandler.onDataRead(buffer)
		}
		
		private function onBBDisconnect(evt:BBEvent):void
		{
			// Connection is off
			_connected = false
				
			// Fire event
			dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason: ClientDisconnectionReason.UNKNOWN}))
		}
		
		private function onBBError(evt:BBEvent):void
		{
			trace("## BlueBox Error: " + evt.params.message)
			var event:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR)
			event.params = {message:evt.params.message}
			
			dispatchEvent(event)
		}		
		
	}
}