package com.smartfoxserver.v2.util;
 
/**
 * The<em>SFSErrorCodes</em>class provides a mean of translation between server error codes and their relative error messages.
 *<p>Error messages are provided by default in the English language but they can be localized and substituted in any other language.
 * The error messages contain special placeholders that are processed at runtime and substituted with runtime data.
 * They are in the form of a number enclosed in curly brackets such as:{0}, {1}, etc.
 * Please make sure you maintain these placeholders while translating the messages.</p>
 *<p>For more informations please check this link:<a href="http://docs2x.smartfoxserver.com/AdvancedTopics/client-error-messages" target="_blank">http://docs2x.smartfoxserver.com/AdvancedTopics/client-error-messages</a></p>
 */
class SFSErrorCodes
{
	private static var errorsByCode:Array<String>=	
	[
		"Client API version is obsolete:{0};required version:{1}", 												// 0
		"Requested Zone {0} does not exist",							
		"User name {0} is not recognized",
		"Wrong password for user {0}",
		"User {0} is banned",
		"Zone {0} is full",																							// 5
		"User {0} is already logged in Zone {1}",
		"The server is full",
		"Zone {0} is currently inactive",
		"User name {0} contains bad words;filtered:{1}",
		"Guest users not allowed in Zone {0}",																		// 10
		"IP address {0} is banned",
		"A Room with the same name already exists:{0}",
		"Requested Group is not available - Room:{0};Group:{1}",
		"Bad Room name length -  Min:{0};max:{1};passed name length:{2}",
		"Room name contains bad words:{0}",																		// 15
		"Zone is full;can't add Rooms anymore",
		"You have exceeded the number of Rooms that you can create per session:{0}",
		"Room creation failed, wrong parameter:{0}",
		"User {0} already joined in Room",
		"Room {0} is full",																							// 20
		"Wrong password for Room {0}",
		"Requested Room does not exist",
		"Room {0} is locked",
		"Group {0} is already subscribed",
		"Group {0} does not exist",																					// 25
		"Group {0} is not subscribed", 
		"Group {0} does not exist",
		"{0}",
		"Room permission error;Room {0} cannot be renamed",
		"Room permission error;Room {0} cannot change password state",												// 30 
		"Room permission error;Room {0} cannot change capacity",
		"Switch user error;no player slots available in Room {0}",
		"Switch user error;no spectator slots available in Room {0}",
		"Switch user error;Room {0} is not a Game Room",
		"Switch user error;you are not joined in Room {0}",														// 35
		"Buddy Manager initialization error, could not load buddy list:{0}",
		"Buddy Manager error, your buddy list is full;size is {0}",
		"Buddy Manager error, was not able to block buddy {0} because offline",
		"Buddy Manager error, you are attempting to set too many Buddy Variables;limit is {0}",
		"Game {0} access denied, user does not match access criteria",												// 40
		"QuickJoinGame action failed:no matching Rooms were found",
		"Your previous invitation reply was invalid or arrived too late"
	];
	
	/** @private */
	public function new()
	{
		throw "This class cannot be instantiated. Please check the documentation for more details on its usage";
	}
	
	/**
	 * Sets the text of the error message corresponding to the passed error code.
	 * 
	 *<p><b>NOTE</b>:you have to make sure you maintain all the placeholders while modifying the messages.</p>
	 * 
	 * @param	code		The code of the error message to be modified.
	 * @param	message 	The new error message, including the placeholders for runtime informations.
	 * 
	 * @example	The following example shows how to translate error 13 to French language retaining the required placeholders:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	SFSErrorCodes.setErrorMessage(13, "Le Groupe demandé n'est pas disponible - Salle:{0};Groupe:{1}");
	 * }
	 *</listing>
	 */
	public static function setErrorMessage(code:Int, message:String):Void
	{
		errorsByCode[code] = message;
	}
	
	/** @private */
	public static function getErrorMessage(code:Int, params:Array<Dynamic>=null):String
	{
		return stringFormat(errorsByCode[code], params);
	}
	
	private static function stringFormat(ss:String, params:Array<Dynamic>):String
	{
		if(ss==null)
			return "";
			
		if(params !=null)
		{
			for(j in 0...params.length)
			{
				var src:String = "{" + j + "}";
				ss = StringTools.replace(ss,src, params[j]);
			}
		}
		
		return ss;
	}
}