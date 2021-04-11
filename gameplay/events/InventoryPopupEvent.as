package gameplay.events
{
   import flash.events.Event;
   
   public class InventoryPopupEvent extends Event
   {
      
      public static const EVENT_OPEN_POPUP_INVENTORY:String = "Inventory_PopupEvent_open";
      
      public static const EVENT_CLOSE_POPUP_INVENTORY:String = "Inventory_PopupEvent_close";
       
      
      public function InventoryPopupEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new InventoryPopupEvent(type);
      }
   }
}
