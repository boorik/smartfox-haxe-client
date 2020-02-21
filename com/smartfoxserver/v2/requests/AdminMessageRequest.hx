package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.requests.GenericMessageRequest;
import com.smartfoxserver.v2.requests.MessageRecipientMode;
import com.smartfoxserver.v2.errors.ArgumentError;
/**
 * Sends an administrator message to a specific user or a group of users.
 * 
 *<p>The current user must have administration privileges to be able to send the message(see the<em>User.privilegeId</em>property).</p>
 * 
 *<p>The<em>recipientMode</em>parameter in the class constructor is used to determine the message recipients:a single user or all the
 * users in a Room, a Group or the entire Zone. Upon message delivery, the clients of the recipient users dispatch the<em>adminMessage</em>event.</p>
 * 
 * @example	The following example sends an administration message to all the users in the Zone;it also shows how to handle the related event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ADMIN_MESSAGE, onAdminMessage);
 * 	
 * 	// Set the message recipients:all users in the Zone
 * 	var recipMode:MessageRecipientMode=new MessageRecipientMode(MessageRecipientMode.TO_ZONE, null);
 * 	
 * 	// Send the administrator message
 * 	sfs.send(new AdminMessageRequest("Hello to everybody from the Administrator!", recipMode));
 * }
 * 
 * private function onAdminMessage(evt:SFSEvent):Void
 * {
 * 	trace("The administrator sent the following message:" + evt.params.message);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:adminMessage adminMessage event
 * @see		com.smartfoxserver.v2.entities.User#privilegeId User.privilegeId
 * @see		ModeratorMessageRequest
 */
class AdminMessageRequest extends GenericMessageRequest
{
	/**
	 * Creates a new<em>AdminMessageRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	message			The message of the administrator to be sent to the target user/s defined by the<em>recipientMode</em>parameter.
	 * @param	recipientMode	An instance of<em>MessageRecipientMode</em>containing the target to which the message should be delivered.
	 * @param	params			An instance of<em>SFSObject</em>containing custom parameters to be sent to the recipient user/s.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(message:String, recipientMode:MessageRecipientMode, params:ISFSObject=null)
	{
		if(recipientMode==null)
			throw new ArgumentError("RecipientMode cannot be null!");
		
		_type=GenericMessageType.ADMING_MSG;
		_message=message;
		_params=params;
		_recipient=recipientMode.target;
		_sendMode=recipientMode.mode;
	}
}