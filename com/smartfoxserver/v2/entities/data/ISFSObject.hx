package com.smartfoxserver.v2.entities.data;

import com.smartfoxserver.v2.util.ByteArray;

/**
 * The<em>ISFSObject</em>interface defines all the public methods and properties
 * of the<em>SFSObject</em>class used by SmartFoxServer in client-server data transfer.
 * Read the implementor class description for additional informations.
 * 
 *<p><b>NOTE</b>:where mentioned in the "See also" section of the members descriptions below,
 * check the<em>SFSDataType</em>class for more informations on data types conversion in ActionScript 3.</p>
 * 
 * @see 	SFSObject
 * @see 	SFSDataType
 */
interface ISFSObject
{
	/**
	 * Indicates if the value mapped by the specified key is<code>null</code>.
	 * 
	 * @param	key	The key to be checked.
	 * 
	 * @return<code>true</code>if the value mapped by the passed key is<code>null</code>.
	 */
	function isNull(key:String):Bool;
	
	/**
	 * Indicates whether this object contains a mapping for the specified key or not.
	 * 
	 * @param	key	The key whose presence in this object is to be tested.
	 * 
	 * @return	<code>true</code>if this object contains a mapping for the specified key.
	 */
	function containsKey(key:String):Bool;
	
	/**
	 * Removes the element corresponding to the passed key from this object.
	 * 
	 * @param	key	The key of the element to be removed.
	 */
	function removeElement(key:String):Void;
	
	/**
	 * Retrieves a list of all the keys contained in this object.
	 * 
	 * @return	The list of all the keys in this object.
	 */
	function getKeys():Array<String>;
	
	/**
	 * Indicates the number of elements in this object.
	 * 
	 * @return	The number of elements in this object.
	 */
	function size():Int;
	
	/**
	 * Provides the binary form of this object.
	 * 
	 * @return	The binary data representing this object.
	 */
	function toBinary():ByteArray;
		
	/**
	 * Converts the SFSObject to a regular AS Dynamic.
	 * 
	 * @return	The object.
	 */
	function toObject():Dynamic;
	
	/** 
	 * Provides a formatted string representing this object.
	 * The returned string can be logged or traced in the console for debugging purposes.
	 * 
	 * @param	format	If<code>true</code>, the output is formatted in a human-readable way.
	 * 
	 * @return	The string representation of this object.
	 */ 
	function getDump(format:Bool = true):String;
	
	/** 
	 * Provides a detailed hexadecimal representation of this object.
	 * The returned string can be logged or traced in the console for debugging purposes.
	 * 
	 * @return	The hexadecimal string representation of this object.
	 */ 
	function getHexDump():String;
	
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type getters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	/** @private */
	function getData(key:String):SFSDataWrapper;
	
	/**
	 * Returns the element corresponding to the specified key as a boolean.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 */
	function getBool(key:String):Bool;
	
	/**
	 * Returns the element corresponding to the specified key as a signed byte(8 bit).
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function getByte(key:String):Int;
	
	/**
	 * Returns the element corresponding to the specified key as an unsigned byte(8 bit).
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function getUnsignedByte(key:String):Int;
	
	/**
	 * Returns the element corresponding to the specified key as a short Integer(16 bit).
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function getShort(key:String):Int;
	
	/**
	 * Returns the element corresponding to the specified key as an Integer(32 bit).
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 */
	function getInt(key:String):Int;
	
	/**
	 * Returns the element corresponding to the specified key as a long Integer(64 bit).
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function getLong(key:String):Null<Float>;
	
	/**
	 * Returns the element corresponding to the specified key as a floating point number.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function getFloat(key:String):Null<Float>;
	
	/**
	 * Returns the element corresponding to the specified key as a double precision number.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function getDouble(key:String):Null<Float>;
	
	/**
	 * Returns the element corresponding to the specified key as a UTF-8 string.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object associated with the specified key.
	 */
	function getUtfString(key:String):String;
	
	/**
	 * Returns the element corresponding to the specified key as an array of booleans.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>Boolean</em>values.
	 */
	function getBoolArray(key:String):Array<Bool>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of bytes.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as a<em>ByteArray</em>.
	 */
	function getByteArray(key:String):ByteArray;
	
	/**
	 * Returns the element corresponding to the specified key as an array of unsigned bytes.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>int</em>values.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function getUnsignedByteArray(key:String):Array<Int>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of short Integers.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>int</em>values.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function getShortArray(key:String):Array<Int>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of Integers.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>int</em>values.
	 */
	function getIntArray(key:String):Array<Int>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of long Integers.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>Number</em>values.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function getLongArray(key:String):Array<Float>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of floating point numbers.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>Number</em>values.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function getFloatArray(key:String):Array<Float>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of double precision numbers.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>Number</em>values.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function getDoubleArray(key:String):Array<Float>;
	
	/**
	 * Returns the element corresponding to the specified key as an array of UTF-8 strings.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an array of<em>String</em>values.
	 */
	function getUtfStringArray(key:String):Array<String>;
	
	/**
	 * Returns the element corresponding to the specified key as an<em>ISFSArray</em>object.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an object implementing the<em>ISFSArray</em>interface.
	 */
	function getSFSArray(key:String):ISFSArray;
	
	/**
	 * Returns the element corresponding to the specified key as an<em>ISFSObject</em>object.
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as an object implementing the<em>ISFSObject</em>interface.
	 */
	function getSFSObject(key:String):ISFSObject;
	
	/**
	 * Returns the element corresponding to the specified key as an instance of a custom class.
	 * 
	 *<p>This advanced feature allows the transmission of specific object instances between client-side ActionScript and
	 * server-side Java provided that the respective class definition on both sides have the same package name.</p>
	 * 
	 * @param	key	The key whose associated value is to be returned.
	 * 
	 * @return  The element of this object as a generic<em>Object</em>type to be casted to the target class definition.
	 * 
	 * @example	The following example shows the same class on the client and server sides,
	 * which can be transferred back and forth with the<em>getClass()</em>and<em>putClass()</em>methods.
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
	 * The SpaceShip instance is sent by the server to the client. This is how to retrieve it:
	 *<listing version="3.0">
	 * 
	 * var key:String="spaceShip";
	 * var myShipData:SpaceShip=sfsObject.getClass(key)as SpaceShip;
	 *</listing>
	 */
	function getClass(key:String):Dynamic;
	
	/*
	*:::::::::::::::::::::::::::::::::::::::::
	* Type setters
	*:::::::::::::::::::::::::::::::::::::::::	
	*/
	
	/** @private */
	function putNull(key:String):Void;
	
	/**
	 * Associates the passed boolean value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 */
	function putBool(key:String, value:Bool):Void;
	
	/**
	 * Associates the passed byte(8 bit)value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 * 
	 * @see		SFSDataType#BYTE
	 */
	function putByte(key:String, value:Int):Void;
	
	/**
	 * Associates the passed short Integer(16 bit)value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function putShort(key:String, value:Int):Void;
	
	/**
	 * Associates the passed Integer(32 bit)value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 */
	function putInt(key:String, value:Int):Void;
	
	/**
	 * Associates the passed long Integer(64 bit)value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function putLong(key:String, value:Float):Void;
	
	/**
	 * Associates the passed floating point number(32 bit)value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function putFloat(key:String, value:Float):Void;
	
	/**
	 * Associates the passed double precision number(64 bit)value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function putDouble(key:String, value:Float):Void;
	
	/**
	 * Associates the passed UTF-8 string value with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified value is to be associated.
	 * @param	value	The value to be associated with the specified key.
	 */
	function putUtfString(key:String, value:String):Void;
	
	/**
	 * Associates the passed array of boolean values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>Boolean</em>values to be associated with the specified key.
	 */
	function putBoolArray(key:String, value:Array<Bool>):Void;
	
	/**
	 * Associates the passed array of bytes with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified<em>ByteArray</em>is to be associated.
	 * @param	value	The<em>ByteArray</em>to be associated with the specified key.
	 */
	function putByteArray(key:String, value:ByteArray):Void;
	
	/**
	 * Associates the passed array of short Integer values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>int</em>values to be associated with the specified key.
	 * 
	 * @see		SFSDataType#SHORT
	 */
	function putShortArray(key:String, value:Array<Int>):Void;
	
	/**
	 * Associates the passed array of Integer values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>int</em>values to be associated with the specified key.
	 */
	function putIntArray(key:String, value:Array<Int>):Void;
	
	/**
	 * Associates the passed array of long Integer values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>Number</em>values to be associated with the specified key.
	 * 
	 * @see		SFSDataType#LONG
	 */
	function putLongArray(key:String, value:Array<Float>):Void;
	
	/**
	 * Associates the passed array of floating point number values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>Number</em>values to be associated with the specified key.
	 * 
	 * @see		SFSDataType#FLOAT
	 */
	function putFloatArray(key:String, value:Array<Float>):Void;
	
	/**
	 * Associates the passed array of double precision number values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>Number</em>values to be associated with the specified key.
	 * 
	 * @see		SFSDataType#DOUBLE
	 */
	function putDoubleArray(key:String, value:Array<Float>):Void;
	
	/**
	 * Associates the passed array of UTF-8 string values with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified array is to be associated.
	 * @param	value	The array of<em>String</em>values to be associated with the specified key.
	 */
	function putUtfStringArray(key:String, value:Array<String>):Void;
	
	/**
	 * Associates the passed<em>ISFSArray</em>object with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified object implementing the<em>ISFSArray</em>interface is to be associated.
	 * @param	value	The<em>ISFSArray</em>object to be associated with the specified key.
	 */
	function putSFSArray(key:String, value:ISFSArray):Void;
	
	/**
	 * Associates the passed<em>ISFSObject</em>object with the specified key in this object.
	 * 
	 * @param	key		The key with which the specified object implementing the<em>ISFSObject</em>interface is to be associated.
	 * @param	value	The<em>ISFSObject</em>object to be associated with the specified key.
	 */
	function putSFSObject(key:String, value:ISFSObject):Void;
	
	/**
	 * Associates the passed custom class instance with the specified key in this object.
	 * Read the<em>getClass()</em>method description for more informations. 
	 * 
	 * @param	key		The key with which the specified custom class instance is to be associated.
	 * @param	value	The custom class instance to be associated with the specified key.
	 * 
	 * @see #getClass()
	 */
	function putClass(key:String, value:Dynamic):Void;
	
	/** @private */
	function put(key:String, value:SFSDataWrapper):Void;
}