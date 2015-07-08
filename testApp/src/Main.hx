package;

import com.smartfoxserver.v2.SmartFox;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Vincent Blanchet
 */
class Main extends Sprite 
{

	public function new() 
	{
	
		super();
		
		var sfs = new SmartFox(true);
		sfs.connect("sfs.chapatiz.com", 9933);
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
	}

}
