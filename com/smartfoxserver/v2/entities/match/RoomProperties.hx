package com.smartfoxserver.v2.entities.match;
import openfl.errors.ArgumentError;

/**
 * The<em>RoomProperties</em>class contains the names of predefined properties that can be used in matching expressions to search/filter Rooms.
 * 
 * @see		MatchExpression
 * @see		com.smartfoxserver.v2.entities.Room Room
 */
class RoomProperties
{
	/**
	 * The Room name.
	 * Requires a<em>StringMatcher</em>to be used for values comparison.
	 */
	public static inline var NAME:String = "${N}";
	
	/**
	 * The name of the Group to which the Room belongs.
	 * Requires a<em>StringMatcher</em>to be used for values comparison.
	 */
	public static inline var GROUP_ID:String = "${G}";
	
	/**
	 * The maximum number of users allowed in the Room(players in Game Rooms).
	 * Requires a<em>NumberMatcher</em>to be used for values comparison.
	 */
	public static inline var MAX_USERS:String = "${MXU}";
	
	/**
	 * The maximum number of spectators allowed in the Room(Game Rooms only).
	 * Requires a<em>NumberMatcher</em>to be used for values comparison.
	 */
	public static inline var MAX_SPECTATORS:String = "${MXS}";
	
	/**
	 * The Room users count(players in Game Rooms).
	 * Requires a<em>NumberMatcher</em>to be used for values comparison.
	 */
	public static inline var USER_COUNT:String = "${UC}";
	
	/**
	 * The Room spectators count(Game Rooms only).
	 * Requires a<em>NumberMatcher</em>to be used for values comparison.
	 */
	public static inline var SPECTATOR_COUNT:String = "${SC}";
	
	/**
	 * The Room is a Game Room.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_GAME:String = "${ISG}";
	
	/**
	 * The Room is private.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_PRIVATE:String = "${ISP}";
	
	/**
	 * The Room has at least one free player slot.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var HAS_FREE_PLAYER_SLOTS:String = "${HFP}";
	
	/**
	 * The Room is an<em>SFSGame</em>on the server-side.
	 * Requires a<em>BoolMatcher</em>to be used for values comparison.
	 */
	public static inline var IS_TYPE_SFSGAME:String = "${IST}";
	
	/** @private */
	public function new()
	{
		throw new ArgumentError("This class cannot be instantiated");
	}
}