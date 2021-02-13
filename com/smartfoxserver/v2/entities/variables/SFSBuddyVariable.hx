package com.smartfoxserver.v2.entities.variables;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.exceptions.SFSError;
import Type;

/**
 * The<em>SFSBuddyVariable</em>object represents a SmartFoxServer Buddy Variable entity on the client.
 * It is a custom value attached to a<em>Buddy</em>object in a Buddy List that gets automatically synchronized between client and server on every change.
 * 
 *<p>Buddy Variables work with the same principle of the User and Room Variables. The only difference is the logic by which they get propagated to other users.
 * While Room and User Variables are usually broadcast to all clients in the same Room, Buddy Variables updates are sent to all users who have the owner of the Buddy Variable in their Buddy Lists.</p>
 * 
 *<p>Buddy Variables are particularly useful to store custom user data that must be "visible" to the buddies only, such as a profile, a score, a status message, etc.
 * Buddy Variables can be set by means of the<em>SetBuddyVariablesRequest</em>request;they support the following data types(also nested):
 *<em>Boolean</em>,<em>int</em>,<em>Number</em>,<em>String</em>,<em>SFSObject</em>,<em>SFSArray</em>. A Buddy Variable can also be<code>null</code>.</p>
 * 
 *<p>There is also a special convention that allows Buddy Variables to be set as "offline".
 * Offline Buddy Variables are persistent values which are made available to all users who have the owner in their Buddy Lists, whether that Buddy is online or not.
 * In order to make a Buddy Variable persistent, its name should start with a dollar sign(<code>$</code>).
 * This conventional character is contained in the<em>OFFLINE_PREFIX</em>constant.</p>
 * 
 * @see		#OFFLINE_PREFIX
 * @see		com.smartfoxserver.v2.entities.Buddy Buddy
 * @see		com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest SetBuddyVariablesRequest
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 * @see		com.smartfoxserver.v2.entities.data.SFSArray SFSArray
 */
class SFSBuddyVariable implements BuddyVariable
{
	/**
	 * The prefix to be added to a Buddy Variable name to make it persistent.
	 * A persistent Buddy Variable is made available to all users who have the owner in their Buddy Lists, whether that Buddy is online or not.
	 */
	public static inline var OFFLINE_PREFIX:String = "$";
	
	/** @private */
	private var _name:String;
	
	/** @private */
	private var _type:String;
	
	/** @private */
	private var _value:Dynamic;
	
	/** @private */
	public static function fromSFSArray(sfsa:ISFSArray):BuddyVariable
	{
		var variable:SFSBuddyVariable=new SFSBuddyVariable(
																	sfsa.getUtfString(0), 	// name
																	sfsa.getElementAt(2),	// typed value
																	sfsa.getByte(1)			// type id
															);
		return variable;
	}
	
	/**
	 * Creates a new<em>SFSBuddyVariable</em>instance.
	 * 
	 * @param 	name	The name of the Buddy Variable.
	 * @param 	value	The value of the Buddy Variable;valid data types are:<em>Boolean</em>,<em>int</em>,<em>Number</em>,<em>String</em>,<em>SFSObject</em>,<em>SFSArray</em>. The value can also be<code>null</code>.
	 * @param 	type	The type of the Buddy Variable among those available in the<em>VariableType</em>class. Usually it is not necessary to pass this parameter, as the type is auto-detected from the value.
	 * 
	 * @see		VariableType
	 */
	public function new(name:String, value:Dynamic, type:Int=-1)
	{
		_name = name;
		
		// If type is specfied let's use it
		if(type>-1)
		{
			_value = value;
			_type = VariableType.getTypeName(type);
		}
		
		// Otherwise let's autodetect the type
		else
			setValue(value);
	}
	
	/** @inheritDoc */
	public var isOffline(get, null):Bool;
 	private function get_isOffline():Bool
	{
		return _name.charAt(0) == "$";
	}

	/** @inheritDoc */
	public var name(get, null):String;
 	private function get_name():String
	{
		return _name;
	}
	
	/** @inheritDoc */
	public var type(get, null):String;
 	private function get_type():String
	{
		return _type;
	}
	
	/** @inheritDoc */
	public function getValue():Dynamic
	{
		return _value;
	}
	
	/** @inheritDoc */
	public function getBoolValue():Bool
	{
		return  cast(_value, Bool);
	}
	
	/** @inheritDoc */
	public function getIntValue():Int
	{
		return cast(_value, Int);	
	}
	
	/** @inheritDoc */
	public function getDoubleValue():Float
	{
		return cast(_value, Float);
	}
	
	/** @inheritDoc */
	public function getStringValue():String
	{
		return cast(_value, String);	
	}
	
	/** @inheritDoc */
	public function getSFSObjectValue():ISFSObject
	{
		return cast(_value, ISFSObject);	
	}
	
	/** @inheritDoc */
	public function getSFSArrayValue():ISFSArray
	{
		return cast(_value, ISFSArray);
	}
	
	/** @inheritDoc */
	public function isNull():Bool
	{
		return type == VariableType.getTypeName(VariableType.NULL);
	}
	
	/** @private */
	public function toSFSArray():ISFSArray
	{
		var sfsa:ISFSArray = SFSArray.newInstance();
		
		// var name(0)
		sfsa.addUtfString(_name);
		
		// var type(1)
		sfsa.addByte(VariableType.getTypeFromName(_type));
		
		// var value(2)
		populateArrayWithValue(sfsa);
			
		return sfsa;
	}
	
	/**
	 * Returns a string that contains the Buddy Variable name, type and value.
	 * 
	 * @return	The string representation of the<em>SFSBuddyVariable</em>object.
	 */
	public function toString():String
	{
		return "[BuddyVar:" + _name + ", type:" + _type + ", value:" + _value + "]";
	}
	
	private function populateArrayWithValue(arr:ISFSArray):Void
	{
		var typeId:Int = VariableType.getTypeFromName(_type);
		
		switch(typeId)
		{
			case VariableType.NULL:
				arr.addNull();
				
			case VariableType.BOOL:
				arr.addBool(getBoolValue());
				
			case VariableType.INT:
				arr.addInt(getIntValue());
				
			case VariableType.DOUBLE:
				arr.addDouble(getDoubleValue());
				
			case VariableType.STRING:
				arr.addUtfString(getStringValue());
				
			case VariableType.OBJECT:
				arr.addSFSObject(getSFSObjectValue());
				
			case VariableType.ARRAY:
				arr.addSFSArray(getSFSArrayValue());
		}
	}
	
	private function setValue(value:Dynamic):Void
	{
		_value = value;
		
		if(value==null)
			_type = VariableType.getTypeName(VariableType.NULL);
			
		else
		{
			var typeValue = Type.typeof(value);
			
			switch(typeValue) {
				case ValueType.TBool:
					_type = VariableType.getTypeName(VariableType.BOOL);
				case ValueType.TFloat:
					_type = VariableType.getTypeName(VariableType.DOUBLE);
				case ValueType.TClass(c):
					switch(Type.getClassName(c)) {
						case "String":
							_type = VariableType.getTypeName(VariableType.STRING);
						case "SFSObject":
							_type = VariableType.getTypeName(VariableType.OBJECT);
						case "SFSArray":
							_type = VariableType.getTypeName(VariableType.ARRAY);
						default:
							throw new SFSError("Unsupport SFS Variable type:" + typeValue);
					}
				default:
					throw new SFSError("Unsupport SFS Variable type:" + typeValue);
					
			}
		}
	}
}