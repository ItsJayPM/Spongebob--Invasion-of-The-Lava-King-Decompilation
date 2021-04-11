package gameplay.events
{
   import flash.events.Event;
   
   public class MapGenerateEvent extends Event
   {
      
      public static const EVENT_CREATE_CHEST:String = "MapGenEv_createChest";
      
      public static const EVENT_CREATE_PATRICK:String = "MapGenEv_createPatrick";
      
      public static const EVENT_CREATE_PUZZLE_NODE:String = "MapGenerateEvent_createPuzzleNode";
      
      public static const EVENT_CREATE_ENEMY:String = "MapGenerateEvent_createEnemy";
      
      public static const EVENT_DESTROY_BREAKABLE_PROP:String = "MapGenEv_destroyBreakProp";
      
      public static const EVENT_DESTROY_INTRO_NODE:String = "MapGenEv_destroyIntroNode";
      
      public static const EVENT_DESTROY_TUTORIAL_NODE:String = "MapGenEv_destroyTutorialNode";
      
      public static const EVENT_DESTROY_OUTDOOR_DOOR:String = "MapgenEv_destroyOutdoorDoor";
      
      public static const EVENT_CREATE_FLOOR_ITEM:String = "MapGenerateEvent_createfloorItem";
      
      public static const EVENT_CREATE_FIXED_OBJECT:String = "MapGenEv_createFixedObj";
      
      public static const EVENT_DESTROY_SANDY:String = "MapGenEv_destroySandy";
      
      public static const EVENT_DESTROY_MOVING_BLOCK:String = "MapGenerateEvent_destroyMovingBlock";
      
      public static const EVENT_CREATE_SQUIDWARD:String = "MapGenEv_createSquidward";
      
      public static const EVENT_DESTROY_KRAB:String = "MapGenEv_destroyKrab";
      
      public static const EVENT_CREATE_INTRO_NODE:String = "MapGenEv_createIntroNode";
      
      public static const EVENT_DESTROY_CHEST:String = "MapGenEv_destroyChest";
      
      public static const EVENT_DESTROY_PATRICK:String = "MapGenEv_destroyPatrick";
      
      public static const EVENT_DESTROY_PUZZLE_NODE:String = "MapGenerateEvent_destroyPuzzleNode";
      
      public static const EVENT_CREATE_INDOOR_DOOR:String = "MapgenEv_createIndoorDoor";
      
      public static const EVENT_DESTROY_ENEMY:String = "MapGenerateEvent_destroyEnemy";
      
      public static const EVENT_CREATE_BREAKABLE_PROP:String = "MapGenEv_createBreakProp";
      
      public static const EVENT_CREATE_OUTDOOR_DOOR:String = "MapgenEv_createOutdoorDoor";
      
      public static const EVENT_CREATE_MOVING_BLOCK:String = "MapGenerateEvent_createMovingBlock";
      
      public static const EVENT_DESTROY_SQUIDWARD:String = "MapGenEv_destroySquidward";
      
      public static const EVENT_CREATE_TUTORIAL_NODE:String = "MapGenEv_createTutorialNode";
      
      public static const EVENT_CREATE_KRAB:String = "MapGenEv_createSandy";
      
      public static const EVENT_DESTROY_INDOOR_DOOR:String = "MapgenEv_destroyIndoorDoor";
      
      public static const EVENT_DESTROY_FIXED_OBJECT:String = "MapGenEv_destroyFixedObj";
      
      public static const EVENT_CREATE_SANDY:String = "MapGenEv_createSandy";
      
      public static const EVENT_DESTROY_FLOOR_ITEM:String = "MapGenerateEvent_destroyFloorItem";
       
      
      private var oInstance:Object;
      
      public function MapGenerateEvent(_sType:String, _oInstance:Object)
      {
         super(_sType);
         oInstance = _oInstance;
      }
      
      override public function clone() : Event
      {
         return new MapGenerateEvent(type,oInstance);
      }
      
      public function get instance() : Object
      {
         return oInstance;
      }
   }
}
