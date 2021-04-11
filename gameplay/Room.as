package gameplay
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import gameplay.events.RoomEvent;
   
   public class Room extends EventDispatcher
   {
       
      
      private var bWorldRoom:Boolean;
      
      private var bActivated:Boolean;
      
      private var bHadBoss:Boolean;
      
      private var bHasBoss:Boolean;
      
      private var bCleared:Boolean;
      
      private var uRoomId:uint;
      
      private var uRemainingEnemies:uint;
      
      public function Room(_uId:uint, _bWorldRoom:Boolean = false)
      {
         super();
         uRoomId = _uId;
         bCleared = false;
         uRemainingEnemies = 0;
         bActivated = false;
         bWorldRoom = _bWorldRoom;
         bHasBoss = false;
         bHadBoss = false;
      }
      
      public function destroy(_e:Event = null) : void
      {
      }
      
      public function isWorldRoom() : Boolean
      {
         return bWorldRoom;
      }
      
      public function isActivated() : Boolean
      {
         return bActivated;
      }
      
      public function getRoomId() : uint
      {
         return uRoomId;
      }
      
      public function enterRoom(_oWorldSource:Point = null) : void
      {
         bActivated = true;
         dispatchEvent(new RoomEvent(RoomEvent.EVENT_ENTER_ROOM,uRoomId,_oWorldSource));
         trace(">> !! ACTIVATE ROOM ",uRoomId);
      }
      
      public function removeBoss() : void
      {
         if(!bHasBoss)
         {
            return;
         }
         bHasBoss = false;
         removeAnEnemy();
      }
      
      public function hadBossInRoom() : Boolean
      {
         return bHadBoss;
      }
      
      public function isCleared() : Boolean
      {
         return bCleared;
      }
      
      public function hasBossInRoom() : Boolean
      {
         return bHasBoss;
      }
      
      public function leaveRoom(_oWorldSource:Point) : void
      {
         bActivated = false;
         dispatchEvent(new RoomEvent(RoomEvent.EVENT_LEAVE_ROOM,uRoomId,_oWorldSource));
         trace(">> !! DEACTIVATE ROOM ",uRoomId);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         super.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function removeAnEnemy() : void
      {
         --uRemainingEnemies;
         trace(">> !! ENN REMAINS @",uRoomId,":",uRemainingEnemies);
         if(uRemainingEnemies <= 0)
         {
            bCleared = true;
            dispatchEvent(new RoomEvent(RoomEvent.EVENT_ROOM_CLEARED,uRoomId));
         }
      }
      
      public function addAnEnemy() : void
      {
         bCleared = false;
         ++uRemainingEnemies;
         trace(">> !! ENN ADDED AT ",uRoomId,": now :",uRemainingEnemies);
      }
      
      public function addBoss() : void
      {
         if(bHasBoss)
         {
            return;
         }
         bHadBoss = true;
         bHasBoss = true;
         addAnEnemy();
      }
   }
}
