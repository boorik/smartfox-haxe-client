package com.smartfoxserver.v2.entities.data
{
	/**
	 * The <em>Vec3D</em> object represents a position in a 2D or 3D space.
	 * This class is used to express a position inside a virtual environment with no specific unit of measure (could be pixels, feet, meters, etc).
	 * 
	 * <p>Positions along the X,Y,Z axes can be expressed as Integers or Floats. Due to the fact that ActionScript 3 doesn't make a clear distinction between these types, while SmartFoxServer 2X does,
	 * it is necessary to declare what type will be used by means of the <em>useFloatCoordinates</em> static field.<br>Long and Doubles are not supported on the server side.</p>
	 */
	public class Vec3D
	{
		private var _px:Number;
		private var _py:Number;
		private var _pz:Number;
		
		/** @private */
		public static function fromArray(arr:Array):Vec3D
		{
			return new Vec3D(arr[0], arr[1], arr[2]);
		}
		
		/**
		 * Forces the API to send all Vec3D instances as floating point coordinates.
		 * This should be set in the application before the first MMORoom is created or joined.
		 */
		public static var useFloatCoordinates:Boolean = false;
		
		/**
		 * Creates a new <em>Vec3D</em> instance.
		 * The position along the Z axis is optional for 2D environments.
		 * 
		 * @param px	The position along the X axis.
		 * @param py	The position along the Y axis.
		 * @param pz	The position along the Z axis (optional).
		 */
		public function Vec3D(px:Number, py:Number, pz:Number = 0)
		{
			_px = px;
			_py = py;
			_pz = pz;
		}
		
		/** @private */
		public function toString() : String 
		{
			return "(" + _px + ", " + _py + ", " + _pz + ")";
		}
		
		/**
		 * Returns the position along the X axis.
		 */
		public function get px():Number
		{
			return _px;
		}
		
		/**
		 * Returns the position along the Y axis.
		 */
		public function get py():Number
		{
			return _py;
		}
		
		/**
		 * Returns the position along the Z axis.
		 */
		public function get pz():Number
		{
			return _pz;
		}
		
		/* REMOVED STARTING FROM VERSION 1.2.1 - See next method
		 * Indicates whether the position is expressed using floating point values or not.
		 * 
		 * @return <code>true</code> if the position is expressed using floating point values.
		 *
		public function isFloat():Boolean
		{
			return !(_px === int(_px) && _py === int(_py) && _pz === int(_pz))
		}
		*/
		
		/** @private */
		public function isFloat():Boolean
		{
			return useFloatCoordinates;
		}
		
		/** @private */
		public function toArray():Array
		{
			return [_px, _py, _pz];
		}
	}
}