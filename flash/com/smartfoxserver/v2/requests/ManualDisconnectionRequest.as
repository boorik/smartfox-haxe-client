package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	
	/**
	 * @private
	 * 
	 * This is used by the system. Never send this directly.
	 */
	public class ManualDisconnectionRequest extends BaseRequest
	{
		public function ManualDisconnectionRequest()
		{
			super( BaseRequest.ManualDisconnection )
		}
		
		/** @private */
		override public function validate(sfs:SmartFox):void
		{
			// Nothing to validate
		}
		
		/** @private */
		override public function execute(sfs:SmartFox):void
		{
			// No data needed
		}
	}
}