package com.smartfoxserver.v2.errors;
class ArgumentError extends Error {
    public function new (message:String = "", id:Int = 0) {
        super(message, id);
        name = "ArgumentError";
    }
}
