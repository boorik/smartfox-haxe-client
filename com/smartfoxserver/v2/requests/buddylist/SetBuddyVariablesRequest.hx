package com.smartfoxserver.v2.requests.buddylist;
import com.smartfoxserver.v2.entities.variables.BuddyVariable;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;

import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.BaseRequest;

/**
 * Sets one or more Buddy Variables for the current user.
 * 
 *<p>This operation updates the<em>Buddy</em>object representing the user in all the buddies lists in which the user was added as a buddy.
 * If the operation is successful, a<em>buddyVariablesUpdate</em>event is dispatched to all the owners of those buddies lists and to the user who updated his variables too.</p>
 * 
 *<p>The Buddy Variables can be persisted, which means that their value will be saved even it the user disconnects and it will be restored when he connects again.
 * In order to make a variable persistent, put the constant<em>SFSBuddyVariable.OFFLINE_PREFIX</em>before its name. Read the SmartFoxServer 2X documentaion about the<b>Buddy List API</b>for more informations.</p>
 * 
 *<p><b>NOTE</b>:this request can be sent if the Buddy List system was previously initialized only(see the<em>InitBuddyListRequest</em>request description)
 * and the current user state in the system is "online".</p>
 * 
 * @example	The following example sets some Buddy Variables for the current user, one of which is persistent;
 * the example also handles changes made by the user or by his buddies:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_VARIABLES_UPDATE, onBuddyVarsUpdate);
 * 	
 * 	// Create two Buddy Variables containing the title and artist of the song I'm listening to
 * 	var songTitle:BuddyVariable=new SFSBuddyVariable("songTitle", "Ascension");
 * 	var songAuthor:BuddyVariable=new SFSBuddyVariable("songAuthor", "Mike Oldfield");
 * 	
 * 	// Create a persistent Buddy Variable containing my mood message
 * 	var mood:BuddyVariable=new SFSBuddyVariable(SFSBuddyVariable.OFFLINE_PREFIX + "mood", "I Need SmartFoxServer 2X desperately!");
 * 	
 * 	// Set my Buddy Variables
 * 	var vars:Array<Dynamic>=[songTitle, songAuthor, mood];
 * 	sfs.send(new SetBuddyVariablesRequest(vars));
 * }
 * 
 * private function onBuddyVarsUpdate(evt:SFSBuddyEvent):Void
 * {
 * 	// As the update event is dispatched to me too,
 * 	// I have to check if I am the one who changed his Buddy Variables
 * 	
 * 	var isItMe:Bool=evt.params.isItMe;
 * 	
 * 	if(isItMe)
 * 	{
 * 		trace("I've updated the following Buddy Variables:");
 * 		
 * 		for(var i:Int=0;i &lt;evt.params.changedVars.length;i++)
 * 		{
 * 			var bVarName:String=evt.params.changedVars[i];
 * 			
 * 			trace(bVarName, "--&gt;", sfs.buddyManager.getMyVariable(bVarName).getValue());
 * 		}
 * 	}
 * 	else
 * 	{
 * 		var buddyName:String=evt.params.buddy.name;
 * 		
 * 		trace("My buddy " + buddyName + " updated the following Buddy Variables:");
 * 		
 * 		for(var i:Int=0;i &lt;evt.params.changedVars.length;i++)
 * 		{
 * 			var bVarName:String=evt.params.changedVars[i];
 * 			
 * 			trace(bVarName, "--&gt;", sfs.buddyManager.getBuddyByName(buddyName).getVariable(bVarName).getValue());
 * 		}
 * 	}
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyVariablesUpdate buddyVariablesUpdate event
 * @see		InitBuddyListRequest
 */
class SetBuddyVariablesRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_BUDDY_NAME:String = "bn";
	
	/** @private */
	public static inline var KEY_BUDDY_VARS:String = "bv";
	
	private var _buddyVariables:Array<BuddyVariable>;
	
	/**
	 * Creates a new<em>SetBuddyVariablesRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	buddyVariables	A list of<em>BuddyVariable</em>objects representing the Buddy Variables to be set.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
	 */
	public function new(buddyVariables:Array<BuddyVariable>)
	{
		super(BaseRequest.SetBuddyVariables);
		_buddyVariables = buddyVariables;
	}

	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
		
		if(sfs.buddyManager.myOnlineState==false)
			errors.push("Can't set buddy variables while off-line");
			
		if(_buddyVariables==null || _buddyVariables.length==0)
			errors.push("No variables were specified");
						
		if(errors.length>0)
			throw new SFSValidationError("SetBuddyVariables request error", errors);
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		var varList:ISFSArray = new SFSArray();
		 
		for(bVar in _buddyVariables)
		{
			varList.addSFSArray(bVar.toSFSArray());
		}
		
		_sfso.putSFSArray(KEY_BUDDY_VARS, varList);
	}
}