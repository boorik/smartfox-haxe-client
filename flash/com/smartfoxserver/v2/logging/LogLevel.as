package com.smartfoxserver.v2.logging
{
	/**
	 * The <em>LogLevel</em> class contains the costants describing the importance levels of logged messages.
	 */
	public class LogLevel
	{
		/**
		 * A DEBUG message is a fine-grained information on the client activity.
		 */
		public static const DEBUG:int = 100
		
		/**
		 * An INFO message contains informations on the standard client activities.
		 */
		public static const INFO:int = 200
		
		/**
		 * A WARN message is a warning caused by an unexpected behavior of the client.
		 * Client operations are not compromised when a warning is raised.
		 */
		public static const WARN:int = 300
		
		/**
		 * An ERROR message contains informations on a problem that occurred during the client activities.
		 * Client operations might be compromised when an error is raised.
		 */
		public static const ERROR:int = 400
		
		/** @private */
		public static function toString(level:int):String
		{
			var levelStr:String = "Unknown"
			
			if (level == DEBUG)
				levelStr = "DEBUG"
				
			else if (level == INFO)
				levelStr = "INFO"
				
			else if (level == WARN)
				levelStr = "WARN"
				
			else if (level == ERROR)
				levelStr = "ERROR"
				
			return levelStr
		}
		
		/** @private */
		public static function fromString(level:String):int
		{
			level = level.toUpperCase()
			
			if (level == toString(DEBUG))
				return DEBUG
				
			else if (level == toString(INFO))
				return INFO
				
			else if (level == toString(WARN))
				return WARN
				
			else if (level == toString(ERROR))
				return ERROR
			
			else
				return -1;
		}
	}
}