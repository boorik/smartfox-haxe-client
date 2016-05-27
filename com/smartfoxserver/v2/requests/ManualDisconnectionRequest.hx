package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;

/**
 * @private
 * 
 * This is used by the system. Never send this directly.
 */
class ManualDisconnectionRequest extends BaseRequest
{
	public function new()
	{
		super(BaseRequest.ManualDisconnection);
	}
	
	/** @private */
	override public function validate(sfs:SmartFox):Void
	{
		// Nothing to validate
	}
	
	/** @private */
	override public function execute(sfs:SmartFox):Void
	{
		// No data needed
	}
}