package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.match.MatchExpression;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.exceptions.SFSValidationError;


/**
 * Retrieves a list of Rooms from the server which match the specified criteria.
 * 
 *<p>By providing a matching expression and a search scope(a Group or the entire Zone), SmartFoxServer can find those Rooms
 * matching the passed criteria and return them by means of the<em>roomFindResult</em>event.</p>
 * 
 * @example	The following example looks for all the server Rooms whose "country" Room Variable is set to<code>Sweden</code>:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_FIND_RESULT, onRoomFindResult);
 * 	
 * 	// Create a matching expression to find Rooms with a "country" variable equal to "Sweden"
 * 	var exp:MatchExpression=new MatchExpression("country", StringMatch.EQUALS, "Sweden");
 * 	
 * 	// Find the Rooms
 * 	sfs.send(new FindRoomsRequest(exp));
 * }
 * 
 * private function onRoomFindResult(evt:SFSEvent):Void
 * {
 * 	trace("Rooms found:" + evt.params.rooms);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.entities.match.MatchExpression MatchExpression
 * @see		com.smartfoxserver.v2.SmartFox#event:roomFindResult roomFindResult event
 */
class FindRoomsRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_EXPRESSION:String = "e";
	
	/** @private */
	public static inline var KEY_GROUP:String = "g";
	
	/** @private */
	public static inline var KEY_LIMIT:String = "l";
	
	/** @private */
	public static inline var KEY_FILTERED_ROOMS:String = "fr";
	
	private var _matchExpr:MatchExpression;
	private var _groupId:String;
	private var _limit:Int;
	
	/**
	 * Creates a new<em>FindRoomsRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	expr	A matching expression that the system will use to retrieve the Rooms.
	 * @param	groupId	The name of the Group where to search for matching Rooms;if<code>null</code>, the search is performed in the whole Zone.
	 * @param	limit	The maximum size of the list of Rooms that will be returned by the<em>roomFindResult</em>event. If<code>0</code>, all the found Rooms are returned.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.SmartFox#event:roomFindResult roomFindResult event
	 */
	public function new(expr:MatchExpression, groupId:String=null, limit:Int=0):Void
	{
		super(BaseRequest.FindRooms);
		
		_matchExpr = expr;
		_groupId = groupId;
		_limit = limit;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(_matchExpr==null)
			errors.push("Missing Match Expression");
		
		if(errors.length>0)
			throw new SFSValidationError("FindRooms request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putSFSArray(KEY_EXPRESSION, _matchExpr.toSFSArray());
		
		if(_groupId !=null)
			_sfso.putUtfString(KEY_GROUP, _groupId);
			
		// 2^15 is already too many Rooms:)
		if(_limit>0)
			_sfso.putShort(KEY_LIMIT, _limit);
	}
}