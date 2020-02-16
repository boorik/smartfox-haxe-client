package com.smartfoxserver.v2.entities.variables;
import com.smartfoxserver.v2.entities.data.ISFSArray;

/**
 * The<em>SFSRoomVariable</em>object represents a SmartFoxServer Room Variable entity on the client.
 * It is a custom value attached to a<em>Room</em>object that gets automatically synchronized between client and server on every change.
 * 
 *<p>Room Variables are particularly useful to store custom Room data such as a game status and other Room-level informations.
 * Room Variables can be set by means of the<em>SetRoomVariablesRequest</em>request;they support the following data types(also nested):
 *<em>Boolean</em>,<em>int</em>,<em>Number</em>,<em>String</em>,<em>SFSObject</em>,<em>SFSArray</em>. A Room Variable can also be<code>null</code>.</p>
 * 
 *<p>Room Variables also support a number of specific flags:
 *<ul>
 * 		<li><b>Private</b>:a private Room Variable can only be modified by its creator.</li>
 * 		<li><b>Persistent</b>:a persistent Room Variable will continue to exist even if its creator has left the Room(but will be deleted when the creator will get disconnected).</li>
 * 		<li><b>Global</b>:a global Room Variable will fire update events not only to all users in the Room, but also to all users in the Group to which the Room belongs
 * 		(NOTE:this flag is not available on the client-side because clients are not allowed to create global Room Variables).</li>
 *</ul>
 *</p>
 * 
 * @see		com.smartfoxserver.v2.entities.Room Room
 * @see		com.smartfoxserver.v2.requests.SetRoomVariablesRequest SetRoomVariablesRequest
 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
 * @see		com.smartfoxserver.v2.entities.data.SFSArray SFSArray
 */
class SFSRoomVariable extends SFSUserVariable implements RoomVariable
{
	private var _isPersistent:Bool;
	private var _isPrivate:Bool;
	
	/** @private */
	public static function fromSFSArray(sfsa:ISFSArray):RoomVariable
	{
		var roomVariable:RoomVariable=new SFSRoomVariable
		(
			sfsa.getUtfString(0), 	// name
			sfsa.getElementAt(2),	// typed value
			sfsa.getByte(1)			// type id
		);
		
		roomVariable.isPrivate = sfsa.getBool(3);// Private
		roomVariable.isPersistent = sfsa.getBool(4);// Persistent
							
		return roomVariable;
	}
	
	/**
	 * Creates a new<em>SFSRoomVariable</em>instance.
	 * 
	 * @param 	name	The name of the Room Variable.
	 * @param 	value	The value of the Room Variable;valid data types are:<em>Boolean</em>,<em>int</em>,<em>Number</em>,<em>String</em>,<em>SFSObject</em>,<em>SFSArray</em>. The value can also be<code>null</code>.
	 * @param 	type	The type of the Room Variable among those available in the<em>VariableType</em>class. Usually it is not necessary to pass this parameter, as the type is auto-detected from the value.
	 * 
	 * @see		VariableType
	 */
	public function new(name:String, value:Dynamic, type:Int=-1)
	{
		super(name, value, type);
	}
	
	/** @inheritDoc */
	public var isPrivate(get, set):Bool;
 	private function get_isPrivate():Bool
	{
		return _isPrivate;
	}
	
	/** @inheritDoc */
	public var isPersistent(get, set):Bool;
 	private function get_isPersistent():Bool
	{
		return _isPersistent;
	}
	
	/** @inheritDoc */
	private function set_isPrivate(value:Bool):Bool
	{
		return _isPrivate = value;	
	}
	
	/** @private */
	private function set_isPersistent(value:Bool):Bool
	{
		return _isPersistent = value;	
	}
	
	/**
	 * Returns a string that contains the Room Variable name, type, value and<em>isPrivate</em>flag.
	 * 
	 * @return	The string representation of the<em>SFSRoomVariable</em>object.
	 */
	override public function toString():String
	{
		return "[RVar:" + _name + ", type:" + _type + ", value:" + _value + ", isPriv:" + isPrivate + "]";
	}
	
	/** @private */
	override public function toSFSArray():ISFSArray
	{
		var arr:ISFSArray = super.toSFSArray();
		
		// isPrivate(3)
		arr.addBool(_isPrivate);
		
		// isPersistent(4)
		arr.addBool(_isPersistent);
		
		return arr;
	}
}