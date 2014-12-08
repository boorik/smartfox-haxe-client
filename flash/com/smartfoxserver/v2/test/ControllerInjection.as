package com.smartfoxserver.v2.test
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.kernel;

	public class ControllerInjection
	{
		var sfs:SmartFox
		
		public function ControllerInjection()
		{
			sfs = new SmartFox()
			//sfs.kernel::socketEngine.addCustomController(4, new GridController())
		}
	}
}