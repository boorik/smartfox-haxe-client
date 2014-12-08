package com.smartfoxserver.v2.entities.match;

/**
 * The<em>NumberMatch</em>class is used in matching expressions to check numeric conditions.
 * 
 * @see MatchExpression
 */
class FloatMatch implements IMatcher
{
	private static inline var TYPE_ID:Int=1
	
	private static var lock:Bool=false
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1==number2</em>.
	 */
	public static inline var EQUALS:FloatMatch=new FloatMatch("==")
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 !=number2</em>.
	 */
	public static inline var NOT_EQUALS:FloatMatch=new FloatMatch("!=")
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &gt;number2</em>.
	 */
	public static inline var GREATER_THAN:FloatMatch=new FloatMatch(">")
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &gt;=number2</em>.
	 */
	public static inline var GREATER_THAN_OR_EQUAL_TO:FloatMatch=new FloatMatch(">=")
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &lt;number2</em>.
	 */
	public static inline var LESS_THAN:FloatMatch=new FloatMatch("<")
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &lt;=number2</em>.
	 */
	public static inline var LESS_THAN_OR_EQUAL_TO:FloatMatch=new FloatMatch("<=")
	
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
		return TYPE_ID	
	}
}