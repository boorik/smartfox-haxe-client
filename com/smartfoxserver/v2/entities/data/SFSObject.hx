package com.smartfoxserver.v2.entities.data;

import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
import com.smartfoxserver.v2.protocol.serialization.ISFSDataSerializer;
import haxe.ds.StringMap;

import flash.utils.ByteArray;

/**
 * The<em>SFSObject</em>class is used by SmartFoxServer in client-server data transfer.
 * It can be thought of as a specialized Dictionary/Map object that can contain any type of data.
 * 
 *<p>The advantage of using the<em>SFSObject</em>class(for example when sending an<em>ExtensionRequest</em>request)is that you can fine tune the way your data is transmitted over the network.
 * For instance, a number like<code>100</code>can be transmitted as a normal Integer(which takes 32 bits), but also a short(16 bit)or even a byte(8 bit).</p>
 * 
 *<p><em>SFSObject</em>supports many primitive data types and related arrays of primitives(see the<em>SFSDataType</em>class). It also allows to serialize class instances and rebuild them on the other side(client or server). 
 * Check the SmartFoxServer 2X documentation for more informations on this advanced topic.</p>
 * 
 * @see 	com.smartfoxserver.v2.requests.ExtensionRequest ExtensionRequest
 * @see 	SFSDataType
 */
class SFSObject implements ISFSObject
{
	private var dataHolder:Map<String,Dynamic>;
	private var serializer:ISFSDataSerializer;
	
	/**
	 * Returns a new<em>SFSObject</em>instance.
	 * 
	 *<p>This is an alternative static constructor that builds a<em>SFSObject</em>populated with the data found in the passed native ActionScript<em>Object</em>.
	 * Numeric data is translated to<em>int</em>(integer values)or<em>Number</em>(decimal values). The procedure is recursive and works for nested objects and arrays.
	 * The supported native types are:<em>Boolean</em>,<em>int</em>,<em>Number</em>,<em>String</em>,<em>Object</em>,<em>Array</em>. The object can contain<code>null</code>values too.</p>
	 * 
	 * @param	o				The source<em>Object</em>.
	 * @param   forceToNumber	Indicates if the conversion of all numeric values should be forced to the highest precision possible(<em>Number</em>). This means that Integer values will be treated as double precision values.
	 * 
	 * @return	A new<em>SFSObject</em>instance populated with data from the passed object.
	 * 
	 * @see		#SFSObject()
	 * @see		#newInstance()
	 * @see		#toObject()
	 */
	public static function newFromObject(o:Dynamic, forceToNumber:Bool=false):SFSObject
	{
		return DefaultSFSDataSerializer.getInstance().genericObjectToSFSObject(o, forceToNumber);
	}
	
	/**
	 * @private
	 * 
	 * Alternative static constructor that builds a SFSObject from a valid SFSObject binary representation.
	 * 
	 * @param	ba
	 * 
	 * @return	 
	 * 
	 * @see		#toBinary()
	 */
	public static function newFromBinaryData(ba:ByteArray):SFSObject
	{
		return cast DefaultSFSDataSerializer.getInstance().binary2object(ba);
	}
	
	/**
	 * Returns a new<em>SFSObject</em>instance.
	 * This method is an alternative to the standard class constructor.
	 * 
	 * @return	A new<em>SFSObject</em>instance.
	 * 
	 * @see		#SFSObject()
	 * @see		#newFromObject()
	 */
	public static function newInstance():SFSObject
	{
		return new SFSObject();
	}
	
	/**
	 * Creates a new<em>SFSObject</em>instance.
	 * 
	 * @see		#newInstance()
	 * @see		#newFromObject()
	 */
	public function new()
	{
		dataHolder = new Map<String,Dynamic>();
		serializer = DefaultSFSDataSerializer.getInstance();
	}

	/** @inheritDoc */
	public function isNull(key:String):Bool
	{
		var wrapper:SFSDataWrapper = dataHolder[key];
		
		if(wrapper==null)
			return true;
			
		return wrapper.data == null;
	}
	
	/** @inheritDoc */
	public function containsKey(key:String):Bool
	{
		return dataHolder.exists(key);
	}
	
	/** @inheritDoc */
	public function removeElement(key:String):Void
	{
		dataHolder[key]=null;
	}
	
	/** @inheritDoc */
	public function getKeys():Array<String>
	{
		var keyList:Array<String> = [];
		
		for(j in dataHolder.keys())
			keyList.push(j);
			
		return keyList	;
	}
	
	/** @inheritDoc */
	public function size():Int
	{
		var count:Int = 0;
		
		for(j in dataHolder)
			count++;
		
		return count;
	}
	
	/** @inheritDoc */
	public function toBinary():ByteArray
	{
		return serializer.object2binary(this);
	}
	
	/** 
	 * Converts this<em>SFSObject</em>to a native ActionScript<em>Object</em>.
	 * The procedure is recurisive, so all nested objects are also converted. The process discards elements of type<em>SFSDataType.CLASS</em>, which must be retrieved with the appropriate method.
	 * 
	 * @return	A generic ActionScript 3<em>Object</em>representing this object.
	 * 
	 * @see SFSDataType#CLASS
	 */ 
	public function toObject():Dynamic
	{
		return DefaultSFSDataSerializer.getInstance().sfsObjectToGenericObject(this);
	}
	
	/** @inheritDoc */
	public function getDump(format:Bool=true):String
	{
		if(!format)
			return dump();
		else 
		{
			var prettyDump:String;
			
			try
			{
				prettyDump = DefaultObjectDumpFormatter.prettyPrintDump(dump());
			}
			catch(err:Dynamic)
			{
				//throw err;
				prettyDump = "Unable to provide a dump of this object";
			}
			
			return prettyDump;
		}
	}
	
	private function dump():String
	{
		var strDump:String = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
		var wrapper:SFSDataWrapper;
		var type:Int;

		for(key in dataHolder.keys())
		{
			wrapper = getData(key);
			type = wrapper.type;
			
			strDump += "(" + SFSDataType.fromId(wrapper.type).toLowerCase() + ")";
			strDump += " " + key + ":" ;
			
			if(type==SFSDataType.SFS_OBJECT)
				strDump += cast(wrapper.data, SFSObject).getDump(false);
			
			else if(type==SFSDataType.SFS_ARRAY)
				strDump += cast(wrapper.data, SFSArray).getDump(false);
					
			else if(type==SFSDataType.BYTE_ARRAY)
				strDump += DefaultObjectDumpFormatter.prettyPrintByteArray(cast(wrapper.data,ByteArray));
				
			else if(type>SFSDataType.UTF_STRING && type<SFSDataType.CLASS)
				strDump += "[" + wrapper.data + "]";
				
			else 
				strDump += wrapper.data;
			
			strDump += DefaultObjectDumpFormatter.TOKEN_DIVIDER;
		}
		
		// We do this only if the object is not empty
		if(size()>0)
			strDump = strDump.substring(0, strDump.length - 1);
		
		strDump += DefaultObjectDumpFormatter.TOKEN_INDENT_CLOSE;
		
		return strDump;
	}
	
	/** @inheritDoc */
	public function getHexDump():String
	{
		return DefaultObjectDumpFormatter.hexDump(this.toBinary());
	}
			
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type getters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	// Raw
	/** @private */
	public function getData(key:String):SFSDataWrapper
	{
		return dataHolder.get(key);
	}
	
	// Primitives
	
	/** @inheritDoc */
	public function getBool(key:String):Bool
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return cast wrapper.data;
		else 
			return false; // false
	}
	
	/** @inheritDoc */
	public function getByte(key:String):Int
	{
		return getInt(key);
	}
	
	/** @inheritDoc */
	public function getUnsignedByte(key:String):Int
	{
		return getInt(key) & 0x000000FF;
	}
	
	/** @inheritDoc */
	public function getShort(key:String):Int
	{
		return getInt(key);
	}
	
	/** @inheritDoc */
	public function getInt(key:String):Int
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		if(wrapper != null)
		{
			#if (js || flash)
			return wrapper.data;
			#else
			var value:Dynamic = wrapper.data;
			if(Std.is(value, Int))
			{
				return value;
			}
			return Std.parseInt(""+value);
			#end
		}else{
			return 0; //==0
		}
	}
	
	/** @inheritDoc */
	public function getLong(key:String):Null<Float>
	{
		return getDouble(key);
	}
	
	/** @inheritDoc */
	public function getFloat(key:String):Null<Float>
	{
		return getDouble(key);
	}
	
	/** @inheritDoc */
	public function getDouble(key:String):Null<Float>
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return cast wrapper.data;
		else 
			return null; //==NaN
	}
	
	/** @inheritDoc */
	public function getUtfString(key:String):String
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return cast wrapper.data;
		else 
			return null;
	}
	
	// Arrays
	
	private function getArray(key:String):Array<Dynamic>
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return cast wrapper.data;
		else 
			return null;
	}
	
	/** @inheritDoc */
	public function getBoolArray(key:String):Array<Bool>
	{
		return cast getArray(key);
	}
	
	/** @inheritDoc */
	public function getByteArray(key:String):ByteArray
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return cast wrapper.data;
		else 
			return null;
	}
	
	/** @inheritDoc */
	public function getUnsignedByteArray(key:String):Array<Int>
	{
		var ba:ByteArray = getByteArray(key);
		
		if(ba==null)
			return null;
		
		ba.position = 0;
		var unsignedBytes:Array<Int> = [];
		
		for(i in 0...ba.length)
		{
			unsignedBytes.push(ba.readByte() & 0x000000FF);
		}
		
		return unsignedBytes;
	}
	
	/** @inheritDoc */
	public function getShortArray(key:String):Array<Int>
	{
		return cast getArray(key);
	}
	
	/** @inheritDoc */
	public function getIntArray(key:String):Array<Int>
	{
		return cast getArray(key);	
	}
	
	/** @inheritDoc */
	public function getLongArray(key:String):Array<Float>
	{
		return cast getArray(key);	
	}
	
	/** @inheritDoc */
	public function getFloatArray(key:String):Array<Float>
	{
		return cast getArray(key);
	}
	
	/** @inheritDoc */
	public function getDoubleArray(key:String):Array<Float>
	{
		return cast getArray(key);
	}
	
	/** @inheritDoc */
	public function getUtfStringArray(key:String):Array<String>
	{
		return cast getArray(key);
	}
	
	// Nested objects
	
	/** @inheritDoc */
	public function getSFSArray(key:String):ISFSArray
	{
		var wrapper:SFSDataWrapper = cast dataHolder.get(key);
		
		if (wrapper != null)
			return cast wrapper.data;
		else 
			return null;
	}
	
	/** @inheritDoc */
	public function getSFSObject(key:String):ISFSObject
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return cast wrapper.data;
		else 
			return null;
	}
	
	/**
	 * @inheritDoc
	 * 
	 * @see		ISFSObject#getClass()
	 */
	public function getClass(key:String):Dynamic
	{
		var wrapper:SFSDataWrapper = cast dataHolder[key];
		
		if(wrapper !=null)
			return wrapper.data;
		else 
			return null;
	}
	
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type setters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	// Primitives
	
	/** @private */
	public function putNull(key:String):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.NULL, null);
	}
	
	/** @inheritDoc */
	public function putBool(key:String, value:Bool):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.BOOL, value);
	}
	
	/** @inheritDoc */
	public function putByte(key:String, value:Int):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.BYTE, value);
	}
	
	/** @inheritDoc */
	public function putShort(key:String, value:Int):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.SHORT, value);
	}
	
	/** @inheritDoc */
	public function putInt(key:String, value:Int):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.INT, value);
	}
	
	/** @inheritDoc */
	public function putLong(key:String, value:Float):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.LONG, value);
	}
	
	/** @inheritDoc */
	public function putFloat(key:String, value:Float):Void
	{	
		dataHolder[key] = new SFSDataWrapper(SFSDataType.FLOAT, value);
	}
	
	/** @inheritDoc */
	public function putDouble(key:String, value:Float):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.DOUBLE, value);
	}
	
	/** @inheritDoc */
	public function putUtfString(key:String, value:String):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.UTF_STRING, value);
	}
	
	// Arrays
	
	/** @inheritDoc */
	public function putBoolArray(key:String, value:Array<Bool>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.BOOL_ARRAY, value);	
	}
	
	/** @inheritDoc */
	public function putByteArray(key:String, value:ByteArray):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.BYTE_ARRAY, value);
	}
	
	/** @inheritDoc */
	public function putShortArray(key:String, value:Array<Int>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.SHORT_ARRAY, value);	
	}
	
	/** @inheritDoc */
	public function putIntArray(key:String, value:Array<Int>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.INT_ARRAY, value);	
	}
	
	/** @inheritDoc */
	public function putLongArray(key:String, value:Array<Float>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.LONG_ARRAY, value);	
	}
	
	/** @inheritDoc */
	public function putFloatArray(key:String, value:Array<Float>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.FLOAT_ARRAY, value);	
	}
	
	/** @inheritDoc */
	public function putDoubleArray(key:String, value:Array<Float>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY, value);
	}
	
	/** @inheritDoc */
	public function putUtfStringArray(key:String, value:Array<String>):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY, value);
	}
	
	// Nested objects
	
	/** @inheritDoc */
	public function putSFSArray(key:String, value:ISFSArray):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.SFS_ARRAY, value);
	}
	
	/** @inheritDoc */
	public function putSFSObject(key:String, value:ISFSObject):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.SFS_OBJECT, value);
	}
	
	/** @inheritDoc */
	public function putClass(key:String, value:Dynamic):Void
	{
		dataHolder[key] = new SFSDataWrapper(SFSDataType.CLASS, value);
	}
	
	// Generic putter
	
	/** @private */
	public function put(key:String, value:SFSDataWrapper):Void
	{
		dataHolder[key] = value;			
	}
}