package com.smartfoxserver.v2.util;

/**
 * @private
 * 
 * Provide information on the Online Status of the Buddy.
 */
class BuddyOnlineState
{
	/** The Buddy is online. */
	public static inline var ONLINE:Int = 0;
	
	/** The Buddy is offline in the Buddy List system. */
	public static inline var OFFLINE:Int = 1;
	
	/** The Buddy left the server. */
	public static inline var LEFT_THE_SERVER:Int = 2;
	
	public function new()
	{
		throw "This class should not be instantiated";
	}
}