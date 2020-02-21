package com.smartfoxserver.v2.events;
class EventDispatcher {
    private var eventList:Map<String, Array<Dynamic->Void>>;

    public function new():Void {
        eventList = new Map<String, Array<Dynamic->Void>>();
    }

    public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
        //useCapture, priority and useWeakReference not implemented!
        if(listener == null)
            return; //Listener not found!
        if(!eventList.exists(type))
        {
            eventList.set(type, new Array<Dynamic->Void>());
        }

        var callbackList:Array<Dynamic->Void> = cast eventList.get(type);
        for(callback in callbackList)
        {
            if(callback == listener)
                return; //Listener already added.
        }

        callbackList.push(listener);

        eventList.set(type, callbackList); //Set Final List
    }

    public function hasEventListener(type:String):Bool {
        if(!eventList.exists(type))
        {
            return false;
        }
        return eventList.get(type).length != 0;
    }

    public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
        //useCapture not implemented!
        if(listener == null)
            return; //Listener not found!
        if(!eventList.exists(type))
            return; //Any listener not found!

        var callbackList:Array<Dynamic->Void> = cast eventList.get(type);
        callbackList.remove(listener);

        if(callbackList.length == 0)
        {
            eventList.remove(type); //Set Final List
        }else{
            eventList.set(type, callbackList); //Set Final List
        }

    }

    public function dispatchEvent (event:Event):Void {
        var callbackList:Array<Dynamic->Void> = cast eventList.get(event.type);
        if(callbackList == null)
            return; //Any Listener Not Found!
        for(callback in callbackList)
        {
            callback(event);
        }
    }
}
