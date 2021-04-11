package gameplay.events
{
   import flash.events.Event;
   
   public class TransitionFocusEvent extends Event
   {
      
      public static const EVENT_TRANSITION_MIDDLE:String = "transitionMiddle";
      
      public static const EVENT_TRANSITION_COMPLETED:String = "transitionFinish";
       
      
      public function TransitionFocusEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new TransitionFocusEvent(type);
      }
   }
}
