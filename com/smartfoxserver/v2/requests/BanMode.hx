package com.smartfoxserver.v2.requests;

/**
 * The<em>BanMode</em>class contains the costants describing the possible banning modalities for a<em>BanUserRequest</em>.
 * 
 * @see		BanUserRequest
 */
class BanMode
{
	/**
	 * User is banned by IP address.
	 */
	public static inline var BY_ADDRESS:Int = 0;
	
	/**
	 * User is banned by name.
	 */
	public static inline var BY_NAME:Int = 1;
}