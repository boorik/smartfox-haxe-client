package com.smartfoxserver.v2.util;

import com.smartfoxserver.v2.core.SFSEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

/**
 * @private
 */
class ConfigLoader extends EventDispatcher
{
	/*
	* By default loads a file called sfs-config.xml located in the same
	* folder of the application
	*/
	public function loadConfig(filePath:String):Void
	{	
		var loader:URLLoader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, onConfigLoadSuccess);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onConfigLoadFailure);
		
		loader.load(new URLRequest(filePath));
	}
	
	private function onConfigLoadSuccess(evt:Event):Void
	{
		var loader:URLLoader = cast evt.target;
		var xmlDoc:Xml = Xml.parse(loader.data);
		var fastDoc:haxe.xml.Fast = new haxe.xml.Fast(xmlDoc);
		var cfgData:ConfigData = new ConfigData();
		
		cfgData.host = fastDoc.att.ip;
		cfgData.port = Std.parseInt(fastDoc.att.port);
		cfgData.udpHost = fastDoc.att.udpIp;
		cfgData.udpPort = Std.parseInt(fastDoc.att.udpPort);
		cfgData.zone = fastDoc.att.zone;
			
		if(fastDoc.att.debug != null)
			cfgData.debug = fastDoc.att.debug.toLowerCase() == "true" ? true:false;
			
		if(fastDoc.att.useBlueBox != null)
			cfgData.useBlueBox = fastDoc.att.useBlueBox.toLowerCase() == "true" ? true:false;
						
		if(fastDoc.att.httpPort != null)
			cfgData.httpPort = Std.parseInt(fastDoc.att.httpPort);
		
		if ( fastDoc.att.httpsPort != undefined )
				cfgData.httpsPort = int( fastDoc.att.httpsPort )	
			
		if(fastDoc.att.blueBoxPollingRate != null)
			cfgData.blueBoxPollingRate = Std.parseInt(fastDoc.att.blueBoxPollingRate);
			
		// Fire event
		var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS, { cfg:cfgData } );
		dispatchEvent(sfsEvt);
		
	}
	
	private function onConfigLoadFailure(evt:IOErrorEvent):Void
	{
		var params:Dynamic = { message:evt.text };
		var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE, params);
		
		dispatchEvent(sfsEvt);
	}
}