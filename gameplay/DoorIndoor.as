package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.AttackEvent;
   import gameplay.events.DoorEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.PlayerEvent;
   import gameplay.events.RoomEvent;
   import library.basic.StateManaged;
   import library.sounds.SoundManager;
   
   public class DoorIndoor extends StateManaged implements IEventDispatcher
   {
      
      private static const sSTATE_OPENED:String = "opened";
      
      private static const sSTATE_IDLE:String = "idle";
      
      private static const sSTATE_OPENING:String = "opening";
      
      private static const sSTATE_CLOSING:String = "closing";
       
      
      protected var bToBreak:Boolean;
      
      protected var bLocked:Boolean;
      
      private var bRoomCleared:Boolean;
      
      protected var oWorldActiveZone:Rectangle;
      
      private var bEnter:Boolean;
      
      private var bNeedChamberKey:Boolean;
      
      private var bNeedDungeonKeys:Boolean;
      
      private var bExit:Boolean;
      
      private var oEventDisp:EventDispatcher;
      
      private var oWorldZone:Rectangle;
      
      protected var oNormal:Point;
      
      private var oProfile:Profile;
      
      private var oExit:DoorIndoor;
      
      private var bFirmClosed:Boolean;
      
      private var oActivator:Activator;
      
      private var oWorldIn:Point;
      
      protected var oRoom:Room;
      
      private var bOpened:Boolean;
      
      private var oWorldOut:Point;
      
      protected var uUnlockType:uint;
      
      private var bRoomToClear:Boolean;
      
      public function DoorIndoor(_mcRef:MovieClip, _oRoom:Room, _oWorldMatrix:Matrix, _bOpened:Boolean = true, _bRoomToClear:Boolean = false, _bLocked:Boolean = false, _bToBreak:Boolean = false, _bNeedDungeonKeys:Boolean = false, _bNeedChamberKey:Boolean = false, _bFirmDoor:Boolean = false)
      {
         super(_mcRef);
         oExit = null;
         bEnter = false;
         bExit = false;
         bOpened = _bOpened;
         bFirmClosed = _bFirmDoor;
         bRoomToClear = _bRoomToClear;
         bRoomCleared = _bOpened;
         bLocked = _bLocked;
         bToBreak = _bToBreak;
         bNeedChamberKey = _bNeedChamberKey;
         bNeedDungeonKeys = _bNeedDungeonKeys;
         oRoom = _oRoom;
         oEventDisp = new EventDispatcher(this);
         oActivator = new Activator(_mcRef);
         oProfile = Profile.Instance;
         oNormal = new Point(0,1);
         oNormal = _oWorldMatrix.deltaTransformPoint(oNormal);
         if(Math.abs(oNormal.x) < 0.001)
         {
            oNormal.x = 0;
         }
         if(Math.abs(oNormal.y) < 0.001)
         {
            oNormal.y = 0;
         }
         oWorldZone = new Rectangle(-Data.iTILE_WIDTH / 2,-Data.iTILE_HEIGHT / 2,Data.iTILE_WIDTH,Data.iTILE_HEIGHT);
         var _oPos:Point = _oWorldMatrix.transformPoint(new Point(0,0));
         oWorldZone.offsetPoint(_oPos);
         oWorldActiveZone = new Rectangle(-Data.iTILE_WIDTH / 2,-Data.iTILE_HEIGHT / 2,Data.iTILE_WIDTH,Data.iTILE_HEIGHT);
         _oPos = _oWorldMatrix.transformPoint(new Point(0,Data.iTILE_HEIGHT));
         oWorldActiveZone.offsetPoint(_oPos);
         oWorldIn = new Point(0,-Data.iTILE_HEIGHT);
         oWorldIn = _oWorldMatrix.transformPoint(oWorldIn);
         oWorldOut = new Point(0,Data.iTILE_HEIGHT);
         oWorldOut = _oWorldMatrix.transformPoint(oWorldOut);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_DESTROY,destroy);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove,false,20,true);
         addState(sSTATE_IDLE,stateIdle);
         addState(sSTATE_OPENING,stateOpening);
         addState(sSTATE_OPENED,stateOpened,stateLoadOpened);
         addState(sSTATE_CLOSING,stateClosing);
         if(_bOpened)
         {
            setState(sSTATE_OPENED);
            if(bRoomToClear)
            {
               oRoom.addWeakEventListener(RoomEvent.EVENT_ROOM_CLEARED,onClearedRoom);
               _oGameDisp.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
            }
         }
         else if(!bFirmClosed)
         {
            if(bToBreak)
            {
               setState(sSTATE_IDLE);
               _oGameDisp.addWeakEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
            }
            else
            {
               setState(sSTATE_IDLE);
               if(bLocked)
               {
                  _oGameDisp.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
               }
               if(bRoomToClear)
               {
                  oRoom.addWeakEventListener(RoomEvent.EVENT_ROOM_CLEARED,onClearedRoom);
                  _oGameDisp.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
               }
            }
         }
         else
         {
            setState(sSTATE_IDLE);
         }
         oActivator.setOnActivation(onActivation);
         oActivator.setOnDeactivation(onDeactivation);
         if(oActivator.isActivated())
         {
            onActivation();
         }
         else
         {
            onDeactivation();
         }
      }
      
      private function stateIdle() : void
      {
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function stateOpening() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_OPENED);
         }
      }
      
      private function exitDoor() : void
      {
         oRoom.enterRoom(new Point(mcRef.x,mcRef.y));
         bExit = true;
         if(Math.abs(oNormal.x) > 0.001)
         {
            Player.Instance.setPosition(oWorldIn.x,oWorldIn.y + 14);
            Player.Instance.walkTo(oWorldOut.x,oWorldOut.y + 14,true,onPlayerWalkFinished);
         }
         else
         {
            Player.Instance.setPosition(oWorldIn.x,oWorldIn.y);
            Player.Instance.walkTo(oWorldOut.x,oWorldOut.y,false,onPlayerWalkFinished);
         }
      }
      
      private function onPlayerMove(_e:MovingBodyEvent) : void
      {
         var _oFeet:Rectangle = null;
         if(bEnter || bExit)
         {
            return;
         }
         if(bFirmClosed)
         {
            return;
         }
         if(!bOpened)
         {
            return;
         }
         var _nDirX:Number = _e.newWorldPosition.x - _e.lastWorldPosition.x;
         var _nDirY:Number = _e.newWorldPosition.y - _e.lastWorldPosition.y;
         if(_nDirX > 0 && oNormal.x < 0 || _nDirX < 0 && oNormal.x > 0 || _nDirY > 0 && oNormal.y < 0 || _nDirY < 0 && oNormal.y > 0)
         {
            _oFeet = _e.localFeetZone;
            _oFeet.offsetPoint(_e.newWorldPosition);
            if(_oFeet.intersects(oWorldZone))
            {
               _e.stopImmediatePropagation();
               Player.Instance.setPosition(_e.lastWorldPosition.x,_e.lastWorldPosition.y);
               enterDoor();
            }
         }
      }
      
      protected function unlockDoor(_bFromOtherSide:Boolean = false) : void
      {
         if(!bLocked)
         {
            return;
         }
         bLocked = false;
         if(!_bFromOtherSide)
         {
            oExit.unlockDoor(true);
            dispatchEvent(new DoorEvent(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR,new Point(mcRef.x,mcRef.y),uUnlockType));
         }
         else
         {
            dispatchEvent(new DoorEvent(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR_FROM_OTHER_SIDE,new Point(mcRef.x,mcRef.y)));
         }
         GameDispatcher.Instance.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
      }
      
      protected function onPlayerWalkFinished() : void
      {
         if(bEnter)
         {
            Player.Instance.getControl();
            bEnter = false;
            oExit.exitDoor();
         }
         else if(bExit)
         {
            bExit = false;
            if(bRoomToClear && !bRoomCleared && oRoom.hadBossInRoom())
            {
               oRoom.addWeakEventListener(RoomEvent.EVENT_ROOM_CLEARED,onClearedRoom);
               GameDispatcher.Instance.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
               closeDoor();
            }
            Level.Instance.removeDoorMask();
            Player.Instance.releaseControl();
         }
      }
      
      protected function enterDoor() : void
      {
         bEnter = true;
         if(Math.abs(oNormal.x) > 0.001)
         {
            Player.Instance.walkTo(oWorldIn.x,oWorldIn.y + 14,false,onPlayerWalkFinished);
         }
         else
         {
            Player.Instance.walkTo(oWorldIn.x,oWorldIn.y + 14,true,onPlayerWalkFinished);
         }
         oRoom.leaveRoom(new Point(mcRef.x,mcRef.y));
      }
      
      protected function openDoor() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndUnlockDoor",1,1,true);
         setState(sSTATE_OPENING);
      }
      
      protected function onPlayerProjectile(_e:AttackEvent) : void
      {
         if(_e.itemUsed == ItemID.uVOLCANIC_URCHIN)
         {
            if(oWorldZone.intersects(_e.worldAttackZone))
            {
               _e.stopImmediatePropagation();
               breakDoor();
            }
         }
      }
      
      private function refreshDoorToClear() : void
      {
         if(!bRoomToClear)
         {
            return;
         }
         if(!oRoom.hadBossInRoom() || !oRoom.isActivated() || !bOpened || !bRoomToClear || !bRoomCleared)
         {
            return;
         }
         if(!oRoom.isCleared())
         {
            closeDoor();
            bRoomCleared = false;
            oRoom.addWeakEventListener(RoomEvent.EVENT_ROOM_CLEARED,onClearedRoom);
            GameDispatcher.Instance.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
         }
      }
      
      public function hasToBeCleared() : Boolean
      {
         return bRoomToClear;
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      protected function closeDoor() : void
      {
         bOpened = false;
         setState(sSTATE_CLOSING);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function onClearedRoom(_e:RoomEvent) : void
      {
         if(!bRoomToClear)
         {
            return;
         }
         bRoomCleared = true;
         oRoom.removeEventListener(RoomEvent.EVENT_ROOM_CLEARED,onClearedRoom);
         dispatchEvent(new DoorEvent(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,new Point(mcRef.x,mcRef.y)));
         if(!bLocked)
         {
            openDoor();
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      protected function onActivation() : void
      {
         trace(">DOOR : onActivation");
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove,false,20,true);
         if(!bOpened)
         {
            if(!bFirmClosed)
            {
               if(bToBreak)
               {
                  _oGameDisp.addWeakEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
               }
               else if(bLocked)
               {
                  _oGameDisp.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
               }
            }
         }
      }
      
      public function isLocked() : Boolean
      {
         return bLocked;
      }
      
      public function hasToBeBroken() : Boolean
      {
         return bToBreak;
      }
      
      private function stateLoadOpened() : void
      {
         bOpened = true;
      }
      
      protected function onActionTriggered(_e:PlayerEvent) : void
      {
         var nDirX:Number = NaN;
         var nDirY:Number = NaN;
         var _bHasWhatNeeded:Boolean = false;
         if(bFirmClosed || bOpened)
         {
            return;
         }
         if(oWorldActiveZone.contains(_e.worldPositionX,_e.worldPositionY))
         {
            nDirX = Math.cos(_e.direction);
            if(Math.abs(nDirX) < 0.001)
            {
               nDirX = 0;
            }
            nDirY = -Math.sin(_e.direction);
            if(Math.abs(nDirY) < 0.001)
            {
               nDirY = 0;
            }
            trace("Is facing door : ",nDirX,nDirY,oNormal);
            if(nDirX > 0 && oNormal.x < 0 || nDirX < 0 && oNormal.x > 0 || nDirY > 0 && oNormal.y < 0 || nDirY < 0 && oNormal.y > 0)
            {
               _bHasWhatNeeded = false;
               if(bLocked)
               {
                  if(bNeedChamberKey)
                  {
                     _bHasWhatNeeded = oProfile.hasBossChamberKey();
                     uUnlockType = DoorEvent.uDOOR_UNLOCKED_BY_CHAMBER_KEY;
                     if(!_bHasWhatNeeded)
                     {
                        Storyline.play("DoorBoss");
                     }
                  }
                  else if(bNeedDungeonKeys)
                  {
                     _bHasWhatNeeded = oProfile.hasBothDungeonKeyParts();
                     uUnlockType = DoorEvent.uDOOR_UNLOCKED_BY_DUNGEON_KEYS;
                     if(!_bHasWhatNeeded)
                     {
                        Storyline.play("DoorLair");
                     }
                  }
                  else
                  {
                     _bHasWhatNeeded = oProfile.hasKey();
                     uUnlockType = DoorEvent.uDOOR_UNLOCKED_BY_KEY;
                     if(!_bHasWhatNeeded)
                     {
                        if(bRoomToClear && !bRoomCleared)
                        {
                           Storyline.play("DoorKillAndKey");
                        }
                        else
                        {
                           Storyline.play("DoorKey");
                        }
                     }
                  }
               }
               else if(bRoomToClear)
               {
                  _bHasWhatNeeded = false;
                  Storyline.play("DoorKill");
               }
               if(_bHasWhatNeeded)
               {
                  unlockDoor();
                  if(bRoomToClear && !bRoomCleared)
                  {
                     Storyline.play("DoorKill");
                  }
                  else
                  {
                     openDoor();
                  }
               }
               _e.stopImmediatePropagation();
            }
         }
      }
      
      public function isLinked() : Boolean
      {
         return oExit != null;
      }
      
      private function stateClosing() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_IDLE);
         }
      }
      
      private function stateOpened() : void
      {
         refreshDoorToClear();
      }
      
      public function setExitDoor(_oDoor:DoorIndoor) : void
      {
         oExit = _oDoor;
      }
      
      protected function breakDoor(_bFromOtherSide:Boolean = false) : void
      {
         if(!bToBreak)
         {
            return;
         }
         bToBreak = false;
         GameDispatcher.Instance.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         openDoor();
         if(!_bFromOtherSide)
         {
            oExit.breakDoor(true);
         }
      }
      
      protected function onDeactivation() : void
      {
         trace(">DOOR : onDeactivation");
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         _oGameDisp.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
      }
      
      public function destroy(_e:Event = null) : void
      {
         if(_e != null)
         {
            dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_INDOOR_DOOR,this));
         }
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggered);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(GameEvent.EVENT_DESTROY,destroy);
         oEventDisp = null;
         if(oActivator != null)
         {
            oActivator.destroy();
            oActivator = null;
         }
         if(mcRef.parent != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         mcRef = null;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
   }
}
