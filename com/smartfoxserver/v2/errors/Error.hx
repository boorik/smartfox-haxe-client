package com.smartfoxserver.v2.errors;
class Error {
    public var errorID (default, null):Int;
    public var message:String;
    public var name:String;


    public function new (message:String = "", id:Int = 0) {
        this.message = message;
        this.errorID = id;
        name = "Error";
    }

    public function toString()
    {
        return "[" + name + "]: " + message + " (" + errorID + ")";
    }
}
