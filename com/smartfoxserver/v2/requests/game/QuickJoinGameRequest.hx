package com.smartfoxserver.v2.requests.game;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.match.MatchExpression;
import openfl.errors.ArgumentError;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Quickly joins the current user in a public game.
 * 
 *<p>By providing a matching expression and a list of Rooms or Groups, SmartFoxServer can search for a matching public Game Room
 * and immediately join the user Into that Room as a player.</p>
 * 
 *<p>If a game could be found and joined, the<em>roomJoin</em>event is dispatched to the requester's client.</p>
 * 
 * @example	The following example makes the user quickly join a public game:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
 * 	
 * 	// Create a matching expression to find a Darts game with a "maxBet" variable less than 100
 * 	var exp:MatchExpression=new MatchExpression("type", StringMatch.EQUALS, "darts").and("maxBet", FloatMatch.LESS_THAN, 100);
 * 	
 * 	// Search and join a public game within the "games" Group, leaving the last joined Room
 * 	sfs.send(new QuickJoinGameRequest(exp, ["games"], sfs.lastJoinedRoom));
 * }
 * 
 * private function onRoomJoin(evt:SFSEvent):Void
 * {
 * 	trace("Successfully joined Room:" + evt.params.room);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.entities.match.MatchExpression MatchExpression
 * @see		com.smartfoxserver.v2.requests.JoinRoomRequest JoinRoomRequest
 * @see		com.smartfoxserver.v2.SmartFox#event:roomJoin roomJoin event
 */
class QuickJoinGameRequest extends BaseRequest
{
	private static inline var MAX_ROOMS:Int = 32;
	
	/** @private */
	public static inline var KEY_ROOM_LIST:String = "rl";
	
	/** @private */
	public static inline var KEY_GROUP_LIST:String = "gl";
	
	/** @private */
	public static inline var KEY_ROOM_TO_LEAVE:String = "tl";
	
	/** @private */
	public static inline var KEY_MATCH_EXPRESSION:String = "me";
	
	private var _whereToSearch:Array<Dynamic>;
	private var _matchExpression:MatchExpression;
	private var _roomToLeave:Room;
		
	/*
	* Due to the lack of constructor overloading in AS3 we allow the developer to pass
	* either an Array<String>where we expect one or more public group names, or an Array<Room>where he can specify
	* a number of Rooms(<32)
	*/
	/**
	 * Creates a new<em>QuickJoinGameRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	matchExpression	A matching expression that the system will use to search a Game Room where to join the current user.
	 * @param	whereToSearch	An array of<em>Room</em>objects or an array of Group names to which the matching expression should be applied.
	 * 							The maximum number of elements that this array can contain is 32.
	 * @param	roomToLeave		A<em>Room</em>object representing the Room that the user should leave when joining the game.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function new(matchExpression:MatchExpression, whereToSearch:Array<Dynamic>, roomToLeave:Room=null)
	{
		super(BaseRequest.QuickJoinGame);
		
		_matchExpression = matchExpression;
		_whereToSearch = whereToSearch;
		_roomToLeave = roomToLeave;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		// NOTE:match expression can be null, in which case the first Room found is going to be good
		if(_whereToSearch==null || _whereToSearch.length<1)
			errors.push("Missing whereToSearch parameter");
			
		else if(_whereToSearch.length>MAX_ROOMS)
			errors.push("Too many Rooms specified in the whereToSearch parameter. Client limit is:" + MAX_ROOMS);
			
		if(errors.length>0)
			throw new SFSValidationError("QuickJoinGame request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		// Auto detect whereToSearch types --->>String, GroupId
		if(Std.isOfType(_whereToSearch[0],String))
			_sfso.putUtfStringArray(KEY_GROUP_LIST, cast _whereToSearch);
		
		// --->>Room
		else if(Std.isOfType(_whereToSearch[0],Room))
		{
			var roomIds:Array<Int> = [];
			
			for(i in 0..._whereToSearch.length)
			{
				var item:Room = _whereToSearch[i];
				
				if(Std.isOfType(item, Room))
					roomIds.push(item.id);
			}
			
			_sfso.putIntArray(KEY_ROOM_LIST, roomIds);			
		}
		
		// Bad type, stop the process via runtime error
		else
		{
			throw new ArgumentError("Invalid type in whereToSearch parameter:" + _whereToSearch[0])	;
		}
		
		if(_roomToLeave !=null)
			_sfso.putInt(KEY_ROOM_TO_LEAVE, _roomToLeave.id);
			
		if(_matchExpression !=null)
			_sfso.putSFSArray(KEY_MATCH_EXPRESSION, _matchExpression.toSFSArray());
	}
}