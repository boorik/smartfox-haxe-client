package com.smartfoxserver.v2.bitswarm.bbox
{
	import com.hurlant.util.Base64;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	/** @private */
	public class BBClient extends EventDispatcher
	{
		private const BB_DEFAULT_HOST:String = "localhost";
		private const BB_DEFAULT_PORT:int = 8080;
		private const BB_SERVLET:String = "BlueBox/BlueBox.do";
		private const BB_NULL:String = "null";
		
		private const CMD_CONNECT:String = "connect";
		private const CMD_POLL:String = "poll";
		private const CMD_DATA:String = "data";
		private const CMD_DISCONNECT:String = "disconnect";
		private const ERR_INVALID_SESSION:String = "err01";
		
		private const SFS_HTTP:String = "sfsHttp";
		private const SEP:String = "|";
		private const MIN_POLL_SPEED:int = 50; // ms
		private const MAX_POLL_SPEED:int = 5000; // ms
		private const DEFAULT_POLL_SPEED:int = 300; // ms
		
		private var _isConnected:Boolean = false;
		private var _host:String = BB_DEFAULT_HOST;
		private var _port:int = BB_DEFAULT_PORT;
		private var _bbUrl:String;
		private var _debug:Boolean;
		private var _sessId:String;
		private var _loader:URLLoader;
		private var _urlRequest:URLRequest;
		private var _pollSpeed:int = DEFAULT_POLL_SPEED; 
		
		public function BBClient(host:String = "localhost", port:int = 8080, debug:Boolean = false)
		{
			_host = host;
			_port = port;
			_debug = debug;
		}
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Getters / Setters
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		public function get isConnected():Boolean
		{
			return _sessId != null;		
		}
		
		public function get isDebug():Boolean
		{
			return _debug;		
		}
		
		public function get host():String
		{
			return _host;		
		}
		
		public function get port():int
		{
			return _port;		
		}
		
		public function get sessionId():String
		{
			return _sessId;		
		}
		
		public function get pollSpeed():int
		{
			return _pollSpeed;
		}
		
		public function set pollSpeed(value:int):void
		{
			_pollSpeed = (value >= MIN_POLL_SPEED && value <= MAX_POLL_SPEED) ? value : DEFAULT_POLL_SPEED;
		}
		
		public function set isDebug(value:Boolean):void
		{
			_debug = value
		}
		
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Public methods
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		public function connect(host:String = "127.0.0.1", port:int = 8080):void
		{
			if (isConnected)
				throw new IllegalOperationError("BlueBox session is already connected");
			
			_host = host
			_port = port
				
			_bbUrl = "http://" + _host + ":" + port + "/" + BB_SERVLET
				
			sendRequest(CMD_CONNECT)
		}
		
		public function send(binData:ByteArray):void
		{
			if (!isConnected)
				throw new IllegalOperationError("Can't send data, BlueBox connection is not active");
			
			sendRequest(CMD_DATA, binData);
		}
		
		/*
		* Initiate a disconnection from client
		*/
		public function disconnect():void
		{
			sendRequest(CMD_DISCONNECT);
		}
		
		/*
		* Handle a disconnection initiated from server
		*/
		public function close():void
		{
			handleConnectionLost(false)
		}
		
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Event handlers methods
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function onHttpResponse(evt:Event):void
		{
			var loader:URLLoader = evt.target as URLLoader;
			var rawData:String = loader.data as String;
			
			if (_debug)
				trace("[ BB-Receive ]: " + rawData)
			
			// Obtain splitted params
			var reqBits:Array = rawData.split(SEP);
			
			var cmd:String = reqBits[0];
			var data:String = reqBits[1];
			
			if (cmd == CMD_CONNECT)
			{
				_sessId = data;
				_isConnected = true;
				
				dispatchEvent( new BBEvent(BBEvent.CONNECT, {}) )
				
				// Start the polling cycle
				poll();
			}
			
			else if (cmd == CMD_POLL)
			{
				var binData:ByteArray = null
				
				// Decode Base64-Encoded string to real ByteArray
				if (data != BB_NULL)
					binData = decodeResponse(data)
					
				// Pre-launch next polling request
				if (_isConnected)
					setTimeout(poll, _pollSpeed);
					
				// Dispatch the event
				dispatchEvent( new BBEvent(BBEvent.DATA, {data:binData}) )
			}
			
			// Connection was lost
			else if (cmd == ERR_INVALID_SESSION)
			{
				handleConnectionLost()
			}
			
		}
		
		private function onHttpIOError(evt:IOErrorEvent):void
		{
			var bbEvt:BBEvent = new BBEvent(BBEvent.IO_ERROR, {message:evt.text});
			dispatchEvent(bbEvt);
		}
		
		private function onSecurityError(evt:SecurityErrorEvent):void
		{
			var bbEvt:BBEvent = new BBEvent(BBEvent.IO_ERROR, {message:evt.text});
			dispatchEvent(bbEvt);
		}
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private methods
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function poll():void
		{
			sendRequest(CMD_POLL);
		}
		
		private function sendRequest(cmd:String, data:* = null):void
		{
			// Prepare request
			_urlRequest = new URLRequest(_bbUrl);
			_urlRequest.method = URLRequestMethod.POST;
			
			// Encode request variables
			var vars:URLVariables = new URLVariables();
			vars[SFS_HTTP] = encodeRequest(cmd, data);
			_urlRequest.data = vars;
			
			if (_debug)
				trace("[ BB-Send ]: " + vars[SFS_HTTP]);
			
			// Create HTTP loader and send
			var urlLoader:URLLoader = getLoader();
			urlLoader.data = vars;
			urlLoader.load(_urlRequest);
		}
		
		private function getLoader():URLLoader
		{
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onHttpResponse);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onHttpIOError);
			urlLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, onHttpIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			return urlLoader
		}
		
		private function handleConnectionLost(fireEvent:Boolean = true):void
		{
			if (_isConnected)
			{
				_isConnected = false;
				_sessId = null;
			
				// Fire event to Bitswarm client
				if (fireEvent)
					dispatchEvent( new BBEvent(BBEvent.DISCONNECT, {}) );
			}
		}
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Message Codec
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function encodeRequest(cmd:String, data:* = null):String
		{
			var encoded:String = "";
			
			if (cmd == null)
				cmd = BB_NULL;
			
			if (data == null)
				data = BB_NULL;
			
			// Encode from ByteArray to Base64-String
			else if (data is ByteArray)
				data = Base64.encodeByteArray(data)
			
			encoded += (_sessId == null ? BB_NULL : _sessId) + SEP + cmd + SEP + data;
			
			return encoded;
		}
		
		private function decodeResponse(rawData:String):ByteArray
		{
			/*
			if (rawData.substr(0, SFS_HTTP.length) != SFS_HTTP)
				throw new ArgumentError("Unexpected Response format. Missing BlueBox header: " + (rawData.length < 1024 ? rawData : "[too big data]"));
			*/
			return Base64.decodeToByteArray(rawData);			
		}
		
		
	}
}