package com.smartfoxserver.v2.entities.match;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;

/**
 * The<em>MatchExpression</em>class represents a matching expression used to compare custom variables or predefined properties when searching for users or Rooms.
 * 
 *<p>The matching expressions are built like "if" statements in any common programming language.
 * They work like queries in a database and can be used to search for Rooms or users using custom criteria:in fact a matching expression can compare predefined
 * properties of the Room and user entities(see the<em>RoomProperties</em>and<em>UserProperties</em>classes), but also custom Room or User Variables.</p>
 *<p>These expressions are easy to create and concatenate, and they can be used for many different filtering operations within the SmartFoxServer 2X framework,
 * for example to invite players to join a game(see the<em>CreateSFSGameRequest</em>request description), to look for specific Rooms
 * or users(see the<em>FindRoomsRequest</em>and<em>FindUsersRequest</em>requests descriptions), etc.</p>
 * 
 *<p>Additionally(see the examples for more informations):
 *<ul>
 * 	<li>any number of expressions can be linked together with the logical<b>AND</b>and<b>OR</b>operators to create complex queries;</li>
 * 	<li>searching through nested data structures such as<em>SFSObject</em>and<em>SFSArray</em>can be done via a very simple dot-syntax.</li>
 *</ul>
 *</p>
 * 
 * @example	The following example shows how to create a simple matching expression made of two concatenated conditions:it compares the custom "rank" and "country" User Variables to the passed values.
 * This expression could be used during the creation of a Game Room, to filter the users that the server should take Into account when sending the invitations to join the game(only
 * italian users with a ranking greater than 5 - whatever this number means to our game):
 *<listing version="3.0">
 * 
 * var exp:MatchExpression=new MatchExpression('rank', FloatMatch.GREATER_THAN, 5).and('country', StringMatch.EQUALS, 'Italy');
 *</listing>
 * 
 * @example	The following example creates a matching expression made of three concatenated conditions which compare two predefined Room properties and the custom "isGameStarted" Room Variable to the passed values;
 * this expression could be used to retrieve all the Game Rooms still waiting for players to join them:
 *<listing version="3.0">
 * 
 * var exp:MatchExpression=new MatchExpression(RoomProperties.IS_GAME, BoolMatch.EQUALS, true)
 * 							.and(RoomProperties.HAS_FREE_PLAYER_SLOTS, BoolMatch.EQUALS, true)
 * 							.and("isGameStarted", BoolMatch.EQUALS, false);
 *</listing>
 * 
 * @example	The following example creates a matching expression which compares a nested property in a complex data structure;
 * an<em>SFSObject</em>called "avatarData"(could be a User Variable for example)contains the "shield" object(a nested<em>SFSObject</em>)
 * which in turn contains, among others, the "inUse" property which could be used to retrieve all user whose avatars are currently equipped with a shield:
 *<listing version="3.0">
 * 
 * var exp:MatchExpression=new MatchExpression("avatarData.shield.inUse", BoolMatch.EQUALS, true);
 *</listing>
 * 
 * @example	The following example is similar to the previous one, but it involves an<em>SFSArray</em>. The "avatarData" object contains the "weapons"<em>SFSArray</em>,
 * from which the expression retrieves the third element(that<em>.3</em>means "give me the element at index==3")that we know being the weapon the user avatar has in his right hand.
 * Again, this element is an<em>SFSObject</em>containing, among the others, the "name" property which can be compared to the passed string.
 * This example could be used to retrieve all users whose avatars have the Narsil sword in the right hand:
 *<listing version="3.0">
 * 
 * var exp:MatchExpression=new MatchExpression("avatarData.weapons.3.name", StringMatch.EQUALS, "Narsil");
 *</listing>
 * 
 * @see		RoomProperties
 * @see		UserProperties
 * @see		com.smartfoxserver.v2.requests.game.CreateSFSGameRequest CreateSFSGameRequest
 * @see		com.smartfoxserver.v2.requests.FindRoomsRequest FindRoomsRequest
 * @see		com.smartfoxserver.v2.requests.FindUsersRequest FindUsersRequest
 */
class MatchExpression
{
	
	//private var condition(default,null):IMatcher;
	//private var value(default,null):Dynamic;
	//
	///** @private */
	//private var _logicOp:LogicOperator;
	//
	public var parent:MatchExpression;
	//
	///** @private */
	//private var _next:MatchExpression;
	
	/*
	* Poor's man version of an overloaded constructor
	*/
	/** @private */
	static function chainedMatchExpression(varName:String, condition:IMatcher, value:Dynamic, logicOp:LogicOperator, parent:MatchExpression):MatchExpression
	{
		var matchingExpression:MatchExpression = new MatchExpression(varName, condition, value);
		matchingExpression.logicOp = logicOp;
		matchingExpression.parent = parent;
		
		return matchingExpression;
	}
	
	/**
	 * Creates a new<em>MatchExpression</em>instance.
	 * 
	 * @param	varName		Name of the variable or property to match.
	 * @param	condition	The matching condition.
	 * @param	value		The value to compare against the variable or property during the matching.
	 * 
	 * @see		#varName
	 * @see		#condition
	 * @see		#value
	 */
	public function new(varName:String, condition:IMatcher, value:Dynamic)
	{
		this.varName = varName;
		this.condition = condition;
		this.value = value;
	}
	
	/**
	 * Concatenates the current expression with a new one using the logical<b>AND</b>operator.
	 * 
	 * @param	varName		The name of the additional variable or property to match.
	 * @param	condition	The additional matching condition.
	 * @param	value		The value to compare against the additional variable or property during the matching.
	 * 
	 * @return 	A new<em>MatchExpression</em>resulting from the concatenation of the current expression with a new one generated from the specified parameters.
	 * 
	 * @see		#varName
	 * @see		#condition
	 * @see		#value
	 * @see		LogicOperator#AND
	 */
	public function and(varName:String, condition:IMatcher, value:Dynamic):MatchExpression
	{
		this.next = chainedMatchExpression(varName, condition, value, LogicOperator.AND(), this);
		return next;
	}
	
	/**
	 * Concatenates the current expression with a new one using the logical<b>OR</b>operator.
	 * 
	 * @param	varName		The name of the additional variable or property to match.
	 * @param	condition	The additional matching condition.
	 * @param	value		The value to compare against the additional variable or property during the matching.
	 * 
	 * @return 	A new<em>MatchExpression</em>resulting from the concatenation of the current expression with a new one generated from the specified parameters.
	 * 
	 * @see		#varName
	 * @see		#condition
	 * @see		#value
	 * @see		LogicOperator#OR
	 */
	public function or(varName:String, condition:IMatcher, value:Dynamic):MatchExpression
	{
		this.next = chainedMatchExpression(varName, condition, value, LogicOperator.OR(), this);
		return next;
	}
	
	/**
	 * Returns the name of the variable or property against which the comparison is made.
	 * 
	 *<p>Depending what the matching expression is used for(searching a user or a Room), this can be
	 * the name of a User Variable or a Room Variable, or it can be one of the constants contained in the<em>UserProperties</em>or<em>RoomProperties</em>classes,
	 * representing some of the predefined properties of the user and Room entities respectively.</p>
	 * 
	 * @see		RoomProperties
	 * @see		UserProperties
	 * @see		com.smartfoxserver.v2.entities.variables.RoomVariable RoomVariable
	 * @see		com.smartfoxserver.v2.entities.variables.UserVariable UserVariable
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 * @see		com.smartfoxserver.v2.entities.User User
	 */
	public var varName(default, null):String;

	
	/**
	 * Returns the matching criteria used during values comparison.
	 * 
	 *<p>Different objects implementing the<em>IMatcher</em>interface can be used, depending on the type of the variable or property to check.</p>
	 * 
	 * @see		BoolMatch
	 * @see		NumberMatch
	 * @see		StringMatch
	 */
	public var condition(default, null):IMatcher;
	
	/**
	 * Returns the value against which the variable or property corresponding to<em>varName</em>is compared.
	 */
	public var value(default, null):Dynamic;
	
	/**
	 * In case of concatenated expressions, returns the current logical operator.
	 * 
	 * @default null
	 */
	public var logicOp:LogicOperator;
	
	/**
	 * Checks if the current matching expression is concatenated to another one through a logical operator.
	 * 
	 * @return	<code>true</code>if the current matching expression is concatenated to another one.
	 * 
	 * @see		#logicOp
	 */
	public function hasNext():Bool
	{
		return next != null;
	}
	
	/**
	 * Returns the next matching expression concatenated to the current one.
	 */
	public var next(default, null):MatchExpression;
	
	/**
	 * Moves the iterator cursor to the first matching expression in the chain.
	 * 
	 * @return	The<em>MatchExpression</em>object at the top of the chain of matching expressions.
	 * 
	 */
	public function rewind():MatchExpression
	{
		var currNode:MatchExpression = this;
	
		while(true)
		{
			if(currNode.parent !=null)
				currNode = currNode.parent;
			else
				break;
		}
		
		return currNode;
	}
	
	/** @private */
	public function asString():String
	{
		var sb:String = "";
		
		if(logicOp !=null)
			sb += " " + logicOp.id + " ";
			
		sb += "(";
		sb += varName + " " + condition.symbol + " " +(Std.isOfType(value, String) ?("'" + value + "'"):value);
		sb += ")";
		
		return sb;
	}
	
	/**
	 * Returns a string representation of the matching expression.
	 * 
	 * @return	The string representation of the<em>MatchExpression</em>object.
	 */
	public function toString():String
	{
		var expr:MatchExpression = rewind();
		var sb:String = expr.asString();
		
		while(expr.hasNext())
		{
			expr = expr.next;
			sb += expr.asString();
		}
		
		return sb;
	}
	
	/** @private */
	public function toSFSArray():ISFSArray
	{
		var expr:MatchExpression = rewind();
		
		// Start with the main expression
		var sfsa:ISFSArray = new SFSArray();
		sfsa.addSFSArray(expr.expressionAsSFSArray());
		
		// continue with other linked expressions, if any
		while(expr.hasNext())
		{
			expr = expr.next;
			sfsa.addSFSArray(expr.expressionAsSFSArray());
		}
		
		return sfsa;
	}
	
	private function expressionAsSFSArray():ISFSArray
	{
		var expr:ISFSArray = new SFSArray();
	
		// 0 ->Logic operator
		if(logicOp !=null)
			expr.addUtfString(logicOp.id);
		else
			expr.addNull();
		
		// 1 ->Var name
		expr.addUtfString(varName);
		
		// 2 ->Matcher type
		expr.addByte(condition.type);
		
		// 3 ->Condition symbol
		expr.addUtfString(condition.symbol);
		
		// 4 ->Value to match against
		if(condition.type==0)
			expr.addBool(value);
			
		else if(condition.type==1)
			expr.addDouble(value);
			
		else
			expr.addUtfString(value);
			
		return expr;
	}	
}