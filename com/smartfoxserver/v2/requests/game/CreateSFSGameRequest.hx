package com.smartfoxserver.v2.requests.game;

import com.smartfoxserver.v2.requests.game.SFSGameSettings;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;
import com.smartfoxserver.v2.requests.CreateRoomRequest;

/**
 * Creates a new public or private game, including player matching criteria, invitations settings and more.
 * 
 *<p>A game is created through the istantiation of a<em>SFSGame</em>on the server-side,
 * a specialized Room type that provides advanced features during the creation phase of a game.
 * Specific game-configuration settings are passed by means of the<em>SFSGameSettings</em>class.</p>
 * 
 *<p>If the creation is successful, a<em>roomAdd</em>event is dispatched to all the users who subscribed the Group to which the Room is associated, including the game creator.
 * Otherwise, a<em>roomCreationError</em>event is returned to the creator's client.</p>
 * 
 *<p>Also, if the settings passed in the<em>SFSGameSettings</em>object cause invitations to join the game to be sent, an<em>invitation</em>event is
 * dispatched to all the recipient clients.</p>
 * 
 *<p>Check the SmartFoxServer 2X documentation for a more in-depth overview of the GAME API.</p>
 * 
 * @example	The following example creates a new game:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomCreated);
 * 	sfs.addEventListener(SFEvent.ROOM_CREATION_ERROR, onRoomCreationError);
 * 	
 * 	// Prepare the settings for a public game
 * 	var settings:SFSGameSettings=new SFSGameSettings("DartsGame");
 * 	settings.maxUsers=2;
 * 	settings.maxSpectators=8;
 * 	settings.isPublic=true;
 * 	settings.minPlayersToStartGame=2;
 * 	settings.notifyGameStarted=true;
 * 	
 * 	// Set the matching expression for filtering users joining the Room
 * 	settings.playerMatchExpression=new MatchExpression("bestScore", FloatMatch.GREATER_THAN, 100);
 * 	
 * 	// Set a Room Variable containing the description of the game
 * 	settings.variables=[new SFSRoomVariable("desc", "Darts game, public, bestScore>100")];
 * 	
 * 	// Create the game
 * 	sfs.send(new CreateSFSGameRequest(settings));
 * }
 * 
 * private function onRoomCreated(evt:SFSEvent):Void
 * {
 * 	trace("Room created:" + evt.params.room);
 * }
 * 
 * private function onRoomCreationError(evt:SFSEvent):Void
 * {
 * 	trace("Room creation failed:" + evt.params.errorMessage);
 * }
 *</listing>
 * 
 * @see		SFSGameSettings
 * @see		com.smartfoxserver.v2.SmartFox#event:roomAdd roomAdd event
 * @see		com.smartfoxserver.v2.SmartFox#event:roomCreationError roomCreationError event
 * @see		com.smartfoxserver.v2.SmartFox#event:invitation invitation event
 */
class CreateSFSGameRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_IS_PUBLIC:String = "gip";
	
	/** @private */
	public static inline var KEY_MIN_PLAYERS:String = "gmp";
	
	/** @private */
	public static inline var KEY_INVITED_PLAYERS:String = "ginp";
	
	/** @private */
	public static inline var KEY_SEARCHABLE_ROOMS:String = "gsr";
	
	/** @private */
	public static inline var KEY_PLAYER_MATCH_EXP:String = "gpme";
	
	/** @private */
	public static inline var KEY_SPECTATOR_MATCH_EXP:String = "gsme";
	
	/** @private */
	public static inline var KEY_INVITATION_EXPIRY:String = "gie";
	
	/** @private */
	public static inline var KEY_LEAVE_ROOM:String = "glr";
	
	/** @private */
	public static inline var KEY_NOTIFY_GAME_STARTED:String = "gns";
	
	/** @private */
	public static inline var KEY_INVITATION_PARAMS:String="ip";
	
	private var _createRoomRequest:CreateRoomRequest;
	private var _settings:SFSGameSettings;
	
	/**
	 * Creates a new<em>CreateSFSGameRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	settings	An object containing the SFSGame configuration settings.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		SFSGameSettings
	 */
	public function new(settings:SFSGameSettings)
	{
		super(BaseRequest.CreateSFSGame);
		_settings = settings;
		_createRoomRequest = new CreateRoomRequest(settings, false, null);
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// First validate Room settings
		try
		{
			_createRoomRequest.validate(sfs);
		}
		catch(err:SFSValidationError)
		{
			// Take the current errors and continue checking...
			errors = err.errors	;
		}
		
		if(_settings.minPlayersToStartGame>_settings.maxUsers)
			errors.push("minPlayersToStartGame cannot be greater than maxUsers");
			
		if(_settings.invitationExpiryTime < InviteUsersRequest.MIN_EXPIRY_TIME || _settings.invitationExpiryTime > InviteUsersRequest.MAX_EXPIRY_TIME)
			errors.push("Expiry time value is out of range(" + InviteUsersRequest.MIN_EXPIRY_TIME + "-" + InviteUsersRequest.MAX_EXPIRY_TIME + ")");
					
		if(_settings.invitedPlayers !=null && _settings.invitedPlayers.length>InviteUsersRequest.MAX_INVITATIONS_FROM_CLIENT_SIDE)
			errors.push("Cannot invite more than " + InviteUsersRequest.MAX_INVITATIONS_FROM_CLIENT_SIDE + " players from client side");
					
		if(errors.length>0)
			throw new SFSValidationError("CreateSFSGameRoom request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		// Execute the parent Request and grab the populated SFSObject
		_createRoomRequest.execute(sfs);
		_sfso = _createRoomRequest.getMessage().content;
		
		// Proceed populating the other fields in the child class
		_sfso.putBool(KEY_IS_PUBLIC, _settings.isPublic);
		_sfso.putShort(KEY_MIN_PLAYERS, _settings.minPlayersToStartGame);
		_sfso.putShort(KEY_INVITATION_EXPIRY, _settings.invitationExpiryTime);
		_sfso.putBool(KEY_LEAVE_ROOM, _settings.leaveLastJoinedRoom);
		_sfso.putBool(KEY_NOTIFY_GAME_STARTED, _settings.notifyGameStarted);
		
		if(_settings.playerMatchExpression !=null)
			_sfso.putSFSArray(KEY_PLAYER_MATCH_EXP, _settings.playerMatchExpression.toSFSArray());
			
		if(_settings.spectatorMatchExpression !=null)
			_sfso.putSFSArray(KEY_SPECTATOR_MATCH_EXP, _settings.spectatorMatchExpression.toSFSArray());
		
		// Invited players
		if(_settings.invitedPlayers !=null)
		{
			var playerIds:Array<Int> = [];
			
			for(player in _settings.invitedPlayers)
			{
				if(Std.isOfType(player, User) || Std.isOfType(player,Buddy))
					playerIds.push(player.id);
			} 
			_sfso.putIntArray(KEY_INVITED_PLAYERS, playerIds);
		}
		
		// Searchable rooms
		if(_settings.searchableRooms !=null)
			_sfso.putUtfStringArray(KEY_SEARCHABLE_ROOMS, _settings.searchableRooms);
			
		// Invitation params
		if(_settings.invitationParams !=null)
			_sfso.putSFSObject(KEY_INVITATION_PARAMS, _settings.invitationParams);
	}
}