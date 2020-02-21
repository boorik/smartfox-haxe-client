package com.smartfoxserver.v2.logging;

import com.smartfoxserver.v2.core.BaseEvent;
import com.smartfoxserver.v2.events.Event;

/**
 *<em>LoggerEvent</em>is the class representing all the events dispatched by the SmartFoxServer 2X ActionScript 3 API Internal logger.
 * 
 *<p>The<em>LoggerEvent</em>parent class provides a public property called<em>params</em>which contains specific parameters depending on the event type.</p>
 * 
 * @example	The following example gets a reference to the logger from the main<em>SmartFox</em>class and add a<em>LoggerEvent</em>listener;please refer to the specific event types for the<em>params</em>object content:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	var logger:Logger=sfs.logger;
 * 	logger.addEventListener(LoggerEvent.ERROR, onErrorLogged);
 * }
 * 
 * private function onErrorLogged(evt:LoggerEvent):Void
 * {
 * 	// Write the error message in a log text area in the application Interface
 * 	log.text="The following error occurred:" + evt.params.message;
 * }
 *</listing>
 * 
 * @see 	Logger
 */
class LoggerEvent extends BaseEvent
{
	/**
	 * The<em>LoggerEvent.DEBUG</em>constant defines the value of the<em>type</em>property of the event object for a<em>debug</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The logged debug message.</td></tr>
	 *</table>
	 * 
	 * @eventType	debug
	 */
	public static inline var DEBUG:String = "debug";
	
	/**
	 * The<em>LoggerEvent.INFO</em>constant defines the value of the<em>type</em>property of the event object for a<em>info</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The logged information message.</td></tr>
	 *</table>
	 * 
	 * @eventType	info
	 */
	public static inline var INFO:String = "info";
	
	/**
	 * The<em>LoggerEvent.WARNING</em>constant defines the value of the<em>type</em>property of the event object for a<em>warn</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The logged warning message.</td></tr>
	 *</table>
	 * 
	 * @eventType	warn
	 */
	public static inline var WARNING:String = "warn";
	
	/**
	 * The<em>LoggerEvent.ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>error</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The logged error message.</td></tr>
	 *</table>
	 * 
	 * @eventType	error
	 */
	public static inline var ERROR:String = "error";
	
	
	//========================================================
	
	
	/**
	 * Creates a new<em>LoggerEvent</em>instance.
	 * 
	 * @param	type	The type of event.
	 * @param	params	An object containing the parameters of the event.
	 */
	public function new(type:String, params:Dynamic=null)
	{
		super(type, params);
	}
	
	/**
	 * Duplicates the instance of the<em>LoggerEvent</em>object.
	 * 
	 * @return		A new<em>LoggerEvent</em>object that is identical to the original.
	 */
	public override function clone():Event
	{
		return new LoggerEvent(this.type, this.params);
	}
	
	/**
	 * Generates a string containing all the properties of the<em>LoggerEvent</em>object.
	 * 
	 * @return		A string containing all the properties of the<em>LoggerEvent</em>object.
	 */
	//public override function toString():String
	//{
		//return formatToString("LoggerEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
	//}
}