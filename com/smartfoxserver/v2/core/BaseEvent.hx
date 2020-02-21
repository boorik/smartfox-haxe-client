package com.smartfoxserver.v2.core;

import com.smartfoxserver.v2.events.Event;

/**
 * This is the base class of all the events dispatched by the SmartFoxServer 2X ActionScript 3 API.
 * In particular, check the<b>SFSEvent</b>and<b>SFSBuddyEvent</b>children classes for more informations.
 * 
 * @see 	SFSEvent
 * @see 	SFSBuddyEvent
 * @see 	com.smartfoxserver.v2.logging.LoggerEvent LoggerEvent
 */
class BaseEvent extends Event
{
	/**
	 * Specifies the object containing the parameters of the event.
	 */
	public var params:Dynamic;
	
	/**
	 * @private
	 * 
	 * Creates a new<em>BaseEvent</em>instance.
	 * 
	 * @param	type	The type of event.
	 * @param	params	An object containing the parameters of the event.
	 */
	public function new(type:String, params:Dynamic=null)
	{
		super(type);
		this.params = params;
	}
	
	/**
	 * @private
	 * 
	 * Duplicates the instance of the<em>BaseEvent</em>object.
	 * 
	 * @return		A new<em>BaseEvent</em>object that is identical to the original.
	 */
	public override function clone():Event
	{
		return new BaseEvent(this.type, this.params);
	}
}