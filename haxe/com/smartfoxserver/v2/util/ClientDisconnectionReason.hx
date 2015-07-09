package com.smartfoxserver.v2.util;

/**
 * The<em>ClientDisconnectionReason</em>class contains the costants describing the possible reasons why a disconnection from the server occurred.
 */
class ClientDisconnectionReason
{
	/**
	 * Client was disconnected because it was idle for too long.
	 * The connection timeout depends on the server settings.
	 */
	public static inline var IDLE:String = "idle";
	
	/**
	 * Client was kicked out of the server.
	 * Kicking can occur automatically(i.e. for swearing, if the words filter is active)
	 * or due to the Intervention of a user with enough privileges(i.e. an administrator or a moderator).
	 */
	public static inline var KICK:String = "kick"; 
	
	/**
	 * Client was banned from the server.
	 * Banning can occur automatically(i.e. for flooding, if the flood filter is active)
	 * or due to the Intervention of a user with enough privileges(i.e. an administrator or a moderator).
	 */
	public static inline var BAN:String = "ban" ;
	
	/**
	 * The client manually disconnected from the server.
	 * The<em>disconnect</em>method on the<b>SmartFox</b>class was called.
	 */
	public static inline var MANUAL:String = "manual" ;
	
	/**
	 * A generic network error occurred, and the client is unable to determine the cause of the disconnection.
	 * The server-side log should be checked for possible error messages or warnings.
	 */
	public static inline var UNKNOWN:String = "unknown";
	
	// Only the idle, kick and ban reasons are required, because they are the only ones sent by the server
	private static var reasons:Array<Dynamic>=
	[
		"idle",
		"kick",
		"ban"
	] ;
	
	/** @private */
	public static function getReason(reasonId:Int):String
	{
		return reasons[reasonId];
	}
}