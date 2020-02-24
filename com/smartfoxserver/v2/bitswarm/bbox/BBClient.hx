package com.smartfoxserver.v2.bitswarm.bbox;

//import com.hurlant.util.Base64;
import com.hurlant.util.Endian;
import com.smartfoxserver.v2.events.Event;
import com.smartfoxserver.v2.events.EventDispatcher;
import com.smartfoxserver.v2.util.ByteArray;
import haxe.crypto.Base64;
import haxe.Timer;
import haxe.Http;

/** @private */
class BBClient extends EventDispatcher
{
	private static inline var BB_DEFAULT_HOST:String="localhost";
	private static inline var BB_DEFAULT_PORT:Int=8080;
	private static inline var BB_SERVLET:String="BlueBox/BlueBox.do";
	private static inline var BB_NULL:String="null";
	
	private static inline var CMD_CONNECT:String="connect";
	private static inline var CMD_POLL:String="poll";
	private static inline var CMD_DATA:String="data";
	private static inline var CMD_DISCONNECT:String="disconnect";
	private static inline var ERR_INVALID_SESSION:String="err01";
	
	private static inline var SFS_HTTP:String="sfsHttp";
	private static inline var SEP:String="|";
	private static inline var MIN_POLL_SPEED:Int=50;// ms
	private static inline var MAX_POLL_SPEED:Int=5000;// ms
	private static inline var DEFAULT_POLL_SPEED:Int=300;// ms
	
	private var _isConnected:Bool=false;
	private var _host:String=BB_DEFAULT_HOST;
	private var _port:Int=BB_DEFAULT_PORT;
	private var _bbUrl:String;
	private var _debug:Bool;
	private var _sessId:String;
	private var _pollSpeed:Int;
	private var _useSSL:Bool;
	
	public function new(host:String="localhost", port:Int=8080, debug:Bool=false)
	{
		super();
		
		_pollSpeed = DEFAULT_POLL_SPEED;
		
		_host=host;
		_port=port;
		_debug=debug;
	}
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Getters / Setters
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	public var isConnected(get, null):Bool;
 	private function get_isConnected():Bool
	{
		return _sessId !=null;		
	}
	
	public var isDebug(get, set):Bool;
 	private function get_isDebug():Bool
	{
		return _debug;		
	}
	
	public var host(get, set):String;
 	private function get_host():String
	{
		return _host;		
	}
	private function set_host(value:String):String
	{
		return _host = value;		
	}
	public var port(get, set):Int;
 	private function get_port():Int
	{
		return _port;		
	}
	 private function set_port(value:Int):Int
	{
		return _port = value;		
	}
	public var sessionId(get, set):String;
 	private function get_sessionId():String
	{
		return _sessId;		
	}
	private function set_sessionId(value:String):String
	{
		return _sessId = value;		
	}
	public var pollSpeed(get, set):Int;
	
 	private function get_pollSpeed():Int
	{
		return _pollSpeed;
	}
	
	private function set_pollSpeed(value:Int):Int
	{
		return _pollSpeed=((value>=MIN_POLL_SPEED && value<=MAX_POLL_SPEED)? value:DEFAULT_POLL_SPEED);
	}
	
	private function set_isDebug(value:Bool):Bool
	{
		return _debug = value;
	}
	
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Public methods
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	public function connect(host:String="127.0.0.1", port:Int=8080, useSSL:Bool = false):Void
	{
		if(isConnected)
			throw "BlueBox session is already connected";

		_useSSL = useSSL;
		
		_host = host;
		_port = port;
			
		_bbUrl = get_protocol() + _host + ":" + port + "/" + BB_SERVLET;
			
		sendRequest(CMD_CONNECT);
	}

	private function get_protocol():String
	{
		return _useSSL ? "https://" : "http://";
	}
	
	public function send(binData:ByteArray):Void
	{
		if(!isConnected)
			throw "Can't send data, BlueBox connection is not active";
		
		sendRequest(CMD_DATA, binData);
	}
	
	/*
	* Initiate a disconnection from client
	*/
	public function disconnect():Void
	{
		sendRequest(CMD_DISCONNECT);
	}
	
	/*
	* Handle a disconnection initiated from server
	*/
	public function close():Void
	{
		handleConnectionLost(false);
	}
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Private methods
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function poll():Void
	{
		sendRequest(CMD_POLL);
	}
	
	private function sendRequest(cmd:String, data:ByteArray=null):Void
	{
		var vars:String =  encodeRequest(cmd, data);
		// Create HTTP loader and send

		var httpLoader:Http = getLoader(_bbUrl);
		httpLoader.setPostData(SFS_HTTP + "=" + vars);
		httpLoader.addHeader("Content-Type","application/x-www-form-urlencoded");
		httpLoader.request(true);

		if(_debug)
			trace("[BB-Send]:" + vars);
	}
	
	private function getLoader(url:String):Http
	{
		var httpLoader:Http = new Http(url);
		//httpLoader.cnxTimeout = 30;
		httpLoader.onError = function(msg:String)
		{
			var bbEvt:BBEvent = new BBEvent(BBEvent.IO_ERROR, {message:msg});
			dispatchEvent(bbEvt);
		};
		httpLoader.onData = function(rawData:String)
		{
			if(_debug)
				trace("[ BB-Receive ]:" + rawData);

			// Obtain splitted params
			var reqBits:Array<Dynamic>=rawData.split(SEP);

			var cmd:String=reqBits[0];
			var data:String=reqBits[1];

			if(cmd==CMD_CONNECT) {
				_sessId=data;
				_isConnected=true;

				dispatchEvent(new BBEvent(BBEvent.CONNECT, { } ));

				// Start the polling cycle
				poll();
			} else if(cmd==CMD_POLL) {
				var binData:ByteArray = null;

				// Decode Base64-Encoded string to real ByteArray
				if(data !=BB_NULL)
					binData = decodeResponse(data);

				// Pre-launch next polling request
				if(_isConnected)
				{
					Timer.delay(poll, _pollSpeed);
				}

				// Dispatch the event
				dispatchEvent(new BBEvent(BBEvent.DATA, { data:binData } ));
			} else if(cmd==ERR_INVALID_SESSION) {
				// Connection was lost
				handleConnectionLost();
			}
		}
		return httpLoader;
	}
	
	private function handleConnectionLost(fireEvent:Bool=true):Void
	{
		if(_isConnected)
		{
			_isConnected=false;
			_sessId=null;
		
			// Fire event to Bitswarm client
			if(fireEvent)
				dispatchEvent(new BBEvent(BBEvent.DISCONNECT, {}));
		}
	}
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Message Codec
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function encodeRequest(cmd:String, byteArray:ByteArray=null):String
	{
		var encoded:String="";
		var data:String;
		
		if(cmd==null)
			cmd=BB_NULL;
		
		if(byteArray==null)
			data = BB_NULL;
		else
			data = Base64.encode(byteArray.getBytes());

		encoded +=(_sessId==null ? BB_NULL:_sessId)+ SEP + cmd + SEP + data;
		return encoded;
	}
	
	private function decodeResponse(rawData:String):ByteArray
	{
		/*
		if(rawData.substr(0, SFS_HTTP.length)!=SFS_HTTP)
			throw new ArgumentError("Unexpected Response format. Missing BlueBox header:" +(rawData.length<1024 ? rawData:"[too big data]"));
		*/

		var byteArray:ByteArray = ByteArray.fromBytes(Base64.decode(rawData));
		byteArray.endian = Endian.BIG_ENDIAN;
		return byteArray;
	}
	
	
}