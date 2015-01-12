package com.smartfoxserver.v2.bitswarm
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSConstants;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.kernel;
	import com.smartfoxserver.v2.logging.Logger;
	import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
	
	import flash.errors.IOError;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
		
	/**
	 * The <em>AirUDPManager</em> class allows clients executed in the Adobe AIR runtime to communicate with SmartFoxServer 2X using the UDP protocol.
	 * 
	 * <p>In order to enable a client to send and received UDP data, a UDP channel must be initialized.
	 * This can be done at any moment after having joined a Zone by calling the <em>SmartFox.initUDP()</em> method.
	 * If an application uses UDP sockets, we recommend to initialize the UDP channel as soon as the Zone is joined.</p>
	 * 
	 * <p><b>NOTE</b>: this class is for use with Adobe AIR 2.0 (or higher) runtime; the standalone or browser-embedded Flash Player does not support this feature.</p>
	 * 
	 * @example	The following example initializes the UDP communication and sends a custom UDP request to an Extension:
	 * <listing version="3.0">
	 * 
	 * private function someMethod():void
	 * {
	 * 	sfs.addEventListener(SFSEvent.UDP_INIT, onUDPInit);
	 * 	sfs.initUDP(new AirUDPManager());
	 * }
	 * 
	 * private function onUDPInit(evt:SFSEvent):void
	 * {
	 * 	if (evt.params.success)
	 * 	{
	 * 		// Connection successful: execute an Extension call via UDP
	 * 		sfs.send( new ExtensionRequest("udpTest", new SFSObject(), null, true) );
	 * 	}
	 * 	else
	 * 	{
	 * 		trace("UDP initialization failed!");
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @playerversion AIR 2.0+
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#initUDP SmartFox#initUDP
	 */
	public class AirUDPManager implements IUDPManager
	{
		private var _sfs:SmartFox;
		private var _packetId:Number;
		private var _udpSocket:DatagramSocket;
		private var _inited:Boolean = false;
		private var _log:Logger;
		private var _locked:Boolean = false;
		private var _initSuccess:Boolean = false;
		
		// Init transaction variables
		private const MAX_RETRY:int = 3;				// Retry max 3 times
		private const RESPONSE_TIMEOUT:int = 3000; 		// Wait response for max 3 seconds
		private var _initThread:Timer;
		private var _currentAttempt:int;
		
		/**
		 * Creates a new <em>AirUDPManager</em> instance.
		 * 
		 * @playerversion AIR 2.0+
		 */
		public function AirUDPManager()
		{
			_packetId = 0;
			_currentAttempt = 1
		}
		
		/**
		 * @private
		 */
		public function initialize(udpAddr:String, udpPort:int):void
		{
			if (_initSuccess)
			{
				_log.warn("UDP Channel already initialized!")
				return
			}
			
			if (!_locked)
			{
				// Lock the object
				_locked = true;
				
				_udpSocket = new DatagramSocket();
				_udpSocket.addEventListener(DatagramSocketDataEvent.DATA, onUDPData)
				_udpSocket.addEventListener(IOErrorEvent.IO_ERROR, onUDPError);
				
				_udpSocket.connect(udpAddr, udpPort);
				_udpSocket.receive();
				
				_initThread = new Timer(RESPONSE_TIMEOUT, 1)
				_initThread.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout)
					
				sendInitializationRequest();
			}
			else
				_log.warn("UPD initialization is already in progress!")
		}
		
		/**
		 * @private
		 */
		public function nextUdpPacketId():Number
		{
			return _packetId++;
		}
		
		/**
		 * @private
		 */
		public function send(binaryData:ByteArray):void
		{
			if (_initSuccess)
			{
				try
				{
					_udpSocket.send(binaryData);
					
					if (_sfs.debug)
						_log.info("UDP Data written: " + DefaultObjectDumpFormatter.hexDump(binaryData));
				}
				catch(err:IOError)
				{
					_log.warn("WriteUDP operation failed due to I/O Error: " + err.toString())
				}
			}
			else
				_log.warn("UDP protocol is not initialized yet. Please use the initUDP() method.")
					
		}
		
		/**
		 * @private
		 */
		public function get inited():Boolean
		{
			return _initSuccess;			
		}
		
		/**
		 * @private
		 */
		public function set sfs(sfs:SmartFox):void
		{
			this._sfs = sfs
			_log = sfs.logger
		}
		
		/**
		 * @private
		 */
		public function reset():void
		{
			if (_initThread != null && _initThread.running)
				_initThread.stop()
			
			_currentAttempt = 1
			_inited = false
			_initSuccess = false
			_locked = false
			_packetId  = 0
		}
		
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Event Handlers
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function onUDPData(evt:DatagramSocketDataEvent):void
		{
			var bytes:ByteArray = evt.data as ByteArray
			
			// Not enough data!
			if (bytes.bytesAvailable < 4)
			{
				_log.warn("Too small UDP packet. Len: " + bytes.length)
				return
			}
			
			if (_sfs.debug)
				_log.info("UDP Data Read: " + DefaultObjectDumpFormatter.hexDump(bytes))
			
			// Get the header byte
			var header:int = bytes.readByte();
			
			// Get the compression flag
			var compressed:Boolean = (header & 0x20) > 0;
			
			// Read the size of message (UDP can only use the short version)
			var dataSize:int = bytes.readShort();
			
			if (dataSize != bytes.bytesAvailable)
			{
				_log.warn("Insufficient UDP data. Expected: " + dataSize + ", got: " + bytes.bytesAvailable)
				return
			}
			
			// Grab the message body and deserialize it
			var objBytes:ByteArray = new ByteArray();
			bytes.readBytes(objBytes, 0, bytes.bytesAvailable);
			var reqObj:ISFSObject = SFSObject.newFromBinaryData(objBytes)
	
			// Check if this is an UDP Handshake response. If so, fire event and stop here.
			if (reqObj.containsKey("h"))
			{
				// Unlock
				_initThread.stop()
				_locked = false
				_initSuccess = true
					
				var evtParams:Object = {}
				evtParams.success = true
				_sfs.dispatchEvent( new SFSEvent(SFSEvent.UDP_INIT, evtParams) )
					
				return
			}
			
			// Hand it to the ProtocolCodec
			_sfs.kernel::socketEngine.ioHandler.codec.onPacketRead(reqObj)
		}
		
		private function onUDPError(evt:IOErrorEvent):void
		{
			_log.warn("Unexpected UDP I/O Error. " + evt.text)
		}
		
		private function sendInitializationRequest():void
		{
			// Prepare full packet
			var message:ISFSObject = new SFSObject();
			message.putByte("c", 1); 		
			message.putByte("h", 1); // <<---- Handshake!
			message.putLong("i", nextUdpPacketId());
			message.putInt("u", _sfs.mySelf.id);
			
			var binData:ByteArray = message.toBinary();
			var compress:Boolean = false;
			
			// Assemble SFS2X packet
			var writeBuffer:ByteArray = new ByteArray();
			
			// Regular Header
			writeBuffer.writeByte(0x80);
			
			// Message len
			writeBuffer.writeShort(binData.length);
			
			// Packet data
			writeBuffer.writeBytes(binData);
			
			_udpSocket.send(writeBuffer);
			
			// Start the timeout thread
			_initThread.start()
		}
		
		private function onTimeout(evt:Event):void
		{
			if (_currentAttempt < MAX_RETRY)
			{
				// Try again
				_currentAttempt++
				_log.debug("UDP Init Attempt: " + _currentAttempt)
					
				sendInitializationRequest()
				_initThread.start()
			}
			
			else
			{
				// If we get here all trials failed
				_currentAttempt = 0;
				_locked = false;
				
				var evtParams:Object = new Object();
				evtParams.success = false;
				
				// Fire failure event
				_sfs.dispatchEvent( new SFSEvent(SFSEvent.UDP_INIT, evtParams) )
			}
		}
	}
}