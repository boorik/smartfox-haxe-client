SmartFoxServer 2X Haxe client API  
=======================  
  
  
**Special Thanks**  
[Originally created by **Vincent Blanchet**](https://github.com/boorik/smartfox-haxe-client)  
  
Haxe OpenFL translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/  
  
**WebSocket fully supports on all OpenFL targets!** (Including Flash)  
WebSocket support it seems to be working but I could not test it. (non-html5 target WSS Protocol may be not working.)
  
Tested on flash, windows, ios and android, html5 targets.  
  
Pull requests are welcome  
  
Let me know how it works on other targets  
  
----------------------------------  
CURRENTLY WORKING WITH :  
  
haxe: 4.0.5
  
lime: 7.6.3 
  
openfl: 8.9.5
  
haxe-crypto: 0.0.7  

haxe-ws: 1.0.5
  
----------------------------------  
  
  
Instructions:  
=====  
Installation  
```  
haxelib git smartfox-haxe-client https://github.com/barisyild/smartfox-haxe-client.git  
```  
  
add in your project.xml :  
```  
<haxelib name="smartfox-haxe-client"/>  
```  

Then you can use it like the as3 api, check the as3 exemples there :  
http://docs2x.smartfoxserver.com/ExamplesFlash/introduction  
  
TODO:  
====  
* test app  
* improve typing