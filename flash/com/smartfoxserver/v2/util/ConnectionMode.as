package com.smartfoxserver.v2.util
{
	/**
	 * The <em>ConnectionMode</em> class contains the costants defining the possible connection modes of the client with the server.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#connectionMode SmartFox.connectionMode
	 */
	public class ConnectionMode
	{
		/**
		 * A socket connection is established between the client and the server.
		 */
		public static const SOCKET:String = "socket";
		
		/**
		 * A tunnelled http connection (through the BlueBox) is established between the client and the server.
		 */
		public static const HTTP:String = "http";
		
		// Avoid construction
		public function ConnectionMode()
		{
			throw new ArgumentError("The ConnectionMode class has no constructor!");
		}
	}
}