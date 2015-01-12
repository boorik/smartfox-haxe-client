package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.IMessage;

/** @private */
interface IRequest
{
	function validate(sfs:SmartFox):Void
	function execute(sfs:SmartFox):Void
	
	function get targetController():Int
	function set targetController(target:Int):Void
	
	function get isEncrypted():Bool
	function set isEncrypted(flag:Bool):Void
	
	function getMessage():IMessage
}