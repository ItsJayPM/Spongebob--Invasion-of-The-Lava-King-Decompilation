package screens
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import library.basic.Screen;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   import mdm.Application;
   
   public class TitleScreen extends Screen implements Idestroyable
   {
       
      
      public function TitleScreen(_mcRef:MovieClip)
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
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      override protected function initButton() : void
      {
         setButton(mcRef.btnPlay,onClick,onRollOver);
         setButton(mcRef.btnHelp,onClick,onRollOver);
         setButton(mcRef.btnViewHS,onClick,onRollOver);
         setButton(mcRef.btnBuilder,onClick,onRollOver);
         if(Main.bSTAND_ALONE)
         {
            mcRef.btnBuilder.visible = true;
            mcRef.btnViewHS.visible = false;
         }
         if(Application.path == null || Application.path == "")
         {
            mcRef.btnBuilder.visible = true;
         }
         mcRef.btnViewHS.filters = [Data.oDISABLED_FILTER];
         mcRef.btnViewHS.enabled = false;
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case mcRef.btnPlay:
               trace("Report on Play button pressed");
               //ExternalInterface.call("trackKidsGamePlay","sb_lava");
               Main.instance.addPopup(Main.sPOPUP_PROFILE);
               break;
            case mcRef.btnHelp:
               Main.instance.addPopup(Main.sPOPUP_HELP);
               break;
            case mcRef.btnViewHS:
               if(mcRef.btnViewHS.enabled)
               {
                  Main.instance.addPopup(Main.sPOPUP_HS_TITLE);
               }
               break;
            case mcRef.btnBuilder:
               Main.instance.transitTo(Main.sSTATE_BUILDER);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      override public function destroy(_e:Event = null) : void
      {
         setButton(mcRef.btnPlay,onClick,onRollOver,true);
         setButton(mcRef.btnHelp,onClick,onRollOver,true);
         setButton(mcRef.btnViewHS,onClick,onRollOver,true);
         setButton(mcRef.btnBuilder,onClick,onRollOver,true);
         mcRef = null;
      }
      
      public function onServiceReady(_e:Event = null) : void
      {
         mcRef.btnViewHS.filters = [];
         mcRef.btnViewHS.enabled = true;
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SERVICES_READY,onServiceReady,false);
      }
   }
}
