package com.smartfoxserver.v2.requests.mmo;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.MMORoom;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.requests.GenericMessageType;
import com.smartfoxserver.v2.requests.ObjectMessageRequest;

/** @private */
internal class ProximityObjectMessageRequest extends DynamicMessageRequest
{
	public function ProximityObjectMessageRequest(obj:ISFSObject, targetRoom:Room, aoi:Vec3D)
	{
		super(obj, targetRoom, null);
		_aoi=aoi;
	}
	
	/** @exclude */ 
	override public function validate(sfs:SmartFox):Void
	{
		var errors:Array<Dynamic>=[];
			
		if(_params==null)
			errors.push("Object message is null!");
		
		if(!(Std.isOfType(_room, MMORoom)))
			errors.push("Target Room is not an MMORoom");
		
		if(_aoi==null)
			errors.push("AOI cannot be null");
			
		if(errors.length>0)
			throw new SFSValidationError("Request error - ", errors);
	}
	
	/** @exclude */ 
	override public function execute(sfs:SmartFox):Void
	{
		super.execute(sfs);
		
		_aoi.isFloat()? _sfso.putFloatArray(KEY_AOI, _aoi.toArray()):_sfso.putIntArray(KEY_AOI, _aoi.toArray());
	}
}