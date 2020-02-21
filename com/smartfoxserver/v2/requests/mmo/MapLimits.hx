package com.smartfoxserver.v2.requests.mmo;

import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.errors.ArgumentError;

/**
 * The<em>MapLimits</em>class is used to set the limits of the virtual environment represented by an MMORoom when creating it.
 * The limits represent the minimum and maximum coordinate values(2D or 3D)that the MMORoom should expect.
 * 
 * @see	com.smartfoxserver.v2.requests.mmo.MMORoomSettings MMORoomSettings
 * @see	com.smartfoxserver.v2.entities.MMORoom MMORoom
 * @see	com.smartfoxserver.v2.entities.data.Vec3D Vec3D
 */
class MapLimits
{
	private var _lowerLimit:Vec3D;
	private var _higherLimit:Vec3D;
	
	/**
	 * Creates a new<em>MapLimits</em>instance.
	 * The<em>MMORoomSettings.mapLimits</em>property must be set to this instance during the MMORoom creation.
	 * 
	 * @param lowerLimit 	The lower coordinates limit of the virtual environment along the X,Y,Z axes.
	 * @param higherLimit	The higher coordinates limit of the virtual environment along the X,Y,Z axes.
	 * 
	 * @see		MMORoomSettings.mapLimits
	 */
	public function new(lowerLimit:Vec3D, higherLimit:Vec3D)
	{
		if(lowerLimit==null || higherLimit==null)
			throw new ArgumentError("Map limits arguments must be both non null!");
			
		_lowerLimit=lowerLimit;
		_higherLimit=higherLimit;
	}
	
	/**
	 * Returns the lower coordinates limit of the virtual environment along the X,Y,Z axes.
	 */
	public var lowerLimit(get, null):Vec3D;
 	private function get_lowerLimit():Vec3D
	{
		return _lowerLimit;
	}
	
	/**
	 * Returns the higher coordinates limit of the virtual environment along the X,Y,Z axes.
	 */
	public var higherLimit(get, null):Vec3D;
 	private function get_higherLimit():Vec3D
	{
		return _higherLimit;
	}
}