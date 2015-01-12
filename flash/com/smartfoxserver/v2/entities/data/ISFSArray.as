package com.smartfoxserver.v2.entities.data
{
	import flash.utils.ByteArray;
	
	/**
	 * The <em>ISFSArray</em> interface defines all the public methods and properties
	 * of the <em>SFSArray</em> class used by SmartFoxServer in client-server data transfer.
	 * Read the implementor class description for additional informations.
	 * 
	 * <p><b>NOTE</b>: where mentioned in the "See also" section of the members descriptions below,
	 * check the <em>SFSDataType</em> class for more informations on data types conversion in ActionScript 3.</p>
	 * 
	 * @see 	SFSArray
	 * @see 	SFSDataType
	 */
	public interface ISFSArray
	{
		/**
		 * Indicates whether this array contains the specified object or not.
		 * 
		 * @param	obj	The object whose presence in this array is to be tested.
		 * 
		 * @return	<code>true</code> if the specified object is present.
		 */
		function contains(obj:*):Boolean
		
		/** Returns the element at the specified index */
		/**
		 * Returns the element at the specified position in this array.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element at the specified index in this array.
		 */
		function getElementAt(index:int):*
		
		/** @private */
		function getWrappedElementAt(index:int):SFSDataWrapper
		
		/**
		 * Removes the element at the specified position in this array.
		 * 
		 * @param	index	The position of the element to be removed.
		 * 
		 * @return	The element that was removed.
		 */
		function removeElementAt(index:int):*
		
		/**
		 * Indicates the number of elements in this array.
		 * 
		 * @return	The number of elements in this array.
		 */
		function size():int
		
		/**
		 * Provides the binary form of this array.
		 * 
		 * @return	The binary data representing this array.
		 */
		function toBinary():ByteArray
		
		/** 
		 * Provides a formatted string representing this array.
		 * The returned string can be logged or traced in the console for debugging purposes.
		 * 
		 * @param	format	If <code>true</code>, the output is formatted in a human-readable way.
		 * 
		 * @return	The string representation of this array.
		 */ 
		function getDump(format:Boolean = true):String
		
		/** 
		 * Provides a detailed hexadecimal representation of this array.
		 * The returned string can be logged or traced in the console for debugging purposes.
		 * 
		 * @return	The hexadecimal string representation of this array.
		 */ 
		function getHexDump():String
		
		/*
		* :::::::::::::::::::::::::::::::::::::::::
		* Type setters
		* :::::::::::::::::::::::::::::::::::::::::	
		*/
		
		/**
		 * Appends a <code>null</code> value to the end of this array.
		 */
		function addNull():void
		
		/**
		 * Appends a boolean value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 */
		function addBool(value:Boolean):void
		
		/**
		 * Appends a byte (8 bit) value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 * 
		 * @see		SFSDataType#BYTE
		 */
		function addByte(value:int):void
		
		/**
		 * Appends a short integer (16 bit) value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 * 
		 * @see		SFSDataType#SHORT
		 */
		function addShort(value:int):void
		
		/**
		 * Appends an integer (32 bit) value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 */
		function addInt(value:int):void
		
		/**
		 * Appends a long integer (64 bit) value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 * 
		 * @see		SFSDataType#LONG
		 */
		function addLong(value:Number):void
		
		/**
		 * Appends a floating point number (32 bit) value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 * 
		 * @see		SFSDataType#FLOAT
		 */
		function addFloat(value:Number):void
		
		/**
		 * Appends a double precision number (64 bit) value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 * 
		 * @see		SFSDataType#DOUBLE
		 */
		function addDouble(value:Number):void
		
		/**
		 * Appends a UTF-8 string value to the end of this array.
		 * 
		 * @param	value	The value to be appended to this array.
		 */
		function addUtfString(value:String):void
		
		/**
		 * Appends an array of boolean values to the end of this array.
		 * 
		 * @param	value	The array of <em>Boolean</em> values to be appended to this array.
		 */
		function addBoolArray(value:Array):void
		
		/**
		 * Appends an array of bytes to the end of this array.
		 * 
		 * @param	value	The array of <em>int</em> values to be appended to this array.
		 * 
		 * @see		SFSDataType#BYTE
		 */
		function addByteArray(value:ByteArray):void
		
		/**
		 * Appends an array of short integer values to the end of this array.
		 * 
		 * @param	value	The array of <em>int</em> values to be appended to this array.
		 * 
		 * @see		SFSDataType#SHORT
		 */
		function addShortArray(value:Array):void
		
		/**
		 * Appends an array of integer values to the end of this array.
		 * 
		 * @param	value	The array of <em>int</em> values to be appended to this array.
		 */
		function addIntArray(value:Array):void
		
		/**
		 * Appends an array of long integer values to the end of this array.
		 * 
		 * @param	value	The array of <em>Number</em> values to be appended to this array.
		 * 
		 * @see		SFSDataType#LONG
		 */
		function addLongArray(value:Array):void
		
		/**
		 * Appends an array of floating point number values to the end of this array.
		 * 
		 * @param	value	The array of <em>Number</em> values to be appended to this array.
		 * 
		 * @see		SFSDataType#FLOAT
		 */
		function addFloatArray(value:Array):void
		
		/**
		 * Appends an array of double precision number values to the end of this array.
		 * 
		 * @param	value	The array of <em>Number</em> values to be appended to this array.
		 * 
		 * @see		SFSDataType#DOUBLE
		 */
		function addDoubleArray(value:Array):void
		
		/**
		 * Appends an array of UTF-8 string values to the end of this array.
		 * 
		 * @param	value	The array of <em>String</em> values to be appended to this array.
		 */
		function addUtfStringArray(value:Array):void
		
		/**
		 * Appends a <em>ISFSArray</em> object to the end of this array.
		 * 
		 * @param	value	The object implementing the <em>ISFSArray</em> interface to be appended to this array.
		 */
		function addSFSArray(value:ISFSArray):void
		
		/**
		 * Appends a <em>ISFSObject</em> object to the end of this array.
		 * 
		 * @param	value	The object implementing the <em>ISFSObject</em> interface to be appended to this array.
		 */
		function addSFSObject(value:ISFSObject):void
		
		/**
		 * Appends the passed custom class instance to the end of this array.
		 * Read the <em>getClass()</em> method description for more informations. 
		 * 
		 * @param	value	The custom class instance to be appended to this array.
		 * 
		 * @see #getClass()
		 */
		function addClass(value:*):void
		
		/** @private */
		function add(wrappedObject:SFSDataWrapper):void
		
		/*
		* :::::::::::::::::::::::::::::::::::::::::
		* Type getters
		* :::::::::::::::::::::::::::::::::::::::::	
		*/
		
		/**
		 * Indicates if the element at the specified position in this array is <code>null</code>.
		 * 
		 * @param	index	The position of the element to be checked.
		 * 
		 * @return  <code>true</code> if the element of this array at the specified position is <code>null</code>.
		 */
		function isNull(index:int):Boolean
		
		/**
		 * Returns the element at the specified position as a boolean.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 */
		function getBool(index:int):Boolean
		
		/**
		 * Returns the element at the specified position as a signed byte (8 bit).
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 * 
		 * @see		SFSDataType#BYTE
		 */
		function getByte(index:int):int
		
		/**
		 * Returns the element at the specified position as an unsigned byte (8 bit).
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 * 
		 * @see		SFSDataType#BYTE
		 */
		function getUnsignedByte(index:int):int
		
		/**
		 * Returns the element at the specified position as a short integer (16 bit).
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 * 
		 * @see		SFSDataType#SHORT
		 */
		function getShort(index:int):int
		
		/**
		 * Returns the element at the specified position as an integer (32 bit).
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 */
		function getInt(index:int):int
		
		/**
		 * Returns the element at the specified position as a long integer (64 bit).
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 * 
		 * @see		SFSDataType#LONG
		 */
		function getLong(index:int):Number
		
		/**
		 * Returns the element at the specified position as a floating point number.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 * 
		 * @see		SFSDataType#FLOAT
		 */
		function getFloat(index:int):Number
		
		/**
		 * Returns the element at the specified position as a double precision number.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 * 
		 * @see		SFSDataType#DOUBLE
		 */
		function getDouble(index:int):Number
		
		/**
		 * Returns the element at the specified position as a UTF-8 string.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array at the specified index.
		 */
		function getUtfString(index:int):String
		
		/**
		 * Returns the element at the specified position as an array of booleans.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>Boolean</em> values.
		 */
		function getBoolArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of bytes.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as a <em>ByteArray</em>.
		 */
		function getByteArray(index:int):ByteArray
		
		/**
		 * Returns the element at the specified position as an array of unsigned bytes.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>int</em> values.
		 * 
		 * @see		SFSDataType#BYTE
		 */
		function getUnsignedByteArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of short integers.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>int</em> values.
		 * 
		 * @see		SFSDataType#SHORT
		 */
		function getShortArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of integers.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>int</em> values.
		 */
		function getIntArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of long integers.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>Number</em> values.
		 * 
		 * @see		SFSDataType#LONG
		 */
		function getLongArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of floating point numbers.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>Number</em> values.
		 * 
		 * @see		SFSDataType#FLOAT
		 */
		function getFloatArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of double precision numbers.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>Number</em> values.
		 * 
		 * @see		SFSDataType#DOUBLE
		 */
		function getDoubleArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an array of UTF-8 strings.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an array of <em>String</em> values.
		 */
		function getUtfStringArray(index:int):Array
		
		/**
		 * Returns the element at the specified position as an <em>ISFSArray</em> object.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an object implementing the <em>ISFSArray</em> interface.
		 */
		function getSFSArray(index:int):ISFSArray
		
		/**
		 * Returns the element at the specified position as an <em>ISFSObject</em> object.
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return	The element of this array as an object implementing the <em>ISFSObject</em> interface.
		 */
		function getSFSObject(index:int):ISFSObject
		
		/**
		 * Returns the element at the specified position as an instance of a custom class.
		 * 
		 * <p>This advanced feature allows the transmission of specific object instances between client-side ActionScript and
		 * server-side Java provided that the respective class definition on both sides have the same package name.</p>
		 * 
		 * @param	index	The position of the element to return.
		 * 
		 * @return  The element of this array as a generic <em>Object</em> type to be casted to the target class definition.
		 * 
		 * @example	The following example shows the same class on the client and server sides,
		 * which can be transferred back and forth with the <em>getClass()</em> and <em>addClass()</em> methods.
		 * The server-side Java definition of a SpaceShip class is:
		 * <listing>
		 * 
		 * package my.game.spacecombat
		 * 
		 * public class SpaceShip
		 * {
		 * 	private String type;
		 * 	private String name;
		 * 	private int firePower;
		 * 	private int maxSpeed;
		 * 	private List&lt;String&gt; weapons;
		 * 	
		 * 	public SpaceShip(String name, String type)
		 * 	{
		 * 		this.name = name;
		 * 		this.type = type;
		 * 	}
		 * 	
		 * 	// Getters/Setters
		 * 	
		 * 	...
		 * }
		 * </listing>
		 * 
		 * The client-side ActionScript 3 definition of the SpaceShip class is:
		 * <listing version="3.0">
		 * 
		 * package my.game.spacecombat
		 * 
		 * public class SpaceShip
		 * {
		 * 	private var _type:String;
		 * 	private var _name:String;
		 * 	private var _firePower:int;
		 * 	private var _maxSpeed:int;
		 * 	private var _weapons:Array;
		 * 	
		 * 	public function SpaceShip(name:String, type:String)
		 * 	{
		 * 		_name = name;
		 * 		_type = type;
		 * 	}
		 * 	
		 * 	// Getters/Setters
		 * 	
		 * 	...
		 * }
		 * </listing>
		 * 
		 * A SpaceShip instance is sent by the server to the client in the first position of an array. This is how to retrieve it:
		 * <listing version="3.0">
		 * 
		 * var myShipData:SpaceShip = sfsArray.getClass(0) as SpaceShip;
		 * </listing> 
		 */
		function getClass(index:int):*
	}
}