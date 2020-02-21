package com.smartfoxserver.v2.util;

import haxe.Timer;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.requests.PingPongRequest;

import com.smartfoxserver.v2.events.Event;
import com.smartfoxserver.v2.events.EventDispatcher;

/**
 * @private
 */
class LagMonitor extends EventDispatcher
{
	private var _lastReqTime:Float;
	private var _valueQueue:Array<Float>;
	private var _interval:Float;
	private var _queueSize:Int;
	private var _thread:Timer;
	private var _sfs:SmartFox;
	
	public function new(sfs:SmartFox, interval:Int=4, queueSize:Int=10)
	{
		super();
		
		if(interval<1)
			interval=1;
		
		_sfs=sfs;
		_valueQueue=[];
		_interval=interval;
		_queueSize=queueSize;
		start();
	}
	
	public function start():Void
	{
		if(!isRunning)
		{
			if(_thread != null)
				_thread.stop();
			_thread = new Timer(cast (_interval * 1000));
			_thread.run = function()
			{
				_lastReqTime=haxe.Timer.stamp();
				_sfs.send(new PingPongRequest());
			};
			_thread.run();
		}
	}
	
	public function stop():Void
	{
		if(isRunning)
			_thread.stop();
	}
	
	public function destroy():Void
	{
		if(_thread !=null)
		{
			stop();
			_thread.stop();
			_thread=null;
			_sfs=null;
		}
	}
	
	public var isRunning(get, null):Bool;
 	private function get_isRunning():Bool
	{
		return (_lastReqTime + (_interval * 1000)) > haxe.Timer.stamp();
	}
	
	public function onPingPong():Float
	{
		// Calculate lag
		var lagValue:Float= 1000. * (haxe.Timer.stamp() - _lastReqTime);
		
		// Remove older value
		if(_valueQueue.length>=_queueSize)
			_valueQueue.shift();
				
		// Add new lag
		_valueQueue.push(lagValue);
			
		return averagePingTime;
	}
	
	public var lastPingTime(get, null):Float;
 	private function get_lastPingTime():Float
	{
		if(_valueQueue.length>0)
			return _valueQueue[_valueQueue.length -1];
		else
			return 0;
	}
	
	public var averagePingTime(get, null):Float;
 	private function get_averagePingTime():Float
	{
		if(_valueQueue.length==0)
			return 0;
		
		var lagAverage:Float=0;
		for(lagValue in _valueQueue)
			lagAverage += lagValue;
				
		return lagAverage / _valueQueue.length;
	}
}
