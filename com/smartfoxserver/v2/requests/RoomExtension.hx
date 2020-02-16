package com.smartfoxserver.v2.requests;
/**
 * The<em>RoomExtension</em>class contains a specific subset of the<em>RoomSettings</em>required to create a Room.
 * It defines which server-side Extension should be attached to the Room upon creation.
 * 
 *<p>The client can communicate with the Room Extension by means of the<em>ExtensionRequest</em>request.</p>
 * 
 * @see RoomSettings#extension
 * @see CreateRoomRequest
 * @see	ExtensionRequest
 */
class RoomExtension
{
	private var _id:String;					//<-- mandatory
	private var _className:String;			//<-- mandatory
	private var _propertiesFile:String;		//<-- optional
	
	/**
	 * Creates a new<em>RoomExtension</em>instance.
	 * The<em>RoomSettings.extension</em>property must be set to this instance during Room creation.
	 * 
	 * @param	id			The name of the Extension as deployed on the server;it's the name of the folder containing the Extension classes inside the main<em>[sfs2x-install-folder]/SFS2X/extensions</em>folder.
	 * @param	className	The fully qualified name of the main class of the Extension.
	 * 
	 * @see		RoomSettings#extension
	 */
	public function new(id:String, className:String)
	{
		_id = id;
		_className = className;
		_propertiesFile = "";
	}
	
	/**
	 * Returns the name of the Extension to be attached to the Room.
	 * It's the name of the server-side folder containing the Extension classes inside the main<em>[sfs2x-install-folder]/SFS2X/extensions</em>folder.
	 */
	public var id(get, set):String;
 	private function get_id():String
	{
		return _id;
	}
	
	private function set_id(value:String):String
	{
		return _id = value;
	}
	
	/**
	 * Returns the fully qualified name of the main class of the Extension.
	 */
	public var className(get, set):String;
 	private function get_className():String
	{
		return _className;
	}
	private function set_className(value:String):String
	{
		return _className = value;
	}
	
	/**
	 * Defines the name of an optional properties file that should be loaded on the server-side during the Extension initialization.
	 * The file must be located in the server-side folder containing the Extension classes(see the<em>id</em>property).
	 * 
	 * @see		#id
	 */
	public var propertiesFile(get, set):String;
 	private function get_propertiesFile():String
	{
		return _propertiesFile;
	}
	
	/** @private */
	private function set_propertiesFile(fileName:String):String
	{
		return _propertiesFile = fileName;
	}
}