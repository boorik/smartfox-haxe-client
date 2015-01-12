package com.smartfoxserver.v2.entities.managers
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.Buddy;
	import com.smartfoxserver.v2.entities.variables.BuddyVariable;
	import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
	import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
	import com.smartfoxserver.v2.util.ArrayUtil;
	
	/**
	 * The <em>SFSBuddyManager</em> class is the entity in charge of managing the current user's <b>Buddy List</b> system.
	 * It keeps track of all the user's buddies, their state and their Buddy Variables.
	 * It also provides utility methods to set the user's properties when he is part of the buddies list of other users.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#buddyManager SmartFox.buddyManager
	 */
	public class SFSBuddyManager implements IBuddyManager
	{
		/** @private */
		protected var _buddiesByName:Object
		
		/** @private */
		protected var _myVariables:Object
		
		/** @private */
		protected var _myOnlineState:Boolean
		
		/** @private 
		protected var _myNickName:String
		protected var _myState:String
		*/
		
		/** @private */
		protected var _inited:Boolean
		
		private var _buddyStates:Array
		private var _sfs:SmartFox
		
		/**
		 * Creates a new <em>SFSBuddyManager</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never instantiate a <em>SFSBuddyManager</em> manually: this is done by the SmartFoxServer 2X API internally.
		 * A reference to the existing instance can be retrieved using the <em>SmartFox.buddyManager</em> property.</p>
		 *  
		 * @param 	sfs		An instance of the SmartFoxServer 2X client API main <em>SmartFox</em> class.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#buddyManager SmartFox.buddyManager
		 */
		public function SFSBuddyManager(sfs:SmartFox)
		{
			_sfs = sfs
			_buddiesByName = {}
			_myVariables = {}
			_inited = false	
		}
		
		/** @inheritDoc */ 
		public function get isInited():Boolean
		{
			return _inited
		}
		
		/** @private */
		public function setInited(flag:Boolean):void
		{
			_inited = flag;
		}
		
		/** @private */
		public function addBuddy(buddy:Buddy):void
		{
			_buddiesByName[buddy.name] = buddy	
		}
		
		/** @private */
		public function clearAll():void
		{
			_buddiesByName = {}
		}
		
		/** @private */
		public function removeBuddyById(id:int):Buddy
		{
			var buddy:Buddy = getBuddyById(id)
			
			if (buddy != null)
				delete _buddiesByName[buddy.name]	
			
			return buddy
		}
		
		/** @private */
		public function removeBuddyByName(name:String):Buddy
		{
			var buddy:Buddy = getBuddyByName(name)
			
			if (buddy != null)
				delete _buddiesByName[name]	
				
			return buddy
		}
		
		/** @inheritDoc */
		public function getBuddyById(id:int):Buddy
		{
			if (id > -1)
			{			
				for each(var buddy:Buddy in _buddiesByName)
				{
					if (buddy.id == id)
						return buddy
				}
			}
			
			return null
		}
		
		/** @inheritDoc */
		public function containsBuddy(name:String):Boolean
		{
			return getBuddyByName(name) != null
		}
		
		/** @inheritDoc */
		public function getBuddyByName(name:String):Buddy
		{
			return _buddiesByName[name]
		}
		
		/** @inheritDoc */
		public function getBuddyByNickName(nickName:String):Buddy
		{
			for each(var buddy:Buddy in _buddiesByName)
			{
				if (buddy.nickName == nickName)
					return buddy
			}
			
			return null
		}
		
		/** @inheritDoc */
		public function get offlineBuddies():Array
		{
			var buddies:Array = []
			
			for each(var buddy:Buddy in _buddiesByName)
			{
				if (!buddy.isOnline)
					buddies.push(buddy)
			}
			
			return buddies
		}
		
		/** @inheritDoc */
		public function get onlineBuddies():Array
		{
			var buddies:Array = []
			
			for each(var buddy:Buddy in _buddiesByName)
			{
				if (buddy.isOnline)
					buddies.push(buddy)
			}
			
			return buddies
		}
		
		/** @inheritDoc */
		public function get buddyList():Array
		{
			return ArrayUtil.objToArray(_buddiesByName)
		}
		
		/** @inheritDoc */
		public function getMyVariable(varName:String):BuddyVariable
		{
			return _myVariables[varName] as BuddyVariable
		}
		
		/** @inheritDoc */
		public function get myVariables():Array
		{
			return ArrayUtil.objToArray(_myVariables)	
		}
		
		/** @inheritDoc */
		public function get myOnlineState():Boolean
		{
			// Manager not inited, we're offline
			if (!_inited)
				return false
		
			// If the online var is not defined we take it as online=true (default)
			var onlineState:Boolean = true
			var onlineVar:BuddyVariable = getMyVariable(ReservedBuddyVariables.BV_ONLINE)
			
			if (onlineVar != null)
				onlineState = onlineVar.getBoolValue()
			
			return onlineState	
		}
		
		/** @inheritDoc */
		public function get myNickName():String
		{
			var nickNameVar:BuddyVariable = getMyVariable(ReservedBuddyVariables.BV_NICKNAME)
			return (nickNameVar != null) ? nickNameVar.getStringValue() : null 
		}
		
		/** @inheritDoc */
		public function get myState():String
		{
			var stateVar:BuddyVariable = getMyVariable(ReservedBuddyVariables.BV_STATE)
			return (stateVar != null) ? stateVar.getStringValue() : null 
		}
		
		/** @inheritDoc */
		public function get buddyStates():Array
		{
			return _buddyStates
		}
		
		/** @private */
		public function setMyVariable(bVar:BuddyVariable):void
		{
			_myVariables[bVar.name] = bVar
		}
		
		// Replaces all
		/** @private */
		public function setMyVariables(variables:Array):void
		{
			for each (var bVar:BuddyVariable in variables)
			{
				setMyVariable(bVar)
			}
		}
		
		/** @private */
		public function setMyOnlineState(isOnline:Boolean):void
		{
			setMyVariable( new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE, isOnline) )
		}
		
		/** @private */
		public function setMyNickName(nickName:String):void
		{
			setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_NICKNAME, nickName))	
		}
		
		/** @private */
		public function setMyState(state:String):void
		{
			setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_STATE, state))
		}
		
		/** @private */
		public function setBuddyStates(states:Array):void
		{
			_buddyStates = states
		}
	}
}