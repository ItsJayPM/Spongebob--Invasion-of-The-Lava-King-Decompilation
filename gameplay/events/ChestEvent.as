package gameplay.events
{
   import flash.events.Event;
   
   public class ChestEvent extends Event
   {
      
      public static const EVENT_UNLOCK_CHEST:String = "ChestEvent_unlockChest";
       
      
      public function ChestEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new ChestEvent(type);
      }
   }
}
