package com.smartfoxserver.v2.requests;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.mmo.MMORoomSettings;

/**
 * Creates a new Room in the current Zone.
 * 
 *<p>If the creation is successful, a<em>roomAdd</em>event is dispatched to all the users who subscribed the Group to which the Room is associated, including the Room creator.
 * Otherwise, a<em>roomCreationError</em>event is returned to the creator's client.</p>
 * 
 * @example	The following example creates a new chat room:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomCreated);
 * 	sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomCreationError);
 * 	
 * 	// Create a new chat Room
 * 	var settings:RoomSettings=new RoomSettings("My Chat Room");
 * 	settings.maxUsers=40;
 * 	settings.groupId="chats";
 * 	
 * 	sfs.send(new CreateRoomRequest(settings));
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
 * @see		com.smartfoxserver.v2.SmartFox#event:roomAdd roomAdd event
 * @see		com.smartfoxserver.v2.SmartFox#event:roomCreationError roomCreationError event
 */
class CreateRoomRequest extends BaseRequest
{
	/** @private */
	public static inline var KEY_ROOM:String = "r";
	
	/** @private */
	public static inline var KEY_NAME:String = "n";
	
	/** @private */
	public static inline var KEY_PASSWORD:String = "p";
	
	/** @private */
	public static inline var KEY_GROUP_ID:String = "g";
	
	/** @private */
	public static inline var KEY_ISGAME:String = "ig";
	
	/** @private */
	public static inline var KEY_MAXUSERS:String = "mu";
	
	/** @private */
	public static inline var KEY_MAXSPECTATORS:String = "ms";
	
	/** @private */
	public static inline var KEY_MAXVARS:String = "mv";
	
	/** @private */
	public static inline var KEY_ROOMVARS:String = "rv";
	
	/** @private */
	public static inline var KEY_PERMISSIONS:String = "pm";
	
	/** @private */
	public static inline var KEY_EVENTS:String = "ev";
	
	/** @private */
	public static inline var KEY_EXTID:String = "xn";
	
	/** @private */
	public static inline var KEY_EXTCLASS:String = "xc";
	
	/** @private */
	public static inline var KEY_EXTPROP:String = "xp";
	
	/** @private */
	public static inline var KEY_AUTOJOIN:String = "aj";
	
	/** @private */
	public static inline var KEY_ROOM_TO_LEAVE:String = "rl";
		
	//--- MMORoom Params --------------------------------------------------------
		
	/** @private */
	public static inline var KEY_MMO_DEFAULT_AOI:String="maoi";
	
	/** @private */
	public static inline var KEY_MMO_MAP_LOW_LIMIT:String="mllm";
	
	/** @private */
	public static inline var KEY_MMO_MAP_HIGH_LIMIT:String="mlhm";
	
	/** @private */
	public static inline var KEY_MMO_USER_MAX_LIMBO_SECONDS:String="muls";
	
	/** @private */
	public static inline var KEY_MMO_PROXIMITY_UPDATE_MILLIS:String="mpum";
		
	/** @private */
	public static inline var KEY_MMO_SEND_ENTRY_POINT:String="msep";
	
	/** @private */
	private var _settings:RoomSettings;
	
	/** @private */
	private var _autoJoin:Bool;
	
	/** @private */
	private var _roomToLeave:Room;
	
	/**
	 * Creates a new<em>CreateRoomRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	settings	An object containing the Room configuration settings.
	 * @param	autoJoin	If<code>true</code>, the Room is joined as soon as it is created.
	 * @param	roomToLeave	A<em>Room</em>object representing the Room that should be left if the new Room is auto-joined.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		RoomSettings
	 * @see		com.smartfoxserver.v2.requests.game.SFSGameSettings SFSGameSettings
	 * @see		com.smartfoxserver.v2.requests.mmo.MMORoomSettings MMORoomSettings
	 * @see		com.smartfoxserver.v2.entities.Room Room
	 */
	public function new(settings:RoomSettings, autoJoin:Bool=false, roomToLeave:Room=null)
	{
		super(BaseRequest.CreateRoom);
		
		_settings = settings;
		_autoJoin = autoJoin;
		_roomToLeave = roomToLeave	;
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putUtfString(KEY_NAME, _settings.name);
		_sfso.putUtfString(KEY_GROUP_ID, _settings.groupId);
		_sfso.putUtfString(KEY_PASSWORD, _settings.password);
		_sfso.putBool(KEY_ISGAME, _settings.isGame);
		_sfso.putShort(KEY_MAXUSERS, _settings.maxUsers);
		_sfso.putShort(KEY_MAXSPECTATORS, _settings.maxSpectators);
		_sfso.putShort(KEY_MAXVARS, _settings.maxVariables);
		
		// Handle Room Variables
		if(_settings.variables !=null && _settings.variables.length>0)
		{
			var roomVars:ISFSArray = SFSArray.newInstance();
			
			for(item in _settings.variables)
			{
				// Skip unknow elements
				if(Std.isOfType(item, RoomVariable))
				{
					var rVar:RoomVariable = cast(item, RoomVariable);
					roomVars.addSFSArray(rVar.toSFSArray());
				}
			}
			
			_sfso.putSFSArray(KEY_ROOMVARS, roomVars);	
		}
		
		// Handle Permissions	
		if(_settings.permissions !=null)
		{
			var sfsPermissions:Array<Bool> = [];
			sfsPermissions.push(_settings.permissions.allowNameChange);
			sfsPermissions.push(_settings.permissions.allowPasswordStateChange);
			sfsPermissions.push(_settings.permissions.allowPublicMessages);
			sfsPermissions.push(_settings.permissions.allowResizing);
			
			_sfso.putBoolArray(KEY_PERMISSIONS, sfsPermissions);
		}
			
		// Handle Events
		if(_settings.events !=null)
		{
			var sfsEvents:Array<Bool> = [];
			sfsEvents.push(_settings.events.allowUserEnter);
			sfsEvents.push(_settings.events.allowUserExit);
			sfsEvents.push(_settings.events.allowUserCountChange);
			sfsEvents.push(_settings.events.allowUserVariablesUpdate);
			
			_sfso.putBoolArray(KEY_EVENTS, sfsEvents);
		}
		
		// Handle Extension data
		if(_settings.extension !=null)
		{
			_sfso.putUtfString(KEY_EXTID, _settings.extension.id);
			_sfso.putUtfString(KEY_EXTCLASS, _settings.extension.className);
			
			// Send the properties file only if was specified
			if(_settings.extension.propertiesFile !=null && _settings.extension.propertiesFile.length>0)
				_sfso.putUtfString(KEY_EXTPROP, _settings.extension.propertiesFile);
		}
		
		//--- MMORooms ------------------------------------------------------------------------
		if(Std.isOfType(_settings, MMORoomSettings))
		{
			var mmoSettings:MMORoomSettings=cast(_settings, MMORoomSettings);
			var useFloats:Bool=mmoSettings.defaultAOI.isFloat();
			
			if(useFloats)
			{
				_sfso.putFloatArray(KEY_MMO_DEFAULT_AOI, mmoSettings.defaultAOI.toArray());
				
				if(mmoSettings.mapLimits !=null)
				{
					_sfso.putFloatArray(KEY_MMO_MAP_LOW_LIMIT, mmoSettings.mapLimits.lowerLimit.toArray());
					_sfso.putFloatArray(KEY_MMO_MAP_HIGH_LIMIT, mmoSettings.mapLimits.higherLimit.toArray());
				}
			}
			else
			{
				_sfso.putIntArray(KEY_MMO_DEFAULT_AOI, mmoSettings.defaultAOI.toIntArray());
				
				if(mmoSettings.mapLimits !=null)
				{
					_sfso.putIntArray(KEY_MMO_MAP_LOW_LIMIT, mmoSettings.mapLimits.lowerLimit.toIntArray());
					_sfso.putIntArray(KEY_MMO_MAP_HIGH_LIMIT, mmoSettings.mapLimits.higherLimit.toIntArray());
				}
			}
			
			_sfso.putShort(KEY_MMO_USER_MAX_LIMBO_SECONDS, mmoSettings.userMaxLimboSeconds);
			_sfso.putShort(KEY_MMO_PROXIMITY_UPDATE_MILLIS, mmoSettings.proximityListUpdateMillis);
			_sfso.putBool(KEY_MMO_SEND_ENTRY_POINT, mmoSettings.sendAOIEntryPoint);
		}
		
		// AutoJoin
		_sfso.putBool(KEY_AUTOJOIN, _autoJoin);
		
		// Room to leave
		if(_roomToLeave !=null)
			_sfso.putInt(KEY_ROOM_TO_LEAVE, _roomToLeave.id);
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<String> = [];
		
		if(_settings.name==null || _settings.name.length==0)
			errors.push("Missing room name");
			
		if(_settings.maxUsers<=0)
			errors.push("maxUsers must be>0");
		
		if(_settings.extension !=null)
		{
			if(_settings.extension.className==null || _settings.extension.className.length==0)
				errors.push("Missing Extension class name");
				
			if(_settings.extension.id==null || _settings.extension.id.length==0)
				errors.push("Missing Extension id");
		}
		
		if(Std.isOfType(_settings, MMORoomSettings))
		{
			var mmoSettings:MMORoomSettings=cast(_settings, MMORoomSettings);
			
			if(mmoSettings.defaultAOI==null)
				errors.push("Missing default AoI(Area of Interest)");
			
			if(mmoSettings.mapLimits !=null &&(mmoSettings.mapLimits.lowerLimit==null || mmoSettings.mapLimits.higherLimit==null))
				errors.push("Map limits must be both defined");
		}
		
		if(errors.length>0)
			throw new SFSValidationError("CreateRoom request error", errors);	
	}
}