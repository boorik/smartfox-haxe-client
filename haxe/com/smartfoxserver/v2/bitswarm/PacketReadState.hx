package com.smartfoxserver.v2.bitswarm;

/** @private */
class PacketReadState
{
	public static inline var WAIT_NEW_PACKET:Int = 0;
	public static inline var WAIT_DATA_SIZE:Int = 1;
	public static inline var WAIT_DATA_SIZE_FRAGMENT:Int = 2;
	public static inline var WAIT_DATA:Int = 3;
}