package com.smartfoxserver.v2.bitswarm.wsocket;

import haxe.io.Bytes;
import haxe.net.WebSocket;
import openfl.errors.IllegalOperationError;
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;

class WSClient extends EventDispatcher
{
	public var connected(get, never) : Bool;
	public var isDebug(get, set) : Bool;

	private var ws:WebSocket = null;
	private var _debug : Bool = false;
	private var _connected:Bool = false;

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

	public function connect(url : String, port:Int) : Void
	{
		if (connected)
		{
			throw new IllegalOperationError("WebSocket session is already connected");
		}
		ws = WebSocket.create("ws://" + url + ":" + port +"/BlueBox/websocket", null, _debug);
		ws.onopen = function () {
			dispatchEvent(new WSEvent(WSEvent.CONNECT, {}));
			_connected = true;
		};
		ws.onmessageBytes = function(bytes:Bytes) {
			dispatchEvent(new WSEvent(WSEvent.DATA, {
				data : ByteArray.fromBytes(bytes)
			}));
		};
		ws.onclose = function() {
			dispatchEvent(new WSEvent(WSEvent.CLOSED, { }));
			_connected = false;
		};
		ws.onerror = function(error:String) {
			var wsEvt : WSEvent = new WSEvent(WSEvent.IO_ERROR, {
				message : error
			});
			dispatchEvent(wsEvt);
			_connected = false;
		};

		#if sys
		sys.thread.Thread.create(() -> {
			while (true) {
				ws.process();
				Sys.sleep(0.1);
			}
		});
		#end
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

