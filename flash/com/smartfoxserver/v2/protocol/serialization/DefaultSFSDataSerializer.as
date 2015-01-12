package com.smartfoxserver.v2.protocol.serialization
{
	import as3reflect.ClassUtils;
	import as3reflect.Field;
	import as3reflect.Type;
	
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSDataType;
	import com.smartfoxserver.v2.entities.data.SFSDataWrapper;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.exceptions.SFSCodecError;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public class DefaultSFSDataSerializer implements ISFSDataSerializer
	{
		private static const CLASS_MARKER_KEY:String = "$C"
		private static const CLASS_FIELDS_KEY:String = "$F"
		private static const FIELD_NAME_KEY:String = "N"
		private static const FIELD_VALUE_KEY:String = "V"
			
		private static var _instance:DefaultSFSDataSerializer 
		private static var _lock:Boolean = true
		
		public static function getInstance():DefaultSFSDataSerializer
		{
			if (_instance == null)
			{
				_lock = false
				_instance = new DefaultSFSDataSerializer()
				_lock = true
			}
			
			return _instance
		}
		
		public function DefaultSFSDataSerializer()
		{
			if (_lock)
				throw new Error("Can't use constructor, please use getInstance() method")			
		}
		
		/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 *  SFSObject ==> Binary
		 *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
		 */
		public function object2binary(obj:ISFSObject):ByteArray
		{
			var buffer:ByteArray = new ByteArray()
			buffer.writeByte(SFSDataType.SFS_OBJECT)
			buffer.writeShort(obj.size())
			
			return obj2bin(obj, buffer)
		}
		
		private function obj2bin(obj:ISFSObject, buffer:ByteArray):ByteArray
		{
			var keys:Array = obj.getKeys()
			var wrapper:SFSDataWrapper
			
			for each (var key:String in keys)
			{
				wrapper = obj.getData(key)

				// Store the key
				buffer = encodeSFSObjectKey(buffer, key)
				
				// Convert 2 binary
				buffer = encodeObject(buffer, wrapper.type, wrapper.data) 
			}
			
			return buffer
		}
		
		/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 *  SFSArray ==> Binary
		 *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
		 */
		public function array2binary(array:ISFSArray):ByteArray
		{
			var buffer:ByteArray = new ByteArray()
			buffer.writeByte(SFSDataType.SFS_ARRAY)
			buffer.writeShort(array.size())
			
			return arr2bin(array, buffer)
		}
		
		private function arr2bin(array:ISFSArray, buffer:ByteArray):ByteArray
		{
			var wrapper:SFSDataWrapper
			
			for (var i:int = 0; i < array.size(); i++)
			{
				wrapper = array.getWrappedElementAt(i)
				buffer = encodeObject(buffer, wrapper.type, wrapper.data)	
			}
			
			return buffer
		}
		
		/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 *  Binary ==> SFSObject
		 *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
		 */
		public function binary2object(data:ByteArray):ISFSObject
		{
			if (data.length < 3)
				throw new SFSCodecError("Can't decode an SFSObject. Byte data is insufficient. Size: " + data.length + " byte(s)");
			
			data.position = 0
			return decodeSFSObject(data)
		}
		
		private function decodeSFSObject(buffer:ByteArray):ISFSObject
		{
			var sfsObject:SFSObject = SFSObject.newInstance()
			
			// Get tpyeId
			var headerByte:int = buffer.readByte()
			
			// Validate typeId
			if (headerByte != SFSDataType.SFS_OBJECT)
				throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_OBJECT + ", found: " + headerByte)
				
			var size:int = buffer.readShort()
			
			// Validate size
			if (size < 0)
				throw new SFSCodecError("Can't decode SFSObject. Size is negative: " + size)
			
			/*
		     * NOTE: we catch codec exceptions OUTSIDE of the loop
		     * meaning that any exception of that type will stop the process of looping through the
		     * object data and immediately discard the whole packet of data. 
		     */
		     
		     try
		     {
		     	for (var i:int = 0; i < size; i++)
		     	{
		     		// Decode object key
		     		var key:String = buffer.readUTF()
		     		
		     		// Decode the next object
		     		var decodedObject:SFSDataWrapper = decodeObject(buffer)
		     		
		     		// Store decoded object and keep going
		     		if (decodedObject != null)
		     			sfsObject.put(key, decodedObject)
		     		else
		     			throw new SFSCodecError("Could not decode value for SFSObject with key: " + key)
		     	}	
		     }
		     catch(err:SFSCodecError)
		     {
		     	throw err;
		     }
		
			return sfsObject
		}
		
		/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 *  Binary ==> SFSArray
		 *:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
		 */
		public function binary2array(data:ByteArray):ISFSArray
		{
			if (data.length < 3)
				throw new SFSCodecError("Can't decode an SFSArray. Byte data is insufficient. Size: " + data.length + " byte(s)");
			
			data.position = 0
			return decodeSFSArray(data)
		}
		
		private function decodeSFSArray(buffer:ByteArray):ISFSArray
		{
			var sfsArray:ISFSArray = SFSArray.newInstance()
			
			// Get tpyeId
			var headerByte:int = buffer.readByte()
			
			// Validate typeId
			if (headerByte != SFSDataType.SFS_ARRAY)
				throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_ARRAY + ", found: " + headerByte)
				
			var size:int = buffer.readShort()
			
			// Validate size
			if (size < 0)
				throw new SFSCodecError("Can't decode SFSArray. Size is negative: " + size)
				
			/*
		     * NOTE: we catch codec exceptions OUTSIDE of the loop
		     * meaning that any exception of that type will stop the process of looping through the
		     * object data and immediately discard the whole packet of data. 
		     */
		     
		     try
		     {
		     	for (var i:int = 0; i < size; i++)
		     	{
		     		// Decode the next object
		     		var decodedObject:SFSDataWrapper = decodeObject(buffer)

		     		// Store decoded object and keep going
		     		if (decodedObject != null)
		     			sfsArray.add(decodedObject)
		     		else
		     			throw new SFSCodecError("Could not decode SFSArray item at index: " + i)
		     	}	
		     }
		     catch(err:SFSCodecError)
		     {
		     	throw err;
		     }
		     
		     return sfsArray
		}
		
		/*
	 	* The buffer pointer (position) must located on the 1st byte of the object to decode
	 	* Throws SFSCodecException
	 	*/
		private function decodeObject(buffer:ByteArray):SFSDataWrapper
		{
			var decodedObject:SFSDataWrapper 
			var headerByte:int = buffer.readByte()
			
			if (headerByte == SFSDataType.NULL)
			 	decodedObject = binDecode_NULL(buffer)
			 	
			else if (headerByte == SFSDataType.BOOL)
				decodedObject = binDecode_BOOL(buffer)
			
			else if (headerByte == SFSDataType.BOOL_ARRAY)
				decodedObject = binDecode_BOOL_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.BYTE)
				decodedObject = binDecode_BYTE(buffer)
			
			else if (headerByte == SFSDataType.BYTE_ARRAY)
				decodedObject = binDecode_BYTE_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.SHORT)
				decodedObject = binDecode_SHORT(buffer)
			
			else if (headerByte == SFSDataType.SHORT_ARRAY)
				decodedObject = binDecode_SHORT_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.INT)
				decodedObject = binDecode_INT(buffer)
			
			else if (headerByte == SFSDataType.INT_ARRAY)
				decodedObject = binDecode_INT_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.LONG)
				decodedObject = binDecode_LONG(buffer)
			
			else if (headerByte == SFSDataType.LONG_ARRAY)
				decodedObject = binDecode_LONG_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.FLOAT)
				decodedObject = binDecode_FLOAT(buffer)
			
			else if (headerByte == SFSDataType.FLOAT_ARRAY)
				decodedObject = binDecode_FLOAT_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.DOUBLE)
				decodedObject = binDecode_DOUBLE(buffer)
			
			else if (headerByte == SFSDataType.DOUBLE_ARRAY)
				decodedObject = binDecode_DOUBLE_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.UTF_STRING)
				decodedObject = binDecode_UTF_STRING(buffer)
			
			else if (headerByte == SFSDataType.UTF_STRING_ARRAY)
				decodedObject = binDecode_UTF_STRING_ARRAY(buffer)
			
			else if (headerByte == SFSDataType.SFS_ARRAY)
			{
				// pointer goes back 1 position
				buffer.position = buffer.position - 1
				decodedObject = new SFSDataWrapper(SFSDataType.SFS_ARRAY, decodeSFSArray(buffer))
			}
			else if (headerByte == SFSDataType.SFS_OBJECT)
			{
				// pointer goes back 1 position
				buffer.position = buffer.position -1 
				
				/*
			 	* See if this is a special type of SFSObject, the one that actually describes a Class
			 	*/
			 	var sfsObj:ISFSObject = decodeSFSObject(buffer)
			 	var type:int = SFSDataType.SFS_OBJECT
			 	var finalSfsObj:* = sfsObj
				
				if (sfsObj.containsKey(CLASS_MARKER_KEY) && sfsObj.containsKey(CLASS_FIELDS_KEY))
				{
					type = SFSDataType.CLASS;
					finalSfsObj = sfs2as(sfsObj); // <--- convert to its original classes
				}
				
				decodedObject = new SFSDataWrapper(type, finalSfsObj)
			}
			
			// What is this typeID??
			else
				throw new Error("Unknow SFSDataType ID: " + headerByte);
			
			return decodedObject;
		}
		
		
		private function encodeObject(buffer:ByteArray, typeId:int, data:*):ByteArray
		{
			switch(typeId)
			{
				case SFSDataType.NULL:
					buffer = binEncode_NULL(buffer)
					break
					
				case SFSDataType.BOOL:
					buffer = binEncode_BOOL(buffer, data as Boolean)
					break
					
				case SFSDataType.BYTE:
					buffer = binEncode_BYTE(buffer, data as int)
					break
					
				case SFSDataType.SHORT:
					buffer = binEncode_SHORT(buffer, data as int)
					break
					
				case SFSDataType.INT:
					buffer = binEncode_INT(buffer, data as int)
					break
					
				case SFSDataType.LONG:
					buffer = binEncode_LONG(buffer, data as Number)
					break
					
				case SFSDataType.FLOAT:
					buffer = binEncode_FLOAT(buffer, data as Number)
					break
					
				case SFSDataType.DOUBLE:
					buffer = binEncode_DOUBLE(buffer, data as Number)
					break
					
				case SFSDataType.UTF_STRING:
					buffer = binEncode_UTF_STRING(buffer, data as String)
					break
					
				case SFSDataType.BOOL_ARRAY:
					buffer = binEncode_BOOL_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.BYTE_ARRAY:
					buffer = binEncode_BYTE_ARRAY(buffer, data as ByteArray)
					break
					
				case SFSDataType.SHORT_ARRAY:
					buffer = binEncode_SHORT_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.INT_ARRAY:
					buffer = binEncode_INT_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.LONG_ARRAY:
					buffer = binEncode_LONG_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.FLOAT_ARRAY:
					buffer = binEncode_FLOAT_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.DOUBLE_ARRAY:
					buffer = binEncode_DOUBLE_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.UTF_STRING_ARRAY:
					buffer = binEncode_UTF_STRING_ARRAY(buffer, data as Array)
					break
					
				case SFSDataType.SFS_ARRAY:
					buffer = addData(buffer, array2binary(data as SFSArray))
					break
					
				case SFSDataType.SFS_OBJECT:
					buffer = addData(buffer, object2binary(data as SFSObject))
					break
					
				case SFSDataType.CLASS:
					buffer = addData(buffer, object2binary(as2sfs(data)));
					break;
					
				default:
					throw new SFSCodecError("Unrecognized type in SFSObject serialization: " + typeId);
			}
			
			return buffer
		}
		
		
	
		/*
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 * 
		 * <<< Binary Entities Decoding Methods >>>
		 * 
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 */
		
		private function binDecode_NULL(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.NULL, null)
		}
		
		private function binDecode_BOOL(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.BOOL, buffer.readBoolean())
		}
		
		private function binDecode_BYTE(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.BYTE, buffer.readByte())	
		}
		
		private function binDecode_SHORT(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.SHORT, buffer.readShort())
		}
		
		private function binDecode_INT(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.INT, buffer.readInt())
		}
		
		private function binDecode_LONG(buffer:ByteArray):SFSDataWrapper
		{			
			return new SFSDataWrapper(SFSDataType.LONG, decodeLongValue(buffer))
		}
		
		// TODO: Needs Testing!
		private function decodeLongValue(buffer:ByteArray):Number
		{
			var hi32:int = buffer.readInt() // preserve long sign
			var lo32:uint = buffer.readUnsignedInt() // low 32bits can be unsigned
				
			// return 64 bit long value
			return (hi32 * Math.pow(2,32)) + lo32
		}
		
		private function encodeLongValue(long:Number, buffer:ByteArray):void
		{
			var hi32:int = 0
			var lo32:int = 0
				
			//trace("Long:" + long + " => " + long.toString(2))
			
			// Encode positive long
			if (long > -1)
			{
				hi32 = long / Math.pow(2, 32)
				lo32 = long % Math.pow(2, 32)
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
				var absVal:Number = Math.abs(long)
				var negLong:Number = absVal - 1
				
				hi32 = negLong / Math.pow(2, 32)
				lo32 = negLong % Math.pow(2, 32)
				
				// Swap bits
				hi32 = ~hi32
				lo32 = ~lo32
			}
			
			buffer.writeUnsignedInt(hi32)
			buffer.writeUnsignedInt(lo32)
				
			//trace(DefaultObjectDumpFormatter.hexDump(buffer))
		}
		
		private function binDecode_FLOAT(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.FLOAT, buffer.readFloat())
		}
		
		private function binDecode_DOUBLE(buffer:ByteArray):SFSDataWrapper
		{
			return new SFSDataWrapper(SFSDataType.DOUBLE, buffer.readDouble())
		}
		
		private function binDecode_UTF_STRING(buffer:ByteArray):SFSDataWrapper
		{
		 	return new SFSDataWrapper(SFSDataType.UTF_STRING, buffer.readUTF())
		}
		
		private function binDecode_BOOL_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( buffer.readBoolean() )
			}
			
			return new SFSDataWrapper(SFSDataType.BOOL_ARRAY, array)
		}
		
		private function binDecode_BYTE_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = buffer.readInt()
			
			if (size < 0)
				throw new SFSCodecError("Array negative size: " + size)
			
			var array:ByteArray = new ByteArray()
			
			// copy bytes
			buffer.readBytes(array, 0, size)
			
			return new SFSDataWrapper(SFSDataType.BYTE_ARRAY, array)
		}
		
		private function binDecode_SHORT_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( buffer.readShort() )
			}
			
			return new SFSDataWrapper(SFSDataType.SHORT_ARRAY, array)
		}
		
		private function binDecode_INT_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( buffer.readInt() )
			}
			
			return new SFSDataWrapper(SFSDataType.INT_ARRAY, array)
		}
		
		private function binDecode_LONG_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( decodeLongValue(buffer) )
			}
			
			return new SFSDataWrapper(SFSDataType.LONG_ARRAY, array)
		}
		
		private function binDecode_FLOAT_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( buffer.readFloat() )
			}
			
			return new SFSDataWrapper(SFSDataType.FLOAT_ARRAY, array)
		}
		
		private function binDecode_DOUBLE_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( buffer.readDouble() )
			}
			
			return new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY, array)
		}
		
		private function binDecode_UTF_STRING_ARRAY(buffer:ByteArray):SFSDataWrapper
		{
			var size:int = getTypedArraySize(buffer)
			var array:Array = []
			
			for (var j:int = 0; j < size; j++)
			{
				array.push( buffer.readUTF() )
			}
			
			return new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY, array)
		}	
	
		private function getTypedArraySize(buffer:ByteArray):int
		{
			var size:int = buffer.readShort()
			
			if (size < 0)
				throw new SFSCodecError("Array negative size: " + size)
				
			return size
		}
		
		
		
		/*
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 * 
		 * <<< Binary Entities Encoding Methods >>>
		 * 
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 */
		 
		private function binEncode_NULL(buffer:ByteArray):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(0x00)
			
			return addData(buffer, data)
		}
		
		private function binEncode_BOOL(buffer:ByteArray, value:Boolean):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.BOOL)
			data.writeBoolean(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_BYTE(buffer:ByteArray, value:int):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.BYTE)
			data.writeByte(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_SHORT(buffer:ByteArray, value:int):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.SHORT)
			data.writeShort(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_INT(buffer:ByteArray, value:int):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.INT)
			data.writeInt(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_LONG(buffer:ByteArray, value:Number):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.LONG)
			encodeLongValue(value, data)
			
			return addData(buffer, data)
		}
		
		private function binEncode_FLOAT(buffer:ByteArray, value:Number):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.FLOAT)
			data.writeFloat(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_DOUBLE(buffer:ByteArray, value:Number):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.DOUBLE)
			data.writeDouble(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_UTF_STRING(buffer:ByteArray, value:String):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.UTF_STRING)
			data.writeUTF(value)
			
			return addData(buffer, data)
		}
		
		private function binEncode_BOOL_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.BOOL_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				data.writeBoolean(value[i])
			}
			
			return addData(buffer, data)
		}
		
		private function binEncode_BYTE_ARRAY(buffer:ByteArray, value:ByteArray):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.BYTE_ARRAY)
			data.writeInt(value.length)
			
			data.writeBytes(value, 0, value.length)
			
			return addData(buffer, data)
		}
		
		private function binEncode_SHORT_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.SHORT_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				data.writeShort(value[i])
			}
			
			return addData(buffer, data)
		}
		
		private function binEncode_INT_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.INT_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				data.writeInt(value[i])
			}
			
			return addData(buffer, data)
		}
		
		private function binEncode_LONG_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.LONG_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				encodeLongValue(value[i], data)
			}
			
			return addData(buffer, data)
		}
		
		private function binEncode_FLOAT_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.FLOAT_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				data.writeFloat(value[i])
			}
			
			return addData(buffer, data)
		}
		
		private function binEncode_DOUBLE_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.DOUBLE_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				data.writeDouble(value[i])
			}
			
			return addData(buffer, data)
		}
		
		private function binEncode_UTF_STRING_ARRAY(buffer:ByteArray, value:Array):ByteArray
		{
			var data:ByteArray = new ByteArray()
			data.writeByte(SFSDataType.UTF_STRING_ARRAY)
			data.writeShort(value.length)
			
			for (var i:int = 0; i < value.length; i++)
			{
				data.writeUTF(value[i])
			}
			
			return addData(buffer, data)
		}
		
		private function encodeSFSObjectKey(buffer:ByteArray, value:String):ByteArray
		{
			buffer.writeUTF(value)	
			return buffer
		}
		
		/*
		* Returns the same buffer
		* (could be used also to create copies)
		*/
		private function addData(buffer:ByteArray, newData:ByteArray):ByteArray
		{
			buffer.writeBytes(newData, 0, newData.length)
			return buffer
		}
		
		/*
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 * 
		 * <<< ASObj 2 SFSObject >>>
		 * 
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 */
		
		public function as2sfs(asObj:*):ISFSObject
		{
			var sfsObj:ISFSObject = SFSObject.newInstance()
			convertAsObj(asObj, sfsObj)
			
			return sfsObj
		}
		
		/*
		* Change class name to x.y.z::Class into x.y.z.Class
		* TODO: maybe change the Reflection API directly??
		*/
		private function encodeClassName(name:String):String
		{
			return name.replace("::", ".") 
		}
		 
		private function convertAsObj(asObj:*, sfsObj:ISFSObject):void
		{
			var type:Type = Type.forInstance(asObj)
			var classFullName:String = encodeClassName(ClassUtils.getFullyQualifiedName(type.clazz))
			
			if (classFullName == null)
				throw new SFSCodecError("Cannot detect class name: " + sfsObj)
			
			if (!(asObj is SerializableSFSType))
				throw new SFSCodecError("Cannot serialize object: " + asObj + ", type: " + classFullName + " -- It doesn't implement the SerializableSFSType interface")
				
			var fieldList:ISFSArray = SFSArray.newInstance()
			
			sfsObj.putUtfString(CLASS_MARKER_KEY, classFullName)
			sfsObj.putSFSArray(CLASS_FIELDS_KEY, fieldList)
			
			for each (var field:Field in type.fields)
			{
				// Skip static fields (including 'prototype')
				if (field.isStatic)
					continue
				
				var fieldName:String = field.name
				var fieldValue:* = asObj[fieldName]
					
				/*
				* Transient fields in Actionscript 3 are by convention marked with a starting $ 
				* Public fields such as: $posx, $name, $gameId won't be serialized.
				*/
				if (fieldName.charAt(0) == "$")
					continue
					
				//trace("working on field: ", fieldName, ":", fieldValue + ", " + Type.forInstance(fieldValue).name)
				
				var fieldDescriptor:ISFSObject = SFSObject.newInstance()
				
				// store field name
				fieldDescriptor.putUtfString(FIELD_NAME_KEY, fieldName)
				
				// store field value
				fieldDescriptor.put(FIELD_VALUE_KEY, wrapASField(fieldValue))
				
				// add to the list of fields
				fieldList.addSFSObject(fieldDescriptor)
			}
			
			// Handle any errors here?
			
		}
		
		private function wrapASField(value:*):SFSDataWrapper
		{
			// Handle special case in which value == NULL
			if (value == null)
				return new SFSDataWrapper(SFSDataType.NULL, null)
				
			var wrapper:SFSDataWrapper
			var type:String = Type.forInstance(value).name
			
			if (value is Boolean)
				wrapper = new SFSDataWrapper(SFSDataType.BOOL, value)
				
			else if (value is int || value is uint)
				wrapper = new SFSDataWrapper(SFSDataType.INT, value)
			
			else if (value is Number)
			{
				// Differntiate between decimal (Double) and non-decimal (Long)
				if (value == Math.floor(value))
					wrapper = new SFSDataWrapper(SFSDataType.LONG, value)
				else
					wrapper = new SFSDataWrapper(SFSDataType.DOUBLE, value)
			}
			
			else if (value is String)
				wrapper = new SFSDataWrapper(SFSDataType.UTF_STRING, value)
			
			else if (value is Array)
				wrapper = new SFSDataWrapper(SFSDataType.SFS_ARRAY, unrollArray(value))
			
			else if (value is SerializableSFSType)
				wrapper = new SFSDataWrapper(SFSDataType.SFS_OBJECT, as2sfs(value))
			
			else if (value is Object)
				wrapper = new SFSDataWrapper(SFSDataType.SFS_OBJECT, unrollDictionary(value))
			
			return wrapper	
		}
		
		private function unrollArray(arr:Array):ISFSArray
		{
			var sfsArray:ISFSArray = SFSArray.newInstance()
			
			for (var j:int = 0; j < arr.length; j++)
				sfsArray.add(wrapASField(arr[j]))
				
			return sfsArray
		}
		
		private function unrollDictionary(dict:Object):ISFSObject
		{
			var sfsObj:ISFSObject = SFSObject.newInstance()
			
			for (var key:String in dict)
				sfsObj.put(key, wrapASField(dict[key]))
				
			return sfsObj
		}
		
		/*
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 * 
		 * <<< SFSObject 2 POJO >>>
		 * 
		 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		 */
		 
		 public function sfs2as(sfsObj:ISFSObject):*
		 {
		 	var asObj:*
		 	
		 	if (!sfsObj.containsKey(CLASS_MARKER_KEY) && !sfsObj.containsKey(CLASS_FIELDS_KEY))
				throw new SFSCodecError("The SFSObject passed does not represent any serialized class.");
				
			var className:String = sfsObj.getUtfString(CLASS_MARKER_KEY)	
			var theClass:Class = ClassUtils.forName(className)
			asObj = new theClass()
			
			if (!(asObj is SerializableSFSType))
				throw new SFSCodecError("Cannot deserialize object: " + asObj + ", type: " + className + " -- It doesn't implement the SerializableSFSType interface");
			
			//trace("CLASS: " + className)
			convertSFSObject(sfsObj.getSFSArray(CLASS_FIELDS_KEY), asObj)
				
			return asObj
		 }
		
		private function convertSFSObject(fieldList:ISFSArray, asObj:*):void
		{
			var fieldDescriptor:ISFSObject
			
			var fieldName:String
			var fieldValue:*
						
			for (var j:int = 0; j < fieldList.size(); j++)
			{
				fieldDescriptor = fieldList.getSFSObject(j)
				fieldName = fieldDescriptor.getUtfString(FIELD_NAME_KEY)
				
				fieldValue = unwrapAsField(fieldDescriptor.getData(FIELD_VALUE_KEY))
				//trace("Working on field: " + fieldName + " -> " + fieldValue)
				// Call the setter and apply value
				asObj[fieldName] = fieldValue
			}	
			
		}
		
		private function unwrapAsField(wrapper:SFSDataWrapper):*
		{
			var obj:*
			var type:int = wrapper.type
			
			// From NULL ... to UTF_STRING they are all primitives, so we can group them together and upcast to *
			if (type <= SFSDataType.UTF_STRING)
				obj = wrapper.data
			
			else if (type == SFSDataType.SFS_ARRAY)
				obj = rebuildArray(wrapper.data as ISFSArray)
				
			else if (type == SFSDataType.SFS_OBJECT)
			{
				/*
				var sfsObj:ISFSObject = wrapper.data as ISFSObject
				if (sfsObj.containsKey(CLASS_MARKER_KEY) && sfsObj.containsKey(CLASS_FIELDS_KEY))
					obj = sfs2as(sfsObj)
				else
				*/
				obj = rebuildDict(wrapper.data as ISFSObject)
			}	
			else if (type == SFSDataType.CLASS)
				obj = wrapper.data
			
			return obj
		}
		
		private function rebuildArray(sfsArr:ISFSArray):Array
		{
			var arr:Array = []
			
			for (var j:int = 0; j < sfsArr.size(); j++)
			{
				arr.push(unwrapAsField(sfsArr.getWrappedElementAt(j)))
			}
			
			return arr
		}
		
		private function rebuildDict(sfsObj:ISFSObject):Object
		{
			var dict:Object = {}
			
			for each (var key:String in sfsObj.getKeys())
			{
				dict[key] = unwrapAsField(sfsObj.getData(key))	
			}
			
			return dict
		}		
		
		/*
		* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		* 
		* Generic Object ==> SFSObject
		* 
		* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		*/
		public function genericObjectToSFSObject(obj:Object, forceToNumber:Boolean = false):SFSObject
		{
			var sfso:SFSObject = new SFSObject()
			_scanGenericObject(obj, sfso, forceToNumber)
			
			return sfso
		}
		
		private function _scanGenericObject(obj:Object, sfso:ISFSObject, forceToNumber:Boolean = false):void
		{
			for (var key:String in obj)
			{
				var item:* = obj[key]
					
				if (item == null)
					sfso.putNull(key)
				
				/*
				 * Hack to identify a generic object without using reflection
				 * ADDENDUM:	there is a special case in which the Object is actually an Array with one element as Object
				 * 				in such case an Array is recognized as Object!
				 */
				else if (item.toString() == "[object Object]" && !(item is Array))
				{
					var subSfso:ISFSObject = new SFSObject()
					sfso.putSFSObject(key, subSfso)
						
					// Call recursively
					_scanGenericObject(item, subSfso, forceToNumber)
				}	
				else if (item is Array)
					sfso.putSFSArray(key, genericArrayToSFSArray(item, forceToNumber))
						
				else if (item is Boolean)
					sfso.putBool(key, item)

				else if (item is int && !forceToNumber)
					sfso.putInt(key, item)		

				else if (item is Number)
					sfso.putDouble(key, item)
				
				else if (item is String)
					sfso.putUtfString(key, item)
				
			}
		}
		
		public function sfsObjectToGenericObject(sfso:ISFSObject):Object
		{
			var obj:Object = {}
			_scanSFSObject(sfso, obj)
			
			return obj
		}
		
		private function _scanSFSObject(sfso:ISFSObject, obj:Object):void
		{
			var keys:Array = sfso.getKeys();
			
			for each (var key:String in keys)
			{
				var item:SFSDataWrapper = sfso.getData(key)
				
				if (item.type == SFSDataType.NULL)
					obj[key] = null
					
				else if (item.type == SFSDataType.SFS_OBJECT)
				{
					var subObj:Object = {}
					obj[key] = subObj
					
					// Call recursively
					_scanSFSObject(item.data as ISFSObject, subObj)
				}	
				
				else if (item.type == SFSDataType.SFS_ARRAY)
					obj[key] = (item.data as SFSArray).toArray()
				
				// Skip CLASS types
				else if (item.type == SFSDataType.CLASS)
					continue;
						
				else 
					obj[key] = item.data	
			}
		}
		
		/*
		* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		* 
		* Generic Array ==> SFSArray
		* 
		* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		*/
		public function genericArrayToSFSArray(arr:Array, forceToNumber:Boolean = false):SFSArray
		{
			var sfsa:SFSArray = new SFSArray()
			_scanGenericArray(arr, sfsa, forceToNumber)
			
			return sfsa
		}
		
		private function _scanGenericArray(arr:Array, sfsa:ISFSArray, forceToNumber:Boolean = false):void
		{
			for (var ii:int = 0; ii < arr.length; ii++)
			{
				var item:* = arr[ii]
				
				if (item == null)
					sfsa.addNull()
					
				// See notes for SFSObject
				else if (item.toString() == "[object Object]"  && !(item is Array))
					sfsa.addSFSObject(genericObjectToSFSObject(item, forceToNumber))
				
				else if (item is Array)
				{
					var subSfsa:ISFSArray = new SFSArray()
					sfsa.addSFSArray(subSfsa)
					
					// Call recursively
					_scanGenericArray(item, subSfsa, forceToNumber)
				}
					
				else if (item is Boolean)
					sfsa.addBool(item)
					
				else if (item is int && !forceToNumber)
					sfsa.addInt(item)		
					
				else if (item is Number)
					sfsa.addDouble(item)
					
				else if (item is String)
					sfsa.addUtfString(item)
				
			}
		}
		
		public function sfsArrayToGenericArray(sfsa:ISFSArray):Array
		{
			var arr:Array = []
			_scanSFSArray(sfsa, arr)
			
			return arr
		}
				
		private function _scanSFSArray(sfsa:ISFSArray, arr:Array):void
		{
			for (var ii:int = 0; ii < sfsa.size(); ii++)
			{
				var item:SFSDataWrapper = sfsa.getWrappedElementAt(ii)
				
				if (item.type == SFSDataType.NULL)
					arr[ii] = null
					
				else if (item.type == SFSDataType.SFS_OBJECT)
					arr[ii] = (item.data as SFSObject).toObject()
					
				else if (item.type == SFSDataType.SFS_ARRAY)
				{
					var subArr:Array = []
					arr[ii] = subArr
					
					// Call recursively
					_scanSFSArray(item.data as ISFSArray, subArr)
				}
				
				// Skip CLASS types
				else if (item.type == SFSDataType.CLASS)
					continue;
					
				else 
					arr[ii] = item.data	
			}
		}
		
	}
}