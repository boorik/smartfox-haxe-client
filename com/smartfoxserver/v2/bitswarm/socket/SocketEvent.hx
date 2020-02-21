package com.smartfoxserver.v2.bitswarm.socket;

import com.smartfoxserver.v2.core.BaseEvent;

class SocketEvent extends BaseEvent
{
   public static inline var CONNECT : String = "socket-connect";

   public static inline var CLOSED : String = "socket-closed";

   public static inline var DATA : String = "socket-data";

   public static inline var IO_ERROR : String = "socket-ioError";

   public static inline var SECURITY_ERROR : String = "socket-securityError";


   public function new(type : String, params : Dynamic = null)
   {
      super(type);
      this.params = params;
   }
}