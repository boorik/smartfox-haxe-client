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
		var loader:URLLoader=new URLLoader()
		loader.addEventListener(Event.COMPLETE, onConfigLoadSuccess)
		loader.addEventListener(IOErrorEvent.IO_ERROR, onConfigLoadFailure)
		
		loader.load(new URLRequest(filePath))
	}
	
	private function onConfigLoadSuccess(evt:Event):Void
	{
		var loader:URLLoader=evt.target as URLLoader
		var xmlDoc:XML=new XML(loader.data)
		var cfgData:ConfigData=new ConfigData()
		
		cfgData.host=xmlDoc.ip
		cfgData.port=Std.int(xmlDoc.port)
		cfgData.udpHost=xmlDoc.udpIp
		cfgData.udpPort=Std.int(xmlDoc.udpPort)
		cfgData.zone=xmlDoc.zone
			
		if(xmlDoc.debug !=undefined)
			cfgData.debug=xmlDoc.debug.toLowerCase()=="true" ? true:false
			
		if(xmlDoc.useBlueBox !=undefined)
			cfgData.useBlueBox=xmlDoc.useBlueBox.toLowerCase()=="true" ? true:false
						
		if(xmlDoc.httpPort !=undefined)
			cfgData.httpPort=Std.int(xmlDoc.httpPort)
		
		if(xmlDoc.blueBoxPollingRate !=undefined)
			cfgData.blueBoxPollingRate=Std.int(xmlDoc.blueBoxPollingRate)
			
		// Fire event
		var sfsEvt:SFSEvent=new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS, {cfg:cfgData})
		dispatchEvent(sfsEvt)
		
	}
	
	private function onConfigLoadFailure(evt:IOErrorEvent):Void
	{
		var params:Dynamic={ message:evt.text }
		var sfsEvt:SFSEvent=new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE, params)
		
		dispatchEvent(sfsEvt)
	}
}