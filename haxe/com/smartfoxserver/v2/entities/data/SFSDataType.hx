package com.smartfoxserver.v2.entities.data;

/**
 * The<em>SFSDataType</em>class contains the costants defining the data types supported by<em>SFSObject</em>and<em>SFSArray</em>classes.
 * 
 * @see		SFSObject
 * @see		SFSArray
 */
class SFSDataType
{
	/**
	 * A<code>null</code>value.
	 */
	public static inline var NULL:Int = 0;
	
	/**
	 * A<em>Boolean</em>value.
	 */
	public static inline var BOOL:Int = 1;
	
	/**
	 * A byte(8 bit)value.
	 * In ActionScript 3 a byte is represented by the<em>int</em>type.
	 */
	public static inline var BYTE:Int = 2;
	
	/**
	 * A short Integer(16 bit)value.
	 * In ActionScript 3 a short Integer is represented by the<em>int</em>type.
	 */
	public static inline var SHORT:Int = 3;
	
	/**
	 * An Integer(32 bit)value.
	 */
	public static inline var INT:Int = 4;
	
	/**
	 * A long Integer(64 bit)value.
	 * In ActionScript 3 a long Integer is represented by the<em>Number</em>type.
	 */
	public static inline var LONG:Int = 5;
	
	/**
	 * A floating point number(32 bit)value.
	 * In ActionScript 3 a floating point number is represented by the<em>Number</em>type.
	 */
	public static inline var FLOAT:Int = 6;
	
	/**
	 * A double precision number(64 bit)value.
	 * In ActionScript 3 a double precision number is represented by the<em>Number</em>type.
	 */
	public static inline var DOUBLE:Int = 7;
	
	/**
	 * A UTF-8 encoded string value.
	 */
	public static inline var UTF_STRING:Int = 8;
	
	/**
	 * An array of<em>Boolean</em>values.
	 */
	public static inline var BOOL_ARRAY:Int = 9;
	
	/**
	 * An array of byte values.
	 * 
	 * @see	#BYTE
	 */
	public static inline var BYTE_ARRAY:Int = 10;
	
	/**
	 * An array of short Integer values.
	 * 
	 * @see	#SHORT
	 */
	public static inline var SHORT_ARRAY:Int = 11;
	
	/**
	 * An array of Integer values.
	 * 
	 * @see	#INT
	 */
	public static inline var INT_ARRAY:Int = 12;
	
	/**
	 * An array of long Integer values.
	 * 
	 * @see	#LONG
	 */
	public static inline var LONG_ARRAY:Int = 13;
	
	/**
	 * An array of floating point number values.
	 * 
	 * @see	#FLOAT
	 */
	public static inline var FLOAT_ARRAY:Int = 14;
	
	/**
	 * An array of double precision number values.
	 * 
	 * @see	#DOUBLE
	 */
	public static inline var DOUBLE_ARRAY:Int = 15;
	
	/**
	 * An array of string values.
	 * 
	 * @see	#UTF_STRING
	 */
	public static inline var UTF_STRING_ARRAY:Int = 16;
	
	/**
	 * A<em>SFSArray</em>object.
	 * 
	 * @see SFSArray 
	 */
	public static inline var SFS_ARRAY:Int = 17;
	
	/**
	 * A<em>SFSObject</em>object.
	 * 
	 * @see SFSObject 
	 */
	public static inline var SFS_OBJECT:Int = 18;
	
	/**
	 * A custom class.
	 */
	public static inline var CLASS:Int = 19;
	
	private static inline function TYPE_NAMES():Array<Dynamic>
	{
		return ["NULL" , "BOOL" , "BYTE" , "SHORT" , "INT" , "LONG" , "FLOAT" , "DOUBLE" , "UTF_STRING" , "BOOL_ARRAY" , "BYTE_ARRAY" , "SHORT_ARRAY" , "INT_ARRAY" , "LONG_ARRAY" , "FLOAT_ARRAY" , "DOUBLE_ARRAY" , "UTF_STRING_ARRAY" , "SFS_ARRAY" , "SFS_OBJECT", "CLASS"];
	}
	
	/** @private */
	public static function fromId(id:Int):String
	{
		return TYPE_NAMES()[id];
	}
}