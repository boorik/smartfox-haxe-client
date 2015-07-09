package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.IMessage;

/** @private */
interface IRequest
{
	function validate(sfs:SmartFox):Void;
	function execute(sfs:SmartFox):Void;
	
	function get_targetController():Int;
	function set_targetController(target:Int):Void;
	
	function get_isEncrypted():Bool;
	function set_isEncrypted(flag:Bool):Void;
	
	function getMessage():IMessage;
}