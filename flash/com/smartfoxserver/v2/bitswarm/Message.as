package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	
	/** @private */
	public class Message implements IMessage
	{
		private var _id:int
		private var _content:ISFSObject
		private var _targetController:int
		private var _isEncrypted:Boolean
		private var _isUDP:Boolean
		private var _packetId:Number = NaN
			
		public function Message()
		{
			_isEncrypted = false
			_isUDP = false
		}
		
		public function get id():int
		{
			return _id
		}
		public function set id(value:int):void
		{
			this._id = value
		}
		
		public function get content():ISFSObject
		{
			return _content
		}
		
		public function set content(obj:ISFSObject):void
		{
			this._content = obj	
		}
		
		public function get targetController():int
		{
			return _targetController
		}
		public function set targetController(value:int):void
		{
			this._targetController = value	
		}
		
		public function get isEncrypted():Boolean
		{
			return _isEncrypted
		}
		public function set isEncrypted(value:Boolean):void
		{
			_isEncrypted = value
		}
		
		public function get isUDP():Boolean
		{
			return _isUDP
		}
		
		public function set isUDP(value:Boolean):void
		{
			_isUDP = value;
		}
		
		public function get packetId():Number
		{
			return _packetId
		}
		
		public function set packetId(value:Number):void
		{
			_packetId = value	
		}

		public function toString():String
		{
			var str:String = "{ Message id: " + _id + " }\n";
			str += "{ Dump: }\n"
			str += _content.getDump()
			
			return str
		}
	}
}