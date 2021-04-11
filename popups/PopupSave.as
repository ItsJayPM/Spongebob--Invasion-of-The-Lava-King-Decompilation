package popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import gameplay.Game;
   import gameplay.events.SavePopupEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   
   public class PopupSave extends Popup implements Idestroyable, IEventDispatcher
   {
       
      
      private var btnVIEW:SimpleButton;
      
      private var btnPLAY:SimpleButton;
      
      private var btnSAVE:SimpleButton;
      
      private var oEventDisp:EventDispatcher;
      
      private var btnSUBMIT:SimpleButton;
      
      public function PopupSave(_mcRef:MovieClip)
      {
         super(_mcRef);
         oEventDisp = new EventDispatcher(this);
         Game.Instance.listenToSave(this);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function onServiceReady(_e:Event = null) : void
      {
         btnVIEW.filters = [];
         btnVIEW.enabled = true;
         btnSUBMIT.filters = [];
         btnSUBMIT.enabled = true;
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
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
               initButton();
               if(!Main.instance.oNickServices.ready)
               {
                  Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false,0,true);
               }
               else
               {
                  onServiceReady();
               }
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupIn.wav",1,1,true);
               break;
            case sSTATE_IDLE:
               initButton();
               setButton(btnSAVE,onClick,onRollOver);
               setButton(btnSUBMIT,onClick,onRollOver);
               setButton(btnVIEW,onClick,onRollOver);
               setButton(btnPLAY,onClick,onRollOver);
               if(!Main.instance.oNickServices.ready)
               {
                  Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false,0,true);
               }
               else
               {
                  onServiceReady();
               }
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupOut.wav",1,1,true);
               break;
            case sSTATE_DISAPPEAR:
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function dispatchOpenEvent() : void
      {
         var _e:SavePopupEvent = new SavePopupEvent(SavePopupEvent.EVENT_OPEN_POPUP_SAVE);
         dispatchEvent(_e);
      }
      
      public function dispatchCloseEvent() : void
      {
         var _e:SavePopupEvent = new SavePopupEvent(SavePopupEvent.EVENT_CLOSE_POPUP_SAVE);
         dispatchEvent(_e);
      }
      
      private function initButton() : void
      {
         btnSAVE = mcState.mcPopup.btnSave;
         btnSUBMIT = mcState.mcPopup.btnSubmitHS;
         btnVIEW = mcState.mcPopup.btnViewHS;
         btnPLAY = mcState.mcPopup.btnPlay;
         btnSUBMIT.filters = [Data.oDISABLED_FILTER];
         btnSUBMIT.enabled = false;
         btnVIEW.filters = [Data.oDISABLED_FILTER];
         btnVIEW.enabled = false;
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnSAVE:
               Profile.Instance.saveCurrentProfile();
               Main.instance.addPopup(Main.sPOPUP_SAVE_CONFIRM);
               break;
            case btnSUBMIT:
               if(btnSUBMIT.enabled)
               {
                  Main.instance.oNickServices.bSubmitHS = true;
                  Main.instance.addPopup(Main.sPOPUP_HS);
               }
               break;
            case btnVIEW:
               if(btnVIEW.enabled)
               {
                  Main.instance.oNickServices.bViewHS = true;
                  Main.instance.addPopup(Main.sPOPUP_HS);
               }
               break;
            case btnPLAY:
               close();
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
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Popup Save destroyed");
         setButton(btnSAVE,onClick,onRollOver,true);
         setButton(btnSUBMIT,onClick,onRollOver,true);
         setButton(btnVIEW,onClick,onRollOver,true);
         setButton(btnPLAY,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false);
         Game.Instance.stopListenToSave(this);
         btnSAVE = null;
         btnSUBMIT = null;
         btnVIEW = null;
         btnPLAY = null;
         mcRef = null;
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
   }
}
