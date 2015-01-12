package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;

	/**
	 * @private
	 * 
	 * Sends a ping-pong request in order to measure the current lag.
	 * This is used by the system. Never send this directly.
	 */
	public class PingPongRequest extends BaseRequest
	{
		public function PingPongRequest()
		{
			super(BaseRequest.PingPong)
		}
		
		/** @private */
		override public function execute(sfs:SmartFox):void
		{
			// No params are sent
		}
		
		/** @private */
		override public function validate(sfs:SmartFox):void
		{
			// Maybe check last send time?
		}
	}
}