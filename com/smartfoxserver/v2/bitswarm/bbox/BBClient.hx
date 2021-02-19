package com.smartfoxserver.v2.bitswarm.bbox;

//import com.hurlant.util.Base64;

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
import haxe.crypto.Base64;
import haxe.Timer;

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
	private var _loader:URLLoader;
	private var _urlRequest:URLRequest;
	private var _pollSpeed:Int;
	
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
	
	public function connect(host:String="127.0.0.1", port:Int=8080):Void
	{
		if(isConnected)
			throw new IllegalOperationError("BlueBox session is already connected");
		
		_host = host;
		_port = port;
			
		_bbUrl = "http://" + _host + ":" + port + "/" + BB_SERVLET;
			
		sendRequest(CMD_CONNECT);
	}
	
	public function send(binData:ByteArray):Void
	{
		if(!isConnected)
			throw new IllegalOperationError("Can't send data, BlueBox connection is not active");
		
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
	// Event handlers methods
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function onHttpResponse(evt:Event):Void
	{
		var loader:URLLoader=cast evt.target;
		var rawData:String=cast loader.data;
		
		if(_debug)
			trace("[ BB-Receive ]:" + rawData);
		
		// Obtain splitted params
		var reqBits:Array<Dynamic>=rawData.split(SEP);
		
		var cmd:String=reqBits[0];
		var data:String=reqBits[1];
		
		if(cmd==CMD_CONNECT)
		{
			_sessId=data;
			_isConnected=true;
			
			dispatchEvent(new BBEvent(BBEvent.CONNECT, { } ));
			
			// Start the polling cycle
			poll();
		}
		
		else if(cmd==CMD_POLL)
		{
			var binData:ByteArray = null;
			
			// Decode Base64-Encoded string to real ByteArray
			if(data !=BB_NULL)
				binData = decodeResponse(data);
				
			// Pre-launch next polling request
			if(_isConnected)
				Timer.delay(poll, _pollSpeed);
				
			// Dispatch the event
			dispatchEvent(new BBEvent(BBEvent.DATA, { data:binData } ));
		}
		
		// Connection was lost
		else if(cmd==ERR_INVALID_SESSION)
		{
			handleConnectionLost();
		}
		
	}
	
	private function onHttpIOError(evt:IOErrorEvent):Void
	{
		var bbEvt:BBEvent=new BBEvent(BBEvent.IO_ERROR, {message:evt.text});
		dispatchEvent(bbEvt);
	}
	
	private function onSecurityError(evt:SecurityErrorEvent):Void
	{
		var bbEvt:BBEvent=new BBEvent(BBEvent.IO_ERROR, {message:evt.text});
		dispatchEvent(bbEvt);
	}
	
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Private methods
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	private function poll():Void
	{
		sendRequest(CMD_POLL);
	}
	
	private function sendRequest(cmd:String, data:Dynamic=null):Void
	{
		// Prepare request
		_urlRequest=new URLRequest(_bbUrl);
		_urlRequest.method=URLRequestMethod.POST;
		
		// Encode request variables
		var vars:URLVariables=new URLVariables();
		Reflect.setField(vars, SFS_HTTP, encodeRequest(cmd, data));
		_urlRequest.data=vars;
		
		if(_debug)
			trace("[ BB-Send ]:" + vars);
		
		// Create HTTP loader and send
		var urlLoader:URLLoader=getLoader();
		urlLoader.data=vars;
		urlLoader.load(_urlRequest);
	}
	
	private function getLoader():URLLoader
	{
		var urlLoader:URLLoader=new URLLoader();
		
		urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
		urlLoader.addEventListener(Event.COMPLETE, onHttpResponse);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onHttpIOError);
		//urlLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, onHttpIOError);
		urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		
		return urlLoader;
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
	private function encodeRequest(cmd:String, data:Dynamic=null):String
	{
		var encoded:String="";
		
		if(cmd==null)
			cmd=BB_NULL;
		
		if(data==null)
			data=BB_NULL;
		
		// Encode from ByteArray to Base64-String
		#if flash
		else if(Std.isOfType(data, ByteArray))
			data = Base64.encode(haxe.io.Bytes.ofData(cast(data, ByteArray)));
		#else
		else if(Std.isOfType(data, openfl.utils.ByteArray.ByteArrayData))
			data = Base64.encode(data);
		#end
		
		encoded +=(_sessId==null ? BB_NULL:_sessId)+ SEP + cmd + SEP + data;
		
		return encoded;
	}
	
	private function decodeResponse(rawData:String):ByteArray
	{
		/*
		if(rawData.substr(0, SFS_HTTP.length)!=SFS_HTTP)
			throw new ArgumentError("Unexpected Response format. Missing BlueBox header:" +(rawData.length<1024 ? rawData:"[too big data]"));
		*/
		#if flash
		return Base64.decode(rawData).getData();
		#else
		return ByteArray.fromBytes(Base64.decode(rawData));
		#end
	}
	
	
}