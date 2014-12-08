package com.smartfoxserver.v2.util
{
	/**
	 * @private
	 * 
	 * Provide information on the Online Status of the Buddy.
	 */
	public class BuddyOnlineState
	{
		/** The Buddy is online. */
		public static const ONLINE:int = 0
		
		/** The Buddy is offline in the Buddy List system. */
		public static const OFFLINE:int = 1
		
		/** The Buddy left the server. */
		public static const LEFT_THE_SERVER:int = 2
		
		public function BuddyOnlineState()
		{
			throw new Error("This class should not be instantiated")
		}
	}
}