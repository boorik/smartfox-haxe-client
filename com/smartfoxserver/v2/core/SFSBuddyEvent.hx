package com.smartfoxserver.v2.core;

import com.smartfoxserver.v2.events.Event;

/**
 *<em>SFSBuddyEvent</em>is the class representing all the events related to the Buddy List system dispatched by the SmartFoxServer 2X ActionScript 3 API.
 * 
 *<p>The<em>SFSBuddyEvent</em>parent class provides a public property called<em>params</em>which contains specific parameters depending on the event type.</p>
 * 
 * @see 	SFSEvent
 */
 class SFSBuddyEvent extends BaseEvent
{
	/**
	 * The<em>SFSBuddyEvent.BUDDY_LIST_INIT</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyListInit</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddyList</td><td><em>Array</em></td><td>A list of<em>Buddy</em>objects representing all the buddies in the current user's buddies list.</td></tr>
	 *<tr><td>myVariables</td><td><em>Array</em></td><td>A list of all the Buddy Variables associated with the current user.</td></tr>
	 *</table>
	 * 
	 * @example	The following example initializes the Buddy List system:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_LIST_INIT, onBuddyListInitialized);
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError)
	 * 	
	 * 	// Initialize the Buddy List system
	 * 	sfs.send(new InitBuddyListRequest());
	 * }
	 * 
	 * private function onBuddyListInitialized(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("Buddy List system initialized successfully");
	 * 	
	 * 	// Retrieve my buddies list
	 * 	var buddies:Array<Dynamic>=evt.params.buddyList;
	 * 	
	 * 	// Display the online buddies in a list component in the application Interface
	 * 	...
	 * }
	 * 
	 * private function onBuddyError(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	buddyListInit
	 * 
	 * @see		#BUDDY_ERROR
	 */
	public static inline var BUDDY_LIST_INIT:String = "buddyListInit";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_ADD</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyAdd</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddy</td><td><em>Buddy</em></td><td>The<em>Buddy</em>object corresponding to the buddy that was added.</td></tr>
	 *</table>
	 * 
	 * @example	The following example handles the possible events caused by a request to add a buddy:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ADD, onBuddyAdded);
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
	 * 	
	 * 	// Add user "Jack" as a new buddy to my buddies list
	 * 	sfs.send(new AddBuddyRequest("Jack"));
	 * }
	 * 
	 * private function onBuddyAdded(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("This buddy was added:", evt.params.buddy.name);
	 * }
	 * 
	 * private function onBuddyError(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("The following error occurred during a buddy-related request:", evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	buddyAdd
	 * 
	 * @see		#BUDDY_REMOVE
	 * @see		#BUDDY_ERROR
	 */
	public static inline var BUDDY_ADD:String = "buddyAdd";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_REMOVE</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyRemove</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddy</td><td><em>Buddy</em></td><td>The<em>Buddy</em>object corresponding to the buddy that was removed.</td></tr>
	 *</table>
	 * 
	 * @example	The following example handles the possible events caused by a request to remove a buddy:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_REMOVE, onBuddyRemoved);
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
	 * 	
	 * 	// Remove Jack from my buddies list
	 * 	sfs.send(new RemoveBuddyRequest("Jack"));
	 * }
	 * 
	 * private function onBuddyRemoved(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("This buddy was removed:", evt.params.buddy.name);
	 * }
	 * 
	 * private function onBuddyError(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	buddyRemove
	 * 
	 * @see		#BUDDY_ADD
	 * @see		#BUDDY_ERROR
	 */
	public static inline var BUDDY_REMOVE:String = "buddyRemove";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_BLOCK</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyBlock</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddy</td><td><em>Buddy</em></td><td>The<em>Buddy</em>object corresponding to the buddy that was blocked/unblocked.</td></tr>
	 *</table>
	 * 
	 * @example	The following example handles the possible events caused by a request to block a buddy:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_BLOCK, onBuddyBlock);
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ERROR, onBuddyError);
	 * 	
	 * 	// Block user "Jack" in my buddies list
	 * 	smartFox.send(new BlockBuddyRequest("Jack", true));
	 * }
	 * 
	 * private function onBuddyBlock(evt:SFSBuddyEvent):Void
	 * {
	 * 	var isBlocked:Bool=evt.params.buddy.isBlocked;
	 * 	trace("Buddy " + evt.params.buddy.name + " is now " +(isBlocked ? "blocked":"unblocked"));
	 * }
	 * 
	 * private function onBuddyError(evt:SFSBuddyEvent):Void
	 * {
	 * 	trace("The following error occurred while executing a buddy-related request:", evt.params.errorMessage);
	 * }
	 *</listing>
	 * 
	 * @eventType	buddyBlock
	 * 
	 * @see		#BUDDY_ERROR
	 */
	public static inline var BUDDY_BLOCK:String = "buddyBlock";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_ERROR</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyError</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>errorMessage</td><td><em>String</em></td><td>The message which describes the error.</td></tr>
	 *<tr><td>errorCode</td><td><em>int</em></td><td>The error code.</td></tr>
	 *</table>
	 * 
	 * @example	See the example provided in the<em>BUDDY_ADD</em>constant description.
	 * 
	 * @eventType	buddyError
	 * 
	 * @see		#BUDDY_ADD
	 */
	public static inline var BUDDY_ERROR:String = "buddyError";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyOnlineStateChange</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddy</td><td><em>Buddy</em></td><td>The<em>Buddy</em>object representing the buddy who changed his own online state. If the<em>isItMe</em>parameter is<code>true</code>, the value of this parameter is<code>null</code>(because a user is not buddy to himself).</td></tr>
	 *<tr><td>isItMe</td><td><em>Boolean</em></td><td><code>true</code>if the online state was changed by the current user himself(in this case this event is a sort of state change confirmation).</td></tr>
	 *</table>
	 * 
	 * @example	The following example changes the online state of the user in the Buddy List system:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, onBuddyOnlineStateUpdated);
	 * 	
	 * 	// Put myself offline in the Buddy List system
	 * 	sfs.send(new GoOnlineRequest(false));
	 * }
	 * 
	 * private function onBuddyOnlineStateUpdated(evt:SFSBuddyEvent):Void
	 * {
	 * 	// As the state change event is dispatched to me too,
	 * 	// I have to check if I am the one who changed his state
	 * 	
	 * 	var isItMe:Bool=evt.params.isItMe;
	 * 	
	 * 	if(isItMe)
	 * 		trace("I'm now",(sfs.buddyManager.myOnlineState ? "online":"offline"));
	 * 	else
	 * 		trace("My buddy " + evt.params.buddy.name + " is now",(evt.params.buddy.isOnline ? "online":"offline"));
	 * }
	 *</listing>
	 * 
	 * @eventType	buddyOnlineStateChange
	 */
	public static inline var BUDDY_ONLINE_STATE_UPDATE:String = "buddyOnlineStateChange";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_VARIABLES_UPDATE</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyVariablesUpdate</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddy</td><td><em>Buddy</em></td><td>The<em>Buddy</em>object representing the buddy who updated his own Buddy Variables. If the<em>isItMe</em>parameter is<code>true</code>, the value of this parameter is<code>null</code>(because a user is not buddy to himself).</td></tr>
	 *<tr><td>isItMe</td><td><em>Boolean</em></td><td><code>true</code>if the Buddy Variables were updated by the current user himself(in this case this event is a sort of update confirmation).</td></tr>
	 *<tr><td>changedVars</td><td><em>Array</em></td><td>The list of names of the Buddy Variables that were changed(or created for the first time).</td></tr>
	 *</table>
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
	 * @eventType	buddyVariablesUpdate
	 */
	public static inline var BUDDY_VARIABLES_UPDATE:String = "buddyVariablesUpdate";
	
	/**
	 * The<em>SFSBuddyEvent.BUDDY_MESSAGE</em>constant defines the value of the<em>type</em>property of the event object for a<em>buddyMessage</em>event.
	 * 
	 *<p>The properties of the<em>params</em>object contained in the event object have the following values:</p>
	 *<table class="innertable">
	 *<tr><th>Property</th><th>Type</th><th>Description</th></tr>
	 *<tr><td>buddy</td><td><em>Buddy</em></td><td>The<em>Buddy</em>object representing the message sender. If the<em>isItMe</em>parameter is<code>true</code>, the value of this parameter is<code>null</code>(because a user is not buddy to himself).</td></tr>
	 *<tr><td>isItMe</td><td><em>Boolean</em></td><td><code>true</code>if the message sender is the current user himself(in this case this event is a sort of message delivery confirmation).</td></tr>
	 *<tr><td>message</td><td><em>String</em></td><td>The message text.</td></tr>
	 *<tr><td>data</td><td><em>ISFSObject</em></td><td>An instance of<em>SFSObject</em>containing additional custom parameters(e.g. the message color, an emoticon id, etc).</td></tr>
	 *</table>
	 * 
	 * @example	The following example sends a message to a buddy and handles the related event:
	 *<listing version="3.0">
	 * 
	 * private function someMethod():Void
	 * {
	 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_MESSAGE, onBuddyMessage);
	 * 	
	 * 	// Get the recipient of the message, in this case my buddy Jack
	 * 	var buddy:Buddy=sfs.buddyManager.getBuddyByName("Jack");
	 * 	
	 * 	// Send a message to Jack
	 * 	sfs.send(new BuddyMessageRequest("Hello Jack!", buddy));
	 * }
	 * 
	 * private function onBuddyMessage(evt:SFSBuddyEvent):Void
	 * {
	 * 	// As messages are forwarded to the sender too,
	 * 	// I have to check if I am the sender
	 * 	
	 * 	var isItMe:Bool=evt.params.isItMe;
	 * 	var sender:Buddy=evt.params.buddy;
	 * 	
	 * 	if(isItMe)
	 * 		trace("I said:", evt.params.message);
	 * 	else
	 * 		trace("My buddy " + sender.name + " said:", evt.params.message);
	 * }
	 *</listing>
	 * 
	 * @eventType	buddyMessage
	 */
	public static inline var BUDDY_MESSAGE:String = "buddyMessage";
	
	
	//========================================================
	
	#if !html5
	/**
	 * Creates a new<em>SFSBuddyEvent</em>instance.
	 * 
	 * @param	type	The type of event.
	 * @param	params	An object containing the parameters of the event.
	 */
	public function new(type:String, params:Dynamic)
	{
		super(type);
		this.params = params;
	}
	
	/**
	 * Duplicates the instance of the<em>SFSBuddyEvent</em>object.
	 * 
	 * @return		A new<em>SFSBuddyEvent</em>object that is identical to the original.
	 */
	public override function clone():Event
	{
		return new SFSBuddyEvent(this.type, this.params);
	}
	#end
	
	/**
	 * Generates a string containing all the properties of the<em>SFSBuddyEvent</em>object.
	 * 
	 * @return		A string containing all the properties of the<em>SFSBuddyEvent</em>object.
	 */
	//public override function toString():String
	//{
		//return formatToString("SFSBuddyEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
	//}

}
