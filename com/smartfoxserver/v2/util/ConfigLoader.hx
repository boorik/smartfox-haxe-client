package com.smartfoxserver.v2.util;

import haxe.Http;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.events.EventDispatcher;

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
		var httpReq:Http = new Http(filePath);
		//httpReq.cnxTimeout = 30;
		httpReq.onData = function(rawData:String)
		{
			var xmlDoc:Xml = Xml.parse(rawData);
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

			if ( fastDoc.att.httpsPort != null )
				cfgData.httpsPort = Std.parseInt( fastDoc.att.httpsPort );

			if(fastDoc.att.blueBoxPollingRate != null)
				cfgData.blueBoxPollingRate = Std.parseInt(fastDoc.att.blueBoxPollingRate);

			// Fire event
			var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS, { cfg:cfgData } );
			dispatchEvent(sfsEvt);
		}
		httpReq.onError = function(msg:String)
		{
			var params:Dynamic = {message: msg};
			var sfsEvt:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE, params);
			dispatchEvent(sfsEvt);
		};
		httpReq.request();
	}
}