package com.smartfoxserver.v2.entities.data;

import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
import com.smartfoxserver.v2.protocol.serialization.ISFSDataSerializer;

import flash.utils.ByteArray;

/**
 * The<em>SFSArray</em>class is used by SmartFoxServer in client-server data transfer.
 * It can be thought of as a specialized Array/List object that can contain any type of data.
 * 
 *<p>The advantage of using the<em>SFSArray</em>class(for example as a nested object inside a<em>SFSObject</em>object)is that you can fine tune the way your data is transmitted over the network.
 * For instance, when transmitting a list of numbers between<code>0</code>and<code>100</code>, those values can be treated as normal Integers(which take 32 bits each), but also as shorts(16 bit)or even as bytes(8 bit).</p>
 * 
 *<p><em>SFSArray</em>supports many primitive data types and related arrays of primitives(see the<em>SFSDataType</em>class). It also allows to serialize class instances and rebuild them on the other side(client or server). 
 * Check the SmartFoxServer 2X documentation for more informations on this advanced topic.</p>
 * 
 * @see 	SFSObject
 * @see 	SFSDataType
 */
class SFSArray implements ISFSArray
{
	private var serializer:ISFSDataSerializer;
	
	public var dataHolder:Array<SFSDataWrapper>;
	
	/**
	 * Returns a new<em>SFSArray</em>instance.
	 * 
	 *<p>This is an alternative static constructor that builds a<em>SFSArray</em>populated with the data found in the passed native ActionScript<em>Array</em>.
	 * Numeric data is translated to<em>int</em>(integer values)or<em>Number</em>(decimal values). The procedure is recursive and works for nested objects and arrays.
	 * The supported native types are:<em>Boolean</em>,<em>int</em>,<em>Number</em>,<em>String</em>,<em>Object</em>,<em>Array</em>. The array can contain<code>null</code>values too.</p>
	 * 
	 * @param	arr				The source<em>Array</em>.
	 * @param   forceToNumber	Indicates if the conversion of all numeric values should be forced to the highest precision possible(<em>Number</em>). This means that Integer values will be treated as double precision values.
	 * 
	 * @return	A new<em>SFSArray</em>instance populated with data from the passed array.
	 * 
	 * @see		#SFSArray()
	 * @see		#newInstance()
	 */
	public static function newFromArray(arr:Array<Dynamic>, forceToNumber:Bool=false):SFSArray
	{
		return DefaultSFSDataSerializer.getInstance().genericArrayToSFSArray(arr, forceToNumber);
	}
	
	/**
	 * @private
	 * 
	 * Alternative static constructor that builds a SFSArray from a valid SFSArray binary representation.
	 * 
	 * @param	ba
	 * 
	 * @return	 
	 * 
	 * @see		#toBinary()
	 */
	public static function newFromBinaryData(ba:ByteArray):SFSArray
	{
		return cast(DefaultSFSDataSerializer.getInstance().binary2array(ba),SFSArray);
	}
	
	/**
	 * Returns a new<em>SFSArray</em>instance.
	 * This method is an alternative to the standard class constructor.
	 * 
	 * @return	A new<em>SFSArray</em>instance.
	 * 
	 * @see		#SFSArray()
	 * @see		#newFromArray()
	 */
	public static function newInstance():SFSArray
	{
		return new SFSArray();
	}
	
	/**
	 * Creates a new<em>SFSArray</em>instance.
	 * 
	 * @see		#newInstance()
	 * @see		#newFromArray()
	 */
	public function new()
	{
		dataHolder = new Array<SFSDataWrapper>();
		serializer = DefaultSFSDataSerializer.getInstance();
	}
	
	/** @inheritDoc */
	public function contains(obj:Dynamic):Bool
	{
		if(Std.isOfType(obj, ISFSArray) || Std.isOfType(obj,ISFSObject))
			throw new SFSError("ISFSArray and ISFSObject are not supported by this method.");
			
		var found:Bool = false;
		
		
		for(j in 0...size())
		{
			var element:Dynamic = getElementAt(j);
			
			if(element !=null && element==obj)
			{
				found = true;
				break;
			}
		}	
		
		return found;
	}
	
	/** @private */
	public function getWrappedElementAt(index:Int):SFSDataWrapper
	{
		return dataHolder[index];
	}
	
	/** @inheritDoc */
	public function getElementAt(index:Int):Dynamic
	{
		var obj:Dynamic = null;
		
		if(dataHolder.length > index)
			obj = dataHolder[index].data;
		
		return obj;
	}
	
	/** @inheritDoc */
	public function removeElementAt(index:Int):Dynamic
	{
		return dataHolder.splice(index,1);
	}
	
	/** @inheritDoc */
	public function size():Int
	{
		return dataHolder.length;
	}
	
	/** @inheritDoc */
	public function toBinary():ByteArray
	{
		return serializer.array2binary(this);
	}
	
	/** 
	 * Converts the SFSArray to a native Actionscript Array. The procedure is recurisive so all nested objects will also be 
	 * converted. The process does not include elements of type<b>SFSDataType.CLASS</b>
	 * 
	 * @return	The converted Array
	 * @see SFSDataType
	 */ 
	public function toArray():Array<Dynamic>
	{
		return DefaultSFSDataSerializer.getInstance().sfsArrayToGenericArray(this);
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
		var objDump:String; 
		var type:Int;

		for(i in 0...dataHolder.length)
		{
			wrapper = dataHolder[i]; 
			type = wrapper.type;
				
			if (type == SFSDataType.SFS_OBJECT)
				objDump = cast(wrapper.data, SFSObject).getDump(false);
			
			else if(type==SFSDataType.SFS_ARRAY)
				objDump = cast(wrapper.data, SFSArray).getDump(false);
			
			else if(type>SFSDataType.UTF_STRING && type<SFSDataType.CLASS)
				objDump = "[" + wrapper.data + "]";
					
			else if(type==SFSDataType.BYTE_ARRAY)
				objDump = DefaultObjectDumpFormatter.prettyPrintByteArray(cast wrapper.data);
			
			else 
				objDump = wrapper.data;
			
			strDump += "(" + SFSDataType.fromId(wrapper.type).toLowerCase() + ")";
			strDump += objDump;
							
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
	* Type setters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	/** @inheritDoc */
	public function addNull():Void
	{
		addObject(null, SFSDataType.NULL);
	}
	
	/** @inheritDoc */
	public function addBool(value:Bool):Void
	{
		addObject(value, SFSDataType.BOOL);
	}
	
	/** @inheritDoc */
	public function addByte(value:Int):Void
	{
		addObject(value, SFSDataType.BYTE);
	}
	
	/** @inheritDoc */
	public function addShort(value:Int):Void
	{
		addObject(value, SFSDataType.SHORT);
	}
	
	/** @inheritDoc */
	public function addInt(value:Int):Void
	{
		addObject(value, SFSDataType.INT);	
	}
	
	/** @inheritDoc */
	public function addLong(value:Float):Void
	{
		addObject(value, SFSDataType.LONG);	
	}
	
	/** @inheritDoc */
	public function addFloat(value:Float):Void
	{
		addObject(value, SFSDataType.FLOAT);	
	}
	
	/** @inheritDoc */
	public function addDouble(value:Float):Void
	{
		addObject(value, SFSDataType.DOUBLE);
	}
	
	/** @inheritDoc */
	public function addUtfString(value:String):Void
	{
		addObject(value, SFSDataType.UTF_STRING);	
	}
	
	/** @inheritDoc */
	public function addBoolArray(value:Array<Bool>):Void
	{
		addObject(value, SFSDataType.BOOL_ARRAY);	
	}
	
	/** @inheritDoc */
	public function addByteArray(value:ByteArray):Void
	{
		addObject(value, SFSDataType.BYTE_ARRAY);
	}
	
	/** @inheritDoc */
	public function addShortArray(value:Array<Int>):Void
	{
		addObject(value, SFSDataType.SHORT_ARRAY);
	}
	
	/** @inheritDoc */
	public function addIntArray(value:Array<Int>):Void
	{
		addObject(value, SFSDataType.INT_ARRAY);	
	}
	
	/** @inheritDoc */
	public function addLongArray(value:Array<Float>):Void
	{
		addObject(value, SFSDataType.LONG_ARRAY);	
	}
	
	/** @inheritDoc */
	public function addFloatArray(value:Array<Float>):Void
	{
		addObject(value, SFSDataType.FLOAT_ARRAY);	
	}
	
	/** @inheritDoc */
	public function addDoubleArray(value:Array<Float>):Void
	{
		addObject(value, SFSDataType.DOUBLE_ARRAY);	
	}
	
	/** @inheritDoc */
	public function addUtfStringArray(value:Array<String>):Void
	{
		addObject(value, SFSDataType.UTF_STRING_ARRAY);
	}
	
	/** @inheritDoc */
	public function addSFSArray(value:ISFSArray):Void
	{
		addObject(value, SFSDataType.SFS_ARRAY);
	}
	
	/** @inheritDoc */
	public function addSFSObject(value:ISFSObject):Void
	{
		addObject(value, SFSDataType.SFS_OBJECT);
	}
	
	/** @inheritDoc */
	public function addClass(value:Dynamic):Void
	{
		addObject(value, SFSDataType.CLASS);
	}
	
	/** @private */
	public function add(wrappedObject:SFSDataWrapper):Void
	{
		dataHolder.push(wrappedObject);
	}
	
	private function addObject(value:Dynamic, type:Int):Void
	{
		this.add(new SFSDataWrapper(type, value));
	}
	
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type getters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	/** @inheritDoc */
	public function isNull(index:Int):Bool
	{
		var isNull:Bool=false;
		var wrapper:SFSDataWrapper = dataHolder[index];
		
		if(wrapper==null || wrapper.type==SFSDataType.NULL)
			isNull = true;
			
		return isNull;
	}
	
	/** @inheritDoc */
	public function getBool(index:Int):Null<Bool>
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?cast(wrapper.data):null);
	}
	
	/** @inheritDoc */
	public function getByte(index:Int):Int
	{
		return getInt(index);
	}
	
	/** @inheritDoc */
	public function getUnsignedByte(index:Int):Int
	{
		return getInt(index) & 0x000000FF;
	}
	
	/** @inheritDoc */
	public function getShort(index:Int):Int
	{
		return getInt(index);
	}
	
	/** @inheritDoc */
	public function getInt(index:Int):Int
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?(cast(wrapper.data,Int)):0);
	}
	
	/** @inheritDoc */
	public function getLong(index:Int):Null<Float>
	{
		return getDouble(index);
	}
	
	/** @inheritDoc */
	public function getFloat(index:Int):Null<Float>
	{
		return getDouble(index);
	}
	
	/** @inheritDoc */
	public function getDouble(index:Int):Null<Float>
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?(cast(wrapper.data,Float)):null);
	}
	
	/** @inheritDoc */
	public function getUtfString(index:Int):String
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?(cast(wrapper.data, String)):null);
	}
	
	private function getArray(index:Int):Array<Dynamic>
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?(cast(wrapper.data, Array<Dynamic>)):null);
	}
	
	/** @inheritDoc */
	public function getBoolArray(index:Int):Array<Bool>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getByteArray(index:Int):ByteArray
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?(cast(wrapper.data, ByteArray)):null);
	}
	
	/** @inheritDoc */
	public function getUnsignedByteArray(index:Int):Array<Int>
	{
		var ba:ByteArray = getByteArray(index);
		
		if(ba==null)
			return null;
			
		var unsignedBytes:Array<Int> = [];
		
		ba.position = 0;
		for(i in 0...ba.length)
		{
			unsignedBytes.push(ba.readByte() & 0x000000FF);
		}
		
		return unsignedBytes;
	}
	
	/** @inheritDoc */
	public function getShortArray(index:Int):Array<Int>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getIntArray(index:Int):Array<Int>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getLongArray(index:Int):Array<Float>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getFloatArray(index:Int):Array<Float>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getDoubleArray(index:Int):Array<Float>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getUtfStringArray(index:Int):Array<String>
	{
		return cast getArray(index);
	}
	
	/** @inheritDoc */
	public function getSFSArray(index:Int):ISFSArray
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return (wrapper != null ?(cast(wrapper.data, ISFSArray)):null);
	}
	
	/** @inheritDoc */
	public function getClass(index:Int):Dynamic
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ? wrapper.data:null);
	}
	
	/** @inheritDoc */
	public function getSFSObject(index:Int):ISFSObject
	{
		var wrapper:SFSDataWrapper = dataHolder[index];
		return(wrapper != null ?(cast(wrapper.data,ISFSObject)):null);
	}
}