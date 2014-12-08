package com.smartfoxserver.v2.entities.match;

/**
 * The<em>BoolMatch</em>class is used in matching expressions to check boolean conditions.
 * 
 * @see MatchExpression
 */
class BoolMatch implements IMatcher
{
	private static inline var TYPE_ID:Int=0
	
	private static var lock:Bool=false
	
	/**
	 * An instance of<em>BoolMatch</em>representing the following condition:<em>bool1==bool2</em>.
	 */
	public static inline var EQUALS:BoolMatch=new BoolMatch("==")
	
	/**
	 * An instance of<em>BoolMatch</em>representing the following condition:<em>bool1 !=bool2</em>.
	 */
	public static inline var NOT_EQUALS:BoolMatch=new BoolMatch("!=")
	
	lock=true
	
	private var _symbol:String
	
	/** @private */
	function new(symbol:String)
	{
		if(lock)
			throw new Dynamic("Cannot instantiate Enum!");
			
		_symbol=symbol	
	}
	
	/** @inheritDoc */
	public var symbol(get_symbol, null):String;
 	private function get_symbol():String
	{
		return _symbol
	}
	
	/** @inheritDoc */
	public var type(get_type, null):Int;
 	private function get_type():Int
	{
		return TYPE_ID;
	}
}