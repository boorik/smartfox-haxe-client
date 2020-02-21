package com.smartfoxserver.v2.util;
import com.smartfoxserver.v2.errors.ArgumentError;

/**
 * The<em>ConnectionMode</em>class contains the costants defining the possible connection modes of the client with the server.
 * 
 * @see		com.smartfoxserver.v2.SmartFox#connectionMode SmartFox.connectionMode
 */
class ConnectionMode
{
	/**
	 * A socket connection is established between the client and the server.
	 */
	public static inline var SOCKET:String="socket";
	
	/**
	 * A tunnelled http connection(through the BlueBox)is established between the client and the server.
	 */
	public static inline var HTTP:String="http";

	/**
	 * WebSocket support
	 */
	public static inline var WEBSOCKET:String="WS";
	
	// Avoid construction
	public function new()
	{
		throw new ArgumentError("The ConnectionMode class has no constructor!");
	}
}