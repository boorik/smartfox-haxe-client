package com.smartfoxserver.v2.entities.variables;
import com.smartfoxserver.v2.entities.data.ISFSArray;

/**
 * The<em>MMOItemVariable</em>object represents a SmartFoxServer MMOItem Variable entity on the client.
 * It is a custom value attached to an<em>MMOItem</em>object that gets automatically synchronized between client and server on every change, provided that the MMOItem
 * is inside the Area of Interest of the current user in a MMORoom.
 * 
 *<p><b>NOTE:</b>MMOItem Variables behave exactly like User Variables and support the same data types, but they can be created, updated and deleted on the server side only.</p>
 * 
 * @see		com.smartfoxserver.v2.entities.MMOItem MMOItem
 * @see		com.smartfoxserver.v2.entities.MMORoom MMORoom
 */
class MMOItemVariable extends SFSUserVariable implements IMMOItemVariable
{
	
	/** @private */
	public static function fromSFSArray(sfsa:ISFSArray):IMMOItemVariable
	{
		var variable:IMMOItemVariable=new MMOItemVariable(
			sfsa.getUtfString(0), 	// name
			sfsa.getElementAt(2),	// typed value
			sfsa.getByte(1)			// type id
		);
			
		return variable;
	}
	
	/** @private */
	private function new(name:String, value:Dynamic, type:Int=-1)
	{
		super(name, value, type);
	}
	
	/**
	 * Returns a string that contains the MMOItem Variable name, type and value.
	 * 
	 * @return	The string representation of the<em>MMOItemVariable</em>object.
	 */
	override public function toString():String
	{
		return "[ItemVar:" + _name + ", type:" + _type + ", value:" + _value + "]";
	}
}