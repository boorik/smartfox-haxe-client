package com.smartfoxserver.v2.entities.data;
import com.smartfoxserver.v2.util.ByteArray;

/**
 * The<em>ISFSArray</em>interface defines all the public methods and properties
 * of the<em>SFSArray</em>class used by SmartFoxServer in client-server data transfer.
 * Read the implementor class description for additional informations.
 * 
 *<p><b>NOTE</b>:where mentioned in the "See also" section of the members descriptions below,
 * check the<em>SFSDataType</em>class for more informations on data types conversion in ActionScript 3.</p>
 * 
 * @see 	SFSArray
 * @see 	SFSDataType
 */
interface ISFSArray
{
	public var dataHolder:Array<SFSDataWrapper>;
	/**
	 * Indicates whether this array contains the specified object or not.
	 * 
	 * @param	obj	The object whose presence in this array is to be tested.
	 * 
	 * @return	<code>true</code>if the specified object is present.
	 */
	function contains(obj:Dynamic):Bool;
	
	/** Returns the element at the specified index */
	/**
	 * Returns the element at the specified position in this array.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element at the specified index in this array.
	 */
	function getElementAt(index:Int):Dynamic;
	
	/** @private */
	function getWrappedElementAt(index:Int):SFSDataWrapper;
	
	/**
	 * Removes the element at the specified position in this array.
	 * 
	 * @param	index	The position of the element to be removed.
	 * 
	 * @return	The element that was removed.
	 */
	function removeElementAt(index:Int):Dynamic;
	
	/**
	 * Indicates the number of elements in this array.
	 * 
	 * @return	The number of elements in this array.
	 */
	function size():Int;
	
	/**
	 * Provides the binary form of this array.
	 * 
	 * @return	The binary data representing this array.
	 */
	function toBinary():ByteArray;
	
	/** 
	 * Provides a formatted string representing this array.
	 * The returned string can be logged or traced in the console for debugging purposes.
	 * 
	 * @param	format	If<code>true</code>, the output is formatted in a human-readable way.
	 * 
	 * @return	The string representation of this array.
	 */ 
	function getDump(format:Bool = true):String;
	
	/** 
	 * Provides a detailed hexadecimal representation of this array.
	 * The returned string can be logged or traced in the console for debugging purposes.
	 * 
	 * @return	The hexadecimal string representation of this array.
	 */ 
	function getHexDump():String;
	
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type setters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	/**
	 * Appends a<code>null</code>value to the end of this array.
	 */
	function addNull():Void;
	
	/**
	 * Appends a boolean value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 */
	function addBool(value:Bool):Void;
	
	/**
	 * Appends a byte(8 bit)value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function addByte(value:Int):Void;
	
	/**
	 * Appends a short Integer(16 bit)value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function addShort(value:Int):Void;
	
	/**
	 * Appends an Integer(32 bit)value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 */
	function addInt(value:Int):Void;
	
	/**
	 * Appends a long Integer(64 bit)value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function addLong(value:Float):Void;
	
	/**
	 * Appends a floating point number(32 bit)value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function addFloat(value:Float):Void;
	
	/**
	 * Appends a double precision number(64 bit)value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function addDouble(value:Float):Void;
	
	/**
	 * Appends a UTF-8 string value to the end of this array.
	 * 
	 * @param	value	The value to be appended to this array.
	 */
	function addUtfString(value:String):Void;
	
	/**
	 * Appends an array of boolean values to the end of this array.
	 * 
	 * @param	value	The array of<em>Boolean</em>values to be appended to this array.
	 */
	function addBoolArray(value:Array<Bool>):Void;
	
	/**
	 * Appends an array of bytes to the end of this array.
	 * 
	 * @param	value	The array of<em>int</em>values to be appended to this array.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function addByteArray(value:ByteArray):Void;
	
	/**
	 * Appends an array of short Integer values to the end of this array.
	 * 
	 * @param	value	The array of<em>int</em>values to be appended to this array.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function addShortArray(value:Array<Int>):Void;
	
	/**
	 * Appends an array of Integer values to the end of this array.
	 * 
	 * @param	value	The array of<em>int</em>values to be appended to this array.
	 */
	function addIntArray(value:Array<Int>):Void;
	
	/**
	 * Appends an array of long Integer values to the end of this array.
	 * 
	 * @param	value	The array of<em>Number</em>values to be appended to this array.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function addLongArray(value:Array<Float>):Void;
	
	/**
	 * Appends an array of floating point number values to the end of this array.
	 * 
	 * @param	value	The array of<em>Number</em>values to be appended to this array.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function addFloatArray(value:Array<Float>):Void;
	
	/**
	 * Appends an array of double precision number values to the end of this array.
	 * 
	 * @param	value	The array of<em>Number</em>values to be appended to this array.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function addDoubleArray(value:Array<Float>):Void;
	
	/**
	 * Appends an array of UTF-8 string values to the end of this array.
	 * 
	 * @param	value	The array of<em>String</em>values to be appended to this array.
	 */
	function addUtfStringArray(value:Array<String>):Void;
	
	/**
	 * Appends a<em>ISFSArray</em>object to the end of this array.
	 * 
	 * @param	value	The object implementing the<em>ISFSArray</em>interface to be appended to this array.
	 */
	function addSFSArray(value:ISFSArray):Void;
	
	/**
	 * Appends a<em>ISFSObject</em>object to the end of this array.
	 * 
	 * @param	value	The object implementing the<em>ISFSObject</em>interface to be appended to this array.
	 */
	function addSFSObject(value:ISFSObject):Void;
	
	/**
	 * Appends the passed custom class instance to the end of this array.
	 * Read the<em>getClass()</em>method description for more informations. 
	 * 
	 * @param	value	The custom class instance to be appended to this array.
	 * 
	 * @see #getClass()
	 */
	function addClass(value:Dynamic):Void;
	
	/** @private */
	function add(wrappedObject:SFSDataWrapper):Void;
	
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type getters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	/**
	 * Indicates if the element at the specified position in this array is<code>null</code>.
	 * 
	 * @param	index	The position of the element to be checked.
	 * 
	 * @return<code>true</code>if the element of this array at the specified position is<code>null</code>.
	 */
	function isNull(index:Int):Bool;
	
	/**
	 * Returns the element at the specified position as a boolean.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 */
	function getBool(index:Int):Null<Bool>;
	
	/**
	 * Returns the element at the specified position as a signed byte(8 bit).
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function getByte(index:Int):Int;
	
	/**
	 * Returns the element at the specified position as an unsigned byte(8 bit).
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function getUnsignedByte(index:Int):Int;
	
	/**
	 * Returns the element at the specified position as a short Integer(16 bit).
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function getShort(index:Int):Int;
	
	/**
	 * Returns the element at the specified position as an Integer(32 bit).
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 */
	function getInt(index:Int):Int;
	
	/**
	 * Returns the element at the specified position as a long Integer(64 bit).
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function getLong(index:Int):Null<Float>;
	
	/**
	 * Returns the element at the specified position as a floating point number.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function getFloat(index:Int):Null<Float>;
	
	/**
	 * Returns the element at the specified position as a double precision number.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function getDouble(index:Int):Null<Float>;
	
	/**
	 * Returns the element at the specified position as a UTF-8 string.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array at the specified index.
	 */
	function getUtfString(index:Int):String;
	
	/**
	 * Returns the element at the specified position as an array of booleans.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>Boolean</em>values.
	 */
	function getBoolArray(index:Int):Array<Bool>;
	
	/**
	 * Returns the element at the specified position as an array of bytes.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as a<em>ByteArray</em>.
	 */
	function getByteArray(index:Int):ByteArray;
	
	/**
	 * Returns the element at the specified position as an array of unsigned bytes.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>int</em>values.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function getUnsignedByteArray(index:Int):Array<Int>;
	
	/**
	 * Returns the element at the specified position as an array of short Integers.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>int</em>values.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function getShortArray(index:Int):Array<Int>;
	
	/**
	 * Returns the element at the specified position as an array of Integers.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>int</em>values.
	 */
	function getIntArray(index:Int):Array<Int>;
	
	/**
	 * Returns the element at the specified position as an array of long Integers.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>Number</em>values.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function getLongArray(index:Int):Array<Float>;
	
	/**
	 * Returns the element at the specified position as an array of floating point numbers.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>Number</em>values.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function getFloatArray(index:Int):Array<Float>;
	
	/**
	 * Returns the element at the specified position as an array of double precision numbers.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>Number</em>values.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function getDoubleArray(index:Int):Array<Float>;
	
	/**
	 * Returns the element at the specified position as an array of UTF-8 strings.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an array of<em>String</em>values.
	 */
	function getUtfStringArray(index:Int):Array<String>;
	
	/**
	 * Returns the element at the specified position as an<em>ISFSArray</em>object.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an object implementing the<em>ISFSArray</em>interface.
	 */
	function getSFSArray(index:Int):ISFSArray;
	
	/**
	 * Returns the element at the specified position as an<em>ISFSObject</em>object.
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return	The element of this array as an object implementing the<em>ISFSObject</em>interface.
	 */
	function getSFSObject(index:Int):ISFSObject;
	
	/**
	 * Returns the element at the specified position as an instance of a custom class.
	 * 
	 *<p>This advanced feature allows the transmission of specific object instances between client-side ActionScript and
	 * server-side Java provided that the respective class definition on both sides have the same package name.</p>
	 * 
	 * @param	index	The position of the element to return.
	 * 
	 * @return  The element of this array as a generic<em>Object</em>type to be casted to the target class definition.
	 * 
	 * @example	The following example shows the same class on the client and server sides,
	 * which can be transferred back and forth with the<em>getClass()</em>and<em>addClass()</em>methods.
	 * The server-side Java definition of a SpaceShip class is:
	 *<listing>
	 * 
	 * package my.game.spacecombat
	 * 
	 * class SpaceShip
	 * {
	 * 	private String type;
	 * 	private String name;
	 * 	private Int firePower;
	 * 	private Int maxSpeed;
	 * 	private List&lt;String&gt;weapons;
	 * 	
	 * 	public SpaceShip(String name, String type)
	 * 	{
	 * 		this.name=name;
	 * 		this.type=type;
	 * 	}
	 * 	
	 * 	// Getters/Setters
	 * 	
	 * 	...
	 * }
	 *</listing>
	 * 
	 * The client-side ActionScript 3 definition of the SpaceShip class is:
	 *<listing version="3.0">
	 * 
	 * package my.game.spacecombat
	 * 
	 * class SpaceShip
	 * {
	 * 	private var _type:String;
	 * 	private var _name:String;
	 * 	private var _firePower:Int;
	 * 	private var _maxSpeed:Int;
	 * 	private var _weapons:Array<Dynamic>;
	 * 	
	 * 	public function new(name:String, type:String)
	 * 	{
	 * 		_name=name;
	 * 		_type=type;
	 * 	}
	 * 	
	 * 	// Getters/Setters
	 * 	
	 * 	...
	 * }
	 *</listing>
	 * 
	 * A SpaceShip instance is sent by the server to the client in the first position of an array. This is how to retrieve it:
	 *<listing version="3.0">
	 * 
	 * var myShipData:SpaceShip=sfsArray.getClass(0)as SpaceShip;
	 *</listing>
	 */
	function getClass(index:Int):Dynamic;
}