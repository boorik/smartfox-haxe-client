package com.smartfoxserver.v2.entities.variables;
/**
 * The<em>RoomVariable</em>interface defines all the public methods and properties that an object representing a SmartFoxServer Room Variable exposes.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSRoomVariable</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSRoomVariable
 */
interface RoomVariable extends UserVariable
{
	/**
	 * Indicates whether this Room Variable is private or not.
	 * A private Room Variable can be modified by its owner only(the user that created it).
	 * 
	 *<p><b>NOTE</b>:setting the<em>isPrivate</em>property manually on an existing Room Variable returned by the API has no effect on the server and can disrupt the API functioning.
	 * This flag can be set when the Room Variable object is created by the developer only(using the<em>new</em>keyword).</p>
	 */
		 var isPrivate(get,set):Bool;
	
	/**
	 * Indicates whether this Room Variable is persistent or not.
	 * A persistent Room Variable continues to exist in the Room after the user who created it has left it and until he disconnects.
	 * 
	 *<p><b>NOTE</b>:setting the<em>isPersistent</em>property manually on an existing Room Variable returned by the API has no effect on the server and can disrupt the API functioning.
	 * This flag can be set when the Room Variable object is created by the developer only(using the<em>new</em>keyword).</p>
	 */
		 var isPersistent(get,set):Bool;
}