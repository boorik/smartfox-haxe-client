package com.smartfoxserver.v2.entities.match;

/**
 * The<em>NumberMatch</em>class is used in matching expressions to check numeric conditions.
 * 
 * @see MatchExpression
 */
class NumberMatch implements IMatcher
{
	private static inline var TYPE_ID:Int=1;
	
	private static var lock:Bool =false;
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1==number2</em>.
	 */
	public static var EQUALS:NumberMatch = new NumberMatch("==");
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 !=number2</em>.
	 */
	public static var NOT_EQUALS:NumberMatch = new NumberMatch("!=");
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &gt;number2</em>.
	 */
	public static var GREATER_THAN:NumberMatch = new NumberMatch(">");
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &gt;=number2</em>.
	 */
	public static var GREATER_THAN_OR_EQUAL_TO:NumberMatch = new NumberMatch(">=");
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &lt;number2</em>.
	 */
	public static var LESS_THAN:NumberMatch = new NumberMatch("<");
	
	/**
	 * An instance of<em>NumberMatch</em>representing the following condition:<em>number1 &lt;=number2</em>.
	 */
	public static var LESS_THAN_OR_EQUAL_TO:NumberMatch = new NumberMatch("<=");

	private static var init = {
        lock = true;
    }
	public var symbol:String;
	
	/** @private */
	function new(symbol:String)
	{
		if(lock)
			throw "Cannot instantiate Enum!";
			
		this.symbol=symbol;
		type = TYPE_ID;
	}

	public var type:Int;

}