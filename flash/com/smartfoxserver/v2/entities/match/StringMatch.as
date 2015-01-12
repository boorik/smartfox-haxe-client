package com.smartfoxserver.v2.entities.match
{
	/**
	 * The <em>StringMatch</em> class is used in matching expressions to check string conditions.
	 * 
	 * @see MatchExpression
	 */
	public class StringMatch implements IMatcher
	{
		private static const TYPE_ID:int = 2
		
		private static var lock:Boolean = false
		
		/**
		 * An instance of <em>StringMatch</em> representing the following condition: <em>string1 == string2</em>.
		 */
		public static const EQUALS:StringMatch = new StringMatch("==")
		
		/**
		 * An instance of <em>StringMatch</em> representing the following condition: <em>string1 != string2</em>.
		 */
		public static const NOT_EQUALS:StringMatch = new StringMatch("!=")
		
		/**
		 * An instance of <em>StringMatch</em> representing the following condition: <em>string1.indexOf(string2) != -1</em>.
		 */
		public static const CONTAINS:StringMatch = new StringMatch("contains")
		
		/**
		 * An instance of <em>StringMatch</em> representing the following condition: <em>string1</em> starts with characters contained in <em>string2</em>.
		 */
		public static const STARTS_WITH:StringMatch = new StringMatch("startsWith")
		
		/**
		 * An instance of <em>StringMatch</em> representing the following condition: <em>string1</em> ends with characters contained in <em>string2</em>.
		 */
		public static const ENDS_WITH:StringMatch = new StringMatch("endsWith")
		
		lock = true
		
		private var _symbol:String
		
		/** @private */
		function StringMatch(symbol:String)
		{
			if (lock)
				throw new Error("Cannot instantiate Enum!");
				
			_symbol = symbol	
		}
		
		/** @inheritDoc */
		public function get type():int
		{
			return TYPE_ID
		}
		
		/** @inheritDoc */
		public function get symbol():String
		{
			return _symbol
		}
	}
}