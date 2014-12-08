package com.smartfoxserver.v2.entities.match
{
	/**
	 * The <em>IMatcher</em> interface defines the properties that an object representing a condition to be used in a matching expression exposes.
	 * 
	 * @see		MatchExpression
	 * @see		BoolMatch
	 * @see		NumberMatch
	 * @see		StringMatch
	 */
	public interface IMatcher
	{
		/**
		 * Returns the condition symbol of this matcher.
		 */
		function get symbol():String
		
		/**
		 * Returns the type id of this matcher.
		 */
		function get type():int
	}
}