package com.smartfoxserver.v2.entities.variables;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;

/**
 * The<em>UserVariable</em>interface defines all the public methods and properties that an object representing a SmartFoxServer User Variable exposes.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSUserVariable</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSUserVariable
 */
interface UserVariable
{
	/**
	 * Indicates the name of this variable.
	 */
	var name(get, null):String;
	//function get_name():String;
	
	/**
	 * Indicates the type of this variable.
	 * Possible types are:<code>Null</code>,<code>Bool</code>,<code>Int</code>,<code>Double</code>,<code>String</code>,<code>Object</code>,<code>Array</code>.
	 */
	var type(get, null):String;
	//function get_type():String;
	
	/**
	 * Retrieves the untyped value of this variable.
	 * 
	 * @return  The variable untyped value.
	 */
	function getValue():Dynamic;
	
	/**
	 * Retrieves the value of a boolean variable.
	 * 
	 * @return  The variable value as a<em>Boolean</em>.
	 */
	function getBoolValue():Bool;
	
	/**
	 * Retrieves the value of an Integer variable.
	 * 
	 * @return  The variable value as an<em>int</em>.
	 */
	function getIntValue():Int;
	
	/**
	 * Retrieves the value of a numeric variable.
	 * 
	 * @return  The variable value as a<em>Number</em>.
	 */
	function getDoubleValue():Float;
	
	/**
	 * Retrieves the value of a string variable.
	 * 
	 * @return  The variable value as a<em>String</em>.
	 */
	function getStringValue():String;
	
	/**
	 * Retrieves the value of a<em>SFSObject</em>variable.
	 * 
	 * @return  The variable value as an<em>ISFSObject</em>.
	 */
	function getSFSObjectValue():ISFSObject;
	
	/**
	 * Retrieves the value of a<em>SFSArray</em>variable.
	 * 
	 * @return  The variable value as an<em>ISFSArray</em>.
	 */
	function getSFSArrayValue():ISFSArray;
	
	/**
	 * Indicates if the variable is<code>null</code>.
	 * 
	 * @return<code>true</code>if the variable has a<code>null</code>value.
	 */
	function isNull():Bool;
	
	/** @private */
	function toSFSArray():ISFSArray;
}