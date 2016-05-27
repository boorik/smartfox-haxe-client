package com.smartfoxserver.v2.entities.match;

/**
 * The<em>StringMatch</em>class is used in matching expressions to check string conditions.
 * 
 * @see MatchExpression
 */
class StringMatch implements IMatcher
{
	private static inline var TYPE_ID:Int = 2;
	
	private static var lock:Bool = true;
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1==string2</em>.
	 */
	public static inline function EQUALS():StringMatch{
		return new StringMatch("==");
	}
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1 !=string2</em>.
	 */
	public static inline function NOT_EQUALS():StringMatch {
		return new StringMatch("!=");
	}
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1.indexOf(string2)!=-1</em>.
	 */
	public static inline function CONTAINS():StringMatch {
		return new StringMatch("contains");
	}
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1</em>starts with characters contained in<em>string2</em>.
	 */
	public static inline function STARTS_WITH():StringMatch {
		return new StringMatch("startsWith");
	}
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1</em>ends with characters contained in<em>string2</em>.
	 */
	public static inline function ENDS_WITH():StringMatch {
		return new StringMatch("endsWith");
	}
	
	private var _symbol:String;
	
	/** @private */
	function new(symbol:String)
	{
		if(lock)
			throw "Cannot instantiate Enum!";
			
		_symbol = symbol;
	}
	
	/** @inheritDoc */
	public var type(get_type, null):Int;
 	private function get_type():Int
	{
		return TYPE_ID;
	}
	
	/** @inheritDoc */
	public var symbol(get_symbol, null):String;
 	private function get_symbol():String
	{
		return _symbol;
	}
}