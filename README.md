
SmartFoxServer 2X Haxe Client API   
======================= 

**Special Thanks**

[Originally created by **Vincent Blanchet**](https://github.com/boorik/smartfox-haxe-client)    

**WebSocket fully supports on all OpenFL targets!** (Including Flash)    

|Platform|Support|
|--|--|
|HTML5|WS/WSS|
|Flash|WS/WSS/Socket/BlueBox|
|Adobe AIR|WS/Socket/BlueBox|
|Windows|WS/WSS/Socket/BlueBox|
|Linux|Untested|
|Mac OS|Untested|
|Android|Untested|
|iOS|Untested|
|Neko|Untested|
|Emscripten|Untested|
    
Pull requests are welcome    
    
Let me know how it works on other targets

Haxe OpenFL translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/    

CURRENTLY WORKING WITH :  
----------------------------------  

haxe: 4.0.5  
    
lime: 7.6.3   
    
openfl: 8.9.5  
    
haxe-crypto: 0.0.7    
  
colyseus-websocket: 1.0.10  
    
----------------------------------    
    
Instructions:  
=====  
Installation
 
```
haxelib git smartfox-haxe-client https://github.com/barisyild/smartfox-haxe-client.git
```    
add in your project.xml:    
```
<haxelib name="smartfox-haxe-client"/>
```
Then you can use it like the as3 api, check the as3 exemples there :    
http://docs2x.smartfoxserver.com/ExamplesFlash/introduction    
  
TODO:  
====
* test app    
* improve typing