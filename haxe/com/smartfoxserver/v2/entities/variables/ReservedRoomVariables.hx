package com.smartfoxserver.v2.entities.variables;

/**
 * The<em>ReservedRoomVariables</em>class contains the constants describing the SmartFoxServer API reserved Room Variable names.
 */
class ReservedRoomVariables
{
	/**
	 * The Room Variable with this name keeps track of the state(started or stopped)of a game created with the<em>CreateSFSGameRequest</em>request.
	 * 
	 * @see		com.smartfoxserver.v2.requests.game.CreateSFSGameRequest CreateSFSGameRequest
	 * @see		com.smartfoxserver.v2.requests.game.SFSGameSettings#notifyGameStarted
	 */
	public static inline var RV_GAME_STARTED:String="$GS";
}