package com.smartfoxserver.v2.entities.match;
import openfl.errors.ArgumentError;

/**
 * The<em>UserProperties</em>class contains the names of predefined properties that can be used in matching expressions to search/filter users.
 * 
 * @see		MatchExpression
 * @see		com.smartfoxserver.v2.entities.User User
 */
class UserProperties
{
	/**
	 * The user name.
	 * Requires a<em>StringMatcher</em>to be used for values comparison.
	 */
	public static inline var NAME:String = "${N}";
	
	/**
	 * The user is a player in a Game Room.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_PLAYER:String = "${ISP}";
	
	/**
	 * The user is a spectator in a Game Room.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_SPECTATOR:String = "${ISS}";
	
	/**
	 * The user is a Non-Player Character(NPC).
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_NPC:String = "${ISN}";
	
	/**
	 * The user privilege id.
	 * Requires a<em>NumberMatcher</em>to be used for values comparison.
	 */
	public static inline var PRIVILEGE_ID:String = "${PRID}";
	
	/**
	 * The user joined at least one Room.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_IN_ANY_ROOM:String = "${IAR}";
	
	/** @private */
	public function new()
	{
		throw new ArgumentError("This class cannot be instantiated");
	}
}