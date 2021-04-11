package gameplay.events
{
   import flash.events.Event;
   
   public class TextboxEvent extends Event
   {
      
      public static const EVENT_CLOSE_TEXTBOX:String = "TextboxEvent_close";
      
      public static const EVENT_OPEN_TEXTBOX:String = "TextboxEvent_open";
       
      
      public function TextboxEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new TextboxEvent(type);
      }
   }
}
