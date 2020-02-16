package com.smartfoxserver.v2.entities.match;

/**
 * The<em>StringMatch</em>class is used in matching expressions to check string conditions.
 * 
 * @see MatchExpression
 */
class StringMatch implements IMatcher
{
	private static inline var TYPE_ID:Int = 2;
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1==string2</em>.
	 */
	public static var EQUALS:StringMatch = new StringMatch("==");
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1 !=string2</em>.
	 */
	public static var NOT_EQUALS:StringMatch = new StringMatch("!=");
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1.indexOf(string2)!=-1</em>.
	 */
	public static var CONTAINS:StringMatch = new StringMatch("contains");
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1</em>starts with characters contained in<em>string2</em>.
	 */
	public static var STARTS_WITH:StringMatch = new StringMatch("startsWith");
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1</em>ends with characters contained in<em>string2</em>.
	 */
	public static var ENDS_WITH:StringMatch = new StringMatch("endsWith");
	
	
	/** @private */
	function new(symbol:String)
	{			
		this.symbol = symbol;
		this.type = TYPE_ID;
	}
	
	/** @inheritDoc */
	public var type:Int;

	
	/** @inheritDoc */
	public var symbol:String;

}