package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.GameEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.interfaces.ILevelCollidable;
   import library.sounds.SoundManager;
   import library.utils.Tools;
   
   public class MovingBlock implements IEventDispatcher
   {
      
      private static const uDIR_UP:uint = 0;
      
      private static const uDIR_LEFT:uint = 2;
      
      private static const uDIR_DOWN:uint = 1;
      
      private static const uDIR_RIGHT:uint = 3;
      
      private static const nACTIVE_ZONE_WIDTH:Number = 3;
       
      
      private var bWallUp:Boolean;
      
      private var oLocalZone:Rectangle;
      
      private var nSpeed:Number;
      
      private var bSolved:Boolean;
      
      private var mcBlock:MovieClip;
      
      private var bIsMoving:Boolean;
      
      private var bWallDown:Boolean;
      
      private var nDestY:Number;
      
      private var oEventDisp:EventDispatcher;
      
      private var oLocalActiveZone:Rectangle;
      
      private var nDestX:Number;
      
      private var bWallRight:Boolean;
      
      private var bPushed:Boolean;
      
      private var nSecsPerFrame:Number;
      
      private var iDirH:int;
      
      private var oActivator:Activator;
      
      private var oRoom:Room;
      
      private var uSideOfColl:uint;
      
      private var iDirV:int;
      
      private var bWallLeft:Boolean;
      
      private var aMovingBlocks:Array;
      
      private var nTimer:Number;
      
      public function MovingBlock(_mcRef:MovieClip, _oRoom:Room, _oWorldSolvedPos:Point, _bSolved:Boolean, _bWallLeft:Boolean = false, _bWallUp:Boolean = false, _bWallRight:Boolean = false, _bWallDown:Boolean = false)
      {
         super();
         oEventDisp = new EventDispatcher(this);
         bWallLeft = _bWallLeft;
         bWallRight = _bWallRight;
         bWallUp = _bWallUp;
         bWallDown = _bWallDown;
         mcBlock = _mcRef;
         oRoom = _oRoom;
         oActivator = new Activator(mcBlock);
         oActivator.setOnActivation(onActivation);
         oActivator.setOnDeactivation(onDeactivation);
         bSolved = _bSolved;
         nSecsPerFrame = 1 / mcBlock.stage.frameRate;
         nSpeed = Data.iTILE_WIDTH / Data.nMOVING_BLOCK_TIME;
         oLocalZone = new Rectangle(-Data.iTILE_WIDTH / 2,-Data.iTILE_HEIGHT / 2,Data.iTILE_WIDTH,Data.iTILE_HEIGHT);
         oLocalActiveZone = oLocalZone.clone();
         oLocalActiveZone.inflate(nACTIVE_ZONE_WIDTH,nACTIVE_ZONE_WIDTH);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_DESTROY,destroy);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck,false,4,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck,false,999,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck,false,4,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck,false,999,true);
         if(bSolved)
         {
            mcBlock.x = _oWorldSolvedPos.x;
            mcBlock.y = _oWorldSolvedPos.y;
         }
         else
         {
            bPushed = false;
            bIsMoving = false;
         }
         resetTimer();
         if(oActivator.isActivated())
         {
            onActivation();
         }
         else
         {
            onDeactivation();
         }
      }
      
      private function obstacleAtPushingSide(_uSide:uint) : Boolean
      {
         var _bTest:Boolean = blockAtPushingSide(_uSide);
         if(_bTest == false)
         {
            switch(_uSide)
            {
               case uDIR_LEFT:
                  _bTest = bWallRight;
                  break;
               case uDIR_RIGHT:
                  _bTest = bWallLeft;
                  break;
               case uDIR_UP:
                  _bTest = bWallDown;
                  break;
               case uDIR_DOWN:
                  _bTest = bWallUp;
            }
         }
         return _bTest;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
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
      
      public function getWorldZone() : Rectangle
      {
         var _oRet:Rectangle = oLocalZone.clone();
         _oRet.offset(mcBlock.x,mcBlock.y);
         return _oRet;
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function resetTimer() : void
      {
         nTimer = Data.nMOVING_BLOCK_PUSH_TIMEOUT;
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
      
      private function onCollisionCheck(_e:MovingBodyEvent) : void
      {
         var tt:uint = 0;
         var _aTilePos:Array = null;
         var _nTW:Number = NaN;
         var _nTH:Number = NaN;
         var t:uint = 0;
         var _oWorldTile:Rectangle = null;
         var _oOffset:Point = null;
         var _oContact:Point = null;
         var _oBump:Point = null;
         var _oSlide:Point = null;
         var _oWorldZone:Rectangle = null;
         var _uSide:uint = 0;
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
         var _bInActiceZone:Boolean = false;
         var _oWorldActiveZone:Rectangle = oLocalActiveZone.clone();
         _oWorldActiveZone.offset(mcBlock.x,mcBlock.y);
         if(Math.abs(_oDisp.x) < 0.001)
         {
            if(Math.abs(_oDisp.y) < 0.001)
            {
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top),new Point(_oFeetTo.right,_oFeetTo.top),new Point(_oFeetTo.left,_oFeetTo.bottom),new Point(_oFeetTo.right,_oFeetTo.bottom));
               tt = 0;
               while(!_bInActiceZone && tt < _aFeetTo.length)
               {
                  _bInActiceZone = _oWorldActiveZone.containsPoint(_aFeetTo[tt]);
                  tt++;
               }
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
               _oWorldTile = oLocalZone.clone();
               _oWorldTile.offset(mcBlock.x,mcBlock.y);
               _oColl = bumpOnRectangle(_oFrom,_oTo,_oWorldTile);
               if(!_bInActiceZone)
               {
                  _bInActiceZone = _oWorldActiveZone.containsPoint(_oTo);
               }
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
            if(canBePushed() && _oMover is Player)
            {
               _oWorldZone = oLocalZone.clone();
               _oWorldZone.offset(mcBlock.x,mcBlock.y);
               _uSide = getSideFromBump(_oBump,_oWorldZone);
               if(nTimer < Data.nMOVING_BLOCK_PUSH_TIMEOUT)
               {
                  if(uSideOfColl == _uSide)
                  {
                     if(nTimer <= 0)
                     {
                        moveBlock(uSideOfColl);
                        resetTimer();
                     }
                     else
                     {
                        nTimer -= nSecsPerFrame;
                     }
                  }
                  else
                  {
                     resetTimer();
                  }
               }
               else if(!obstacleAtPushingSide(_uSide))
               {
                  uSideOfColl = _uSide;
                  nTimer -= nSecsPerFrame;
               }
            }
         }
         else if(canBePushed() && _oMover is Player)
         {
            if(!_bInActiceZone)
            {
               resetTimer();
            }
         }
      }
      
      private function blockAtPushingSide(_uSide:uint) : Boolean
      {
         var _oMov:MovingBlock = null;
         if(aMovingBlocks == null)
         {
            return false;
         }
         var _bRet:Boolean = false;
         var _oZoneTest:Rectangle = getWorldZone();
         _oZoneTest.inflate(-1,-1);
         switch(_uSide)
         {
            case uDIR_LEFT:
               _oZoneTest.offset(Data.iTILE_HEIGHT,0);
               break;
            case uDIR_RIGHT:
               _oZoneTest.offset(-Data.iTILE_HEIGHT,0);
               break;
            case uDIR_UP:
               _oZoneTest.offset(0,Data.iTILE_WIDTH);
               break;
            case uDIR_DOWN:
               _oZoneTest.offset(0,-Data.iTILE_WIDTH);
         }
         var i:uint = 0;
         while(!_bRet && i < aMovingBlocks.length)
         {
            _oMov = aMovingBlocks[i];
            _bRet = _oZoneTest.intersects(_oMov.getWorldZone());
            i++;
         }
         return _bRet;
      }
      
      private function floatEquals(_n1:Number, _n2:Number) : Boolean
      {
         return Math.abs(_n1 - _n2) < 0.001;
      }
      
      private function moveBlock(_uPushedSide:uint) : void
      {
         trace("MovingBlock : move block");
         if(!canBePushed())
         {
            return;
         }
         nDestX = mcBlock.x;
         nDestY = mcBlock.y;
         iDirH = 0;
         iDirV = 0;
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRockPush.wav",1,1,true);
         switch(_uPushedSide)
         {
            case uDIR_UP:
               nDestY += Data.iTILE_HEIGHT;
               ++iDirV;
               break;
            case uDIR_DOWN:
               nDestY -= Data.iTILE_HEIGHT;
               --iDirV;
               break;
            case uDIR_LEFT:
               nDestX += Data.iTILE_WIDTH;
               ++iDirH;
               break;
            case uDIR_RIGHT:
               nDestX -= Data.iTILE_WIDTH;
               --iDirH;
         }
         bPushed = true;
         bIsMoving = true;
         onActivation();
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function update(_e:Event = null) : void
      {
         var _nLastPos:Number = NaN;
         if(bIsMoving)
         {
            if(iDirV != 0)
            {
               _nLastPos = mcBlock.y;
               mcBlock.y += nSpeed * nSecsPerFrame * iDirV;
               if(_nLastPos <= nDestY && mcBlock.y >= nDestY || _nLastPos >= nDestY && mcBlock.y <= nDestY)
               {
                  mcBlock.y = nDestY;
                  bIsMoving = false;
               }
            }
            else
            {
               _nLastPos = mcBlock.x;
               mcBlock.x += nSpeed * nSecsPerFrame * iDirH;
               if(_nLastPos <= nDestX && mcBlock.x >= nDestX || _nLastPos >= nDestX && mcBlock.x <= nDestX)
               {
                  mcBlock.x = nDestX;
                  bIsMoving = false;
               }
            }
         }
         else
         {
            GameDispatcher.Instance.removeEventListener(GameEvent.EVENT_UPDATE,update);
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function canBePushed() : Boolean
      {
         return !(bPushed || bSolved);
      }
      
      private function onActivation() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         if(bIsMoving)
         {
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
         }
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck,false,4,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck,false,999,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck,false,4,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck,false,999,true);
      }
      
      private function onDeactivation() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck);
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
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function setMovingBlocks(_aMovingBlocks:Array) : void
      {
         aMovingBlocks = Tools.doCopyArray(_aMovingBlocks);
         Tools.removeItemInArray(aMovingBlocks,this);
      }
      
      public function destroy(_e:Event = null) : void
      {
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_MOVING_BLOCK,this));
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_DESTROY,destroy);
         oActivator.destroy();
         oActivator = null;
         oLocalZone = null;
         oLocalActiveZone = null;
      }
      
      private function getSideFromBump(_oBump:Point, _oZone:Rectangle) : uint
      {
         var _uRet:uint = 0;
         if(_oBump.y < _oZone.top)
         {
            _uRet = uDIR_UP;
         }
         else if(_oBump.y > _oZone.bottom)
         {
            _uRet = uDIR_DOWN;
         }
         else if(_oBump.x < _oZone.left)
         {
            _uRet = uDIR_LEFT;
         }
         else
         {
            _uRet = uDIR_RIGHT;
         }
         return _uRet;
      }
   }
}
