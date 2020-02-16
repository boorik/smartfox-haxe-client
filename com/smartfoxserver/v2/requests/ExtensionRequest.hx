package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSValidationError;

/**
 * Sends a command to the server-side Extension attached to the Zone or to a Room.
 * 
 *<p>This request is used to send custom commands from the client to a server-side Extension, be it a Zone-level or Room-level Extension.
 * Viceversa, the<em>extensionResponse</em>event is used by the server to send Extension commands/responses to the client.</p>
 * 
 *<p>Read the SmartFoxServer 2X documentation about server-side Extension for more informations.</p>
 * 
 *<p>The<em>ExtensionRequest</em>request can be sent using the UDP protocol too, provided it is available(see the<em>SmartFox.udpAvailable</em>property):
 * this allows sending fast stream of packets to the server in real-time type games, typically for position/transformation updates, etc.</p>
 * 
 * @example	The following example sends a command to the Zone Extension;it also handles responses coming from the
 * Extension by implementing the<em>extensionResponse</em>listener(the same command name is used in both the request and the response):
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
 * 	
 * 	// Send two Integers to the Zone extension and get their sum in return
 * 	var params:ISFSObject=new SFSObject();
 * 	params.putInt("n1", 26);
 * 	params.putInt("n2", 16);
 * 	
 * 	sfs.send(new ExtensionRequest("add", params));
 * }
 * 
 * private function onExtensionResponse(evt:SFSEvent):Void
 * {
 * 	if(evt.params.cmd=="add")
 * 	{
 * 		var responseParams:ISFSObject=evt.params.params as SFSObject;
 * 		
 * 		// We expect an Int parameter called "sum"
 * 		trace("The sum is:" + responseParams.getInt("sum"));
 * 	}
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:extensionResponse extensionResponse event
 * @see		com.smartfoxserver.v2.SmartFox#udpAvailable SmartFox.udpAvailable
 */
class ExtensionRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_CMD:String = "c";
	
	/** @private */
	public static inline var KEY_PARAMS:String = "p";
	
	/** @private */
	public static inline var KEY_ROOM:String = "r";
	
	private var _extCmd:String;
	private var _params:ISFSObject;
	private var _room:Room;
	private var _useUDP:Bool;
	
	/**
	 * Creates a new<em>ExtensionRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	extCmd	The name of the command which identifies an action that should be executed by the server-side Extension.
	 * @param	params	An instance of<em>SFSObject</em>containing custom data to be sent to the Extension. Can be null if no data needs to be sent.
	 * @param	room	If<code>null</code>, the specified command is sent to the current Zone server-side Extension;if not<code>null</code>, the command is sent to the server-side Extension attached to the passed Room.
	 * @param	useUDP	If<code>true</code>, the UDP protocol is used to send the request to the server(check the<em>SmartFox.udpAvailable</em>property for more informations).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 * @see		com.smartfoxserver.v2.SmartFox#udpAvailable SmartFox.udpAvailable
	 */
	public function new(extCmd:String, params:ISFSObject=null, room:Room=null, useUDP:Bool=false)
	{
		super(BaseRequest.CallExtension);
		
		_targetController = 1;
		
		_extCmd = extCmd;
		_params = params;
		_room = room;
		_useUDP = useUDP;
			
		// since 0.9.6
		if(_params==null)
			_params = new SFSObject();
	}
	
	/** @private */
	public var useUDP(get, null):Bool;
 	private function get_useUDP():Bool
	{
		return _useUDP;
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
			
		if(_extCmd==null || _extCmd.length==0)
			errors.push("Missing extension command");

		if(errors.length>0)
			throw new SFSValidationError("ExtensionCall request error", errors);
		
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putUtfString(KEY_CMD, _extCmd);
		_sfso.putInt(KEY_ROOM, _room == null ? -1:_room.id);
		_sfso.putSFSObject(KEY_PARAMS, _params);
	}
}