SmartFoxServer 2X Haxe Client API (Very Experimental)
=======================

**Decompress doesn't work but the problem will be solved as soon as possible.**

OpenFL Platforms
----------------------------------
|Platform|Support|
|--|--|
|HTML5|WS/WSS|
|Flash|TCP Socket/WS/WSS/BlueBox|
|Adobe AIR|TCP Socket/WS/BlueBox|
|Windows|TCP Socket/WS/WSS/BlueBox|
|Linux|Untested|
|Mac OS|Untested|
|Android|Untested|
|iOS|Untested|

Haxe Platforms
----------------------------------
|Platform|Support|
|--|--|
|Python|TCP Socket/WS/WSS|
|Neko|TCP Socket/WS/WSS|
|HashLink|TCP Socket/WS/WSS|
|CPP|TCP Socket/WS/WSS|
|Lua|Untested|
|C#|Untested|
|Java|Untested|
|PHP|FAIL (no thread support!)|

Pull requests are welcome

Let me know how it works on other targets.

Pure Haxe translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/


Warning:
----------------------------------

**BlueBox is not optimized for multi threading, not recommended to use.**

**UDP Socket Support Dropped!** (If you need udp socket feature, please open issue.)


Currently Working With:
----------------------------------

haxe: 4.0.5

haxe-crypto: 0.0.7

haxe-ws: 1.0.5

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
Then you can use it like the as3 api, check the as3 exemples there:
http://docs2x.smartfoxserver.com/ExamplesFlash/introduction

TODO:
====
* test app
* improve typing

Special Thanks
====
[Originally created by **Vincent Blanchet**](https://github.com/boorik/smartfox-haxe-client)
