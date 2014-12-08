package com.smartfoxserver.v2.entities.variables
{
	/**
	 * The <em>VariableType</em> class contains the constants defining the valid types of User, Room and Buddy Variables to be passed to their constructors.
	 */
	public class VariableType
	{
		/**
		 * The User/Room/Buddy Variable is <code>null</code>.
		 */
		public static const NULL:int = 0
		
		/**
		 * The type of the User/Room/Buddy Variable is <em>Boolean</em>.
		 */
		public static const BOOL:int = 1
		
		/**
		 * The type of the User/Room/Buddy Variable is <em>int</em>.
		 */
		public static const INT:int = 2
		
		/**
		 * The type of the User/Room/Buddy Variable is <em>Number</em>.
		 */
		public static const DOUBLE:int = 3
		
		/**
		 * The type of the User/Room/Buddy Variable is <em>String</em>.
		 */
		public static const STRING:int = 4
		
		/**
		 * The type of the User/Room/Buddy Variable is <em>SFSObject</em>.
		 * 
		 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
		 */
		public static const OBJECT:int = 5
		
		/**
		 * The type of the User/Room/Buddy Variable is <em>SFSArray</em>.
		 * 
		 * @see		com.smartfoxserver.v2.entities.data.SFSArray SFSArray
		 */
		public static const ARRAY:int = 6
		
		
		// --------------------------------------------
		
		
		private static const TYPES_AS_STRING:Array = ["Null", "Bool", "Int", "Double", "String", "Object", "Array"]
		
		/** @private */
		public static function getTypeName(id:int):String
		{
			return TYPES_AS_STRING[id]
		}
		
		/** @private */
		public static function getTypeFromName(name:String):int
		{
			return TYPES_AS_STRING.indexOf(name)
		}
				
		// No instantiation please!
		/** @private */
		public function VariableType()
		{
			throw new Error("This class is not instantiable")
		}
	}
}