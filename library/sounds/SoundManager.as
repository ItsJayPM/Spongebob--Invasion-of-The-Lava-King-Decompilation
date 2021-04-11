package library.sounds
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class SoundManager
   {
      
      private static var aSounds:Array;
      
      private static var aAvailableSounds:Array;
      
      private static var sDEFAULT_CATEGORY:String = "sfx";
      
      private static var nSoundNum:Number;
      
      private static var aSoundCategories:Array;
      
      private static var bInited:Boolean = false;
      
      private static var nMasterVolume:Number;
       
      
      public function SoundManager()
      {
         super();
      }
      
      public static function resumeAllSoundsInCat(_sCategoryName:String) : void
      {
         var i:* = null;
         for(i in aSounds)
         {
            if(aSounds[i].category == _sCategoryName)
            {
               aSounds[i].resume();
            }
         }
      }
      
      public static function pauseAllSoundsInCat(_sCategoryName:String) : void
      {
         var i:* = null;
         for(i in aSounds)
         {
            if(aSounds[i].category == _sCategoryName)
            {
               aSounds[i].pause();
            }
         }
      }
      
      public static function isCategoryMuted(__sCategoryName:String) : Boolean
      {
         var _bMuted:Boolean = false;
         var i:* = null;
         for(i in aSoundCategories)
         {
            if(aSoundCategories[i].sName == __sCategoryName)
            {
               _bMuted = aSoundCategories[i].bMuted;
            }
         }
         return _bMuted;
      }
      
      public static function update(_e:Event) : void
      {
         var i:* = null;
         for(i in aSounds)
         {
            aSounds[i].update();
         }
      }
      
      public static function init(_mcRef:Sprite) : void
      {
         if(!bInited)
         {
            bInited = true;
            nSoundNum = 0;
            aSounds = new Array();
            aSoundCategories = new Array();
            nMasterVolume = 1;
            _mcRef.addEventListener(Event.ENTER_FRAME,update);
         }
      }
      
      private static function getSoundItem(_sLinkageName:String) : SoundItem
      {
         var i:* = null;
         var _oReturn:SoundItem = null;
         for(i in aSounds)
         {
            if(aSounds[i].sLinkage == _sLinkageName)
            {
               _oReturn = aSounds[i];
               break;
            }
         }
         return _oReturn;
      }
      
      public static function setMasterVolume(__nVol:Number) : void
      {
         nMasterVolume = __nVol;
         updateAllSoundsVolume();
      }
      
      public static function cleanUpSound(_oSound:SoundItem) : void
      {
         var i:* = null;
         for(i in aSounds)
         {
            if(aSounds[i] == _oSound)
            {
               delete aSounds[i];
               aSounds.splice(i,1);
            }
         }
      }
      
      public static function getCategoryVolume(__sCategoryName:String) : Number
      {
         var _nVolume:Number = NaN;
         var i:* = null;
         for(i in aSoundCategories)
         {
            if(aSoundCategories[i].sName == __sCategoryName)
            {
               _nVolume = aSoundCategories[i].nVolume;
            }
         }
         return _nVolume;
      }
      
      public static function isSoundPlaying(_sLinkageName:String) : Object
      {
         var i:* = null;
         var _oReturn:Object = new Object();
         _oReturn.bPlaying = false;
         _oReturn.oSound = undefined;
         for(i in aSounds)
         {
            if(aSounds[i].sLinkage == _sLinkageName)
            {
               _oReturn.oSound = aSounds[i];
               _oReturn.bPlaying = true;
            }
         }
         return _oReturn;
      }
      
      public static function playSoundInCat(_sCategoryName:String, _sLinkage:String, _nVolume:Number, _nLoop:Number, _bUnique:Boolean) : SoundItem
      {
         var i:* = null;
         var _oSound:SoundItem = null;
         var _bCreateSound:Boolean = false;
         var _oSndObj:Class = getDefinitionByName(_sLinkage) as Class;
         if(_bUnique)
         {
            _bCreateSound = true;
            for(i in aSounds)
            {
               if(aSounds[i].linkage == _sLinkage)
               {
                  _bCreateSound = false;
               }
            }
         }
         else
         {
            _bCreateSound = true;
         }
         if(_bCreateSound)
         {
            _oSound = new SoundItem(new _oSndObj(),_sLinkage,_nVolume,_nLoop,_sCategoryName);
            _oSound.doPlay();
            aSounds.push(_oSound);
         }
         return _oSound;
      }
      
      public static function setCategoryVolume(_sCategoryName:String, _nVol:Number) : void
      {
         var i:* = null;
         for(i in aSoundCategories)
         {
            if(aSoundCategories[i].sName == _sCategoryName)
            {
               aSoundCategories[i].nVolume = _nVol;
            }
         }
         updateAllSoundsVolume();
      }
      
      public static function playSound(_sLinkage:String, _nVolume:Number, _nLoop:Number, _bUnique:Boolean) : SoundItem
      {
         return playSoundInCat(sDEFAULT_CATEGORY,_sLinkage,_nVolume,_nLoop,_bUnique);
      }
      
      public static function get MasterVolume() : Number
      {
         return nMasterVolume;
      }
      
      private static function updateAllSoundsVolume() : void
      {
         var i:* = null;
         for(i in aSounds)
         {
            aSounds[i].updateSound();
         }
      }
      
      public static function addCategory(_sCategoryName:String, _nVolume:Number) : void
      {
         var _oCat:Object = new Object();
         _oCat.sName = _sCategoryName;
         _oCat.nVolume = _nVolume;
         _oCat.bMuted = false;
         aSoundCategories.push(_oCat);
      }
   }
}
