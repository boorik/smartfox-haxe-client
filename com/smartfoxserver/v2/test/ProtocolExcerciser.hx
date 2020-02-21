package com.smartfoxserver.v2.test;

import com.smartfoxserver.v2.core.SFSIOHandler;

import com.smartfoxserver.v2.util.ByteArray<Dynamic>;

class ProtocolExcerciser
{
	private var ioHandler:SFSIOHandler;
	private var codec:TestProtocolCodec;
	
	private var testPacketData:Array<Dynamic>=
	[
		0x80, 0x00, 0x4D, 0x12, 0x00, 0x03, 0x00, 0x01, 0x61, 0x03, 0x00, 0x00, 0x00, 0x01, 0x63, 0x02,
		0x00, 0x00, 0x01, 0x70, 0x12, 0x00, 0x03, 0x00, 0x02, 0x74, 0x6B, 0x08, 0x00, 0x20, 0x32, 0x66,
		0x32, 0x33, 0x30, 0x38, 0x64, 0x31, 0x36, 0x65, 0x61, 0x62, 0x66, 0x62, 0x36, 0x34, 0x65, 0x32,
		0x34, 0x62, 0x31, 0x66, 0x62, 0x65, 0x34, 0x31, 0x65, 0x39, 0x37, 0x61, 0x36, 0x63, 0x00, 0x02,
		0x63, 0x74, 0x04, 0x00, 0x00, 0x04, 0x00, 0x00, 0x02, 0x6D, 0x73, 0x04, 0x00, 0x1E, 0x84, 0x80,
	];
	private var testPacket:ByteArray<Dynamic>;
	
	public function new()
	{
		codec=new TestProtocolCodec();
		
		ioHandler=new SFSIOHandler(null);
		ioHandler.codec=codec;
			
		generateTestPacket();
		codec.setVerificationPacket(testPacket);
		
		trace("--- READY TO START ----");
	}
	
	private function generateTestPacket():Void
	{
		testPacket=new ByteArray();
		testPacket.endian = Endian.BIG_ENDIAN;
		for(i in 0...testPacketData.length)
		{
			testPacket.writeByte(testPacketData[i])	
		}
	}
	
	public function runExercises():Void
	{
		fragmentedHeaderTest1();
		fragmentedHeaderTest2();
		fragmentedHeaderTest3();
		fragmentedHeaderTest4();
		fragmentedHeaderTest5();
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Protocol Exercises
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	/*
		1 byte only
		all the rest
	*/
	public function fragmentedHeaderTest1():Void
	{
		ioHandler.onDataRead(getBufferSlice(0,1));
		ioHandler.onDataRead(getBufferSlice(1));
	}
	
	/*
		header byte + 1st byte of size short
		all the rest
	*/
	public function fragmentedHeaderTest2():Void
	{
		ioHandler.onDataRead(getBufferSlice(0,2));
		ioHandler.onDataRead(getBufferSlice(2));
	}
	
	/*
		header byte
		1st byte of size
		all the rest
	*/
	public function fragmentedHeaderTest3():Void
	{
		ioHandler.onDataRead(getBufferSlice(0,1));
		ioHandler.onDataRead(getBufferSlice(1,1));
		ioHandler.onDataRead(getBufferSlice(2));
	}
	
	/*
	header byte + 1st byte of size
	2nd byte of size + 1st data byte
	all the rest
	*/
	public function fragmentedHeaderTest4():Void
	{
		ioHandler.onDataRead(getBufferSlice(0,2));
		ioHandler.onDataRead(getBufferSlice(2,2));
		ioHandler.onDataRead(getBufferSlice(4));
	}
	
	/*
	header byte + size bytes + 2 data bytes
	all the rest
	*/
	public function fragmentedHeaderTest5():Void
	{
		ioHandler.onDataRead(getBufferSlice(0,5));
		ioHandler.onDataRead(getBufferSlice(5));
	}
	
	/*
	1 full packet + header byte of next packet
	all the rest
	*/
	public function fragmentedHeaderTest6():Void
	{
		var bb:ByteArray<Dynamic>=getBufferSlice(0);
		bb.writeBytes(testPacket, 0, 1);
		ioHandler.onDataRead(bb);
		ioHandler.onDataRead(getBufferSlice(1));
	}
	
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Helper methods
	//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	private function getBufferSlice(start:Int, len:Int=-1):ByteArray
	{
		if(len<0)
			len=testPacket.length - start;
		
		var ba:ByteArray = new ByteArray();
		ba.endian = Endian.BIG_ENDIAN;
		ba.writeBytes(testPacket, start, len);
		
		return ba;
	}
	
}