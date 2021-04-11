package gameplay.events
{
   import flash.events.Event;
   import gameplay.Map;
   
   public class LevelEvent extends Event
   {
      
      public static const EVENT_FINISH_MAP_CREATION:String = "LevelEvent_eventMapCreated";
      
      public static const EVENT_CREATE_MAP:String = "LevelEvent_eventCreateMap";
       
      
      private var oMap:Map;
      
      public function LevelEvent(_sType:String, _oMap:Map = null)
      {
         super(_sType);
         oMap = _oMap;
      }
      
      override public function clone() : Event
      {
         return new LevelEvent(type,oMap);
      }
      
      public function get map() : Map
      {
         return oMap;
      }
   }
}
