package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;

/**
 * Sends an object containing custom data to all users in a Room, or a subset of them.
 * 
 *<p>The data object is delivered to the selected users(or all users excluding the sender)inside the target Room by means of the<em>objectMessage</em>event.
 * It can be useful to send game data, like for example the target coordinates of the user's avatar in a virtual world.</p>
 * 
 * @example	The following example sends the player's character movement coordinates and handles the respective event
 *(note:the<em>myCharacter</em>instance is supposed to be the user sprite on the stage, while the<em>getUserCharacter</em>method retrieves the sprite of other users' characters):
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.OBJECT_MESSAGE, onObjectMessage);
 * 	
 * 	// Send my movement to all players
 * 	var dataObj:ISFSObject=new SFSObject();
 * 	dataObj.putInt("x", myCharacter.x);
 * 	dataObj.putInt("y", myCharacter.y);
 * 	
 * 	sfs.send(new ObjectMessageRequest(dataObj));
 * }
 * 
 * private function onObjectMessage(evt:SFSEvent):Void
 * {
 * 	var dataObj:ISFSObject=evt.params.message as SFSObject;
 * 	
 * 	var sender:User=evt.params.sender;
 * 	var character:Sprite=getUserCharacter(sender.id);
 * 	
 * 	character.x=dataObj.getInt("x");
 * 	character.y=dataObj.getInt("y");
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:objectMessage objectMessage event
 */
class ObjectMessageRequest extends GenericMessageRequest
{
	/**
	 * Creates a new<em>ObjectMessageRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	obj			An instance of<em>SFSObject</em>containing custom parameters to be sent to the message recipients.
	 * @param	targetRoom	The<em>Room</em>object corresponding to the Room where the message should be dispatched;if<code>null</code>, the last Room joined by the user is used.
	 * @param	recipients	A list of<em>User</em>objects corresponding to the message recipients;if<code>null</code>, the message is sent to all users in the target Room(except the sender himself).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 * @see		com.smartfoxserver.v2.entities.User User
	 */
	public function new(obj:ISFSObject, targetRoom:Room=null, recipients:Array<Dynamic>=null)
	{
		super();
		_type=GenericMessageType.OBJECT_MSG;
		_params=obj;
		_room=targetRoom;
		_recipient=recipients;
	}
}