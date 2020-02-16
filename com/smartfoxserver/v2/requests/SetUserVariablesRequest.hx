package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Sets one or more custom User Variables for the current user.
 * 
 *<p>When a User Variable is set, the<em>userVariablesUpdate</em>event is dispatched to all the users in all the Rooms joined by the current user, including himself.</p>
 * 
 *<p><b>NOTE</b>:the<em>userVariablesUpdate</em>event is dispatched to users in a specific Room only if it is configured to allow this event(see the<em>RoomSettings.permissions</em>parameter).</p>
 * 
 * @example	The following example sets a number of User Variables and handles the respective update event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
 * 	
 * 	// Create some User Variables
 * 	var userVars:Array<Dynamic>=[];
 * 	userVars.push(new SFSUserVariable("avatarType", "SwedishCook"));
 * 	userVars.push(new SFSUserVariable("country", "Sweden"));
 * 	userVars.push(new SFSUserVariable("x", 10));
 * 	userVars.push(new SFSUserVariable("y", 5));
 * 	
 * 	sfs.send(new SetUserVariablesRequest(userVars));
 * }
 * 
 * private function onUserVarsUpdate(evt:SFSEvent):Void
 * {
 * 	var changedVars:Array<Dynamic>=evt.params.changedVars as Array<Dynamic>;
 * 	var user:User=evt.params.user as User;
 * 	
 * 	// Check if the user changed his x and y user variables
 * 	if(changedVars.indexOf("x")!=-1 || changedVars.indexOf("y")!=-1)
 * 	{
 * 		// Move the user avatar to a new position
 * 		...
 * 	}
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:userVariablesUpdate userVariablesUpdate event
 * @see		RoomSettings#permissions RoomSettings.permissions
 */
class SetUserVariablesRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_USER:String = "u";
	
	/** @private */
	public static inline var KEY_VAR_LIST:String = "vl";
	
	private var _userVariables:Array<UserVariable>;
	
	/**
	 * Creates a new<em>SetUserVariablesRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	userVariables	A list of<em>UserVariable</em>objects representing the User Variables to be set.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.variables.UserVariable UserVariable
	 */
	public function new(userVariables:Array<UserVariable>)
	{
		super(BaseRequest.SetUserVariables);
		_userVariables = userVariables	;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(_userVariables==null || _userVariables.length==0)
			errors.push("No variables were specified");
		
		if(errors.length>0)
			throw new SFSValidationError("SetUserVariables request error", errors);
		
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		var varList:ISFSArray = SFSArray.newInstance();
		 
		for(uVar in _userVariables)
		{
			varList.addSFSArray(uVar.toSFSArray());	
		}
		
		_sfso.putSFSArray(KEY_VAR_LIST, varList);
	}
}