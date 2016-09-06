package com.smartfoxserver.v2.util;

/**
 * The<em>ConfigData</em>class stores the client configuration data loaded from an external XML file or passed directly to the deputy connect method.
 * The external configuration file is loaded by the<em>SmartFox</em>class when its<em>loadConfig()</em>method is called.
 * Otherwise it can be passed directly to the<em>connectWithConfig()</em>method of the<em>SmartFox</em>class.
 * 
 * @see		com.smartfoxserver.v2.SmartFox#loadConfig()SmartFox.loadConfig()
 * @see		com.smartfoxserver.v2.SmartFox#connectWithConfig()SmartFox.connectWithConfig()
 */
class ConfigData
{
	/**
	 * Creates a new<em>ConfigData</em>instance.
	 */
	public function new()
	{
	}
	
	/**
	 * Specifies the IP address or host name of the SmartFoxServer 2X instance to connect to(TCP connection).
	 * 
	 * @default 127.0.0.1
	 */
	public var host:String = "127.0.0.1";
	
	/**
	 * Specifies the TCP port of the SmartFoxServer 2X instance to connect to(TCP connection).
	 * 
	 * @default 9933
	 */
	public var port:Int = 9933;
	
	/**
	 * Specifies the IP address of the SmartFoxServer 2X instance to connect to(UDP connection).
	 * 
	 * @default 127.0.0.1
	 */
	public var udpHost:String = "127.0.0.1";
	
	/**
	 * Specifies the UDP port of the SmartFoxServer 2X instance to connect to(UDP connection).
	 * 
	 * @default 9933
	 */
	public var udpPort:Int = 9933;
	
	/**
	 * Specifies the Zone of the SmartFoxServer 2X instance to join.
	 * 
	 * @default null
	 */
	public var zone:String;
	
	/**
	 * Indicates whether the client-server messages debug should be enabled or not.
	 * 
	 * @default false
	 */
	public var debug:Bool = false;
	
	/**
	 * Specifies the port for generic HTTP communication.
	 * 
	 * @default 8080
	 */
	public var httpPort:Int = 8080;
	
				
	/**
	 * Specifies the port for HTTPS communication. 
	 * E.g. the initialization of an encrypted connection.
	 * 
	 * @default 8443
	 */
	public var httpsPort:Int = 8443;
	
	/**
	 * Indicates whether the SmartFoxServer's BlueBox should be enabled or not.
	 * 
	 * @default true
	 */
	public var useBlueBox:Bool = true;

	/**
	 * Specifies the BlueBox polling speed.
	 * 
	 * @default 750
	 */
	public var blueBoxPollingRate:Int = 750;
	
	public function toString():String
	{
		var s = "=== SFS Config ====\n";
		for (f in Reflect.fields(this))
		{
			s += f + " : " + Reflect.field(this, f) + "\n";
		}
		return s;
	}
}