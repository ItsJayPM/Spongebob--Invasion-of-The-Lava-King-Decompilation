package builder.popups
{
   import builder.events.BuilderEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   
   public class PopupIndoor extends Popup implements Idestroyable
   {
       
      
      private var btnYES:SimpleButton;
      
      private var sDoorLink:String;
      
      public function PopupIndoor(_mcRef:MovieClip)
      {
         super(_mcRef);
         sDoorLink = "--";
         if(Main.instance.builderManager.currentDoor.sDoorLink != null)
         {
            sDoorLink = Main.instance.builderManager.currentDoor.sDoorLink;
         }
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         trace("Over: " + _e.target.name);
      }
      
      public function destroy(_e:Event = null) : void
      {
         setButton(btnYES,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_DESTROY,destroy,false);
         btnYES = null;
         mcRef = null;
      }
      
      override protected function state_disappear() : void
      {
         if(stateComplete)
         {
            Main.instance.builderManager.removePopup(this);
         }
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnYES:
               if(mcState.mcPopup.txtLink.text == "" || mcState.mcPopup.txtLink.text == "--")
               {
                  sDoorLink = "--";
               }
               else
               {
                  sDoorLink = mcState.mcPopup.txtLink.text;
               }
               Main.instance.builderManager.setLinkData(sDoorLink,null);
               close();
         }
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
               mcState.mcPopup.txtLink.text = sDoorLink;
               break;
            case sSTATE_IDLE:
               mcState.mcPopup.txtLink.text = sDoorLink;
               mcState.mcPopup.txtLink.restrict = "0-9";
               btnYES = mcState.mcPopup.btnYes;
               setButton(btnYES,onClick,onRollOver);
               break;
            case sSTATE_DISAPPEAR:
               mcState.mcPopup.txtLink.text = sDoorLink;
         }
      }
   }
}
