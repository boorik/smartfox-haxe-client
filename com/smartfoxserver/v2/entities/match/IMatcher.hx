package com.smartfoxserver.v2.entities.match;

/**
 * The<em>IMatcher</em>interface defines the properties that an object representing a condition to be used in a matching expression exposes.
 * 
 * @see		MatchExpression
 * @see		BoolMatch
 * @see		NumberMatch
 * @see		StringMatch
 */
interface IMatcher
{
	/**
	 * Returns the condition symbol of this matcher.
	 */
	 var symbol:String;
	
	/**
	 * Returns the type id of this matcher.
	 */
	 var type:Int;
}