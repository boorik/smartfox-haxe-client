
SmartFoxServer 2X Haxe Client API   
======================= 

Haxe openfl translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/

Tested on flash, windows, ios and android targets.

You can have a look at https://github.com/boorik/smartfox-haxe-fullstack to check a sample project that use the api and haxe all the way.

Pull requests are welcome

Let me know how it works on other targets

Haxe OpenFL translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/    

CURRENTLY WORKING WITH :  
----------------------------------  

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
haxelib git smartfox-haxe-client https://github.com/boorik/smartfox-haxe-client
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
* make it framework agnostic pure haxe without openfl dependency
* make it work with html5 target