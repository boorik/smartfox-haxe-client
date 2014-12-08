package com.smartfoxserver.v2.entities.variables
{
	import as3reflect.Type;
	
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.exceptions.SFSError;
	
	/**
	 * The <em>SFSUserVariable</em> object represents a SmartFoxServer User Variable entity on the client.
	 * It is a custom value attached to a <em>User</em> object that gets automatically synchronized between client and server on every change.
	 * 
	 * <p>User Variables are particularly useful to store custom user data that must be "visible" to the other users, such as a profile, a score, a status message, etc.
	 * User Variables can be set by means of the <em>SetUserVariablesRequest</em> request; they support the following data types (also nested):
	 * <em>Boolean</em>, <em>int</em>, <em>Number</em>, <em>String</em>, <em>SFSObject</em>, <em>SFSArray</em>. A User Variable can also be <code>null</code>.</p>
	 * 
	 * @see		com.smartfoxserver.v2.entities.User User
	 * @see		com.smartfoxserver.v2.requests.SetUserVariablesRequest SetUserVariablesRequest
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 * @see		com.smartfoxserver.v2.entities.data.SFSArray SFSArray
	 */
	public class SFSUserVariable implements UserVariable
	{
		/** @private */
		protected var _name:String
		
		/** @private */
		protected var _type:String
		
		/** @private */
		protected var _value:*
		
		/** @private */
		public static function fromSFSArray(sfsa:ISFSArray):UserVariable
		{
			var variable:UserVariable = new SFSUserVariable(
																		sfsa.getUtfString(0), 	// name
																		sfsa.getElementAt(2),	// typed value
																		sfsa.getByte(1)			// type id
																	)
			return variable
		}
		
		/**
		 * Creates a new <em>SFSUserVariable</em> instance.
		 * 
		 * @param 	name	The name of the User Variable.
		 * @param 	value	The value of the User Variable; valid data types are: <em>Boolean</em>, <em>int</em>, <em>Number</em>, <em>String</em>, <em>SFSObject</em>, <em>SFSArray</em>. The value can also be <code>null</code>.
		 * @param 	type	The type of the User Variable among those available in the <em>VariableType</em> class. Usually it is not necessary to pass this parameter, as the type is auto-detected from the value.
		 * 
		 * @see		VariableType
		 */
		function SFSUserVariable(name:String, value:*, type:int = -1)
		{
			_name = name
			
			// If type is specfied let's use it
			if (type > -1)
			{
				_value = value
				_type = VariableType.getTypeName(type)
			}
			
			// Otherwise let's autodetect the type
			else
				setValue(value)	
		}
		
		/** @inheritDoc */
		public function get name():String
		{
			return _name
		}
		
		/** @inheritDoc */
		public function get type():String
		{
			return _type
		}
		
		/** @inheritDoc */
		public function getValue():*
		{
			return _value
		}
		
		/** @inheritDoc */
		public function getBoolValue():Boolean
		{
			return _value as Boolean
		}
		
		/** @inheritDoc */
		public function getIntValue():int
		{
			return _value as int	
		}
		
		/** @inheritDoc */
		public function getDoubleValue():Number
		{
			return _value as Number
		}
		
		/** @inheritDoc */
		public function getStringValue():String
		{
			return _value as String	
		}
		
		/** @inheritDoc */
		public function getSFSObjectValue():ISFSObject
		{
			return _value as ISFSObject	
		}
		
		/** @inheritDoc */
		public function getSFSArrayValue():ISFSArray
		{
			return _value as ISFSArray
		}
		
		/** @inheritDoc */
		public function isNull():Boolean
		{
			return type == VariableType.getTypeName(VariableType.NULL)
		}
		
		/** @private */
		public function toSFSArray():ISFSArray
		{
			var sfsa:ISFSArray = SFSArray.newInstance()
			
			// var name (0)
			sfsa.addUtfString(_name)
			
			// var type (1)
			sfsa.addByte(VariableType.getTypeFromName(_type))
			
			// var value (2)
			populateArrayWithValue(sfsa)
				
			return sfsa
		}
		
		/**
		 * Returns a string that contains the User Variable name, type and value.
		 * 
		 * @return	The string representation of the <em>SFSUserVariable</em> object.
		 */
		public function toString():String
		{
			return "[UVar: " + _name + ", type: " + _type + ", value: " + _value + "]"
		}
		
		private function populateArrayWithValue(arr:ISFSArray):void
		{
			var typeId:int = VariableType.getTypeFromName(_type)
			
			switch(typeId)
			{
				case VariableType.NULL:
					arr.addNull()
					break
					
				case VariableType.BOOL:
					arr.addBool(getBoolValue())
					break
					
				case VariableType.INT:
					arr.addInt(getIntValue())
					break
					
				case VariableType.DOUBLE:
					arr.addDouble(getDoubleValue())
					break
					
				case VariableType.STRING:
					arr.addUtfString(getStringValue())
					break
					
				case VariableType.OBJECT:
					arr.addSFSObject(getSFSObjectValue())
					break
					
				case VariableType.ARRAY:
					arr.addSFSArray(getSFSArrayValue())
					break				
			}
		}
		
		private function setValue(value:*):void
		{
			_value = value
			
			if (value == null)
				_type = VariableType.getTypeName( VariableType.NULL )
				
			else
			{
				var typeName:String = typeof value
				
				if (typeName == "boolean")
					_type = VariableType.getTypeName( VariableType.BOOL )
				
				// Check if number is Int or Double
				else if (typeName == "number")
				{
					// check if is int or double
					if (int(value) == value)
						_type = VariableType.getTypeName( VariableType.INT )
					else
						_type = VariableType.getTypeName( VariableType.DOUBLE )
				}
				
				else if (typeName == "string")
					_type = VariableType.getTypeName( VariableType.STRING )
				
				// Check which type of object is this	
				else if (typeName == "object")
				{
					var className:String = Type.forInstance(value).name
					
					if (className == "SFSObject")
						_type = VariableType.getTypeName( VariableType.OBJECT )
						
					else if (className == "SFSArray")
						_type = VariableType.getTypeName( VariableType.ARRAY )
						
					else 
						throw new SFSError("Unsupport SFS Variable type: " + className)		
				}
			}	
		}	
	}
}