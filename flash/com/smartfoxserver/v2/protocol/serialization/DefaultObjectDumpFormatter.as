package com.smartfoxserver.v2.protocol.serialization
{
	import com.smartfoxserver.v2.exceptions.SFSError;
	
	import flash.utils.ByteArray;
	
	/** @private */
	public class DefaultObjectDumpFormatter
	{
		public static const TOKEN_INDENT_OPEN:String = '{' //(char) 0x01;
		public static const TOKEN_INDENT_CLOSE:String = '}' //(char) 0x02;
		public static const TOKEN_DIVIDER:String = ';' //(char) 0x03;
		
		public static const NEW_LINE:String = "\n"
		public static const TAB:String = "\t"
		public static const DOT:String = "."
		
		public static const HEX_BYTES_PER_LINE:int = 16
			
		public static function prettyPrintByteArray(ba:ByteArray):String
		{
			if (ba == null)
				return "Null"
			else
				return "Byte[" + ba.length + "]"
		}
		
		public static function prettyPrintDump(rawDump:String):String
		{
			var strBuf:String = ""
			var indentPos:int = 0
			var lastChar:String = null
			
			for (var i:int = 0; i < rawDump.length; i++)
			{
				var ch:String = rawDump.charAt(i)
				
				if (ch == TOKEN_INDENT_OPEN)
				{
					indentPos++
					strBuf += NEW_LINE + getFormatTabs(indentPos)
				}
				
				else if (ch == TOKEN_INDENT_CLOSE)
				{
					indentPos--
					if (indentPos < 0)
						throw new SFSError("DumpFormatter: the indentPos is negative. TOKENS ARE NOT BALANCED!")
					
					strBuf += NEW_LINE + getFormatTabs(indentPos)
				}
				
				else if (ch == TOKEN_DIVIDER)
				{
					strBuf += NEW_LINE + getFormatTabs(indentPos)
				}
				
				else
				{
					strBuf += ch
				}
				
				//trace("Dump indentpos: " + indentPos)
			}
			
			if (indentPos != 0)
				throw new SFSError("DumpFormatter: the indentPos is not == 0. TOKENS ARE NOT BALANCED!")
					
			return strBuf	
		}
		
		private static function getFormatTabs(howMany:int):String
		{
			return strFill(TAB, howMany)
		}
		
		private static function strFill(ch:String, howMany:int):String
		{
			var strBuf:String = ""
			
			for (var i:int = 0; i < howMany; i++)
			{
				strBuf += ch
			}
			
			return strBuf
		}
		
		
		/*
		* Dumps the ByteArray to a readable hex/chr representation
		*/
		public static function hexDump(ba:ByteArray, bytesPerLine:int = -1):String
		{
			// Check and store current ByteArray position
			var savedByteArrayPosition:int = ba.position
			
			// Set it to 0 before looping
			ba.position = 0
			
			if (bytesPerLine == -1)
				bytesPerLine = HEX_BYTES_PER_LINE
				
			var sb:String = "Binary Size: " + ba.length + NEW_LINE
			var hexLine:String = ""
			var chrLine:String = ""
			
			var index:int = 0
			var count:int = 0
			var currChar:String
			var currByte:int
			
			do
			{
				currByte = ba.readByte() & 0xff

				var hexByte:String = currByte.toString(16).toUpperCase()
				if (hexByte.length == 1)
					hexByte = "0" + hexByte
				
				hexLine += hexByte + " "
				
				if (currByte >= 33 && currByte <= 126)
					currChar = String.fromCharCode(currByte)
				else
					currChar = DOT
				
				chrLine += currChar
				
				if (++count == bytesPerLine)
				{
					count = 0
					sb += hexLine + TAB + chrLine + NEW_LINE
					
					hexLine = ""
					chrLine = "" 
				}
			}
			while(++index < ba.length)
			
			// Add last incomplete line
			if (count != 0)
			{
				for (var j:int = bytesPerLine - count; j > 0; --j)
				{
					hexLine += "   "
					chrLine += " "
				}
				
				sb += hexLine + TAB + chrLine + NEW_LINE
			}
			
			ba.position = savedByteArrayPosition
			
			return sb
		}
	}
}