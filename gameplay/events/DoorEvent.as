package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Point;
   
   public class DoorEvent extends Event
   {
      
      public static const EVENT_ENTERING_OUTDOOR_DOOR:String = "DoorEvent_enteringOutdoorDoor";
      
      public static const EVENT_UNLOCK_INDOOR_DOOR:String = "DoorEvent_unlockIndoorDoor";
      
      public static const EVENT_IN_OUTDOOR_DOOR:String = "DoorEvent_inOutdoorDoor";
      
      public static const EVENT_UNLOCK_OUTDOOR_DOOR:String = "DoorEvent_unlockOutdoorDoor";
      
      public static const EVENT_ENTERING_INDOOR_DOOR:String = "DoorEvent_enteringDoor";
      
      public static const EVENT_UNLOCK_INDOOR_DOOR_FROM_OTHER_SIDE:String = "DoorEvent_unlockIndoorDoorOther";
      
      public static const uDOOR_UNLOCKED_BY_DUNGEON_KEYS:uint = 1;
      
      public static const EVENT_OPEN_DOOR_TO_CLEAR:String = "DoorEvent_openDoorToClear";
      
      public static const uDOOR_UNLOCKED_BY_CHAMBER_KEY:uint = 2;
      
      public static const uDOOR_UNLOCKED_BY_KEY:uint = 0;
      
      public static const EVENT_EXIT_INDOOR_DOOR:String = "DoorEvent_exitIndoorDoor";
       
      
      private var uUnlockType:uint;
      
      private var oPos:Point;
      
      public function DoorEvent(_sType:String, _oWorldSource:Point = null, _uUnlocking:uint = 0)
      {
         super(_sType);
         if(_oWorldSource != null)
         {
            oPos = _oWorldSource.clone();
         }
         uUnlockType = _uUnlocking;
      }
      
      public function get unlockedBy() : uint
      {
         return uUnlockType;
      }
      
      public function get worldSource() : Point
      {
         if(oPos == null)
         {
            return null;
         }
         return oPos.clone();
      }
      
      override public function clone() : Event
      {
         return new DoorEvent(type,oPos,uUnlockType);
      }
   }
}
