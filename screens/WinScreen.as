package screens
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import library.basic.Screen;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   import library.utils.Tools;
   
   public class WinScreen extends Screen implements Idestroyable
   {
       
      
      private var btnViewHS:SimpleButton;
      
      private var btnPlayAgain:SimpleButton;
      
      private var btnSubmitHS:SimpleButton;
      
      public function WinScreen(_mcRef:MovieClip)
      {
         super(_mcRef);
         initButton();
         if(!Main.instance.oNickServices.ready)
         {
            Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false,0,true);
         }
         else
         {
            onServiceReady();
         }
         mcRef.txtScore.text = Tools.getFormatedUint(Profile.Instance.getCurrentScore());
      }
      
      override protected function initButton() : void
      {
         btnSubmitHS = mcRef.btnSubmitHS;
         btnViewHS = mcRef.btnViewHS;
         btnPlayAgain = mcRef.btnPlayAgain;
         btnSubmitHS.filters = [Data.oDISABLED_FILTER];
         btnSubmitHS.enabled = false;
         btnViewHS.filters = [Data.oDISABLED_FILTER];
         btnViewHS.enabled = false;
         setButton(btnPlayAgain,onClick,onRollOver);
         setButton(btnSubmitHS,onClick,onRollOver);
         setButton(btnViewHS,onClick,onRollOver);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnPlayAgain:
               trace("Report on Win Play Again button pressed");
               ExternalInterface.call("trackKidsGamePlay","sb_lava");
               Main.instance.transitTo(Main.sSTATE_TITLE);
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
      
      override public function destroy(_e:Event = null) : void
      {
         setButton(mcRef.btnPlayAgain,onClick,onRollOver,true);
         setButton(mcRef.btnSubmitHS,onClick,onRollOver,true);
         setButton(mcRef.btnViewHS,onClick,onRollOver,true);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false);
         btnSubmitHS = null;
         btnViewHS = null;
         btnPlayAgain = null;
         mcRef = null;
      }
   }
}
