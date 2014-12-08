package com.smartfoxserver.v2.entities.match
{
	/**
	 * The <em>NumberMatch</em> class is used in matching expressions to check numeric conditions.
	 * 
	 * @see MatchExpression
	 */
	public class NumberMatch implements IMatcher
	{
		private static const TYPE_ID:int = 1
		
		private static var lock:Boolean = false
		
		/**
		 * An instance of <em>NumberMatch</em> representing the following condition: <em>number1 == number2</em>.
		 */
		public static const EQUALS:NumberMatch = new NumberMatch("==")
		
		/**
		 * An instance of <em>NumberMatch</em> representing the following condition: <em>number1 != number2</em>.
		 */
		public static const NOT_EQUALS:NumberMatch = new NumberMatch("!=")
		
		/**
		 * An instance of <em>NumberMatch</em> representing the following condition: <em>number1 &gt; number2</em>.
		 */
		public static const GREATER_THAN:NumberMatch = new NumberMatch(">")
		
		/**
		 * An instance of <em>NumberMatch</em> representing the following condition: <em>number1 &gt;= number2</em>.
		 */
		public static const GREATER_THAN_OR_EQUAL_TO:NumberMatch = new NumberMatch(">=")
		
		/**
		 * An instance of <em>NumberMatch</em> representing the following condition: <em>number1 &lt; number2</em>.
		 */
		public static const LESS_THAN:NumberMatch = new NumberMatch("<")
		
		/**
		 * An instance of <em>NumberMatch</em> representing the following condition: <em>number1 &lt;= number2</em>.
		 */
		public static const LESS_THAN_OR_EQUAL_TO:NumberMatch = new NumberMatch("<=")
		
		lock = true
		
		private var _symbol:String
		
		/** @private */
		function NumberMatch(symbol:String)
		{
			if (lock)
				throw new Error("Cannot instantiate Enum!");
				
			_symbol = symbol	
		}
		
		/** @inheritDoc */
		public function get symbol():String
		{
			return _symbol
		}
		
		/** @inheritDoc */
		public function get type():int
		{
			return TYPE_ID	
		}
	}
}