package com.smartfoxserver.v2.util
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.requests.PingPongRequest;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.events.TimeEvent;
	
	/**
	 * @private
	 */
	public class LagMonitor extends EventDispatcher
	{
		private var _lastReqTime:int;
		private var _valueQueue:Array;
		private var _interval:int;
		private var _queueSize:int;
		private var _thread:Timer;
		private var _sfs:SmartFox;
		
		public function LagMonitor(sfs:SmartFox, interval:int = 4, queueSize:int = 10)
		{
			if (interval < 1)
				interval = 1;
			
			_sfs = sfs;
			_valueQueue = [];
			_interval = interval;
			_queueSize = queueSize;
			_thread = new Timer(interval * 1000);
			_thread.addEventListener(TimerEvent.TIMER, threadRunner);	
		}
		
		public function start():void
		{
			if (!isRunning)
				_thread.start();
		}
		
		public function stop():void
		{
			if (isRunning)
				_thread.stop();
		}
		
		public function destroy():void
		{
			if (_thread != null)
			{
				stop();
				_thread.removeEventListener(TimerEvent.TIMER, threadRunner);
				_thread = null;
				_sfs = null;
			}
		}
		
		public function get isRunning():Boolean
		{
			return _thread.running
		}
		
		public function onPingPong():int
		{
			// Calculate lag
			var lagValue:int = getTimer() - _lastReqTime;
			
			// Remove older value
			if (_valueQueue.length >= _queueSize)
				_valueQueue.shift()
					
			// Add new lag
			_valueQueue.push(lagValue)
				
			return averagePingTime;
		}
		
		public function get lastPingTime():int
		{
			if (_valueQueue.length > 0)
				return _valueQueue[_valueQueue.length -1];
			else
				return 0;
		}
		
		public function get averagePingTime():int
		{
			if (_valueQueue.length == 0)
				return 0;
			
			var lagAverage:int = 0;
			for each (var lagValue:int in _valueQueue)
				lagAverage += lagValue
					
			return lagAverage / _valueQueue.length;
		}
		
		
		// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function threadRunner(evt:Event):void
		{
			_lastReqTime = getTimer();
			_sfs.send(new PingPongRequest());
		}
	}
}