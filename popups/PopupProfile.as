package popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   
   public class PopupProfile extends Popup implements Idestroyable
   {
       
      
      private var oProfileSlot1:ProfileSlot;
      
      private var btnBack:SimpleButton;
      
      private var oProfileSlot2:ProfileSlot;
      
      private var oProfileSlot3:ProfileSlot;
      
      public function PopupProfile(_mcRef:MovieClip)
      {
         super(_mcRef);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      public function destroy(_e:Event = null) : void
      {
         setButton(btnBack,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         btnBack = null;
         mcRef = null;
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnBack:
               destroyProfileSlot();
               close();
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
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
               initProfileSlot();
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupIn.wav",1,1,true);
               break;
            case sSTATE_IDLE:
               btnBack = mcState.mcPopup.btnBack;
               setButton(btnBack,onClick,onRollOver);
               initProfileSlot();
               break;
            case sSTATE_DISAPPEAR:
               initProfileSlot();
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupOut.wav",1,1,true);
         }
      }
      
      public function destroyProfileSlot() : void
      {
         oProfileSlot1.destroy();
         oProfileSlot2.destroy();
         oProfileSlot3.destroy();
         oProfileSlot1 = null;
         oProfileSlot2 = null;
         oProfileSlot3 = null;
         setButton(btnBack,onClick,onRollOver,true);
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
      
      private function unloadState() : void
      {
         destroyProfileSlot();
      }
      
      public function initProfileSlot(_iProfileID:int = 0) : void
      {
         if(_iProfileID == 0)
         {
            oProfileSlot1 = new ProfileSlot(mcState.mcPopup.mcProfile1,1);
            oProfileSlot2 = new ProfileSlot(mcState.mcPopup.mcProfile2,2);
            oProfileSlot3 = new ProfileSlot(mcState.mcPopup.mcProfile3,3);
         }
         else
         {
            this["oProfileSlot" + _iProfileID].destroy();
            this["oProfileSlot" + _iProfileID] = new ProfileSlot(mcState.mcPopup["mcProfile" + _iProfileID],_iProfileID);
         }
      }
   }
}
