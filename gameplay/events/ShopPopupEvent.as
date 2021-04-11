package gameplay.events
{
   import flash.events.Event;
   
   public class ShopPopupEvent extends Event
   {
      
      public static const EVENT_OPEN_POPUP_SHOP:String = "Shop_PopupEvent_open";
      
      public static const EVENT_CLOSE_POPUP_SHOP:String = "Shop_PopupEvent_close";
       
      
      public function ShopPopupEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new ShopPopupEvent(type);
      }
   }
}
