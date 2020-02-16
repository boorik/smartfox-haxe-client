package com.smartfoxserver.v2.entities.match;

/**
 * The<em>BoolMatch</em>class is used in matching expressions to check boolean conditions.
 * 
 * @see MatchExpression
 */
class BoolMatch implements IMatcher
{
	private static inline var TYPE_ID:Int = 0;

	
	/**
	 * An instance of<em>BoolMatch</em>representing the following condition:<em>bool1==bool2</em>.
	 */
	public static var EQUALS:BoolMatch = new BoolMatch("==");

	/**
	 * An instance of<em>BoolMatch</em>representing the following condition:<em>bool1 !=bool2</em>.
	 */
	public static var NOT_EQUALS:BoolMatch = new BoolMatch("!=");
	
	
	/** @private */
	function new(symbol:String)
	{
		this.symbol = symbol;
		type = TYPE_ID;	
	}
	
	/** @inheritDoc */
	public var symbol:String;

	
	/** @inheritDoc */
	public var type:Int;

}
