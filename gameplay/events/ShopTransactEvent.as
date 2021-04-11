package gameplay.events
{
   import flash.events.Event;
   
   public class ShopTransactEvent extends Event
   {
      
      public static const EVENT_BUY_ITEM:String = "ShopTransEvent_buyItem";
       
      
      private var uQty:uint;
      
      private var uItemId:uint;
      
      private var uCost:uint;
      
      public function ShopTransactEvent(_sType:String, _uItemId:uint, _uQty:uint = 1, _uCost:uint = 0)
      {
         super(_sType);
         uItemId = _uItemId;
         uQty = _uQty;
         uCost = _uCost;
      }
      
      public function get quantity() : uint
      {
         return uQty;
      }
      
      override public function clone() : Event
      {
         return new ShopTransactEvent(type,uItemId,uQty,uCost);
      }
      
      public function get cost() : uint
      {
         return uCost;
      }
      
      public function get itemId() : uint
      {
         return uItemId;
      }
   }
}
