package com.smartfoxserver.v2.logging;

import flash.events.EventDispatcher;

//--------------------------------------
//  Events
//--------------------------------------

/**
 * Dispatched when a message of level<em>DEBUG</em>is logged.
 * The<em>enableEventDispatching</em>property must be<code>true</code>.
 * 
 * @eventType com.smartfoxserver.v2.logging.LoggerEvent.DEBUG
 * 
 * @see		#enableEventDispatching
 * @see		LogLevel#DEBUG
 * @see		com.smartfoxserver.v2.logging.LoggerEvent#DEBUG LoggerEvent.DEBUG
 */ 
//[Event(name="debug", type="com.smartfoxserver.v2.logging.LoggerEvent")]

/**
 * Dispatched when a message of level<em>INFO</em>is logged.
 * The<em>enableEventDispatching</em>property must be<code>true</code>.
 * 
 * @eventType com.smartfoxserver.v2.logging.LoggerEvent.INFO
 * 
 * @see		#enableEventDispatching
 * @see		LogLevel#INFO
 * @see		com.smartfoxserver.v2.logging.LoggerEvent#INFO LoggerEvent.INFO
 */ 
//[Event(name="info", type="com.smartfoxserver.v2.logging.LoggerEvent")]

/**
 * Dispatched when a message of level<em>WARN</em>is logged.
 * The<em>enableEventDispatching</em>property must be<code>true</code>.
 * 
 * @eventType com.smartfoxserver.v2.logging.LoggerEvent.WARN
 * 
 * @see		#enableEventDispatching
 * @see		LogLevel#WARN
 * @see		com.smartfoxserver.v2.logging.LoggerEvent#WARN LoggerEvent.WARN
 */ 
//[Event(name="warn", type="com.smartfoxserver.v2.logging.LoggerEvent")]

/**
 * Dispatched when a message of level<em>ERROR</em>is logged.
 * The<em>enableEventDispatching</em>property must be<code>true</code>.
 * 
 * @eventType com.smartfoxserver.v2.logging.LoggerEvent.ERROR
 * 
 * @see		#enableEventDispatching
 * @see		LogLevel#ERROR
 * @see		com.smartfoxserver.v2.logging.LoggerEvent#ERROR LoggerEvent.ERROR
 */ 
//[Event(name="error", type="com.smartfoxserver.v2.logging.LoggerEvent")]

//--------------------------------------
//  Class
//--------------------------------------

/**
 * The Internal logger used by the SmartFoxServer 2X client API.
 * This is a singleton class.
 * 
 *<p>You can get a reference to the<em>Logger</em>by means of the<em>SmartFox.logger</em>property.
 * Accessing the logger can be useful to control the client-side logging level,
 * enable or disable the output towards the Adobe Flash or Flash/Flex Builder console and
 * enable or disable the events dispatching. When logger events are enabled, you can add your own listeners to this class,
 * in order to have a lower access to logged messages(for example you could display them in a dedicated panel in the application Interface).</p>
 * 
 * @see		LoggerEvent
 * @see		com.smartfoxserver.v2.SmartFox#logger SmartFox#logger
 */
class Logger extends EventDispatcher
{
	private var _enableConsoleTrace:Bool = true;
	private var _enableEventDispatching:Bool = false;
	private var _loggingLevel:Int = LogLevel.INFO;
	private var _loggingPrefix:String;
	
	/** @private */
	function new(prefix:String="SFS2X")
	{
		super();
		_loggingPrefix = prefix;
	}
	
	/**
	 * Indicates whether or not the output of logged messages to the console window of Adobe Flash and Flex/Flash Builder is enabled.
	 */
	public var enableConsoleTrace(get, set):Bool;
 	private function get_enableConsoleTrace():Bool
	{
		return _enableConsoleTrace;
	}
	
	/** @private */
	private function set_enableConsoleTrace(value:Bool):Bool
	{
		return _enableConsoleTrace = value;
	}
	
	/**
	 * Indicates whether dispatching of log events is enabled or not.
	 * 
	 * @see 	#event:debug debug event
	 * @see 	#event:info info event
	 * @see 	#event:warn warn event
	 * @see 	#event:error error event
	 */
	public var enableEventDispatching(get, set):Bool;
 	private function get_enableEventDispatching():Bool
	{
		return _enableEventDispatching;
	}
	
	/** @private */
	private function set_enableEventDispatching(value:Bool):Bool
	{
		return _enableEventDispatching = value;
	}
	
	/**
	 * Determines the current logging level.
	 * Messages with a level lower than this value are not logged.
	 * The available log levels are contained in the<em>LogLevel</em>class.
	 * 
	 * @see		LogLevel
	 */
	public var loggingLevel(get, set):Int;
 	private function get_loggingLevel():Int
	{
		return _loggingLevel;	
	}
	
	/** @private */
	private function set_loggingLevel(level:Int):Int
	{
		return _loggingLevel = level;
	}
	
	/** @private */
	public function debug(msg:String, ?pos:haxe.PosInfos):Void
	{
		log(LogLevel.DEBUG, msg, pos);
	}
	
	/** @private */
	public function info(msg:String, ?pos:haxe.PosInfos):Void
	{
		log(LogLevel.INFO, msg, pos);
	}
	
	/** @private */
	public function warn(msg:String, ?pos:haxe.PosInfos):Void
	{
		log(LogLevel.WARN, msg, pos);
	}
	
	/** @private */
	public function error(msg:String, ?pos:haxe.PosInfos):Void
	{
		log(LogLevel.ERROR, msg, pos);
	}
	
	/**
	 * Traces a log message in the console and dispatches the related event.
	 */
	private function log(level:Int, message:String, pos:haxe.PosInfos):Void
	{
		if(level<_loggingLevel)
			return;
		
		var levelStr:String = LogLevel.toString(level);
		
		// Trace message in console
		if(_enableConsoleTrace)
			haxe.Log.trace("[" + _loggingPrefix + "|" + levelStr + "] " + message, pos);
		
		if(_enableEventDispatching)
		{
			// Dispatch event
			var params:Dynamic = { };
			params.message = message;
			params.pos = pos;

			var evt:LoggerEvent = new LoggerEvent(levelStr.toLowerCase(), params);
			dispatchEvent(evt);
		}
	}
}