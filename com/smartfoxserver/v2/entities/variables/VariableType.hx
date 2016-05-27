package com.smartfoxserver.v2.entities.variables;
import haxe.io.Error;

/**
 * The<em>VariableType</em>class contains the constants defining the valid types of User, Room and Buddy Variables to be passed to their constructors.
 */
class VariableType
{
	/**
	 * The User/Room/Buddy Variable is<code>null</code>.
	 */
	public static inline var NULL:Int = 0;
	
	/**
	 * The type of the User/Room/Buddy Variable is<em>Boolean</em>.
	 */
	public static inline var BOOL:Int = 1;
	
	/**
	 * The type of the User/Room/Buddy Variable is<em>int</em>.
	 */
	public static inline var INT:Int = 2;
	
	/**
	 * The type of the User/Room/Buddy Variable is<em>Number</em>.
	 */
	public static inline var DOUBLE:Int = 3;
	
	/**
	 * The type of the User/Room/Buddy Variable is<em>String</em>.
	 */
	public static inline var STRING:Int = 4;
	
	/**
	 * The type of the User/Room/Buddy Variable is<em>SFSObject</em>.
	 * 
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public static inline var OBJECT:Int = 5;
	
	/**
	 * The type of the User/Room/Buddy Variable is<em>SFSArray</em>.
	 * 
	 * @see		com.smartfoxserver.v2.entities.data.SFSArray SFSArray
	 */
	public static inline var ARRAY:Int = 6;
	
	
	// --------------------------------------------
	
	
	private static inline function TYPES_AS_STRING():Array<String>
	{
		return ["Null", "Bool", "Int", "Double", "String", "Object", "Array"];
	}
	
	/** @private */
	public static function getTypeName(id:Int):String
	{
		return TYPES_AS_STRING()[id];
	}
	
	/** @private */
	public static function getTypeFromName(name:String):Int
	{
		return TYPES_AS_STRING().indexOf(name);
	}
			
	// No instantiation please!
	/** @private */
	public function new()
	{
		throw "This class is not instantiable";
	}
}