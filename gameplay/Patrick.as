package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.AttackEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.ItemEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.PlayerEvent;
   import gameplay.events.RoomEvent;
   import gameplay.events.TextboxEvent;
   import gameplay.interfaces.ILevelCollidable;
   import library.basic.InactivityPromp;
   import library.basic.StateManaged;
   import library.sounds.SoundManager;
   import library.utils.MoreMath;
   
   public class Patrick extends StateManaged implements IEventDispatcher
   {
      
      private static const sINACTIVITY_NOSWORD:String = "Patrick_NoSword";
      
      private static const sINACTIVITY_NOKEY:String = "Patrick_NoKey";
      
      private static var uTries:uint = 0;
      
      private static const sINACTIVITY_NOPUSH:String = "Patrick_NoPush";
      
      private static var uPhase:uint = 0;
      
      private static const sINACTIVITY_NOKILL:String = "Patrick_NoKill";
      
      private static const sSTATE_IDLE1:String = "idle1";
      
      private static const sSTATE_IDLE2:String = "idle2";
       
      
      private var oInactivity:InactivityPromp;
      
      private var oWorldBody:Rectangle;
      
      private var oEventDisp:EventDispatcher;
      
      private var oRoom:Room;
      
      private var bFlagEasterEgg:Boolean;
      
      public function Patrick(_mcRef:MovieClip, _oRoom:Room)
      {
         super(_mcRef);
         trace(">>> HEY HEY HEY NEW PATRICK : ",_oRoom);
         oRoom = _oRoom;
         addState(sSTATE_IDLE1,stateIdle);
         addState(sSTATE_IDLE2,stateIdle);
         bFlagEasterEgg = false;
         oWorldBody = new Rectangle();
         oWorldBody.width = Data.iTILE_WIDTH;
         oWorldBody.height = Data.iTILE_HEIGHT;
         oWorldBody.x = -Data.iTILE_WIDTH / 2;
         oWorldBody.y = -Data.iTILE_HEIGHT / 2;
         oWorldBody.offset(mcRef.x,mcRef.y);
         oInactivity = new InactivityPromp();
         addListeners();
         oEventDisp = new EventDispatcher(this);
         updateState();
      }
      
      private function playPatrickTalk() : void
      {
         if(MoreMath.getRandomRange(1,3) == 1)
         {
            SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPatrickTalk.mp3",1,1,true);
         }
      }
      
      private function openPopup() : void
      {
         if(oInactivity != null)
         {
            oInactivity.resetAllCue();
         }
         Main.instance.addPopup(Main.sPOPUP_SAVE);
         trace("TALK");
      }
      
      private function stateIdle() : void
      {
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function onPlayerMove(_e:MovingBodyEvent) : void
      {
         if(oInactivity != null)
         {
            oInactivity.resetAllCue();
         }
      }
      
      private function onBlockStart(_e:GameEvent) : void
      {
         if(uTries == 0)
         {
            playPatrickTalk();
            Storyline.goto("Tutorial","StartBlock");
            Storyline.play("Tutorial");
         }
         else if(uTries == 1)
         {
            playPatrickTalk();
            Storyline.goto("Tutorial","GiveUpBlock");
            Storyline.play("Tutorial");
         }
         ++uTries;
      }
      
      private function onLeave(_e:RoomEvent = null) : void
      {
         uPhase = 0;
         Profile.Instance.endTutorial();
         removeTutorialListeners();
      }
      
      private function removeListeners() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onTalk);
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(GameEvent.EVENT_DESTROY,destroy);
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         if(oInactivity != null)
         {
            _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,oInactivity.update);
         }
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
      }
      
      private function addListeners() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         if(Profile.Instance.isTutorial())
         {
            addTutorialListeners();
         }
         _oGameDisp.addEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onTalk);
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         _oGameDisp.addEventListener(GameEvent.EVENT_UPDATE,update,false,0,true);
         if(oInactivity != null)
         {
            _oGameDisp.addEventListener(GameEvent.EVENT_UPDATE,oInactivity.update,false,0,true);
         }
         _oGameDisp.addEventListener(GameEvent.EVENT_PAUSE,pause,false,0,true);
         _oGameDisp.addEventListener(GameEvent.EVENT_RESUME,resume,false,0,true);
         _oGameDisp.addEventListener(GameEvent.EVENT_DESTROY,destroy,false,0,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck,false,3,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck,false,888,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck,false,3,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove,false,-1,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck,false,888,true);
      }
      
      private function bumpOnWall(_oFrom:Point, _oTo:Point, _oWallFrom:Point, _oWallTo:Point) : Object
      {
         var _oI:Point = getIntersectionPoint(_oFrom,_oTo,_oWallFrom,_oWallTo);
         if(_oI == null || isNaN(_oI.x))
         {
            return null;
         }
         var _nLen:Number = Math.sqrt(Math.pow(_oI.x - _oTo.x,2) + Math.pow(_oI.y - _oTo.y,2));
         var _oRet:Object = new Object();
         if(_nLen <= 0)
         {
            _nLen = 0.1;
         }
         _oRet.oBumpResult = new Point();
         var _oN:Point = new Point(-_oWallTo.y + _oWallFrom.y,_oWallTo.x - _oWallFrom.x);
         _oN.normalize(1);
         var _oDisp:Point = _oTo.subtract(_oFrom);
         var _nDot:Number = _oDisp.x * _oN.x + _oDisp.y * _oN.y;
         _oRet.oBumpResult.x = _oDisp.x - 2 * _oN.x * _nDot;
         _oRet.oBumpResult.y = _oDisp.y - 2 * _oN.y * _nDot;
         _oRet.oBumpResult.normalize(_nLen);
         _oRet.oBumpResult.offset(_oI.x,_oI.y);
         var _oU:Point = _oTo.subtract(_oI);
         var _oV:Point = _oWallFrom.subtract(_oI);
         if(Math.abs(_oV.x - 0) <= 0.01 && Math.abs(_oV.y - 0) < 0.01)
         {
            _oV = _oWallTo.subtract(_oI);
         }
         var _nProjScalar:Number = (_oU.x * _oV.x + _oU.y * _oV.y) / (_oV.x * _oV.x + _oV.y * _oV.y);
         var _oSlide:Point = _oV.clone();
         _oSlide.x *= _nProjScalar;
         _oSlide.y *= _nProjScalar;
         var _oAdd:Point = _oFrom.subtract(_oTo);
         _oAdd.normalize(0.1);
         _oI = _oI.add(_oAdd);
         _oRet.oContact = _oI.clone();
         _oRet.oSlideResult = _oSlide.add(_oI);
         return _oRet;
      }
      
      private function getStandardLinearEquation(_oPointA:Point, _oPointB:Point) : Object
      {
         var _nOffset:Number = NaN;
         var _oU:Point = null;
         var _oV:Point = null;
         var _oRet:Object = new Object();
         _oRet.x = 0;
         if(_oPointA.y == _oPointB.y)
         {
            _oRet.a = 0;
            _oRet.b = _oPointA.y;
         }
         else
         {
            _nOffset = 0;
            if(_oPointA.x == _oPointB.x)
            {
               _oRet.a = 0;
               _oRet.b = 0;
               _oRet.x = _oPointA.x;
            }
            else
            {
               if(_oPointA.x <= _oPointB.x)
               {
                  _oU = _oPointA;
                  _oV = _oPointB;
               }
               else
               {
                  _oU = _oPointB;
                  _oV = _oPointA;
               }
               _oRet.a = (_oV.y - _oU.y) / (_oV.x + _nOffset - _oU.x);
               _oRet.b = _oV.y - _oRet.a * _oV.x;
            }
         }
         return _oRet;
      }
      
      private function onGetItem(_e:ItemEvent = null) : void
      {
         if(_e != null)
         {
            switch(_e.itemId)
            {
               case ItemID.uSWORD_LV_1:
                  onGetSword(_e);
                  break;
               case ItemID.uDOOR_KEY:
                  onGetKey(_e);
            }
         }
      }
      
      private function onTalk(_e:PlayerEvent = null) : void
      {
         var _nDeltaX:Number = NaN;
         var _nDeltaY:Number = NaN;
         if(oInactivity != null)
         {
            oInactivity.resetAllCue();
         }
         var _bTalk:Boolean = true;
         if(_e != null)
         {
            _nDeltaX = Math.abs(_e.worldPositionX - mcRef.x);
            _nDeltaY = Math.abs(_e.worldPositionY - mcRef.y);
            if(_nDeltaX < mcRef.width && _nDeltaY < mcRef.height)
            {
               _e.stopImmediatePropagation();
            }
            else
            {
               _bTalk = false;
            }
         }
         if(_bTalk)
         {
            playPatrickTalk();
            if(Profile.Instance.isTutorial())
            {
               Storyline.goto("Tutorial","Save1stTime");
               Storyline.play("Tutorial");
            }
            else
            {
               openPopup();
            }
         }
      }
      
      override public function resume(_e:Event = null) : void
      {
         super.resume(_e);
      }
      
      private function onIdleNoPush(_e:AttackEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","IdleNoPush");
         Storyline.play("Tutorial");
      }
      
      private function onDoorNoKey(_e:RoomEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","DoorNoKey");
         Storyline.play("Tutorial");
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function bumpOnRectangle(_oFrom:Point, _oTo:Point, _oZone:Rectangle) : Object
      {
         if(_oFrom == null || _oTo == null || _oZone == null)
         {
            return null;
         }
         var _oRet:Object = null;
         var _nL:Number = _oZone.left;
         var _nR:Number = _oZone.right;
         var _nT:Number = _oZone.top;
         var _nB:Number = _oZone.bottom;
         if(_oTo.x - _oFrom.x > 0)
         {
            _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nL,_nT),new Point(_nL,_nB));
         }
         else
         {
            _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nR,_nT),new Point(_nR,_nB));
         }
         if(_oRet == null)
         {
            if(_oTo.y - _oFrom.y > 0)
            {
               _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nL,_nT),new Point(_nR,_nT));
            }
            else
            {
               _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nL,_nB),new Point(_nR,_nB));
            }
         }
         return _oRet;
      }
      
      private function onKeyUp(_e:KeyboardEvent = null) : void
      {
         if(_e != null)
         {
            switch(_e.keyCode)
            {
               case 72:
                  onHermit();
            }
         }
      }
      
      private function onCollisionCheck(_e:MovingBodyEvent) : void
      {
         var _aTilePos:Array = null;
         var _nTW:Number = NaN;
         var _nTH:Number = NaN;
         var t:uint = 0;
         var _oOffset:Point = null;
         var _oContact:Point = null;
         var _oBump:Point = null;
         var _oSlide:Point = null;
         if(!(_e.mover is ILevelCollidable))
         {
            return;
         }
         var _oMover:ILevelCollidable = _e.mover as ILevelCollidable;
         var _oDisp:Point = _e.newWorldPosition.subtract(_e.lastWorldPosition);
         var _oFeetFrom:Rectangle = _e.localFeetZone.clone();
         _oFeetFrom.offsetPoint(_e.lastWorldPosition);
         var _oFeetTo:Rectangle = _e.localFeetZone.clone();
         _oFeetTo.offsetPoint(_e.newWorldPosition);
         var _aFeetFrom:Array = [];
         var _aFeetTo:Array = [];
         var _oColl:Object = null;
         if(Math.abs(_oDisp.x) < 0.001)
         {
            if(Math.abs(_oDisp.y) < 0.001)
            {
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top),new Point(_oFeetTo.right,_oFeetTo.top),new Point(_oFeetTo.left,_oFeetTo.bottom),new Point(_oFeetTo.right,_oFeetTo.bottom));
            }
            else if(_oDisp.y > 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.bottom),new Point(_oFeetFrom.right,_oFeetFrom.bottom));
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.bottom),new Point(_oFeetTo.right,_oFeetTo.bottom));
            }
            else if(_oDisp.y < 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.top),new Point(_oFeetFrom.right,_oFeetFrom.top));
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top),new Point(_oFeetTo.right,_oFeetTo.top));
            }
         }
         else if(_oDisp.x < 0)
         {
            _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.top),new Point(_oFeetFrom.left,_oFeetFrom.bottom));
            _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top),new Point(_oFeetTo.left,_oFeetTo.bottom));
            if(_oDisp.y > 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.right,_oFeetFrom.bottom));
               _aFeetTo.push(new Point(_oFeetTo.right,_oFeetTo.bottom));
            }
            else if(_oDisp.y < 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.right,_oFeetFrom.top));
               _aFeetTo.push(new Point(_oFeetTo.right,_oFeetTo.top));
            }
         }
         else
         {
            _aFeetFrom.push(new Point(_oFeetFrom.right,_oFeetFrom.top),new Point(_oFeetFrom.right,_oFeetFrom.bottom));
            _aFeetTo.push(new Point(_oFeetTo.right,_oFeetTo.top),new Point(_oFeetTo.right,_oFeetTo.bottom));
            if(_oDisp.y > 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.bottom));
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.bottom));
            }
            else if(_oDisp.y < 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.top));
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top));
            }
         }
         var _oFrom:Point = null;
         var _oTo:Point = null;
         var i:uint = 0;
         while(_oColl == null && i < _aFeetFrom.length)
         {
            _oFrom = _aFeetFrom[i];
            _oTo = _aFeetTo[i];
            _aTilePos = [];
            _nTW = Data.iTILE_WIDTH;
            _nTH = Data.iTILE_HEIGHT;
            if(_oDisp.x > 0)
            {
               _aTilePos.push(_oTo.add(new Point(-_nTW,0)));
            }
            else if(_oDisp.x < 0)
            {
               _aTilePos.push(_oTo.add(new Point(_nTW,0)));
            }
            if(_oDisp.y > 0)
            {
               _aTilePos.push(_oTo.add(new Point(0,-_nTH)));
            }
            else if(_oDisp.x < 0)
            {
               _aTilePos.push(_oTo.add(new Point(0,_nTH)));
            }
            _aTilePos.push(_oTo);
            t = 0;
            while(_oColl == null && t < _aTilePos.length)
            {
               _oColl = bumpOnRectangle(_oFrom,_oTo,oWorldBody);
               t++;
            }
            i++;
         }
         if(_oColl != null)
         {
            _oOffset = new Point();
            if(_oFrom.x == _oFeetFrom.left)
            {
               _oOffset.x = -_e.localFeetZone.left;
            }
            else
            {
               _oOffset.x = -_e.localFeetZone.right;
            }
            if(_oFrom.y == _oFeetFrom.top)
            {
               _oOffset.y = -_e.localFeetZone.top;
            }
            else
            {
               _oOffset.y = -_e.localFeetZone.bottom;
            }
            _oContact = _oColl.oContact as Point;
            _oBump = _oColl.oBumpResult as Point;
            _oSlide = _oColl.oSlideResult as Point;
            _oContact.x += _oOffset.x;
            _oContact.y += _oOffset.y;
            _oBump.x += _oOffset.x;
            _oBump.y += _oOffset.y;
            _oSlide.x += _oOffset.x;
            _oSlide.y += _oOffset.y;
            _e.stopImmediatePropagation();
            _oMover.onWallCollide(_e.lastWorldPosition,_oContact,_oBump,_oSlide,_e.tries + 1);
         }
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function floatEquals(_n1:Number, _n2:Number) : Boolean
      {
         return Math.abs(_n1 - _n2) < 0.001;
      }
      
      private function onGetSword(_e:Event = null) : void
      {
         playPatrickTalk();
         uPhase = 3;
         resetTutorialListeners();
      }
      
      public function updateState() : void
      {
         if(bFlagEasterEgg)
         {
            setState(sSTATE_IDLE2);
         }
         else
         {
            setState(sSTATE_IDLE1);
         }
      }
      
      override public function update(_e:Event) : void
      {
         super.update(_e);
      }
      
      private function onIdleNoKey(_e:AttackEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","IdleNoKey");
         Storyline.play("Tutorial");
      }
      
      private function onDoorNoKill(_e:RoomEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","DoorNoKey");
         Storyline.play("Tutorial");
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority);
      }
      
      private function onDoorNoSword(_e:RoomEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","DoorNoSword");
         Storyline.play("Tutorial");
      }
      
      private function getIntersectionPoint(_oPointA1:Point, _oPointA2:Point, _oPointB1:Point, _oPointB2:Point) : Point
      {
         var _oRet:Point = null;
         var _nYMin:Number = NaN;
         var _nXMin:Number = NaN;
         var _oLine1:Object = getStandardLinearEquation(_oPointA1,_oPointA2);
         var _oLine2:Object = getStandardLinearEquation(_oPointB1,_oPointB2);
         var _bInf:Boolean = false;
         if(_oLine1.x != 0 || _oLine2.x != 0)
         {
            if(_oLine1.x == _oLine2.x)
            {
               _bInf = true;
               _nYMin = Math.min(_oPointA1.y,_oPointA2.y);
               _nYMin = Math.min(_nYMin,_oPointB1.y);
               _nYMin = Math.min(_nYMin,_oPointB2.y);
               if(_nYMin == _oPointA1.y)
               {
                  _oRet = _oPointA2;
                  if(_oRet.y < _oPointB1.y && _oRet.y < _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y))
                  {
                     _oRet = null;
                  }
               }
               else if(_nYMin == _oPointA2.y)
               {
                  _oRet = _oPointA1;
                  if(_oRet.y < _oPointB1.y && _oRet.y < _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y))
                  {
                     _oRet = null;
                  }
               }
               else if(_nYMin == _oPointB1.y)
               {
                  _oRet = _oPointB2;
                  if(_oRet.y < _oPointA1.y && _oRet.y < _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y))
                  {
                     _oRet = null;
                  }
               }
               else
               {
                  _oRet = _oPointB1;
                  if(_oRet.y < _oPointA1.y && _oRet.y < _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y))
                  {
                     _oRet = null;
                  }
               }
            }
            else
            {
               if(_oLine1.x != 0)
               {
                  _oRet = new Point();
                  _oRet.x = _oLine1.x;
                  _oRet.y = _oLine2.a * _oRet.x + _oLine2.b;
                  if(floatEquals(_oRet.y,_oPointB1.y))
                  {
                     _oRet.y = _oPointB1.y;
                  }
                  else if(floatEquals(_oRet.y,_oPointB2.y))
                  {
                     _oRet.y = _oPointB2.y;
                  }
               }
               else
               {
                  _oRet = new Point();
                  _oRet.x = _oLine2.x;
                  _oRet.y = _oLine1.a * _oRet.x + _oLine1.b;
                  if(floatEquals(_oRet.y,_oPointA1.y))
                  {
                     _oRet.y = _oPointA1.y;
                  }
                  else if(floatEquals(_oRet.y,_oPointA2.y))
                  {
                     _oRet.y = _oPointA2.y;
                  }
               }
               if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x > _oPointA1.x && _oRet.x > _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x) || _oRet.x > _oPointB1.x && _oRet.x > _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
               {
                  _oRet = null;
               }
            }
            if(_oRet != null && (_oRet.y < _oPointA1.y && _oRet.y < _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y) || _oRet.y > _oPointA1.y && _oRet.y > _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y) || _oRet.y < _oPointB1.y && _oRet.y < _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y) || _oRet.y > _oPointB1.y && _oRet.y > _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y)))
            {
               _oRet = null;
            }
         }
         else if(_oLine1.a == _oLine2.a)
         {
            if(_oLine1.b != _oLine2.b)
            {
               _oRet = null;
            }
            else
            {
               _bInf = true;
               _nXMin = Math.min(_oPointA1.x,_oPointA2.x);
               _nXMin = Math.min(_nXMin,_oPointB1.x);
               _nXMin = Math.min(_nXMin,_oPointB2.x);
               if(_nXMin == _oPointA1.x)
               {
                  _oRet = _oPointA2;
                  if(_oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
                  {
                     _oRet = null;
                  }
               }
               else if(_nXMin == _oPointA2.x)
               {
                  _oRet = _oPointA1;
                  if(_oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
                  {
                     _oRet = null;
                  }
               }
               else if(_nXMin == _oPointB1.x)
               {
                  _oRet = _oPointB2;
                  if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x))
                  {
                     _oRet = null;
                  }
               }
               else
               {
                  _oRet = _oPointB1;
                  if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x))
                  {
                     _oRet = null;
                  }
               }
            }
         }
         else
         {
            _oRet = new Point();
            _oRet.x = (_oLine1.b - _oLine2.b) / (_oLine2.a - _oLine1.a);
            _oRet.y = _oLine1.a * _oRet.x + _oLine1.b;
            if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x > _oPointA1.x && _oRet.x > _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x) || _oRet.x > _oPointB1.x && _oRet.x > _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
            {
               _oRet = null;
            }
         }
         if(_oRet != null && _bInf)
         {
            _oRet = new Point(Number.NaN,Number.NaN);
         }
         return _oRet;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function removeTutorialListeners() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_START,onGameStart);
         _oGameDisp.removeEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onDoorNoSword);
         if(oInactivity != null)
         {
            oInactivity.deleteCue(sINACTIVITY_NOSWORD);
         }
         _oGameDisp.removeEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onDoorNoKill);
         if(oRoom != null)
         {
            oRoom.removeEventListener(RoomEvent.EVENT_ROOM_CLEARED,onKillJellyfish);
            oRoom.removeEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onPushBlock);
         }
         _oGameDisp.removeEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onDoorNoKey);
         _oGameDisp.removeEventListener(TextboxEvent.EVENT_CLOSE_TEXTBOX,onCloseTextbox);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onGetItem);
         _oGameDisp.removeEventListener(GameEvent.EVENT_START,onBlockStart);
      }
      
      private function onKillJellyfish(_e:RoomEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","KillJellyfish");
         Storyline.play("Tutorial");
         uPhase = 4;
         resetTutorialListeners();
      }
      
      private function onHermit(_e:Event = null) : void
      {
         bFlagEasterEgg = !bFlagEasterEgg;
         updateState();
      }
      
      private function onCloseTextbox(_e:TextboxEvent = null) : void
      {
         if(uPhase % 2 == 0)
         {
            ++uPhase;
            resetTutorialListeners();
         }
      }
      
      private function addTutorialListeners() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         trace(">>>>>>>>>>>>> ADD TUTORIAL LISTENERS : PHASE : ",uPhase);
         switch(uPhase)
         {
            case 0:
               _oGameDisp.addWeakEventListener(GameEvent.EVENT_START,onGameStart,-1);
            case 1:
               _oGameDisp.addWeakEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onDoorNoSword,-1);
               oInactivity.addCue(sINACTIVITY_NOSWORD,onIdleNoSword,5,true);
               break;
            case 3:
               _oGameDisp.addWeakEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onDoorNoKill,-1);
               oRoom.addEventListener(RoomEvent.EVENT_ROOM_CLEARED,onKillJellyfish,false,-1,true);
               break;
            case 5:
               _oGameDisp.addWeakEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onDoorNoKey,-1);
               break;
            case 7:
               _oGameDisp.addWeakEventListener(GameEvent.EVENT_START,onBlockStart,-1);
               _oGameDisp.addEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onPushBlock);
               break;
            case 9:
         }
         _oGameDisp.addEventListener(TextboxEvent.EVENT_CLOSE_TEXTBOX,onCloseTextbox);
         _oGameDisp.addEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onGetItem);
      }
      
      private function onGetKey(_e:Event = null) : void
      {
         playPatrickTalk();
         uPhase = 7;
         resetTutorialListeners();
      }
      
      private function onIdleNoSword(_e:AttackEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","IdleNoSword");
         Storyline.play("Tutorial");
      }
      
      private function onGameStart(_e:GameEvent) : void
      {
         uPhase = 1;
         playPatrickTalk();
         Storyline.goto("Tutorial","Welcome");
         Storyline.play("Tutorial");
      }
      
      private function onIdleNoKill(_e:AttackEvent = null) : void
      {
         playPatrickTalk();
         Storyline.goto("Tutorial","IdleNoKill");
         Storyline.play("Tutorial");
      }
      
      override public function pause(_e:Event = null) : void
      {
         super.pause(_e);
      }
      
      private function resetTutorialListeners() : void
      {
         removeTutorialListeners();
         addTutorialListeners();
      }
      
      private function destroy(_e:GameEvent = null) : void
      {
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_PATRICK,this));
         oEventDisp = null;
         if(Profile.Instance.isTutorial())
         {
            removeTutorialListeners();
         }
         removeListeners();
         if(oInactivity != null)
         {
            oInactivity.clearData();
            oInactivity = null;
         }
         oWorldBody = null;
         oRoom = null;
         mcRef = null;
      }
      
      private function onPushBlock(_e:RoomEvent = null) : void
      {
         if(!Profile.Instance.isTutorial())
         {
            return;
         }
         playPatrickTalk();
         Storyline.goto("Tutorial","PushBlock");
         Storyline.play("Tutorial");
         uPhase = 8;
         resetTutorialListeners();
         onLeave();
         GameDispatcher.Instance.removeEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onPushBlock);
      }
   }
}
