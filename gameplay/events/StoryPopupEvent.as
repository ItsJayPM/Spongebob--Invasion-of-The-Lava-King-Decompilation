package gameplay.events
{
   import flash.events.Event;
   
   public class StoryPopupEvent extends Event
   {
      
      public static const EVENT_OPEN_POPUP_STORY:String = "Story_PopupEvent_open";
      
      public static const EVENT_CLOSE_POPUP_STORY:String = "Story_PopupEvent_close";
       
      
      public function StoryPopupEvent(_sType:String)
      {
         super(_sType);
      }
      
      override public function clone() : Event
      {
         return new StoryPopupEvent(type);
      }
   }
}
