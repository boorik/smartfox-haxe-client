package com.smartfoxserver.v2.entities.managers;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.User;

/** @private */
class SFSGlobalUserManager extends SFSUserManager
{
	private var _roomRefCount:Map<User,Int>;
	
	public function new(sfs:SmartFox)
	{
		super(sfs);
		_roomRefCount = new Map<User,Int>();
	}
	
	/*
	* Does not allow duplicates and keeps a reference count
	*/
	override public function addUser(user:User):Void
	{
		// Doesn't exist create and set refCount
		if(!_roomRefCount.exists(user))
		{
			//trace("User duplicate NOT FOUND. Adding as new")
			super._addUser(user);
			_roomRefCount.set(user,1);
		}
		
		else
		{
			//trace("User duplicate FOUND. Incrementing value")
			super._addUser(user);
			var newCount = _roomRefCount.get(user) + 1;
			_roomRefCount.set(user,newCount);	
		}			
	}
	
	override public function removeUser(user:User):Void
	{
		removeUserReference(user, false);
	}
	
	public function removeUserReference(user:User, disconnected:Bool=false):Void
	{
		if(_roomRefCount !=null)
		{
			/* Debug Only */
			if(_roomRefCount.get(user)<1)
			{
				_smartFox.logger.warn("GlobalUserManager RefCount is already at zero. User:" + user);
				return;
			}
			
			var newCount = _roomRefCount.get(user) - 1;
			_roomRefCount.set(user, newCount);
			
			if(_roomRefCount.get(user)==0 || disconnected)
			{
				super.removeUser(user);
				_roomRefCount.remove(user);
			}
		}
		else
			_smartFox.logger.warn("Can't remove User from GlobalUserManager. RefCount missing. User:" + user);
	}
	
	private function dumpRefCount():Void
	{
		//for(var	
	}
}