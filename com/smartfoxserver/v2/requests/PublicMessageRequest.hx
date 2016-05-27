package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;

/**
 * Sends a public chat message.
 * 
 *<p>A public message is dispatched to all the users in the specified Room, including the message sender(this allows showing
 * messages in the correct order in the application Interface);the corresponding event is the<em>publicMessage</em>event.
 * It is also possible to send an optional object together with the message:it can contain custom parameters useful to transmit, for example, additional
 * informations related to the message, like the text font or color, or other formatting details.</p>
 * 
 *<p>In case the target Room is not specified, the message is sent in the last Room joined by the sender.</p>
 * 
 *<p><b>NOTE</b>:the<em>publicMessage</em>event is dispatched if the Room is configured to allow public messaging only(see the<em>RoomSettings.permissions</em>parameter).</p>
 * 
 * @example	The following example sends a public message and handles the respective event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessage);
 * 	
 * 	// Send a public message
 * 	sfs.send(new PublicMessageRequest("Hello everyone!"));
 * }
 * 
 * private function onPublicMessage(evt:SFSEvent):Void
 * {
 * 	// As messages are forwarded to the sender too,
 * 	// I have to check if I am the sender
 * 	
 * 	var sender:User=evt.params.sender;
 * 	
 * 	if(sender==sfs.mySelf)
 * 		trace("I said:", evt.params.message);
 * 	else
 * 		trace("User " + sender.name + " said:", evt.params.message);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:publicMessage publicMessage event
 * @see		RoomSettings#permissions RoomSettings.permissions
 */
class PublicMessageRequest extends GenericMessageRequest
{
	/**
	 * Creates a new<em>PublicMessageRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	message		The message to be sent to all the users in the target Room.
	 * @param	params		An instance of<em>SFSObject</em>containing additional custom parameters to be sent to the message recipients(for example the color of the text, etc).
	 * @param	targetRoom	The<em>Room</em>object corresponding to the Room where the message should be dispatched;if<code>null</code>, the last Room joined by the user is used.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(message:String, params:ISFSObject=null, targetRoom:Room=null)
	{
		super();
		
		_type = GenericMessageType.PUBLIC_MSG;
		_message = message;
		_room = targetRoom;
		_params = params;
	}		
}