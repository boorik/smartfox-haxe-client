package com.smartfoxserver.v2.bitswarm.wsocket;

import com.smartfoxserver.v2.core.BaseEvent;

class WSEvent extends BaseEvent
{
   public static inline var CONNECT : String = "ws-connect";

   public static inline var CLOSED : String = "ws-closed";

   public static inline var DATA : String = "ws-data";

   public static inline var IO_ERROR : String = "ws-ioError";

   public static inline var SECURITY_ERROR : String = "ws-securityError";


   public function new(type : String, params : Dynamic = null)
   {
      super(type);
      this.params = params;
   }
}