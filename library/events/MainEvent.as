package library.events
{
   import flash.events.Event;
   
   public class MainEvent extends Event
   {
      
      public static const EVENT_PAUSE:String = "pause";
      
      public static const EVENT_DESTROY:String = "destroy";
      
      public static const EVENT_RESUME:String = "resume";
      
      public static const EVENT_UPDATE:String = "update";
       
      
      public function MainEvent(_type:String, _bubbles:Boolean, _cancelable:Boolean)
      {
         super(_type,_bubbles,_cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("MainEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new MainEvent(type,bubbles,cancelable);
      }
   }
}
