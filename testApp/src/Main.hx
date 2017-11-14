package;

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

		var r = new utest.Runner();
		r.addCase(new ConnectionTest());
		utest.ui.Report.create(r);
		r.run();
		
	}
	function onComplete() {
		#if (cpp || neko || php)
		Sys.exit(0);
		#end
	}

}
