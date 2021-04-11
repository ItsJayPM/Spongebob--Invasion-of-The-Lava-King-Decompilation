package popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   
   public class PopupHelp extends Popup implements Idestroyable
   {
       
      
      private var btnBACK:SimpleButton;
      
      private var btnPLAY:SimpleButton;
      
      public function PopupHelp(_mcRef:MovieClip)
      {
         super(_mcRef);
         addState(sSTATE_APPEAR,state_appear,loadState,unloadState);
         addState(sSTATE_IDLE,null,loadState,unloadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState,unloadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      private function onAddedButton(_e:Event) : void
      {
         if(_e.target == mcState.mcPopup.mcButton.getChildByName("btnPlay"))
         {
            btnPLAY = mcState.mcPopup.mcButton.getChildByName("btnPlay");
            setButton(btnPLAY,onClick,onRollOver);
            mcState.removeEventListener(Event.ADDED,onAddedButton);
         }
      }
      
      private function setPlayButton() : void
      {
         if(Main.instance.state == Main.sSTATE_TITLE)
         {
            mcState.mcPopup.mcButton.gotoAndStop(1);
         }
         else
         {
            mcState.mcPopup.mcButton.gotoAndStop(2);
         }
         if(mcState.mcPopup.mcButton.btnPlay == null)
         {
            mcState.addEventListener(Event.ADDED,onAddedButton);
         }
         else
         {
            btnPLAY = mcState.mcPopup.mcButton.btnPlay;
            setButton(btnPLAY,onClick,onRollOver);
         }
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnBACK:
               if(Main.instance.popupMenu != null)
               {
                  Main.instance.popupMenu.showTitle();
               }
               close();
               break;
            case btnPLAY:
               if(Main.instance.state == Main.sSTATE_TITLE)
               {
                  trace("Report on Help Play button pressed");
                  ExternalInterface.call("trackKidsGamePlay","sb_lava");
                  Main.instance.addPopup(Main.sPOPUP_PROFILE);
               }
               else
               {
                  if(Main.instance.popupMenu != null)
                  {
                     Main.instance.popupMenu.resumeGame();
                  }
                  Main.instance.removePopup(Main.instance.popupMenu);
                  Main.instance.popupHelp.close();
               }
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         trace("Help state: " + state);
         switch(state)
         {
            case sSTATE_APPEAR:
               setPlayButton();
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupIn.wav",1,1,true);
               break;
            case sSTATE_IDLE:
               setPlayButton();
               btnBACK = mcState.mcPopup.btnBack;
               setButton(btnBACK,onClick,onRollOver);
               break;
            case sSTATE_DISAPPEAR:
               setPlayButton();
               Main.instance.stage.focus = Main.instance.stage;
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupOut.wav",1,1,true);
         }
      }
      
      private function unloadState() : void
      {
         switch(state)
         {
            case sSTATE_APPEAR:
            case sSTATE_IDLE:
            case sSTATE_DISAPPEAR:
         }
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         trace("Over: " + _e.target);
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Popup help destroyed");
         setButton(btnBACK,onClick,onRollOver,true);
         setButton(btnPLAY,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         btnBACK = null;
         btnPLAY = null;
         mcRef = null;
      }
   }
}
