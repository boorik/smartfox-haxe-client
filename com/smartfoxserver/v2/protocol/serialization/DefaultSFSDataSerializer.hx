package com.smartfoxserver.v2.protocol.serialization;

import flash.utils.ByteArray;
/*
#if html5
@native(_DataSerializer.SFSDataSerializer)
extern class DefaultSFSDataSerializer
{
	static var instance:DefaultSFSDataSerializer;

	inline static function getInstance():DefaultSFSDataSerializer
	{
		return instance;
	}
	function object2binary(o:Dynamic):ByteArray;
	function binary2object(b:ByteArray):Dynamic;
}
#else
**/
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSDataType;
import com.smartfoxserver.v2.entities.data.SFSDataWrapper;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSCodecError;
import openfl.utils.Endian;

/** @private */
class DefaultSFSDataSerializer implements ISFSDataSerializer
{
	private static inline var CLASS_MARKER_KEY:String = "$C";
	private static inline var CLASS_FIELDS_KEY:String = "$F";
	private static inline var FIELD_NAME_KEY:String = "N";
	private static inline var FIELD_VALUE_KEY:String = "V";

	private static var _instance:DefaultSFSDataSerializer ;
	private static var _lock:Bool = true;

	public static function getInstance():DefaultSFSDataSerializer
	{
		if(_instance==null)
		{
			_lock = false;
			_instance = new DefaultSFSDataSerializer();
			_lock = true;
		}

		return _instance;
	}

	public function new()
	{
		if(_lock)
			throw "Can't use constructor, please use getInstance()method";
	}

	/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *  SFSObject==>Binary
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	public function object2binary(obj:ISFSObject):ByteArray
	{
		var buffer:ByteArray = new ByteArray();
		buffer.endian = Endian.BIG_ENDIAN;//fix for new openfl version
		buffer.writeByte(SFSDataType.SFS_OBJECT);
		buffer.writeShort(obj.size());

		return obj2bin(obj, buffer);
	}

	private function obj2bin(obj:ISFSObject, buffer:ByteArray):ByteArray
	{
		var keys:Array<String> = obj.getKeys();
		var wrapper:SFSDataWrapper;

		for(key in keys)
		{
			wrapper = obj.getData(key);
			// Store the key
			buffer = encodeSFSObjectKey(buffer, key);
			// Convert 2 binary
			buffer = encodeObject(buffer, wrapper.type, wrapper.data);
		}

		return buffer;
	}

	/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *  SFSArray<Dynamic>==>Binary
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	public function array2binary(array:ISFSArray):ByteArray
	{
		var buffer:ByteArray = new ByteArray();
		buffer.endian = Endian.BIG_ENDIAN;
		buffer.writeByte(SFSDataType.SFS_ARRAY);
		buffer.writeShort(array.size());

		return arr2bin(array, buffer);
	}

	private function arr2bin(array:ISFSArray, buffer:ByteArray):ByteArray
	{
		var wrapper:SFSDataWrapper;

		for(i in 0...array.size())
		{
			wrapper = array.getWrappedElementAt(i);
			buffer = encodeObject(buffer, wrapper.type, wrapper.data)	;
		}

		return buffer;
	}

	/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *  Binary==>SFSObject
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	public function binary2object(data:ByteArray):ISFSObject
	{
		if(data.length<3)
			throw new SFSCodecError("Can't decode an SFSObject. Byte data is insufficient. Size:" + data.length + " byte(s)");
		data.position = 0;
		return decodeSFSObject(data);
	}

	private function decodeSFSObject(buffer:ByteArray):ISFSObject
	{
		var sfsObject:SFSObject = SFSObject.newInstance();

		// Get tpyeId
		var headerByte:Int = buffer.readByte();

		// Validate typeId
		if(headerByte !=SFSDataType.SFS_OBJECT)
			throw new SFSCodecError("Invalid SFSDataType. Expected:" + SFSDataType.SFS_OBJECT + ", found:" + headerByte);

		var size:Int = buffer.readShort();

		// Validate size
		if(size<0)
			throw new SFSCodecError("Can't decode SFSObject. Size is negative:" + size);

		/*
		 * NOTE:we catch codec exceptions OUTSIDE of the loop
		 * meaning that any exception of that type will stop the process of looping through the
		 * object data and immediately discard the whole packet of data.
		 */

		try
		{
			for(i in 0...size)
			{
				// Decode object key
				var key:String = buffer.readUTF();
				// Decode the next object
				var decodedObject:SFSDataWrapper = decodeObject(buffer);

				// Store decoded object and keep going
				if(decodedObject !=null)
					sfsObject.put(key, decodedObject);
				else
					throw new SFSCodecError("Could not decode value for SFSObject with key:" + key);
			}
		}
		catch(err:SFSCodecError)
		{
			throw err;
		}

		return sfsObject;
	}

	/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *  Binary==>SFSArray
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	public function binary2array(data:ByteArray):ISFSArray
	{
		if(data.length<3)
			throw new SFSCodecError("Can't decode an SFSArray. Byte data is insufficient. Size:" + data.length + " byte(s)");

		data.position = 0;
		return decodeSFSArray(data);
	}

	private function decodeSFSArray(buffer:ByteArray):ISFSArray
	{
		var sfsArray:ISFSArray = SFSArray.newInstance();

		// Get tpyeId
		var headerByte:Int = buffer.readByte();

		// Validate typeId
		if(headerByte !=SFSDataType.SFS_ARRAY)
			throw new SFSCodecError("Invalid SFSDataType. Expected:" + SFSDataType.SFS_ARRAY + ", found:" + headerByte);

		var size:Int = buffer.readShort();

		// Validate size
		if(size<0)
			throw new SFSCodecError("Can't decode SFSArray. Size is negative:" + size);

		/*
		 * NOTE:we catch codec exceptions OUTSIDE of the loop
		 * meaning that any exception of that type will stop the process of looping through the
		 * object data and immediately discard the whole packet of data.
		 */

		try
		{
			for(i in 0...size)
			{
				// Decode the next object
				var decodedObject:SFSDataWrapper = decodeObject(buffer);

				// Store decoded object and keep going
				if(decodedObject !=null)
					sfsArray.add(decodedObject);
				else
					throw new SFSCodecError("Could not decode SFSArray item at index:" + i);
			}
		}
		catch(err:SFSCodecError)
		{
			throw err;
		}

		return sfsArray;
	}

	/*
 	* The buffer pointer(position)must located on the 1st byte of the object to decode
 	* Throws SFSCodecException
 	*/
	private function decodeObject(buffer:ByteArray):SFSDataWrapper
	{
		var decodedObject:SFSDataWrapper;
		var headerByte:Int = buffer.readByte();

		if(headerByte==SFSDataType.NULL)
			decodedObject = binDecode_NULL(buffer);

		else if(headerByte==SFSDataType.BOOL)
			decodedObject = binDecode_BOOL(buffer);

		else if(headerByte==SFSDataType.BOOL_ARRAY)
			decodedObject = binDecode_BOOL_ARRAY(buffer);

		else if(headerByte==SFSDataType.BYTE)
			decodedObject = binDecode_BYTE(buffer);

		else if(headerByte==SFSDataType.BYTE_ARRAY)
			decodedObject = binDecode_BYTE_ARRAY(buffer);

		else if(headerByte==SFSDataType.SHORT)
			decodedObject = binDecode_SHORT(buffer);

		else if(headerByte==SFSDataType.SHORT_ARRAY)
			decodedObject = binDecode_SHORT_ARRAY(buffer);

		else if(headerByte==SFSDataType.INT)
			decodedObject = binDecode_INT(buffer);

		else if(headerByte==SFSDataType.INT_ARRAY)
			decodedObject = binDecode_INT_ARRAY(buffer);

		else if(headerByte==SFSDataType.LONG)
			decodedObject = binDecode_LONG(buffer);

		else if(headerByte==SFSDataType.LONG_ARRAY)
			decodedObject = binDecode_LONG_ARRAY(buffer);

		else if(headerByte==SFSDataType.FLOAT)
			decodedObject = binDecode_FLOAT(buffer);

		else if(headerByte==SFSDataType.FLOAT_ARRAY)
			decodedObject = binDecode_FLOAT_ARRAY(buffer);

		else if(headerByte==SFSDataType.DOUBLE)
			decodedObject = binDecode_DOUBLE(buffer);

		else if(headerByte==SFSDataType.DOUBLE_ARRAY)
			decodedObject = binDecode_DOUBLE_ARRAY(buffer);

		else if(headerByte==SFSDataType.UTF_STRING)
			decodedObject = binDecode_UTF_STRING(buffer);

		else if(headerByte==SFSDataType.UTF_STRING_ARRAY)
			decodedObject = binDecode_UTF_STRING_ARRAY(buffer);

		else if(headerByte==SFSDataType.SFS_ARRAY)
		{
			// pointer goes back 1 position
			buffer.position = buffer.position - 1;
			decodedObject = new SFSDataWrapper(SFSDataType.SFS_ARRAY, decodeSFSArray(buffer));
		}
		else if(headerByte==SFSDataType.SFS_OBJECT)
		{
			// pointer goes back 1 position
			buffer.position = buffer.position -1 ;

			/*
		 	* See if this is a special type of SFSObject, the one that actually describes a Class
		 	*/
			var sfsObj:ISFSObject = decodeSFSObject(buffer);
			var type:Int = SFSDataType.SFS_OBJECT;
			var finalSfsObj:Dynamic = sfsObj;

			if(sfsObj.containsKey(CLASS_MARKER_KEY)&& sfsObj.containsKey(CLASS_FIELDS_KEY))
			{
				type=SFSDataType.CLASS;
				finalSfsObj=sfs2as(sfsObj);//<--- convert to its original classes
			}

			decodedObject = new SFSDataWrapper(type, finalSfsObj);
		}
		else if(headerByte==SFSDataType.TEXT)
		{
			decodedObject = binDecode_TEXT(buffer);
		}
			// What is this typeID??
		else
			throw "Unknow SFSDataType ID:" + headerByte;

		return decodedObject;
	}


	private function encodeObject(buffer:ByteArray, typeId:Int, data:Dynamic):ByteArray
	{
		switch(typeId)
		{
			case SFSDataType.NULL:
				buffer = binEncode_NULL(buffer);

			case SFSDataType.BOOL:
				buffer = binEncode_BOOL(buffer, data);

			case SFSDataType.BYTE:
				buffer = binEncode_BYTE(buffer, data);

			case SFSDataType.SHORT:
				buffer = binEncode_SHORT(buffer, data);

			case SFSDataType.INT:
				buffer = binEncode_INT(buffer, data);

			case SFSDataType.LONG:
				buffer = binEncode_LONG(buffer, data);

			case SFSDataType.FLOAT:
				buffer = binEncode_FLOAT(buffer, data);

			case SFSDataType.DOUBLE:
				buffer = binEncode_DOUBLE(buffer, data);

			case SFSDataType.UTF_STRING:
				buffer = binEncode_UTF_STRING(buffer, data);

			case SFSDataType.TEXT:
				buffer = binEncode_TEXT(buffer, cast(data, String));

			case SFSDataType.BOOL_ARRAY:
				buffer = binEncode_BOOL_ARRAY(buffer, data);

			case SFSDataType.BYTE_ARRAY:
				buffer = binEncode_BYTE_ARRAY(buffer, data);

			case SFSDataType.SHORT_ARRAY:
				buffer = binEncode_SHORT_ARRAY(buffer, data);

			case SFSDataType.INT_ARRAY:
				buffer = binEncode_INT_ARRAY(buffer, data);

			case SFSDataType.LONG_ARRAY:
				buffer = binEncode_LONG_ARRAY(buffer, data);

			case SFSDataType.FLOAT_ARRAY:
				buffer = binEncode_FLOAT_ARRAY(buffer, data);

			case SFSDataType.DOUBLE_ARRAY:
				buffer = binEncode_DOUBLE_ARRAY(buffer, data);

			case SFSDataType.UTF_STRING_ARRAY:
				buffer = binEncode_UTF_STRING_ARRAY(buffer, data);

			case SFSDataType.SFS_ARRAY:
				buffer = addData(buffer, array2binary(data));

			case SFSDataType.SFS_OBJECT:
				buffer = addData(buffer, object2binary(data));

			case SFSDataType.CLASS:
				buffer=addData(buffer, object2binary(as2sfs(data)));

			default:
				throw new SFSCodecError("Unrecognized type in SFSObject serialization:" + typeId);
		}

		return buffer;
	}



	/*
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *
	 *<<<Binary Entities Decoding Methods>>>
	 *
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */

	private function binDecode_NULL(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.NULL, null);
	}

	private function binDecode_BOOL(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.BOOL, buffer.readBoolean());
	}

	private function binDecode_BYTE(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.BYTE, buffer.readByte());
	}

	private function binDecode_SHORT(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.SHORT, buffer.readShort());
	}

	private function binDecode_INT(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.INT, buffer.readInt());
	}

	private function binDecode_LONG(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.LONG, decodeLongValue(buffer));
	}

	// TODO:Needs Testing!
	private function decodeLongValue(buffer:ByteArray):Float
	{
		var hi32:Int = buffer.readInt();// preserve long sign
		var lo32:Int = buffer.readUnsignedInt();// low 32bits can be unsigned

		// return 64 bit long value
		return(hi32 * Math.pow(2, 32)) + lo32;
	}

	private function encodeLongValue(long:Float, buffer:ByteArray):Void
	{
		var hi32:Int = 0;
		var lo32:Int = 0;

		//trace("Long:" + long + "=>" + long.toString(2))

		// Encode positive long
		if(long>-1)
		{
			hi32 = Std.int(long / Math.pow(2, 32));
			lo32 = Std.int(long % Math.pow(2, 32));
		}

			/*
		* Encode negative long
		* This is done in three steps:
		*
		* 1. Take the abs value, non negative
		* 2. Subtract 1
		* 3. Flip all bits
		*/
		else
		{
			var absVal:Float = Math.abs(long);
			var negLong:Float = absVal - 1;

			hi32 = Std.int(negLong / Math.pow(2, 32));
			lo32 = Std.int(negLong % Math.pow(2, 32));

			// Swap bits
			hi32 = ~hi32;
			lo32 = ~lo32;
		}

		buffer.writeUnsignedInt(hi32);
		buffer.writeUnsignedInt(lo32);

		//trace(DefaultObjectDumpFormatter.hexDump(buffer))
	}

	private function binDecode_FLOAT(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.FLOAT, buffer.readFloat());
	}

	private function binDecode_DOUBLE(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.DOUBLE, buffer.readDouble());
	}

	private function binDecode_TEXT(buffer:ByteArray) : SFSDataWrapper
	{
		var size:Int = buffer.readInt();
		var value:String = buffer.readUTFBytes(size);
		return new SFSDataWrapper(SFSDataType.TEXT,value);
	}

	private function binDecode_UTF_STRING(buffer:ByteArray):SFSDataWrapper
	{
		return new SFSDataWrapper(SFSDataType.UTF_STRING, buffer.readUTF());
	}

	private function binDecode_BOOL_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(buffer.readBoolean());
		}

		return new SFSDataWrapper(SFSDataType.BOOL_ARRAY, array);
	}

	private function binDecode_BYTE_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = buffer.readInt();

		if(size<0)
			throw new SFSCodecError("Array negative size:" + size);

		var array:ByteArray = new ByteArray();
		array.endian = Endian.BIG_ENDIAN;
		// copy bytes
		buffer.readBytes(array, 0, size);

		return new SFSDataWrapper(SFSDataType.BYTE_ARRAY, array);
	}

	private function binDecode_SHORT_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(buffer.readShort());
		}

		return new SFSDataWrapper(SFSDataType.SHORT_ARRAY, array);
	}

	private function binDecode_INT_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(buffer.readInt());
		}

		return new SFSDataWrapper(SFSDataType.INT_ARRAY, array);
	}

	private function binDecode_LONG_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(decodeLongValue(buffer));
		}

		return new SFSDataWrapper(SFSDataType.LONG_ARRAY, array);
	}

	private function binDecode_FLOAT_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(buffer.readFloat());
		}

		return new SFSDataWrapper(SFSDataType.FLOAT_ARRAY, array);
	}

	private function binDecode_DOUBLE_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(buffer.readDouble());
		}

		return new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY, array);
	}

	private function binDecode_UTF_STRING_ARRAY(buffer:ByteArray):SFSDataWrapper
	{
		var size:Int = getTypedArraySize(buffer);
		var array:Array<Dynamic> = [];

		for(j in 0...size)
		{
			array.push(buffer.readUTF());
		}

		return new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY, array);
	}

	private function getTypedArraySize(buffer:ByteArray):Int
	{
		var size:Int = buffer.readShort();

		if(size<0)
			throw new SFSCodecError("Array negative size:" + size);

		return size;
	}



	/*
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *
	 *<<<Binary Entities Encoding Methods>>>
	 *
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */

	private function binEncode_NULL(buffer:ByteArray):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(0x00);

		return addData(buffer, data);
	}

	private function binEncode_BOOL(buffer:ByteArray, value:Bool):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.BOOL);
		data.writeBoolean(value);

		return addData(buffer, data);
	}

	private function binEncode_BYTE(buffer:ByteArray, value:Int):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.BYTE);
		data.writeByte(value);

		return addData(buffer, data);
	}

	private function binEncode_SHORT(buffer:ByteArray, value:Int):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.SHORT);
		data.writeShort(value);

		return addData(buffer, data);
	}

	private function binEncode_INT(buffer:ByteArray, value:Int):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.INT);
		data.writeInt(value);

		return addData(buffer, data);
	}

	private function binEncode_LONG(buffer:ByteArray, value:Float):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.LONG);
		encodeLongValue(value, data);

		return addData(buffer, data);
	}

	private function binEncode_FLOAT(buffer:ByteArray, value:Float):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.FLOAT);
		data.writeFloat(value);

		return addData(buffer, data);
	}

	private function binEncode_DOUBLE(buffer:ByteArray, value:Float):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.DOUBLE);
		data.writeDouble(value);

		return addData(buffer, data);
	}

	private function binEncode_UTF_STRING(buffer:ByteArray, value:String):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.UTF_STRING);
		data.writeUTF(value);

		return addData(buffer, data);
	}

	private function binEncode_TEXT(buffer:ByteArray, value:String) : ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.writeByte(SFSDataType.TEXT);
		data.writeInt(value.length);
		data.writeUTFBytes(value);
		return this.addData(buffer,data);
	}

	private function binEncode_BOOL_ARRAY(buffer:ByteArray, value:Array<Bool>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.BOOL_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			data.writeBoolean(value[i]);
		}

		return addData(buffer, data);
	}

	private function binEncode_BYTE_ARRAY(buffer:ByteArray, value:ByteArray):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.BYTE_ARRAY);
		data.writeInt(value.length);

		data.writeBytes(value, 0, value.length);

		return addData(buffer, data);
	}

	private function binEncode_SHORT_ARRAY(buffer:ByteArray, value:Array<Int>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.SHORT_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			data.writeShort(value[i]);
		}

		return addData(buffer, data);
	}

	private function binEncode_INT_ARRAY(buffer:ByteArray, value:Array<Int>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.INT_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			data.writeInt(value[i]);
		}

		return addData(buffer, data);
	}

	private function binEncode_LONG_ARRAY(buffer:ByteArray, value:Array<Float>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.LONG_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			encodeLongValue(value[i], data);
		}

		return addData(buffer, data);
	}

	private function binEncode_FLOAT_ARRAY(buffer:ByteArray, value:Array<Float>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.FLOAT_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			data.writeFloat(value[i]);
		}

		return addData(buffer, data);
	}

	private function binEncode_DOUBLE_ARRAY(buffer:ByteArray, value:Array<Float>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.DOUBLE_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			data.writeDouble(value[i]);
		}

		return addData(buffer, data);
	}

	private function binEncode_UTF_STRING_ARRAY(buffer:ByteArray, value:Array<String>):ByteArray
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.BIG_ENDIAN;
		data.writeByte(SFSDataType.UTF_STRING_ARRAY);
		data.writeShort(value.length);

		for(i in 0...value.length)
		{
			data.writeUTF(value[i]);
		}

		return addData(buffer, data);
	}

	private function encodeSFSObjectKey(buffer:ByteArray, value:String):ByteArray
	{
		buffer.writeUTF(value);
		return buffer;
	}

	/*
	* Returns the same buffer
	*(could be used also to create copies)
	*/
	private function addData(buffer:ByteArray, newData:ByteArray):ByteArray
	{
		buffer.writeBytes(newData, 0, newData.length);
		return buffer;
	}

	/*
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *
	 *<<<ASObj 2 SFSObject>>>
	 *
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */

	public function as2sfs(asObj:Dynamic):ISFSObject
	{
		var sfsObj:ISFSObject = SFSObject.newInstance();
		convertAsObj(asObj, sfsObj);

		return sfsObj;
	}

	/*
	* Change class name to x.y.z::Class Into x.y.z.Class
	* TODO:maybe change the Reflection API directly??
	*/
	private function encodeClassName(name:String):String
	{
		return StringTools.replace(name, "::", ".");
	}

	private function convertAsObj(asObj:Dynamic, sfsObj:ISFSObject):Void
	{
		//var type:Type = Type.forInstance(asObj);
		var type:Class<Dynamic> = Type.getClass(asObj);
		var classFullName:String = Type.getClassName(type);//encodeClassName(ClassUtils.getFullyQualifiedName(type.clazz));

		if(classFullName==null)
			throw new SFSCodecError("Cannot detect class name:" + sfsObj);

		if(!(Std.isOfType(asObj, SerializableSFSType)))
			throw new SFSCodecError("Cannot serialize object:" + asObj + ", type:" + classFullName + " -- It doesn't implement the SerializableSFSType Interface");

		var fieldList:ISFSArray = SFSArray.newInstance();

		sfsObj.putUtfString(CLASS_MARKER_KEY, classFullName);
		sfsObj.putSFSArray(CLASS_FIELDS_KEY, fieldList);

		for(fieldName in Type.getInstanceFields(type))//Reflect??
		{
			// Skip static fields(including 'prototype')
			//if(field.isStatic)
			//continue;

			//var fieldName:String = field.name;
			var fieldValue:Dynamic = Reflect.field(asObj,fieldName);

			/*
			* Transient fields in Actionscript 3 are by convention marked with a starting $
			* Public fields such as:$posx, $name, $gameId won't be serialized.
			*/
			if(fieldName.charAt(0)=="$")
				continue;

			//trace("working on field:", fieldName, ":", fieldValue + ", " + Type.forInstance(fieldValue).name)

			var fieldDescriptor:ISFSObject = SFSObject.newInstance();

			// store field name
			fieldDescriptor.putUtfString(FIELD_NAME_KEY, fieldName);

			// store field value
			fieldDescriptor.put(FIELD_VALUE_KEY, wrapASField(fieldValue));

			// add to the list of fields
			fieldList.addSFSObject(fieldDescriptor);
		}

		// Handle any errors here?

	}

	private function wrapASField(value:Dynamic):SFSDataWrapper
	{
		// Handle special case in which value==NULL
		if(value==null)
			return new SFSDataWrapper(SFSDataType.NULL, null);

		var wrapper:SFSDataWrapper=null;
		var type:String = Type.getClassName(Type.getClass(value));

		if(Std.isOfType(value, Bool))
			wrapper = new SFSDataWrapper(SFSDataType.BOOL, value);

		else if(Std.isOfType(value, Int) || Std.isOfType(value,Int))
			wrapper = new SFSDataWrapper(SFSDataType.INT, value);

		else if(Std.isOfType(value, Float))
		{
			// Differntiate between decimal(Double)and non-decimal(Long)
			if(value==Math.floor(value))
				wrapper = new SFSDataWrapper(SFSDataType.LONG, value);
			else
				wrapper = new SFSDataWrapper(SFSDataType.DOUBLE, value);
		}

		else if(Std.isOfType(value, String))
			wrapper = new SFSDataWrapper(SFSDataType.UTF_STRING, value);

		else if(Std.isOfType(value, Array))
			wrapper = new SFSDataWrapper(SFSDataType.SFS_ARRAY, unrollArray(value));

		else if(Std.isOfType(value, SerializableSFSType))
			wrapper = new SFSDataWrapper(SFSDataType.SFS_OBJECT, as2sfs(value));

		else if(Std.isOfType(value, Dynamic))
			wrapper = new SFSDataWrapper(SFSDataType.SFS_OBJECT, unrollDictionary(value));

		return wrapper;
	}

	private function unrollArray(arr:Array<Dynamic>):ISFSArray
	{
		var sfsArray:ISFSArray = SFSArray.newInstance();

		for(j in 0...arr.length)
			sfsArray.add(wrapASField(arr[j]));

		return sfsArray;
	}

	private function unrollDictionary(dict:Dynamic):ISFSObject
	{
		var sfsObj:ISFSObject = SFSObject.newInstance();

		for(key in Reflect.fields(dict))
			sfsObj.put(key, wrapASField(Reflect.field(dict,key)));

		return sfsObj;
	}

	/*
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 *
	 *<<<SFSObject 2 POJO>>>
	 *
	 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */

	public function sfs2as(sfsObj:ISFSObject):Dynamic
	{
		var asObj:Dynamic;

		if(!sfsObj.containsKey(CLASS_MARKER_KEY)&& !sfsObj.containsKey(CLASS_FIELDS_KEY))
			throw new SFSCodecError("The SFSObject passed does not represent any serialized class.");

		var className:String = sfsObj.getUtfString(CLASS_MARKER_KEY)	;
		var theClass:Class<Dynamic> = Type.resolveClass(className);
		asObj = Type.createInstance(theClass,[]);

		if(!(Std.isOfType(asObj, SerializableSFSType)))
			throw new SFSCodecError("Cannot deserialize object:" + asObj + ", type:" + className + " -- It doesn't implement the SerializableSFSType Interface");

		//trace("CLASS:" + className)
		convertSFSObject(sfsObj.getSFSArray(CLASS_FIELDS_KEY), asObj);

		return asObj;
	}

	private function convertSFSObject(fieldList:ISFSArray, asObj:Dynamic):Void
	{
		var fieldDescriptor:ISFSObject;

		var fieldName:String;
		var fieldValue:Dynamic;

		for(j in 0...fieldList.size())
		{
			fieldDescriptor = fieldList.getSFSObject(j);
			fieldName = fieldDescriptor.getUtfString(FIELD_NAME_KEY);

			fieldValue = unwrapAsField(fieldDescriptor.getData(FIELD_VALUE_KEY));
			//trace("Working on field:" + fieldName + " ->" + fieldValue)
			// Call the setter and apply value
			Reflect.setField(asObj,fieldName,fieldValue);
		}

	}

	private function unwrapAsField(wrapper:SFSDataWrapper):Dynamic
	{
		var obj:Dynamic=null;
		var type:Int = wrapper.type;

		// From NULL ... to UTF_STRING they are all primitives, so we can group them together and upcast to *
		if(type<=SFSDataType.UTF_STRING)
			obj = wrapper.data;

		else if(type==SFSDataType.SFS_ARRAY)
			obj = rebuildArray(cast(wrapper.data,ISFSArray));

		else if(type==SFSDataType.SFS_OBJECT)
		{
			/*
			var sfsObj:ISFSObject=wrapper.data as ISFSObject
			if(sfsObj.containsKey(CLASS_MARKER_KEY)&& sfsObj.containsKey(CLASS_FIELDS_KEY))
				obj=sfs2as(sfsObj)
			else
			*/
			obj = rebuildDict(cast(wrapper.data,ISFSObject));
		}
		else if(type==SFSDataType.CLASS)
			obj = wrapper.data;

		return obj;
	}

	private function rebuildArray(sfsArr:ISFSArray):Array<Dynamic>
	{
		var arr:Array<Dynamic> = [];

		for(j in 0...sfsArr.size())
		{
			arr.push(unwrapAsField(sfsArr.getWrappedElementAt(j)));
		}

		return arr;
	}

	private function rebuildDict(sfsObj:ISFSObject):Dynamic
	{
		var dict:Dynamic = { };

		for(key in sfsObj.getKeys())
		{
			Reflect.setField(dict,key,unwrapAsField(sfsObj.getData(key)));
		}

		return dict;
	}

	/*
	*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	*
	* Generic Dynamic==>SFSObject
	*
	*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	*/
	public function genericObjectToSFSObject(obj:Dynamic, forceToNumber:Bool=false):SFSObject
	{
		var sfso:SFSObject = new SFSObject();
		_scanGenericObject(obj, sfso, forceToNumber);

		return sfso;
	}

	private function _scanGenericObject(obj:Dynamic, sfso:ISFSObject, forceToNumber:Bool=false):Void
	{
		for(key in Reflect.fields(obj))
		{
			var item:Dynamic = Reflect.field(obj,key);

			if(item==null)
				sfso.putNull(key);

				/*
			 * Hack to identify a generic object without using reflection
			 * ADDENDUM:	there is a special case in which the Dynamic is actually an Array with one element as Dynamic
			 * 				in such case an Array is recognized as Dynamic!
			 */
			else if((item.toString()=="[object Dynamic]" || item.toString() == "[object Object]")  && !(Std.isOfType(item, Array)))
			{
				var subSfso:ISFSObject = new SFSObject();
				sfso.putSFSObject(key, subSfso);

				// Call recursively
				_scanGenericObject(item, subSfso, forceToNumber);
			}
			else if(Std.isOfType(item, Array))
				sfso.putSFSArray(key, genericArrayToSFSArray(item, forceToNumber));

			else if(Std.isOfType(item, Bool))
				sfso.putBool(key, item);

			else if(Std.isOfType(item, Int) && !forceToNumber)
				sfso.putInt(key, item);

			else if(Std.isOfType(item, Float))
				sfso.putDouble(key, item);

			else if(Std.isOfType(item, String))
				sfso.putUtfString(key, item);

		}
	}

	public function sfsObjectToGenericObject(sfso:ISFSObject):Dynamic
	{
		var obj:Dynamic = { };
		_scanSFSObject(sfso, obj);

		return obj;
	}

	private function _scanSFSObject(sfso:ISFSObject, obj:Dynamic):Void
	{
		var keys:Array<Dynamic>=sfso.getKeys();

		for(key in keys)
		{
			var item:SFSDataWrapper = sfso.getData(key);

			if(item.type==SFSDataType.NULL)
				Reflect.setField(obj,key, null);

			else if(item.type==SFSDataType.SFS_OBJECT)
			{
				var subObj:Dynamic = { };
				Reflect.setField(obj,key, subObj);

				// Call recursively
				_scanSFSObject(cast(item.data,ISFSObject), subObj);
			}

			else if(item.type==SFSDataType.SFS_ARRAY)
				Reflect.setField(obj,key,cast(item.data, SFSArray).toArray());

				// Skip CLASS types
			else if(item.type==SFSDataType.CLASS)
				continue;

			else
				Reflect.setField(obj,key,item.data);
		}
	}

	/*
	*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	*
	* Generic Array<Dynamic>==>SFSArray
	*
	*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	*/
	public function genericArrayToSFSArray(arr:Array<Dynamic>, forceToNumber:Bool=false):SFSArray
	{
		var sfsa:SFSArray = new SFSArray();
		_scanGenericArray(arr, sfsa, forceToNumber);

		return sfsa;
	}

	private function _scanGenericArray(arr:Array<Dynamic>, sfsa:ISFSArray, forceToNumber:Bool=false):Void
	{
		for(ii in 0...arr.length)
		{
			var item:Dynamic = arr[ii];

			if(item==null)
				sfsa.addNull();

				// See notes for SFSObject
			else if((item.toString()=="[object Dynamic]" || item.toString() == "[object Object]")  && !(Std.isOfType(item, Array)))
				sfsa.addSFSObject(genericObjectToSFSObject(item, forceToNumber));

			else if(Std.isOfType(item, Array))
			{
				var subSfsa:ISFSArray = new SFSArray();
				sfsa.addSFSArray(subSfsa);

				// Call recursively
				_scanGenericArray(item, subSfsa, forceToNumber);
			}

			else if(Std.isOfType(item, Bool))
				sfsa.addBool(item);

			else if(Std.isOfType(item, Int) && !forceToNumber)
				sfsa.addInt(item);

			else if(Std.isOfType(item, Float))
				sfsa.addDouble(item);

			else if(Std.isOfType(item, String))
				sfsa.addUtfString(item);

		}
	}

	public function sfsArrayToGenericArray(sfsa:ISFSArray):Array<Dynamic>
	{
		var arr:Array<Dynamic> = [];
		_scanSFSArray(sfsa, arr);

		return arr;
	}

	private function _scanSFSArray(sfsa:ISFSArray, arr:Array<Dynamic>):Void
	{
		for(ii in 0...sfsa.size())
		{
			var item:SFSDataWrapper = sfsa.getWrappedElementAt(ii);
			if(item.type==SFSDataType.NULL)
				arr.push(null);

			else if(item.type==SFSDataType.SFS_OBJECT)
				arr.push(cast(item.data,SFSObject).toObject());

			else if(item.type==SFSDataType.SFS_ARRAY)
			{
				var subArr:Array<Dynamic> = [];
				arr.push(subArr);

				// Call recursively
				_scanSFSArray(cast(item.data,ISFSArray), subArr);
			}

				// Skip CLASS types
			else if(item.type==SFSDataType.CLASS)
				continue;

			else
				arr.push(item.data);
		}
	}

}
