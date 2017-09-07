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
	
	
	/** @private */
	function new(symbol:String)
	{
		if(lock)
			throw "Cannot instantiate Enum!";
			
		this.symbol = symbol;
	}
	
	/** @inheritDoc */
	public var type:Int;

	
	/** @inheritDoc */
	public var symbol:String;

}