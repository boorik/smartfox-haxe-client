package com.smartfoxserver.v2.bitswarm.wsocket;

import openfl.events.Event;
import openfl.Lib;
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
	private var _useWSS:Bool = true;

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
		return _useWSS ? "wss://" : "ws://";
	}

	public function connect(url : String, port:Int, useWSS:Bool) : Void
	{
		if (connected)
		{
			throw new IllegalOperationError("WebSocket session is already connected");
		}
		_useWSS = useWSS;
		ws = WebSocket.create(protocol + url + ":" + port +"/BlueBox/websocket", null, _debug);
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
			_connected = false;
			dispatchEvent(new WSEvent(WSEvent.CLOSED, { }));
		};
		ws.onerror = function(error:String) {
			_connected = false;
			var wsEvt : WSEvent = new WSEvent(WSEvent.IO_ERROR, {
				message : error
			});
			dispatchEvent(wsEvt);
		};

		#if (target.threaded)
			Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		#end
	}

	private function onEnterFrame(e:Event):Void
	{
		//trace("onEnterFrame");
		ws.process();
	}

	public function send(binData : ByteArray) : Void
	{
		binData.position = 0;
		ws.sendBytes(binData);
	}

	public function close() : Void
	{
		ws.close();
	}
}

