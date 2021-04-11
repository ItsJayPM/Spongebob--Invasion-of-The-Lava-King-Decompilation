package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ItemEvent extends Event
   {
      
      public static const EVENT_FINISH_SHOWING_ITEM:String = "ItemEvent_finishShowingItem";
      
      public static const EVENT_PICKING_UP_ITEM_WITH_BOOMERANG:String = "ItemEvent_pickingUpItemBoomerang";
      
      public static const EVENT_PICKING_UP_ITEM_FROM_CHEST:String = "ItemEvent_pickFromChest";
      
      public static const EVENT_FINISH_SHOWING_NEW_ITEM:String = "ItemEvent_finishShowingNewItem";
      
      public static const EVENT_PICKING_UP_ITEM:String = "ItemEvent_pickingUpItem";
       
      
      private var uItemId:uint;
      
      private var oSource:Point;
      
      public function ItemEvent(_sType:String, _uItem:uint, _oWorldSource:Point = null)
      {
         super(_sType);
         uItemId = _uItem;
         if(_oWorldSource != null)
         {
            oSource = _oWorldSource.clone();
         }
      }
      
      public function get worldSource() : Point
      {
         if(oSource == null)
         {
            return null;
         }
         return oSource.clone();
      }
      
      override public function clone() : Event
      {
         return new ItemEvent(type,uItemId,oSource);
      }
      
      public function get itemId() : uint
      {
         return uItemId;
      }
   }
}
