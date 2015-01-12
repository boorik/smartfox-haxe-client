package com.smartfoxserver.v2.entities.match
{
	/**
	 * The <em>BoolMatch</em> class is used in matching expressions to check boolean conditions.
	 * 
	 * @see MatchExpression
	 */
	public class BoolMatch implements IMatcher
	{
		private static const TYPE_ID:int = 0
		
		private static var lock:Boolean = false
		
		/**
		 * An instance of <em>BoolMatch</em> representing the following condition: <em>bool1 == bool2</em>.
		 */
		public static const EQUALS:BoolMatch = new BoolMatch("==")
		
		/**
		 * An instance of <em>BoolMatch</em> representing the following condition: <em>bool1 != bool2</em>.
		 */
		public static const NOT_EQUALS:BoolMatch = new BoolMatch("!=")
		
		lock = true
		
		private var _symbol:String
		
		/** @private */
		function BoolMatch(symbol:String)
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
			return TYPE_ID;
		}
	}
}