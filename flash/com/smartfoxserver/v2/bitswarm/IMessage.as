package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	
	/** @private */
	public interface IMessage
	{
		function get id():int
		function set id(value:int):void
		
		function get content():ISFSObject
		function set content(obj:ISFSObject):void
		
		function get targetController():int
		function set targetController(value:int):void
		
		function get isEncrypted():Boolean
		function set isEncrypted(value:Boolean):void
			
		function get isUDP():Boolean
		function set isUDP(value:Boolean):void
			
		function get packetId():Number
		function set packetId(value:Number):void
	}
}