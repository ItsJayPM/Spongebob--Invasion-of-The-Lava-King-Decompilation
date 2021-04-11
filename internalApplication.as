package
{
   import flash.display.Sprite;
   
   public final class internalApplication
   {
       
      
      private var resolver:mdm_Application = null;
      
      public function internalApplication()
      {
         resolver = null;
         super();
      }
      
      public function set onAppExit(param1:Function) : void
      {
         internal_resolver().onAppExit = param1;
      }
      
      public function set onFormMinimize(param1:Function) : void
      {
         internal_resolver().onFormMinimize = param1;
      }
      
      public function delay(param1:Number, param2:Boolean = true) : void
      {
         internal_resolver().delay(param1);
      }
      
      public function doEvents(param1:Boolean = true) : void
      {
         internal_resolver().doEvents();
      }
      
      public function get Screensaver() : mdm_resolver
      {
         return internal_resolver().Screensaver;
      }
      
      public function set onFormChangeFocus(param1:Function) : void
      {
         internal_resolver().onFormChangeFocus = param1;
      }
      
      public function get isMinimized() : Boolean
      {
         return internal_resolver().isMinimized;
      }
      
      public function exitWithModalResult(param1:String, param2:Boolean = true) : void
      {
         internal_resolver().exitWithModalResult(param1);
      }
      
      public function restore(param1:Boolean = true) : void
      {
         internal_resolver().restore();
      }
      
      public function init(param1:Sprite, param2:Function = null) : void
      {
         internal_resolver().init(param1,param2);
      }
      
      public function exitWithCode(param1:Number, param2:Boolean = true) : void
      {
         internal_resolver().exitWithCode(param1);
      }
      
      public function set onBottomHit(param1:Function) : void
      {
         internal_resolver().onBottomHit = param1;
      }
      
      public function set onDragDrop(param1:Function) : void
      {
         internal_resolver().onDragDrop = param1;
      }
      
      public function bringToFront(param1:Boolean = true) : void
      {
         internal_resolver().bringToFront();
      }
      
      public function shake(param1:Number, param2:Boolean = true) : void
      {
         internal_resolver().shake(param1);
      }
      
      public function minimizeToTray(param1:Boolean, param2:Boolean = true) : void
      {
         internal_resolver().minimizeToTray(param1);
      }
      
      public function set onAppMinimize(param1:Function) : void
      {
         internal_resolver().onAppMinimize = param1;
      }
      
      public function get Library() : mdm_resolver
      {
         return internal_resolver().Library;
      }
      
      public function set onTopHit(param1:Function) : void
      {
         internal_resolver().onTopHit = param1;
      }
      
      public function set onFormRestore(param1:Function) : void
      {
         internal_resolver().onFormRestore = param1;
      }
      
      public function minimize(param1:Boolean = true) : void
      {
         internal_resolver().minimize();
      }
      
      public function get filename() : String
      {
         return internal_resolver().filename;
      }
      
      public function exit(param1:Boolean = true) : void
      {
         internal_resolver().exit();
      }
      
      public function getCMDParams(param1:Number) : String
      {
         return internal_resolver().getCMDParams(param1);
      }
      
      public function get Timer() : mdm_resolver
      {
         return internal_resolver().Timer;
      }
      
      public function getFormNames() : Array
      {
         return internal_resolver().getFormNames();
      }
      
      public function get filenameUnix() : String
      {
         return internal_resolver().filenameUnix;
      }
      
      public function set title(param1:String) : void
      {
         internal_resolver().title = param1;
      }
      
      public function sendToBack(param1:Boolean = true) : void
      {
         internal_resolver().sendToBack();
      }
      
      public function get path() : String
      {
         var _loc1_:String = null;
         var _loc2_:RegExp = null;
         var _loc3_:* = false;
         _loc1_ = internal_resolver().path;
         _loc2_ = /\\\\/g;
         _loc3_ = _loc1_.indexOf("\\\\") == 0;
         return (!!_loc3_ ? "\\" : "") + _loc1_.replace(_loc2_,"\\");
      }
      
      public function set onFormResize(param1:Function) : void
      {
         internal_resolver().onFormResize = param1;
      }
      
      public function printVar(param1:String, param2:Boolean = false, param3:Boolean = true) : void
      {
         internal_resolver().printVar(param1,param2);
      }
      
      public function set onRightHit(param1:Function) : void
      {
         internal_resolver().onRightHit = param1;
      }
      
      private function internal_resolver() : mdm_Application
      {
         if(resolver == null)
         {
            resolver = new mdm_Application();
         }
         return resolver;
      }
      
      public function get Kiosk() : mdm_resolver
      {
         return internal_resolver().Kiosk;
      }
      
      public function maximize(param1:Boolean = true) : void
      {
         internal_resolver().maximize();
      }
      
      public function get pathUnix() : String
      {
         return internal_resolver().pathUnix;
      }
      
      public function getGlobalVar(param1:String) : String
      {
         return internal_resolver().getGlobalVar(param1);
      }
      
      public function enableExitHandler(param1:Boolean = true) : void
      {
         internal_resolver().enableExitHandler();
      }
      
      public function set onAppChangeFocus(param1:Function) : void
      {
         internal_resolver().onAppChangeFocus = param1;
      }
      
      public function showTips(param1:String) : Boolean
      {
         return internal_resolver().showTips(param1);
      }
      
      public function get filenameUnicode() : String
      {
         return internal_resolver().filenameUnicode;
      }
      
      public function set onAppRestore(param1:Function) : void
      {
         internal_resolver().onAppRestore = param1;
      }
      
      public function set onLeftHit(param1:Function) : void
      {
         internal_resolver().onLeftHit = param1;
      }
      
      public function set onArrowKeyPress(param1:Function) : void
      {
         internal_resolver().onArrowKeyPress = param1;
      }
      
      public function set onFormMaximize(param1:Function) : void
      {
         internal_resolver().onFormMaximize = param1;
      }
      
      public function createForm(param1:String, param2:String, param3:String, param4:Number, param5:Number, param6:Number, param7:Number) : *
      {
         return internal_resolver().createForm(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function set onMDMScriptException(param1:Function) : void
      {
         internal_resolver().onMDMScriptException = param1;
      }
      
      public function set onSplashClosed(param1:Function) : void
      {
         internal_resolver().onSplashClosed = param1;
      }
      
      public function set onFormClose(param1:Function) : void
      {
         internal_resolver().onFormClose = param1;
      }
      
      public function say(param1:String, param2:Boolean = true) : void
      {
         internal_resolver().say(param1);
      }
      
      public function exitWithDialog(param1:String, param2:Boolean) : void
      {
         internal_resolver().exitWithDialog(param1);
      }
      
      public function getEnvVar(param1:String) : String
      {
         return internal_resolver().getEnvVar(param1);
      }
      
      public function textAreaEnhance(param1:Boolean, param2:Boolean = true) : void
      {
         internal_resolver().textAreaEnhance(param1);
      }
      
      public function get Trial() : mdm_resolver
      {
         return internal_resolver().Trial;
      }
      
      public function get pathUnicode() : String
      {
         var _loc1_:String = null;
         var _loc2_:RegExp = null;
         var _loc3_:* = false;
         _loc1_ = internal_resolver().path;
         _loc2_ = /\\\\/g;
         _loc3_ = _loc1_.indexOf("\\\\") == 0;
         return (!!_loc3_ ? "\\" : "") + _loc1_.replace(_loc2_,"\\");
      }
      
      public function getSecureVar(param1:String) : String
      {
         return internal_resolver().getSecureVar(param1);
      }
      
      public function setEnvVar(param1:String, param2:String, param3:Boolean = true) : void
      {
         internal_resolver().setEnvVar(param1,param2);
      }
      
      public function set onFormReposition(param1:Function) : void
      {
         internal_resolver().onFormReposition = param1;
      }
   }
}

import flash.display.Sprite;
import flash.events.Event;
import mdm.Alert;

dynamic class mdm_Application extends mdm_resolver
{
    
   
   private var m_onInitCallback:Function = null;
   
   private var m_bInitDispatched:Boolean = false;
   
   function mdm_Application()
   {
      m_onInitCallback = null;
      m_bInitDispatched = false;
      super();
      SetClassName("mdm.Application");
      AddEvents();
      AddObject("Library",null);
      AddObject("Screensaver",null);
      AddObject("Timer",new mdm_Timer());
      AddObject("Trial",null);
      AddObject("Kiosk",null);
   }
   
   public function init(param1:Sprite, param2:Function = null) : void
   {
      var strURL:String = null;
      var dispObj:Sprite = param1;
      var onInitCallback:Function = param2;
      strURL = null;
      try
      {
         strURL = dispObj.root.loaderInfo.url;
      }
      catch(e:Error)
      {
      }
      finally
      {
         if(strURL == null)
         {
         }
      }
      AssocURL(strURL);
      mdmSetup();
      m_spr = dispObj;
      Alert.init(dispObj.stage);
      if(onInitCallback != null)
      {
         m_onInitCallback = onInitCallback;
         dispObj.addEventListener("enterFrame",onInitialise);
      }
   }
   
   private function onInitialise(param1:Event) : void
   {
      if(!m_bInitDispatched && m_onInitCallback != null)
      {
         m_bInitDispatched = true;
         m_onInitCallback();
      }
   }
   
   private function AddEvents() : void
   {
      AddEvent("onAppChangeFocus",true);
      AddEvent("onAppExit",false);
      AddEvent("onAppMinimize",false);
      AddEvent("onAppRestore",false);
      AddEvent("onArrowKeyPress",true);
      AddEvent("onBottomHit",false);
      AddEvent("onDragDrop",true);
      AddEvent("onFormChangeFocus",true);
      AddEvent("onFormClose",false);
      AddEvent("onFormMaximize",true);
      AddEvent("onFormMinimize",true);
      AddEvent("onFormReposition",true);
      AddEvent("onFormResize",true);
      AddEvent("onFormRestore",true);
      AddEvent("onLeftHit",false);
      AddEvent("onMDMScriptException",true);
      AddEvent("onRightHit",false);
      AddEvent("onSplashClosed",false);
      AddEvent("onTopHit",false);
   }
}

dynamic class mdm_Timer extends mdm_resolver
{
    
   
   function mdm_Timer()
   {
      super();
      SetClassName("mdm.Application.Timer");
      AddEvents();
   }
   
   private function AddEvents() : void
   {
      AddEvent("onTimer0",false);
      AddEvent("onTimer1",false);
      AddEvent("onTimer2",false);
      AddEvent("onTimer3",false);
      AddEvent("onTimer4",false);
      AddEvent("onTimer5",false);
      AddEvent("onTimer6",false);
      AddEvent("onTimer7",false);
      AddEvent("onTimer8",false);
      AddEvent("onTimer9",false);
      AddEvent("onTimer10",false);
   }
}

import flash.utils.ByteArray;

class Base64
{
   
   private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
   
   function Base64()
   {
      super();
      throw new Error("Base64 class is static container only");
   }
   
   public static function encode(param1:String) : String
   {
      var _loc2_:ByteArray = null;
      _loc2_ = new ByteArray();
      _loc2_.writeUTFBytes(param1);
      return encodeByteArray(_loc2_);
   }
   
   public static function decodeToByteArray(param1:String) : ByteArray
   {
      var _loc2_:ByteArray = null;
      var _loc3_:Array = null;
      var _loc4_:Array = null;
      var _loc5_:uint = 0;
      var _loc6_:uint = 0;
      var _loc7_:uint = 0;
      _loc2_ = new ByteArray();
      _loc3_ = new Array(4);
      _loc4_ = new Array(3);
      _loc5_ = 0;
      while(_loc5_ < param1.length)
      {
         _loc6_ = 0;
         while(_loc6_ < 4 && _loc5_ + _loc6_ < param1.length)
         {
            _loc3_[_loc6_] = BASE64_CHARS.indexOf(param1.charAt(_loc5_ + _loc6_));
            _loc6_++;
         }
         _loc4_[0] = (_loc3_[0] << 2) + ((_loc3_[1] & 48) >> 4);
         _loc4_[1] = ((_loc3_[1] & 15) << 4) + ((_loc3_[2] & 60) >> 2);
         _loc4_[2] = ((_loc3_[2] & 3) << 6) + _loc3_[3];
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            if(_loc3_[_loc7_ + 1] == 64)
            {
               break;
            }
            _loc2_.writeByte(_loc4_[_loc7_]);
            _loc7_++;
         }
         _loc5_ += 4;
      }
      _loc2_.position = 0;
      return _loc2_;
   }
   
   public static function encodeByteArray(param1:ByteArray) : String
   {
      var _loc2_:String = null;
      var _loc3_:Array = null;
      var _loc4_:Array = null;
      var _loc5_:uint = 0;
      var _loc6_:uint = 0;
      var _loc7_:uint = 0;
      _loc2_ = "";
      _loc4_ = new Array(4);
      param1.position = 0;
      while(param1.bytesAvailable > 0)
      {
         _loc3_ = new Array();
         _loc5_ = 0;
         while(_loc5_ < 3 && param1.bytesAvailable > 0)
         {
            _loc3_[_loc5_] = param1.readUnsignedByte();
            _loc5_++;
         }
         _loc4_[0] = (_loc3_[0] & 252) >> 2;
         _loc4_[1] = (_loc3_[0] & 3) << 4 | _loc3_[1] >> 4;
         _loc4_[2] = (_loc3_[1] & 15) << 2 | _loc3_[2] >> 6;
         _loc4_[3] = _loc3_[2] & 63;
         _loc6_ = _loc3_.length;
         while(_loc6_ < 3)
         {
            _loc4_[_loc6_ + 1] = 64;
            _loc6_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc2_ += BASE64_CHARS.charAt(_loc4_[_loc7_]);
            _loc7_++;
         }
      }
      return _loc2_;
   }
   
   public static function decode(param1:String) : String
   {
      var _loc2_:ByteArray = null;
      _loc2_ = decodeToByteArray(param1);
      return _loc2_.readUTFBytes(_loc2_.length);
   }
}
