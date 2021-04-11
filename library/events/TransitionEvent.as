package library.events
{
   import flash.events.Event;
   
   public class TransitionEvent extends Event
   {
      
      public static const EVENT_COMPLETE:String = "complete";
      
      public static const EVENT_FULL_SCREEN:String = "full";
       
      
      public function TransitionEvent(_type:String, _bubbles:Boolean, _cancelable:Boolean = true)
      {
         super(_type,_bubbles,_cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TransitionEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new TransitionEvent(type,bubbles,cancelable);
      }
   }
}
