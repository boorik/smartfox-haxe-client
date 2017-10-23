package com.smartfoxserver.v2.entities.match;

/**
 * The<em>StringMatch</em>class is used in matching expressions to check string conditions.
 * 
 * @see MatchExpression
 */
#if html5 
 @:native('SFS2X.StringMatch')
 extern #end 
class StringMatch implements IMatcher
{
	private static inline var TYPE_ID:Int = 2;
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1==string2</em>.
	 */
	public static var EQUALS:StringMatch #if html5 ; #else = new StringMatch("==");#end
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1 !=string2</em>.
	 */
	public static var NOT_EQUALS:StringMatch  #if html5 ; #else = new StringMatch("!=");#end
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1.indexOf(string2)!=-1</em>.
	 */
	public static var CONTAINS:StringMatch #if html5 ; #else = new StringMatch("contains");#end
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1</em>starts with characters contained in<em>string2</em>.
	 */
	public static var STARTS_WITH:StringMatch #if html5 ; #else = new StringMatch("startsWith");#end
	
	/**
	 * An instance of<em>StringMatch</em>representing the following condition:<em>string1</em>ends with characters contained in<em>string2</em>.
	 */
	public static var ENDS_WITH:StringMatch #if html5 ; #else = new StringMatch("endsWith");#end
	
	
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