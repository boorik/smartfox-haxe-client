package com.smartfoxserver.v2.entities.data
{
	/**
	 * The <em>SFSDataType</em> class contains the costants defining the data types supported by <em>SFSObject</em> and <em>SFSArray</em> classes.
	 * 
	 * @see		SFSObject
	 * @see		SFSArray
	 */
	public class SFSDataType
	{
		/**
		 * A <code>null</code> value.
		 */
		public static const NULL:int = 0
		
		/**
		 * A <em>Boolean</em> value.
		 */
		public static const BOOL:int = 1
		
		/**
		 * A byte (8 bit) value.
		 * In ActionScript 3 a byte is represented by the <em>int</em> type.
		 */
		public static const BYTE:int = 2
		
		/**
		 * A short integer (16 bit) value.
		 * In ActionScript 3 a short integer is represented by the <em>int</em> type.
		 */
		public static const SHORT:int = 3
		
		/**
		 * An integer (32 bit) value.
		 */
		public static const INT:int = 4
		
		/**
		 * A long integer (64 bit) value.
		 * In ActionScript 3 a long integer is represented by the <em>Number</em> type.
		 */
		public static const LONG:int = 5
		
		/**
		 * A floating point number (32 bit) value.
		 * In ActionScript 3 a floating point number is represented by the <em>Number</em> type.
		 */
		public static const FLOAT:int = 6
		
		/**
		 * A double precision number (64 bit) value.
		 * In ActionScript 3 a double precision number is represented by the <em>Number</em> type.
		 */
		public static const DOUBLE:int = 7
		
		/**
		 * A UTF-8 encoded string value.
		 */
		public static const UTF_STRING:int = 8
		
		/**
		 * An array of <em>Boolean</em> values.
		 */
		public static const BOOL_ARRAY:int = 9
		
		/**
		 * An array of byte values.
		 * 
		 * @see	#BYTE
		 */
		public static const BYTE_ARRAY:int = 10
		
		/**
		 * An array of short integer values.
		 * 
		 * @see	#SHORT
		 */
		public static const SHORT_ARRAY:int = 11
		
		/**
		 * An array of integer values.
		 * 
		 * @see	#INT
		 */
		public static const INT_ARRAY:int = 12
		
		/**
		 * An array of long integer values.
		 * 
		 * @see	#LONG
		 */
		public static const LONG_ARRAY:int = 13
		
		/**
		 * An array of floating point number values.
		 * 
		 * @see	#FLOAT
		 */
		public static const FLOAT_ARRAY:int = 14
		
		/**
		 * An array of double precision number values.
		 * 
		 * @see	#DOUBLE
		 */
		public static const DOUBLE_ARRAY:int = 15
		
		/**
		 * An array of string values.
		 * 
		 * @see	#UTF_STRING
		 */
		public static const UTF_STRING_ARRAY:int = 16
		
		/**
		 * A <em>SFSArray</em> object.
		 * 
		 * @see SFSArray 
		 */
		public static const SFS_ARRAY:int = 17
		
		/**
		 * A <em>SFSObject</em> object.
		 * 
		 * @see SFSObject 
		 */
		public static const SFS_OBJECT:int = 18
		
		/**
		 * A custom class.
		 */
		public static const CLASS:int = 19
		
		private static const TYPE_NAMES:Array = ["NULL" ,"BOOL" ,"BYTE" ,"SHORT" ,"INT" ,"LONG" ,"FLOAT" ,"DOUBLE" ,"UTF_STRING" ,"BOOL_ARRAY" ,"BYTE_ARRAY" ,"SHORT_ARRAY" ,"INT_ARRAY" ,"LONG_ARRAY" ,"FLOAT_ARRAY" ,"DOUBLE_ARRAY" ,"UTF_STRING_ARRAY" ,"SFS_ARRAY" ,"SFS_OBJECT", "CLASS"]
		
		/** @private */
		public static function fromId(id:int):String
		{
			return TYPE_NAMES[id]
		}
	}
}