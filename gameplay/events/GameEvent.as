package gameplay.events
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const EVENT_PLAYER_UPDATE:String = "GameEvent_playerUpdate";
      
      public static const EVENT_PLAYER_RESUME:String = "GameEvent_playerResume";
      
      public static const EVENT_UPDATE:String = "GameEvent_update";
      
      public static const EVENT_PAUSE:String = "GameEvent_pause";
      
      public static const EVENT_RESUME:String = "GameEvent_resume";
      
      public static const EVENT_DESTROY:String = "GameEvent_destroy";
      
      public static const EVENT_PLAYER_PAUSE:String = "GameEvent_playerPause";
      
      public static const EVENT_START:String = "GameEvent_start";
       
      
      public function GameEvent(_sType:String)
      {
         super(_sType);
      }
   }
}
