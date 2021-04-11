package library.basic
{
   import flash.events.KeyboardEvent;
   
   public class InputManager
   {
      
      public static const LEFT:uint = 37;
      
      public static const NUMBER_3_NUMPAD:uint = 99;
      
      public static const PGDOWN:uint = 34;
      
      public static const NUMBER_2_NUMPAD:uint = 98;
      
      public static const PRINTSCREEN:uint = 44;
      
      public static const A:uint = 65;
      
      public static const B:uint = 66;
      
      public static const C:uint = 67;
      
      public static const D:uint = 68;
      
      public static const E:uint = 69;
      
      public static const F:uint = 70;
      
      public static const G:uint = 71;
      
      public static const H:uint = 72;
      
      public static const I:uint = 73;
      
      public static const J:uint = 74;
      
      public static const K:uint = 75;
      
      public static const L:uint = 76;
      
      public static const M:uint = 77;
      
      public static const N:uint = 78;
      
      public static const O:uint = 79;
      
      public static const P:uint = 80;
      
      public static const Q:uint = 81;
      
      public static const R:uint = 82;
      
      public static const S:uint = 83;
      
      public static const T:uint = 84;
      
      public static const U:uint = 85;
      
      public static const V:uint = 86;
      
      public static const W:uint = 87;
      
      public static const X:uint = 88;
      
      public static const Y:uint = 89;
      
      public static const Z:uint = 90;
      
      public static const NUMBER_1_NUMPAD:uint = 97;
      
      public static const NUMBER_9_NUMPAD:uint = 105;
      
      public static const NUMBER_8_NUMPAD:uint = 104;
      
      public static const CTRL:uint = 17;
      
      public static const NUMBER_0_NUMPAD:uint = 96;
      
      public static const TAB:uint = 9;
      
      public static const SCROLLLOCK:uint = 145;
      
      public static const SHIFT:uint = 16;
      
      public static const NUMLOCK:uint = 144;
      
      public static const CAPSLOCK:uint = 20;
      
      private static const nKEY_PRESS:Number = 0;
      
      public static const UP:uint = 38;
      
      public static const NUMBER_7_NUMPAD:uint = 103;
      
      public static const F1:uint = 112;
      
      public static const F2:uint = 113;
      
      public static const F3:uint = 114;
      
      public static const F5:uint = 116;
      
      public static const F7:uint = 118;
      
      public static const F4:uint = 115;
      
      public static const ALT:uint = 18;
      
      public static const F6:uint = 117;
      
      public static const ENTER:uint = 13;
      
      public static const F8:uint = 119;
      
      public static const NUMBER_0:uint = 48;
      
      public static const NUMBER_6_NUMPAD:uint = 102;
      
      public static const NUMBER_2:uint = 50;
      
      public static const NUMBER_3:uint = 51;
      
      public static const NUMBER_4:uint = 52;
      
      public static const NUMBER_5:uint = 53;
      
      public static const NUMBER_6:uint = 54;
      
      public static const NUMBER_7:uint = 55;
      
      public static const NUMBER_1:uint = 49;
      
      public static const NUMBER_9:uint = 57;
      
      public static const DOWN:uint = 40;
      
      public static const INSERT:uint = 45;
      
      public static const NUMBER_8:uint = 56;
      
      public static const F9:uint = 120;
      
      public static const NUMBER_5_NUMPAD:uint = 101;
      
      private static const nKEY_UP:Number = -1;
      
      public static const PGUP:uint = 33;
      
      public static const END:uint = 35;
      
      public static const PAUSE:uint = 19;
      
      public static const DELETE:uint = 46;
      
      public static const HOME:uint = 36;
      
      public static const F10:uint = 121;
      
      public static const F11:uint = 122;
      
      public static const F12:uint = 123;
      
      public static const NUMBER_4_NUMPAD:uint = 100;
      
      public static const RIGHT:uint = 39;
      
      private static const nKEY_RELEASED:Number = -2;
       
      
      private var iNumKeyOn:int;
      
      private var aKeyNextId:Number;
      
      private var aKeyMap:Array;
      
      private var aKeyId:Array;
      
      private var aKeyStates:Array;
      
      private var bAnyKeyPress:Boolean;
      
      private var aKeyOn:Array;
      
      private var bEnabled:Boolean;
      
      public function InputManager()
      {
         super();
         aKeyNextId = 0;
         bAnyKeyPress = false;
         aKeyId = new Array();
         aKeyMap = new Array();
         aKeyStates = new Array();
         aKeyOn = new Array();
         iNumKeyOn = 0;
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         enable();
      }
      
      public function enable() : void
      {
         bEnabled = true;
      }
      
      public function addKey(_nKeyCode:uint) : void
      {
         aKeyId[String(_nKeyCode)] = aKeyNextId;
         aKeyMap[aKeyNextId] = _nKeyCode;
         aKeyStates[aKeyNextId] = nKEY_UP;
         aKeyOn[aKeyNextId] = false;
         ++aKeyNextId;
      }
      
      public function isKeyJustPressed(_nKey:uint) : Boolean
      {
         if(!bEnabled)
         {
            return false;
         }
         var _sLabel:String = String(_nKey);
         var _nId:Number = aKeyId[_sLabel];
         if(aKeyId[_sLabel] == null)
         {
            return false;
         }
         return aKeyStates[_nId] == nKEY_PRESS;
      }
      
      public function update(_nDeltaTime:Number) : void
      {
         var _nID:Number = NaN;
         if(!bEnabled)
         {
            resetKeys();
            return;
         }
         bAnyKeyPress = false;
         for(var i:Number = 0; i < aKeyMap.length; i++)
         {
            if(aKeyOn[i])
            {
               if(aKeyStates[i] == nKEY_UP)
               {
                  aKeyStates[i] = nKEY_PRESS;
                  bAnyKeyPress = true;
                  ++iNumKeyOn;
               }
               else
               {
                  aKeyStates[i] += _nDeltaTime;
               }
            }
            else if(aKeyStates[i] >= nKEY_PRESS)
            {
               aKeyStates[i] = nKEY_RELEASED;
               --iNumKeyOn;
            }
            else
            {
               aKeyStates[i] = nKEY_UP;
            }
         }
      }
      
      public function getKeyHoldDuration(_nKey:uint) : Number
      {
         if(!bEnabled)
         {
            return 0;
         }
         var _sLabel:String = String(_nKey);
         var _nId:Number = aKeyId[_sLabel];
         if(aKeyId[_sLabel] == null)
         {
            return 0;
         }
         return aKeyStates[_nId];
      }
      
      public function isKeyJustReleased(_nKey:uint) : Boolean
      {
         if(!bEnabled)
         {
            return false;
         }
         var _sLabel:String = String(_nKey);
         var _nId:Number = aKeyId[_sLabel];
         if(aKeyId[_sLabel] == null)
         {
            return false;
         }
         return aKeyStates[_nId] == nKEY_RELEASED;
      }
      
      public function isKeyDown(_nKey:uint) : Boolean
      {
         if(!bEnabled)
         {
            return false;
         }
         var _sLabel:String = String(_nKey);
         var _nId:Number = aKeyId[_sLabel];
         if(aKeyId[_sLabel] == null)
         {
            return false;
         }
         return aKeyStates[_nId] >= nKEY_PRESS;
      }
      
      private function onKeyDown(_e:KeyboardEvent) : void
      {
         var _nKey:Number = _e.keyCode;
         var _sLabel:String = String(_nKey);
         var _nId:Number = aKeyId[_sLabel];
         if(aKeyId[_sLabel] != null)
         {
            aKeyOn[_nId] = true;
         }
      }
      
      public function isAnyKeyDown() : Boolean
      {
         return iNumKeyOn > 0;
      }
      
      public function resetKeys() : void
      {
         for(var i:Number = 0; i < aKeyMap.length; i++)
         {
            aKeyStates[i] = nKEY_UP;
         }
         iNumKeyOn = 0;
      }
      
      public function disable() : void
      {
         bEnabled = false;
      }
      
      public function clearAllKeys() : void
      {
         aKeyMap.splice(0);
         aKeyId.splice(0);
         aKeyStates.splice(0);
         aKeyOn.splice(0);
         iNumKeyOn = 0;
      }
      
      public function isAnyKeyJustPressed() : Boolean
      {
         return bAnyKeyPress;
      }
      
      private function onKeyUp(_e:KeyboardEvent) : void
      {
         var _nKey:Number = _e.keyCode;
         var _sLabel:String = String(_nKey);
         var _nId:Number = aKeyId[_sLabel];
         if(aKeyId[_sLabel] != null)
         {
            aKeyOn[_nId] = false;
         }
      }
   }
}
