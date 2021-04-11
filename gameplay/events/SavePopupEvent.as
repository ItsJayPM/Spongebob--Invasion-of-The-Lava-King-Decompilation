package gameplay.events
{
   import flash.events.Event;
   
   public class SavePopupEvent extends Event
   {
      
      public static const EVENT_CLOSE_POPUP_SAVE:String = "Save_PopupEvent_close";
      
      public static const EVENT_OPEN_POPUP_SAVE:String = "Save_PopupEvent_open";
       
      
      public function SavePopupEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new SavePopupEvent(type);
      }
   }
}
