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
   import library.utils.Tools;
   
   public class PopupLose extends Popup implements Idestroyable
   {
       
      
      private var btnViewHS:SimpleButton;
      
      private var btnPlayAgain:SimpleButton;
      
      private var btnSubmitHS:SimpleButton;
      
      public function PopupLose(_mcRef:MovieClip)
      {
         super(_mcRef);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      private function initButton() : void
      {
         btnSubmitHS.filters = [Data.oDISABLED_FILTER];
         btnSubmitHS.enabled = false;
         btnViewHS.filters = [Data.oDISABLED_FILTER];
         btnViewHS.enabled = false;
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnPlayAgain:
               trace("Report on Lose Play Again button pressed");
               ExternalInterface.call("trackKidsGamePlay","sb_lava");
               close();
               Main.instance.startGame();
               break;
            case btnSubmitHS:
               if(btnSubmitHS.enabled)
               {
                  Main.instance.oNickServices.bSubmitHS = true;
                  Main.instance.addPopup(Main.sPOPUP_HS);
               }
               break;
            case btnViewHS:
               if(btnViewHS.enabled)
               {
                  Main.instance.oNickServices.bViewHS = true;
                  Main.instance.addPopup(Main.sPOPUP_HS);
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
         mcState.mcPopup.txtScore.text = Tools.getFormatedUint(Profile.Instance.getCurrentScore());
         switch(state)
         {
            case sSTATE_APPEAR:
               btnSubmitHS = mcState.mcPopup.btnSubmitHS;
               btnViewHS = mcState.mcPopup.btnViewHS;
               initButton();
               if(!Main.instance.oNickServices.ready)
               {
                  Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false,0,true);
               }
               else
               {
                  onServiceReady();
               }
               break;
            case sSTATE_IDLE:
               btnPlayAgain = mcState.mcPopup.btnPlayAgain;
               btnSubmitHS = mcState.mcPopup.btnSubmitHS;
               btnViewHS = mcState.mcPopup.btnViewHS;
               initButton();
               setButton(btnPlayAgain,onClick,onRollOver);
               setButton(btnSubmitHS,onClick,onRollOver);
               setButton(btnViewHS,onClick,onRollOver);
               if(!Main.instance.oNickServices.ready)
               {
                  Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false,0,true);
               }
               else
               {
                  onServiceReady();
               }
               break;
            case sSTATE_DISAPPEAR:
               btnSubmitHS = mcState.mcPopup.btnSubmitHS;
               btnViewHS = mcState.mcPopup.btnViewHS;
               initButton();
         }
      }
      
      public function onServiceReady(_e:Event = null) : void
      {
         btnViewHS.filters = [];
         btnViewHS.enabled = true;
         btnSubmitHS.filters = [];
         btnSubmitHS.enabled = true;
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false);
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
      
      public function destroy(_e:Event = null) : void
      {
         setButton(btnPlayAgain,onClick,onRollOver,true);
         setButton(btnSubmitHS,onClick,onRollOver,true);
         setButton(btnViewHS,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false);
         btnPlayAgain = null;
         btnSubmitHS = null;
         btnViewHS = null;
         mcRef = null;
      }
   }
}
