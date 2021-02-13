package com.smartfoxserver.v2.entities.variables;

import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.exceptions.SFSError;

/**
 * The <em>BaseVariable</em> object is the base class for all SmartFoxServer Variable entities on the client.
 *
 * @see		com.smartfoxserver.v2.entities.variables.SFSUserVariable SFSUserVariable
 * @see		com.smartfoxserver.v2.entities.variables.SFSRoomVariable SFSRoomVariable
 * @see		com.smartfoxserver.v2.entities.variables.SFSBuddyVariable SFSBuddyVariable
 * @see		com.smartfoxserver.v2.entities.variables.MMOItemVariable MMOItemVariable
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 * @see		com.smartfoxserver.v2.entities.data.SFSArray SFSArray
 */
class BaseVariable implements Variable
{
	@:isVar public var name(get, null) : String;
	@:isVar public var type(get, null) : String;

	/** @private */
	private var _value : Dynamic;


	/**
	 * Creates a new <em>BaseVariable</em> instance.
	 *
	 * @param 	name	The name of the Variable.
	 * @param 	value	The value of the Variable; valid data types are: <em>Boolean</em>, <em>int</em>, <em>Number</em>, <em>String</em>, <em>SFSObject</em>, <em>SFSArray</em>. The value can also be <code>null</code>.
	 * @param 	type	The type of the Variable among those available in the <em>VariableType</em> class. Usually it is not necessary to pass this parameter, as the type is auto-detected from the value.
	 *
	 * @see		VariableType
	 *
	 * @private
	 */
	public function new(name : String, value : Dynamic, type : Int = -1)
	{
		this.name = name;  // If type is specfied let's use it



		if (type > -1)
		{
			_value = value;
			this.type = VariableType.getTypeName(type);
		}
			// Otherwise let's autodetect the type
		else
		{

			setValue(value);
		}
	}

	/** @inheritDoc */
	private function get_name() : String
	{
		return this.name;
	}

	/** @inheritDoc */
	private function get_type() : String
	{
		return this.type;
	}

	/** @inheritDoc */
	public function getValue() : Dynamic
	{
		return _value;
	}

	/** @inheritDoc */
	public function getBoolValue() : Bool
	{
		return try cast(_value, Bool) catch(e:Dynamic) null;
	}

	/** @inheritDoc */
	public function getIntValue() : Int
	{
		return Std.parseInt(_value);
	}

	/** @inheritDoc */
	public function getDoubleValue() : Float
	{
		return Std.parseFloat(_value);
	}

	/** @inheritDoc */
	public function getStringValue() : String
	{
		return Std.string(_value);
	}

	/** @inheritDoc */
	public function getSFSObjectValue() : ISFSObject
	{
		return try cast(_value, ISFSObject) catch(e:Dynamic) null;
	}

	/** @inheritDoc */
	public function getSFSArrayValue() : ISFSArray
	{
		return try cast(_value, ISFSArray) catch(e:Dynamic) null;
	}

	/** @inheritDoc */
	public function isNull() : Bool
	{
		return type == VariableType.getTypeName(VariableType.NULL);
	}

	/** @private */
	public function toSFSArray() : ISFSArray
	{
		var sfsa : ISFSArray = SFSArray.newInstance();  // var name (0)



		sfsa.addUtfString(this.name);  // var type (1)



		sfsa.addByte(VariableType.getTypeFromName(this.type));  // var value (2)



		populateArrayWithValue(sfsa);

		return sfsa;
	}

	// ---------------------------------------------------------------------------------------------------------

	private function populateArrayWithValue(arr : ISFSArray) : Void
	{
		var typeId : Int = VariableType.getTypeFromName(this.type);

		switch (typeId)
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

	private function setValue(value : Dynamic) : Void
	{
		_value = value;

		if (value == null)
		{
			this.type = VariableType.getTypeName(VariableType.NULL);
		}
		else
		{
			var typeName : String = Type.typeof(value); //TODO: Fix typeof!

			

			if (typeName == "boolean")
			{
				this.type = VariableType.getTypeName(VariableType.BOOL);
				// Check if number is Int or Double
			}
			else if (typeName == "number")
			{
				// check if is int or double

				if (Std.parseInt(value) == value)
				{
					this.type = VariableType.getTypeName(VariableType.INT);
				}
				else
				{
					this.type = VariableType.getTypeName(VariableType.DOUBLE);
				}
			}
			else if (typeName == "string")
			{
				this.type = VariableType.getTypeName(VariableType.STRING);
				// Check which type of object is this
			}
			else if (typeName == "object")
			{
				var className : String = Type.getClassName(value); //TODO: Check this!

				if (className == "SFSObject")
				{
					this.type = VariableType.getTypeName(VariableType.OBJECT);
				}
				else if (className == "SFSArray")
				{
					this.type = VariableType.getTypeName(VariableType.ARRAY);
				}
				else
				{
					throw new SFSError("Unsupport SFS Variable type: " + className);
				}
			}
		}
	}
}
