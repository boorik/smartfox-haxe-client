package com.smartfoxserver.v2.requests
{
	/**
	 * The <em>BanMode</em> class contains the costants describing the possible banning modalities for a <em>BanUserRequest</em>.
	 * 
	 * @see		BanUserRequest
	 */
	public class BanMode
	{
		/**
		 * User is banned by IP address.
		 */
		public static const BY_ADDRESS:int = 0
		
		/**
		 * User is banned by name.
		 */
		public static const BY_NAME:int = 1
	}
}