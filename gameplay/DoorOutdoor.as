package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import gameplay.events.AttackEvent;
   import gameplay.events.DoorEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.PlayerEvent;
   
   public class DoorOutdoor extends DoorIndoor
   {
       
      
      private var oWorldSource:Point;
      
      public function DoorOutdoor(_mcRef:MovieClip, _oRoom:Room, _oWorldMatrix:Matrix, _bOpened:Boolean = true, _bRoomToClear:Boolean = false, _bLocked:Boolean = false, _bToBreak:Boolean = false, _bNeedDungeonKeys:Boolean = false, _bNeedChamberKey:Boolean = false, _bFirmDoor:Boolean = false)
      {
         super(_mcRef,_oRoom,_oWorldMatrix,_bOpened,_bRoomToClear,_bLocked,_bToBreak,_bNeedDungeonKeys,_bNeedChamberKey,_bFirmDoor);
         oWorldSource = new Point(_mcRef.x,_mcRef.y);
      }
      
      override protected function unlockDoor(_bFromOtherSide:Boolean = false) : void
      {
         if(!isLocked())
         {
            return;
         }
         bLocked = false;
         dispatchEvent(new DoorEvent(DoorEvent.EVENT_UNLOCK_OUTDOOR_DOOR,new Point(mcRef.x,mcRef.y),uUnlockType));
         GameDispatcher.Instance.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
      }
      
      override protected function enterDoor() : void
      {
         super.enterDoor();
         dispatchEvent(new DoorEvent(DoorEvent.EVENT_ENTERING_OUTDOOR_DOOR,oWorldSource));
         oRoom.leaveRoom(new Point(mcRef.x,mcRef.y));
      }
      
      override public function destroy(_e:Event = null) : void
      {
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_OUTDOOR_DOOR,this));
         super.destroy();
      }
      
      override protected function onPlayerWalkFinished() : void
      {
         Player.Instance.getControl();
         dispatchEvent(new DoorEvent(DoorEvent.EVENT_IN_OUTDOOR_DOOR,oWorldSource));
      }
      
      override protected function breakDoor(_bFromOtherSide:Boolean = false) : void
      {
         if(!hasToBeBroken())
         {
            return;
         }
         bToBreak = false;
         GameDispatcher.Instance.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         openDoor();
      }
      
      override public function setExitDoor(_oDoor:DoorIndoor) : void
      {
      }
   }
}
