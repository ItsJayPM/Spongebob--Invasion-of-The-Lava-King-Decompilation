package library.sounds
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundItem extends Sound
   {
      
      private static const FADE_RATE:Number = 0.08;
      
      private static const PAN_RATE:Number = 0.08;
      
      private static const FADE_AT_END_TIME:Number = 800;
       
      
      public var sLinkage:String;
      
      private var sndObj:Sound;
      
      private var nFadeRate:Number;
      
      private var bStopAfterFade:Boolean;
      
      private var sCategory:String;
      
      private var nTargetVolume:Number;
      
      private var nCurrentTime:Number;
      
      private var oSndTransform:SoundTransform;
      
      private var nCurrentVolume:Number;
      
      private var bMuted:Boolean;
      
      private var bMustRestartAfterLooped:Boolean;
      
      private var oSndChannel:SoundChannel;
      
      public var bIsPlaying:Boolean;
      
      private var nLoop:Number;
      
      private var bPaused:Boolean;
      
      public function SoundItem(_sndObject:Sound, _sLinkage:String, _nVolume:Number, _nLoop:Number, _sCategory:String)
      {
         super();
         sndObj = _sndObject;
         bIsPlaying = false;
         sLinkage = _sLinkage;
         nLoop = _nLoop;
         trace(nLoop);
         nFadeRate = FADE_RATE;
         sCategory = _sCategory;
         nCurrentVolume = _nVolume;
         nTargetVolume = _nVolume;
         oSndTransform = new SoundTransform(returnComputedVolume(nCurrentVolume));
         bStopAfterFade = false;
         bMuted = false;
         bPaused = false;
         bMustRestartAfterLooped = false;
      }
      
      private function manageFade() : void
      {
         if(nCurrentVolume != nTargetVolume)
         {
            nCurrentVolume = getReachNum(nCurrentVolume,nTargetVolume,nFadeRate);
            updateSound();
         }
         if(nCurrentVolume <= 0 && bStopAfterFade)
         {
            doStop();
         }
      }
      
      private function onSoundCompleted(_e:Event) : void
      {
         if(bMustRestartAfterLooped)
         {
            doPlay();
         }
         else
         {
            bIsPlaying = false;
            SoundManager.cleanUpSound(this);
         }
      }
      
      public function set volume(_nVolume:Number) : void
      {
         oSndTransform.volume = returnComputedVolume(_nVolume);
         oSndChannel.soundTransform = oSndTransform;
      }
      
      public function get linkage() : String
      {
         return sLinkage;
      }
      
      public function updateSound() : void
      {
         oSndTransform.volume = returnComputedVolume(nCurrentVolume);
         oSndChannel.soundTransform = oSndTransform;
      }
      
      public function update() : void
      {
         if(!bPaused)
         {
            manageFade();
         }
      }
      
      public function setFadeRate(_nRate:Number = 0.08) : void
      {
         nFadeRate = _nRate;
      }
      
      private function getReachNum(_nNum:Number, _nTargetNum:Number, _nReducer:Number) : Number
      {
         var _tmpNum:Number = _nNum;
         if(_tmpNum != _nTargetNum)
         {
            if(_tmpNum < _nTargetNum)
            {
               _tmpNum += _nReducer;
               if(_tmpNum > _nTargetNum)
               {
                  _tmpNum = _nTargetNum;
               }
            }
            else
            {
               _tmpNum -= _nReducer;
               if(_tmpNum < _nTargetNum)
               {
                  _tmpNum = _nTargetNum;
               }
            }
         }
         return _tmpNum;
      }
      
      public function fadeTo(_nVolume:Number, _bStopAfterFade:Boolean = true) : void
      {
         bStopAfterFade = _bStopAfterFade;
         nTargetVolume = _nVolume;
      }
      
      public function get volume() : Number
      {
         return oSndTransform.volume;
      }
      
      private function returnComputedVolume(_nVolume:Number) : Number
      {
         var _nFinalVolume:Number = NaN;
         if(!bMuted && !SoundManager.isCategoryMuted(sCategory))
         {
            _nFinalVolume = _nVolume;
            _nFinalVolume *= SoundManager.getCategoryVolume(sCategory);
            _nFinalVolume *= SoundManager.MasterVolume;
         }
         else
         {
            _nFinalVolume = 0;
         }
         return _nFinalVolume;
      }
      
      public function doPlay() : void
      {
         bIsPlaying = true;
         oSndChannel = sndObj.play(0,nLoop,oSndTransform);
         oSndChannel.addEventListener(Event.SOUND_COMPLETE,onSoundCompleted);
      }
      
      public function doStop() : void
      {
         oSndChannel.stop();
         bIsPlaying = false;
         SoundManager.cleanUpSound(this);
      }
      
      public function unMute() : void
      {
         bMuted = false;
         updateSound();
      }
      
      public function mute() : void
      {
         bMuted = true;
         updateSound();
      }
      
      public function resume() : void
      {
         if(bPaused)
         {
            bPaused = false;
            if(bMustRestartAfterLooped)
            {
               if(nCurrentTime > sndObj.length)
               {
                  nCurrentTime -= sndObj.length;
               }
               oSndChannel = sndObj.play(nCurrentTime,1,oSndTransform);
            }
            else
            {
               oSndChannel = sndObj.play(nCurrentTime,nLoop,oSndTransform);
            }
            oSndChannel.addEventListener(Event.SOUND_COMPLETE,onSoundCompleted);
         }
      }
      
      public function pause() : void
      {
         if(!bPaused)
         {
            nCurrentTime = oSndChannel.position;
            if(nLoop > 1)
            {
               bMustRestartAfterLooped = true;
            }
            oSndChannel.stop();
            bPaused = true;
         }
      }
      
      public function get category() : String
      {
         return sCategory;
      }
   }
}
