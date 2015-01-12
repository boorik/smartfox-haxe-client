package com.smartfoxserver.v2.util
{
	/**
	 * The <em>ClientDisconnectionReason</em> class contains the costants describing the possible reasons why a disconnection from the server occurred.
	 */
	public class ClientDisconnectionReason
	{
		/**
		 * Client was disconnected because it was idle for too long.
		 * The connection timeout depends on the server settings.
		 */
		public static const IDLE:String = "idle" 
		
		/**
		 * Client was kicked out of the server.
		 * Kicking can occur automatically (i.e. for swearing, if the words filter is active)
		 * or due to the intervention of a user with enough privileges (i.e. an administrator or a moderator).
		 */
		public static const KICK:String = "kick" 
		
		/**
		 * Client was banned from the server.
		 * Banning can occur automatically (i.e. for flooding, if the flood filter is active)
		 * or due to the intervention of a user with enough privileges (i.e. an administrator or a moderator).
		 */
		public static const BAN:String = "ban" 
		
		/**
		 * The client manually disconnected from the server.
		 * The <em>disconnect</em> method on the <b>SmartFox</b> class was called.
		 */
		public static const MANUAL:String = "manual" 
		
		/**
		 * A generic network error occurred, and the client is unable to determine the cause of the disconnection.
		 * The server-side log should be checked for possible error messages or warnings.
		 */
		public static const UNKNOWN:String = "unknown"
		
		// Only the idle, kick and ban reasons are required, because they are the only ones sent by the server
		private static var reasons:Array = 
		[
			"idle",
			"kick",
			"ban"
		] 
		
		/** @private */
		public static function getReason(reasonId:int):String
		{
			return reasons[reasonId]
		}
	}
}