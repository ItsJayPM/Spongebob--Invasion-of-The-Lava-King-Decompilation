package popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import gameplay.Game;
   import gameplay.events.MenuPopupEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   import library.sounds.SoundSlider;
   
   public class PopupMenu extends Popup implements Idestroyable, IEventDispatcher
   {
       
      
      private var oSliderSound:SoundSlider;
      
      private var btnRESUME:SimpleButton;
      
      private var oSliderMusic:SoundSlider;
      
      private var btnHELP:SimpleButton;
      
      private var btnQUIT:SimpleButton;
      
      private var oEventDisp:EventDispatcher;
      
      public function PopupMenu(_mcRef:MovieClip)
      {
         super(_mcRef);
         oEventDisp = new EventDispatcher(this);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Game.Instance.listenToMenu(this);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function destroy(_e:Event = null) : void
      {
         setButton(btnRESUME,onClick,onRollOver,true);
         setButton(btnHELP,onClick,onRollOver,true);
         setButton(btnQUIT,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         btnRESUME = null;
         btnHELP = null;
         btnQUIT = null;
         Game.Instance.stopListenToMenu(this);
         if(oSliderSound != null)
         {
            oSliderSound.destroy();
         }
         oSliderSound = null;
         if(oSliderMusic != null)
         {
            oSliderMusic.destroy();
         }
         oSliderMusic = null;
         mcRef = null;
         oEventDisp = null;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         switch(state)
         {
            case sSTATE_APPEAR:
               dispatchOpenEvent();
               oSliderSound = new SoundSlider(mcState.mcPopup.mcSliderSound,Data.sCATEGORY_SOUND_LINKAGE);
               oSliderMusic = new SoundSlider(mcState.mcPopup.mcSliderMusic,Data.sCATEGORY_MUSIC_LINKAGE);
               break;
            case sSTATE_IDLE:
               btnRESUME = mcState.mcPopup.btnResume;
               btnHELP = mcState.mcPopup.btnHelp;
               btnQUIT = mcState.mcPopup.btnQuit;
               setButton(btnRESUME,onClick,onRollOver);
               setButton(btnHELP,onClick,onRollOver);
               setButton(btnQUIT,onClick,onRollOver);
               oSliderSound = new SoundSlider(mcState.mcPopup.mcSliderSound,Data.sCATEGORY_SOUND_LINKAGE);
               oSliderMusic = new SoundSlider(mcState.mcPopup.mcSliderMusic,Data.sCATEGORY_MUSIC_LINKAGE);
               break;
            case sSTATE_DISAPPEAR:
               oSliderSound = new SoundSlider(mcState.mcPopup.mcSliderSound,Data.sCATEGORY_SOUND_LINKAGE);
               oSliderMusic = new SoundSlider(mcState.mcPopup.mcSliderMusic,Data.sCATEGORY_MUSIC_LINKAGE);
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function unloadState() : void
      {
         oSliderSound.destroy();
         oSliderSound = null;
         oSliderMusic.destroy();
         oSliderMusic = null;
      }
      
      public function showTitle() : void
      {
         mcState.mcPopup.mcTitle.visible = true;
      }
      
      public function dispatchCloseEvent() : void
      {
         var _e:MenuPopupEvent = new MenuPopupEvent(MenuPopupEvent.EVENT_CLOSE_POPUP_MENU);
         dispatchEvent(_e);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      public function dispatchOpenEvent() : void
      {
         var _e:MenuPopupEvent = new MenuPopupEvent(MenuPopupEvent.EVENT_OPEN_POPUP_MENU);
         dispatchEvent(_e);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnRESUME:
               close();
               break;
            case btnHELP:
               hideTitle();
               Main.instance.addPopup(Main.sPOPUP_HELP);
               break;
            case btnQUIT:
               Main.instance.addPopup(Main.sPOPUP_QUIT);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         trace("Over: " + _e.target.name);
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function hideTitle() : void
      {
         mcState.mcPopup.mcTitle.visible = false;
      }
      
      override protected function state_disappear() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         if(stateComplete)
         {
            dispatchCloseEvent();
            Main.instance.removePopup(this);
         }
      }
      
      public function resumeGame() : void
      {
         dispatchCloseEvent();
      }
   }
}
