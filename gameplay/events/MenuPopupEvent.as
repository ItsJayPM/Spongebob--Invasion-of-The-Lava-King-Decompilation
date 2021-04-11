package gameplay.events
{
   import flash.events.Event;
   
   public class MenuPopupEvent extends Event
   {
      
      public static const EVENT_OPEN_POPUP_MENU:String = "Menu_PopupEvent_open";
      
      public static const EVENT_CLOSE_POPUP_MENU:String = "Menu_PopupEvent_close";
       
      
      public function MenuPopupEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new MenuPopupEvent(type);
      }
   }
}
