package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.entities.data.ISFSObject;

/**
 * Sends a private chat message.
 * 
 *<p>The private message is dispatched to a specific user, who can be in any server Room, or even in no Room at all. The message is delivered by means of the<em>privateMessage</em>event.
 * It is also returned to the sender:this allows showing the messages in the correct order in the application Interface.
 * It is also possible to send an optional object together with the message:it can contain custom parameters useful to transmit, for example, additional
 * informations related to the message, like the text font or color, or other formatting details.</p>
 * 
 * @example	The following example sends a private message and handles the respective event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE, onPrivateMessage);
 * 	
 * 	// Send a private message to Jack
 * 	var user:User=sfs.usermanager.getUserByName("Jack");
 * 	sfs.send(new PrivateMessageRequest("Hello Jack!", user.id));
 * }
 * 
 * private function onPrivateMessage(evt:SFSEvent):Void
 * {
 * 	// As messages are forwarded to the sender too,
 * 	// I have to check if I am the sender
 * 	
 * 	var sender:User=evt.params.sender;
 * 	
 * 	if(sender !=sfs.mySelf)
 * 		trace("User " + sender.name + " sent me this PM:", evt.params.message);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:privateMessage privateMessage event
 */
class PrivateMessageRequest extends GenericMessageRequest
{
	/**
	 * Creates a new<em>PrivateMessageRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	message		The message to be sent to to the recipient user.
	 * @param	recipientId	The id of the user to which the message is to be sent.
	 * @param	params		An instance of<em>SFSObject</em>containing additional custom parameters to be sent to the message recipient(for example the color of the text, etc).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(message:String, recipientId:Int, params:ISFSObject=null)
	{
		super();
		
		_type = GenericMessageType.PRIVATE_MSG;
		_message = message;
		_recipient = recipientId;
		_params = params;
	}
}