package com.smartfoxserver.v2.entities
{
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.variables.BuddyVariable;
	import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
	import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
	import com.smartfoxserver.v2.util.ArrayUtil;
	
	/**
	 * The <em>SFSBuddy</em> object represents a buddy in the current user's buddies list.
	 * 
	 * <p>A buddy is marked out by the following characteristics.</p>
	 * <ul>
	 * 	<li><b>Nickname</b>: a buddy can have an optional nickname, which differs from the username used during the login process.</li>
	 * 	<li><b>Online/offline state</b>: users can be online or offline as buddies in the Buddy List system. By default a buddy is online every time he joins a Zone,
	 * 	but the user can also switch the state to offline at runtime, and disappear from other user's buddies list. This state is persistent and it is based on a reserved Buddy Variable.</li>
	 * 	<li><b>Custom state</b>: each user can have a typical IM state such as "Available", "Away", "Occupied", etc. State can be selected among the custom ones defined in the Zone configuration,
	 * 	which can be changed or enriched at any time. This state is persistent and it is based on a reserved Buddy Variable.</li>
	 * 	<li><b>Blocked buddy</b>: buddies that are blocked in a user's buddies list won't be able to send messages to that user; also they won't be able to see if the user is online or offline in the Buddy List system.</li>
	 * 	<li><b>Temporary buddy</b>: a temporary buddy is added to the current user's buddies list whenever another user adds him to his own buddies list. 
	 * 	In this way users can "see" each other and exchange messages. If the current user doesn't add that temporary buddy to his buddies list voluntarily, that buddy won't be persisted and will be lost upon disconnection.</li>
	 * 	<li><b>Variables</b>: Buddy Variables enable each user to show (and send updates on) specific custom informations to each user to whom he is a buddy. 
	 * 	For example one could send realtime updates on his last activity, or post the title of the song he's listening right now, or scores, rankings and whatnot.</li>
	 * </ul>
	 * 
	 * @see 	com.smartfoxserver.v2.SmartFox#buddyManager SmartFox.buddyManager
	 * @see 	com.smartfoxserver.v2.entities.variables.BuddyVariable BuddyVariable
	 */
	public class SFSBuddy implements Buddy
	{
		/** @private */
		protected var _name:String
		
		/** @private */
		protected var _id:int
		
		/** @private */
		protected var _isBlocked:Boolean
		
		/** @private */
		protected var _variables:Object
		
		/** @private */
		protected var _isTemp:Boolean
		
		/** @private */
		public static function fromSFSArray(arr:ISFSArray):Buddy
		{
			var buddy:Buddy = new SFSBuddy
			(
				arr.getInt(0), 									// id
				arr.getUtfString(1), 							// name
				arr.getBool(2),									// blocked
				arr.size() > 3 ? arr.getBool(4) : false			// isTemp is optional, we have to check
			)
			
			var bVarsData:ISFSArray = arr.getSFSArray(3) // variables data array
			
			for (var j:int = 0; j < bVarsData.size(); j++)
			{
				buddy.setVariable( SFSBuddyVariable.fromSFSArray(bVarsData.getSFSArray(j)) )
			}
			
			return buddy
		}
		
		/**
		 * Creates a new <em>SFSBuddy</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never istantiate a <em>SFSBuddy</em> manually: this is done by the SmartFoxServer 2X API internally.</p>
		 *  
		 * @param 	id			The buddy id.
		 * @param 	name		The buddy name.
		 * @param 	isBlocked	If <code>true</code>, the buddy being created is blocked by the current user.
		 * @param 	isTemp		If <code>true</code>, the buddy being created is temporary in the current client.
		 */
		public function SFSBuddy(id:int, name:String, isBlocked:Boolean = false, isTemp:Boolean = false)
		{
			_id = id
			_name = name
			_isBlocked = isBlocked
			_variables = {}
			_isTemp = isTemp
		}
		
		/** @inheritDoc */
		public function get id():int
		{
			return _id
		}
		
		/** @inheritDoc */
		public function get name():String
		{
			return _name
		}
		
		/** @inheritDoc */
		public function get isBlocked():Boolean
		{
			return _isBlocked
		}
		
		/** @inheritDoc */
		public function get isTemp():Boolean
		{
			return _isTemp
		}
		
		/** @inheritDoc */
		public function get isOnline():Boolean
		{
			var bv:BuddyVariable = getVariable(ReservedBuddyVariables.BV_ONLINE)
			
			// An non-inited ONLINE state == online
			var onlineStateVar:Boolean = bv == null ? true : bv.getBoolValue();
			
			/* The buddy is considered ONLINE if 
			* 	1. he is connectected in the system
			*	2. his online variable is set to true
			*/			
			return onlineStateVar && _id > -1		
		}
		
		/** @inheritDoc */
		public function get state():String
		{
			/*
			* TOOD: what if state was not inited yet?
			* Do we return null or a default state?
			*/
			var bv:BuddyVariable = getVariable(ReservedBuddyVariables.BV_STATE)
			return bv == null ? null : bv.getStringValue()
		}
	
		/** @inheritDoc */		
		public function get nickName():String
		{
			var bv:BuddyVariable = getVariable(ReservedBuddyVariables.BV_NICKNAME)
			return bv == null ? null : bv.getStringValue()
		}
		
		/** @inheritDoc */
		public function get variables():Array
		{
			return ArrayUtil.objToArray(_variables)
		}
		
		/** @inheritDoc */
		public function getVariable(varName:String):BuddyVariable
		{
			return _variables[varName]
		}
		
		/** @inheritDoc */
		public function getOfflineVariables():Array
		{
			var offlineVars:Array = []
			
			for each (var item:BuddyVariable in _variables)
			{
				if (item.name.charAt(0) == SFSBuddyVariable.OFFLINE_PREFIX)
					offlineVars.push(item)
			}
			
			return offlineVars
		}
		
		/** @inheritDoc */
		public function getOnlineVariables():Array
		{
			var onlineVars:Array = []
			
			for each (var item:BuddyVariable in _variables)
			{
				if (item.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
					onlineVars.push(item)
			}
			
			return onlineVars
		}
		
		/** @inheritDoc */
		public function containsVariable(varName:String):Boolean
		{
			return _variables[varName]  != null
		}
		
		/** @private */
		public function setVariable(bVar:BuddyVariable):void
		{
			_variables[bVar.name] = bVar			
		}
		
		/*
		* Overwrite all current variables
		*/
		
		/** @private */
		public function setVariables(variables:Array):void
		{
			for each (var bVar:BuddyVariable in variables)
			{
				setVariable(bVar)
			}
		}
		
		/** @private */
		public function setId(id:int):void
		{
			_id = id
		}
		
		/** @private */
		public function setBlocked(value:Boolean):void
		{
			_isBlocked = value	
		}
		
		/** @private */
		public function removeVariable(varName:String):void
		{
			delete _variables[varName]
		}
		
		/** @private */
		public function clearVolatileVariables():void
		{
			for each (var bVar:BuddyVariable in variables)
			{
				if (bVar.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
					removeVariable(bVar.name)
			}
		}
		
		/**
		 * Returns a string that contains the buddy name and id.
		 * 
		 * @return	The string representation of the <em>SFSBuddy</em> object.
		 */
		public function toString():String
		{
			return "[Buddy: " + name + ", id: " + id + "]"
		}
	}
}