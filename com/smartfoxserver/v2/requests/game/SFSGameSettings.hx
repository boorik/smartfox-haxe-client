package com.smartfoxserver.v2.requests.game;

import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.match.MatchExpression;
import com.smartfoxserver.v2.requests.RoomSettings;

/**
 * The<em>SFSGameSettings</em>class is a container for the settings required to create a Game Room using the<em>CreateSFSGameRequest</em>request.
 * 
 *<p>On the server-side, a Game Room is represented by the<em>SFSGame</em>Java class which extends the<em>Room</em>class
 * providing new advanced features such as player matching, game invitations, public and private games, quick game joining, etc.
 * On the client side Game Rooms are regular Rooms with their<em>isGame</em>property set to<code>true</code>.</p>
 * 
 * @see 	CreateSFSGameRequest
 * @see		com.smartfoxserver.v2.entities.Room
 */
class SFSGameSettings extends RoomSettings
{
	private var _isPublic:Bool;
	private var _minPlayersToStartGame:Int;
	private var _invitedPlayers:Array;
	private var _searchableRooms:Array;
	private var _playerMatchExpression:MatchExpression;
	private var _spectatorMatchExpression:MatchExpression;
	private var _invitationExpiryTime:Int;
	private var _leaveLastJoinedRoom:Bool;
	private var _notifyGameStarted:Bool;
	private var _invitationParams:SFSObject;

	/**
	 * Creates a new<em>SFSGameSettings</em>instance.
	 * The instance must be passed to the<em>CreateSFSGameRequest</em>class constructor.
	 * 
	 * @param	name	The name of the Game Room to be created.
	 * 
	 * @see		CreateSFSGameRequest
	 */
	public function new(name:String)
	{
		super(name);
		
		_isPublic=true;
		_minPlayersToStartGame=2;
		_invitationExpiryTime=15;
		_leaveLastJoinedRoom=true;
	}
	
	/**
	 * Indicates whether the game is public or private.
	 *<p>A public game can be joined by any player whose User Variables match the<em>playerMatchExpression</em>assigned to the Game Room.
	 * A private game can be joined by users invited by the game creator by means of<em>invitedPlayers</em>list.</p>
	 * 
	 * @default	true
	 * 
	 * @see		#playerMatchExpression
	 * @see		#invitedPlayers
	 */
	public var isPublic(get_isPublic, set_isPublic):Bool;
 	private function get_isPublic():Bool
	{
		return _isPublic;
	}
	
	/**
	 * Defines the minimum number of players required to start the game.
	 * If the<em>notifyGameStarted</em>property is set to<code>true</code>, when this number is reached, the game start is notified.
	 * 
	 * @default	2
	 * 
	 * @see		#notifyGameStarted
	 */
	public var minPlayersToStartGame(get_minPlayersToStartGame, set_minPlayersToStartGame):Int;
 	private function get_minPlayersToStartGame():Int
	{
		return _minPlayersToStartGame;
	}
	
	/**
	 * In private games, defines a list of<em>User</em>objects representing players to be invited to join the game.
	 * 
	 *<p>If the invitations are less than the minimum number of players required to start the game(see the<em>minPlayersToStartGame</em>property),
	 * the server will send additional invitations automatically, searching users in the Room Groups specified in the<em>searchableRooms</em>list
	 * and filtering them by means of the object passed to the<em>playerMatchExpression</em>property.</p>
	 * 
	 *<p>The game matching criteria contained in the<em>playerMatchExpression</em>property do not apply to the users specified in this list.</p>
	 * 
	 * @default	null
	 * 
	 * @see 	#minPlayersToStartGame
	 * @see 	#searchableRooms
	 * @see 	#playerMatchExpression
	 * @see		com.smartfoxserver.v2.entities.User
	 */
	public var invitedPlayers(get_invitedPlayers, set_invitedPlayers):Array;
 	private function get_invitedPlayers():Array
	{
		return _invitedPlayers;
	}
	
	/**
	 * In private games, defines a list of Groups names where to search players to invite.
	 * 
	 *<p>If the users invited to join the game(specified through the<em>invitedPlayers</em>property)are less than the minimum number of
	 * players required to start the game(see the<em>minPlayersToStartGame</em>property),
	 * the server will invite others automatically, searching them in Rooms belonging to the Groups specified in this list
	 * and filtering them by means of the object passed to the<em>playerMatchExpression</em>property.</p>
	 * 
	 * @default	null
	 * 
	 * @see		#invitedPlayers
	 * @see		#minPlayersToStartGame
	 * @see 	#playerMatchExpression
	 */
	public var searchableRooms(get_searchableRooms, set_searchableRooms):Array;
 	private function get_searchableRooms():Array
	{
		return _searchableRooms;
	}
	
	/**
	 * In private games, defines the number of seconds that the users invited to join the game have to reply to the invitation.
	 * The suggested range is 10 to 40 seconds.
	 * 
	 * @default	15
	 */
	public var invitationExpiryTime(get_invitationExpiryTime, set_invitationExpiryTime):Int;
 	private function get_invitationExpiryTime():Int
	{
		return _invitationExpiryTime; 
	}
	
	/**
	 * In private games, indicates whether the players must leave the previous Room when joining the game or not.
	 * 
	 *<p>This setting applies to private games only because users join the Game Room automatically when they accept the invitation to play,
	 * while public games require a<em>JoinRoomRequest</em>request to be sent, where this behavior can be determined manually.</p>
	 * 
	 * @default	true
	 */
	public var leaveLastJoinedRoom(get_leaveLastJoinedRoom, set_leaveLastJoinedRoom):Bool;
 	private function get_leaveLastJoinedRoom():Bool
	{
		return _leaveLastJoinedRoom;
	}
	
	/**
	 * Indicates if a game state change must be notified when the minimum number of players is reached.
	 * 
	 *<p>If this setting is<code>true</code>, the game state(started or stopped)is handled by means of the reserved Room Variable
	 * represented by the<em>ReservedRoomVariables.RV_GAME_STARTED</em>constant. Listening to the<em>roomVariablesUpdate</em>event for this variable
	 * allows clients to be notified when the game can start due to minimum number of players being reached.</p>
	 * 
	 *<p>As the used Room Variable is created as<em>global</em>(see the<em>SFSRoomVariable</em>class description), its update is broadcast outside the Room too:
	 * this can be used on the client-side, for example, to show the game state in a list of available games.</p>
	 * 
	 * @default	false
	 * 
	 * @see 	com.smartfoxserver.v2.entities.variables.ReservedRoomVariables#RV_GAME_STARTED ReservedRoomVariables.RV_GAME_STARTED
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomVariablesUpdate roomVariablesUpdate event
	 * @see		com.smartfoxserver.v2.entities.variables.SFSRoomVariable
	 */
	public var notifyGameStarted(get_notifyGameStarted, set_notifyGameStarted):Bool;
 	private function get_notifyGameStarted():Bool
	{
		return _notifyGameStarted;
	}
	
	/**
	 * Defines the game matching expression to be used to filters players.
	 * 
	 *<p>Filtering is applied when:
	 *<ol>
	 * 	<li>users try to join a public Game Room as players(their User Variables must match the matching criteria);</li>
	 * 	<li>the server selects additional users to be invited to join a private game(see the<em>searchableRooms</em>property).</li>
	 *</ol>
	 *</p>
	 * 
	 *<p>Filtering is not applied to users invited by the creator to join a private game(see the<em>invitedPlayers</em>property).</p>
	 * 
	 * @default	null
	 * 
	 * @see 	#spectatorMatchExpression
	 * @see 	#invitedPlayers
	 * @see 	#searchableRooms
	 */ 
	public var playerMatchExpression(get_playerMatchExpression, set_playerMatchExpression):MatchExpression;
 	private function get_playerMatchExpression():MatchExpression
	{
		return _playerMatchExpression;
	}
	
	/**
	 * Defines the game matching expression to be used to filters spectators.
	 * 
	 *<p>Filtering is applied when users try to join a public Game Room as spectators(their User Variables must match the matching criteria).</p>
	 * 
	 * @default	null
	 * 
	 * @see 	#playerMatchExpression
	 */ 
	public var spectatorMatchExpression(get_spectatorMatchExpression, set_spectatorMatchExpression):MatchExpression;
 	private function get_spectatorMatchExpression():MatchExpression
	{
		return _spectatorMatchExpression;
	}
	
	/**
	 * In private games, defines an optional object containing additional custom parameters to be sent together with the invitation.
	 *<p>This object must be an instance of<em>SFSObject</em>. Possible custom parameters to be transferred to the invitees are
	 * a message for the recipient, the game details(title, type...), the inviter details, etc.</p>
	 * 
	 * @default	null
	 * 
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */ 
	public var invitationParams(get_invitationParams, set_invitationParams):SFSObject;
 	private function get_invitationParams():SFSObject
	{
		return _invitationParams;
	}
	
	/** @private */
	private function set_isPublic(value:Bool):Void
	{
		_isPublic=value;
	}
	
	/** @private */
	private function set_minPlayersToStartGame(value:Int):Void
	{
		_minPlayersToStartGame=value;
	}
	
	/** @private */
	private function set_invitedPlayers(value:Array):Void
	{
		_invitedPlayers=value;
	}
	
	/** @private */
	private function set_searchableRooms(value:Array):Void
	{
		_searchableRooms=value;
	}
	
	/** @private */
	private function set_invitationExpiryTime(value:Int):Void
	{
		_invitationExpiryTime=value;
	}
	
	/** @private */
	private function set_leaveLastJoinedRoom(value:Bool):Void
	{
		_leaveLastJoinedRoom=value;
	}
	
	/** @private */
	private function set_notifyGameStarted(value:Bool):Void
	{
		_notifyGameStarted=value;
	}
	
	/** @private */
	private function set_playerMatchExpression(value:MatchExpression):Void
	{
		_playerMatchExpression=value;
	}
	
	/** @private */
	private function set_spectatorMatchExpression(value:MatchExpression):Void
	{
		_spectatorMatchExpression=value;
	}
	
	/** @private */
	private function set_invitationParams(value:SFSObject):Void
	{
		_invitationParams=value;
	}
}