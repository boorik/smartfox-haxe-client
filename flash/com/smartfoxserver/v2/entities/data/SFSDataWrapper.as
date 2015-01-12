package com.smartfoxserver.v2.entities.data
{
	/**
	 * @private
	 * 
	 * A wrapper object used by SFSObject and SFSArray to encapsulate data and relative types.
	 */
	public class SFSDataWrapper
	{
		private var _type:int
		private var _data:*
		
		public function SFSDataWrapper(type:int, data:*)
		{
			this._type = type
			this._data = data
		}
		
		public function get type():int
		{
			return _type
		} 
		
		public function get data():*
		{
			return _data
		}
	}
}