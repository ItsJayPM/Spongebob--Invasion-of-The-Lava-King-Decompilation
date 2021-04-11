package popups
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   
   public class PopupBlocker extends Popup implements Idestroyable
   {
       
      
      public function PopupBlocker(_mcRef:MovieClip)
      {
         super(_mcRef);
         addState(sSTATE_APPEAR,null,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,null,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_IDLE);
      }
      
      public function destroy(_e:Event = null) : void
      {
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
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
               break;
            case sSTATE_IDLE:
               break;
            case sSTATE_DISAPPEAR:
         }
      }
   }
}
