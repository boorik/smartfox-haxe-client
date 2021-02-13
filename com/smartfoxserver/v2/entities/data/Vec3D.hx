package com.smartfoxserver.v2.entities.data;

/**
 * The<em>Vec3D</em>object represents a position in a 2D or 3D space.
 * This class is used to express a position inside a virtual environment with no specific unit of measure(could be pixels, feet, meters, etc).
 * 
 *<p>Positions along the X,Y,Z axes can be expressed as Integers or Floats. Due to the fact that ActionScript 3 doesn't make a clear distinction between these types, while SmartFoxServer 2X does,
 * it is necessary to declare what type will be used by means of the<em>useFloatCoordinates</em>static field.<br>Long and Doubles are not supported on the server side.</p>
 */
class Vec3D
{
	private var _px:Float;
	private var _py:Float;
	private var _pz:Float;
	
	/** @private */
	public static function fromArray(arr:Array<Float>):Vec3D
	{
		return new Vec3D(arr[0], arr[1], arr[2]);
	}
	
	/**
	 * Forces the API to send all Vec3D instances as floating point coordinates.
	 * This should be set in the application before the first MMORoom is created or joined.
	 */
	public static var useFloatCoordinates:Bool=false;
	
	/**
	 * Creates a new<em>Vec3D</em>instance.
	 * The position along the Z axis is optional for 2D environments.
	 * 
	 * @param px	The position along the X axis.
	 * @param py	The position along the Y axis.
	 * @param pz	The position along the Z axis(optional).
	 */
	public function new(px:Float, py:Float, pz:Float=0)
	{
		_px=px;
		_py=py;
		_pz=pz;
	}
	
	/** @private */
	public function toString():String 
	{
		return "(" + _px + ", " + _py + ", " + _pz + ")";
	}
	
	/**
	 * Returns the position along the X axis.
	 */
	public var px(get, null):Float;
 	private function get_px():Float
	{
		return _px;
	}
	
	/**
	 * Returns the position along the Y axis.
	 */
	public var py(get, null):Float;
 	private function get_py():Float
	{
		return _py;
	}
	
	/**
	 * Returns the position along the Z axis.
	 */
	public var pz(get, null):Float;
 	private function get_pz():Float
	{
		return _pz;
	}
	
	/* REMOVED STARTING FROM VERSION 1.2.1 - See next method
	 * Indicates whether the position is expressed using floating point values or not.
	 * 
	 * @return<code>true</code>if the position is expressed using floating point values.
	 *
	public function isFloat():Bool
	{
		return !(_px===Std.int(_px)&& _py===Std.int(_py)&& _pz===Std.int(_pz))
	}
	*/
	
	/** @private */
	public function isFloat():Bool
	{
		return useFloatCoordinates;
	}
	
	/** @private */
	public function toIntArray():Array<Int>
	{
		return [Std.int(_px), Std.int(_py), Std.int(_pz)];
	}
	public function toArray():Array<Float>
	{
		return [_px, _py, _pz];
	}
}