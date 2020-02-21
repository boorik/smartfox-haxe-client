package com.smartfoxserver.v2.bitswarm.wsocket;

import com.hurlant.util.Endian;
import haxe.io.Bytes;
import haxe.net.WebSocket;
import com.smartfoxserver.v2.events.EventDispatcher;
import com.smartfoxserver.v2.util.ByteArray;

class WSClient extends EventDispatcher
{
	public var connected(get, never) : Bool;
	public var isDebug(get, set) : Bool;

	private var ws:WebSocket = null;
	private var _debug : Bool = false;
	private var _connected:Bool = false;
	private var _useSSL:Bool = true;

	public function new(debug : Bool = false)
	{
		super();
	}

	private function get_connected() : Bool
	{
		if (ws == null)
		{
			return false;
		}
		return _connected;
	}

	private function get_isDebug() : Bool
	{
		return this._debug;
	}

	private function set_isDebug(value : Bool) : Bool
	{
		this._debug = value;
		return value;
	}

	public var protocol(get, never) : String;

	private function get_protocol():String
	{
		return _useSSL ? "wss://" : "ws://";
	}

	public function connect(url : String, port:Int, useSSL:Bool = false) : Void
	{
		if (connected)
		{
			throw "WebSocket session is already connected";
		}
		_useSSL = useSSL;
		ws = WebSocket.create(protocol + url + ":" + port +"/BlueBox/websocket", null, _debug);
		ws.onopen = function () {
			_connected = true;
			dispatchEvent(new WSEvent(WSEvent.CONNECT, {}));
		};
		ws.onmessageBytes = function(bytes:Bytes) {
			var byteArray:ByteArray = ByteArray.fromBytes(bytes);
			byteArray.endian = Endian.BIG_ENDIAN;
			dispatchEvent(new WSEvent(WSEvent.DATA, {
				data: byteArray
			}));
		};
		ws.onclose = function() {
			dispatchEvent(new WSEvent(WSEvent.CLOSED, { }));
			_connected = false;
			ws = null;
		};
		ws.onerror = function(error:String) {
			var wsEvt : WSEvent = new WSEvent(WSEvent.IO_ERROR, {
				message : error
			});
			dispatchEvent(wsEvt);
			_connected = false;
			ws = null;
		};

		#if (target.threaded)
			sys.thread.Thread.create(() -> {
				runThread();
			});
		#elseif python
			var threadOptions:python.lib.threading.Thread.ThreadOptions = {target: runThread};
			var thread = new python.lib.threading.Thread(threadOptions);
			thread.run();
		#end
	}

	private function runThread():Void
	{
		while(true)
		{
			if(ws == null)
				break; //Kill Thread!
			ws.process();
		}
		trace("WebSocket thread died");
	}

	public function send(binData : ByteArray) : Void
	{
		ws.sendBytes(binData);
	}

	public function close() : Void
	{
		ws.close();
	}
}

