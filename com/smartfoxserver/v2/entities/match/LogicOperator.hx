package com.smartfoxserver.v2.entities.match;

/**
 * The<em>LogicOperator</em>class is used to concatenate two matching expressions using the<b>AND</b>or<b>OR</b>logical operator.
 * 
 * @see MatchExpression
 */
class LogicOperator
{
	/**
	 * An instance of<em>LogicOperator</em>representing the<b>AND</b>logical operator.
	 */
	public static inline function AND():LogicOperator{
		return new LogicOperator("AND");
	}
	
	/**
	 * An instance of<em>LogicOperator</em>representing the<b>OR</b>logical operator.
	 */
	public static inline function OR():LogicOperator{
		return new LogicOperator("OR");
	}
	
	private var _id:String;
	
	/** @private */
	function new(id:String)
	{
		_id = id;
	}
	
	/**
	 * Returns the id of the current<em>LogicOperator</em>instance.
	 * It can be the string "AND" or "OR".
	 */
	public var id(get, null):String;
 	private function get_id():String
	{
		return _id;
	}
}