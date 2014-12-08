package com.smartfoxserver.v2.requests
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.bitswarm.IMessage;
	
	/** @private */
	public interface IRequest
	{
		function validate(sfs:SmartFox):void
		function execute(sfs:SmartFox):void
		
		function get targetController():int
		function set targetController(target:int):void
		
		function get isEncrypted():Boolean
		function set isEncrypted(flag:Boolean):void
		
		function getMessage():IMessage
	}
}