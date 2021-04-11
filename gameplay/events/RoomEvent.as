package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Point;
   
   public class RoomEvent extends Event
   {
      
      public static const EVENT_ROOM_PUZZLE_SOLVED:String = "RoomEvent_puzzleSolved";
      
      public static const EVENT_LEAVE_ROOM:String = "RoomEvent_eventLeaveRoom";
      
      public static const EVENT_ROOM_CLEARED:String = "RoomEvent_roomCleared";
      
      public static const EVENT_ROOM_INTRO_TILE:String = "RoomEvent_introTile";
      
      public static const EVENT_ENTER_ROOM:String = "RoomEvent_eventEnterRoom";
      
      public static const EVENT_ROOM_TUTORIAL_TILE:String = "RoomEvent_tutorialTile";
       
      
      private var oPos:Point;
      
      private var uRoomId:uint;
      
      public function RoomEvent(_sType:String, _uRoomId:uint, _oWorldPosition:Point = null)
      {
         super(_sType);
         uRoomId = _uRoomId;
         if(_oWorldPosition != null)
         {
            oPos = _oWorldPosition.clone();
         }
      }
      
      public function get worldPosition() : Point
      {
         if(oPos == null)
         {
            return null;
         }
         return oPos.clone();
      }
      
      override public function clone() : Event
      {
         return new RoomEvent(type,uRoomId,oPos);
      }
      
      public function get roomId() : uint
      {
         return uRoomId;
      }
   }
}
