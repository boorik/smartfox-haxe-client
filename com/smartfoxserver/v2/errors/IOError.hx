package com.smartfoxserver.v2.errors;
class IOError extends Error {
    public function new (message:String = "", id:Int = 0) {
        super(message, id);
        name = "IOError";
    }
}
