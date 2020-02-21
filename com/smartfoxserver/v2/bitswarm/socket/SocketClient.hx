package com.smartfoxserver.v2.bitswarm.socket;
import com.smartfoxserver.v2.util.ByteArray;
import haxe.io.Bytes;
import haxe.net.Socket2;
import haxe.io.Output;
import com.smartfoxserver.v2.events.EventDispatcher;
class SocketClient extends EventDispatcher {
    private var _socket:Socket2;
    private var _useSSL:Bool;
    private var _connected:Bool = false;
    public var connected(get, null):Bool;

    public function get_connected():Bool
    {
        return _connected;
    }

    public function new() {
        super();
    }

    public var socket(get, null):Socket2;

    public function get_socket():Socket2
    {
        return _socket;
    }

    public function connect(ip:String, port:Int, useSSL:Bool = false) : Void
    {
        if (connected)
        {
            throw "Socket session is already connected";
        }
        useSSL = _useSSL;
        _socket = Socket2.create(ip,port, useSSL);
        _socket.ondata = function(bytes:Bytes)
        {
            dispatchEvent(new SocketEvent(SocketEvent.DATA, {
                data : ByteArray.fromBytes(bytes)
            }));
        }
        _socket.onclose = function()
        {
            _connected = false;
            dispatchEvent(new SocketEvent(SocketEvent.CLOSED, {}));
            socket = null;
        }
        _socket.onerror = function()
        {
            _connected = false;
            dispatchEvent(new SocketEvent(SocketEvent.CLOSED, {}));
            socket = null;
        }
        _socket.onconnect = function()
        {
            _connected = true;
            dispatchEvent(new SocketEvent(SocketEvent.CONNECT, {}));
        }
        #if (target.threaded)
                sys.thread.Thread.create(() -> {
                    runThread();
                });
         #elseif python
                trace("python");
                var threadOptions:python.lib.threading.Thread.ThreadOptions = {target: runThread};
                var thread = new python.lib.threading.Thread(threadOptions);
                thread.run();
         #end
    }

    private function runThread()
    {
        while(true)
        {
            if(_socket == null)
                break; //Kill Thread!
            _socket.process();
        }
        trace("Socket thread died");
    }

    public function send(bytes:Bytes):Void
    {
        trace("send");
        _socket.send(bytes);
    }


    public function close():Void
    {
        _socket.close();
    }
}
