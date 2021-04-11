package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.effects.EffectDie;
   import gameplay.events.AttackEvent;
   import gameplay.events.DropItemEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.HurtEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import library.basic.StateManaged;
   import library.sounds.SoundManager;
   import library.utils.MoreMath;
   
   public class Enemy extends StateManaged implements IEventDispatcher
   {
      
      private static const sDEFAULT_STATE_HIDE:String = "hide";
      
      public static const nFPS:Number = Main.instance.stage.frameRate;
      
      private static const nBUMP_SPEED:Number = 250;
      
      private static const sDEFAULT_STATE_HURT:String = "hurt";
      
      private static const nBUMP_DISTANCE:Number = 45;
      
      private static const uNUM_COLLISION_TO_FORCE_BUMP:uint = 5;
      
      public static const nSPF:Number = 1 / nFPS;
       
      
      private var oEffectDie:EffectDie;
      
      private var oRoom:Room;
      
      private var nBumpDist:Number;
      
      private var oBumpNormal:Point;
      
      private var sStateHurt:String;
      
      private var mcEnemy:MovieClip;
      
      private var nHitDamage:Number;
      
      private var oEventDisp:EventDispatcher;
      
      private var uItem:uint;
      
      private var nLastPosY:Number;
      
      private var nLastPosX:Number;
      
      private var oLocalBodyZone:Rectangle;
      
      private var oLocalFeetZone:Rectangle;
      
      private var bIsDying:Boolean;
      
      private var bCanBump:Boolean;
      
      private var oActivator:Activator;
      
      private var nHealth:Number;
      
      private var oSource:Point;
      
      public function Enemy(_mcRef:MovieClip, _oRoom:Room = null, _nInitialHealth:Number = 1, _nTouchDamage:Number = 1, _bCanBump:Boolean = true, _uItemToDrop:uint = 0)
      {
         super(_mcRef);
         mcEnemy = _mcRef;
         oSource = new Point(mcEnemy.x,mcEnemy.y);
         bIsDying = false;
         nHitDamage = _nTouchDamage;
         oEffectDie = null;
         uItem = _uItemToDrop;
         bCanBump = _bCanBump;
         oRoom = _oRoom;
         if(oRoom != null)
         {
            oRoom.addAnEnemy();
         }
         oEventDisp = new EventDispatcher(this);
         nHealth = _nInitialHealth;
         oLocalBodyZone = new Rectangle();
         oLocalBodyZone.x = -Data.iTILE_WIDTH / 2;
         oLocalBodyZone.y = -Data.iTILE_HEIGHT / 2;
         oLocalBodyZone.width = Data.iTILE_WIDTH;
         oLocalBodyZone.height = Data.iTILE_HEIGHT;
         oLocalFeetZone = new Rectangle();
         oLocalFeetZone.x = -24;
         oLocalFeetZone.y = 15;
         oLocalFeetZone.right = 24;
         oLocalFeetZone.bottom = 25;
         oActivator = new Activator(mcEnemy,oRoom);
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
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_DESTROY,destroy);
         sStateHurt = sDEFAULT_STATE_HURT;
         addState(sDEFAULT_STATE_HIDE,stateHide,stateLoadHide);
         oBumpNormal = new Point();
         nLastPosX = mcEnemy.x;
         nLastPosY = mcEnemy.y;
      }
      
      public function isBumping() : Boolean
      {
         return canBump() && nBumpDist < nBUMP_DISTANCE;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function onPlayerAttack(_e:AttackEvent) : Boolean
      {
         var _bRet:Boolean = false;
         var _oWorldBody:Rectangle = getWorldBodyZone();
         var _bWouldDie:* = nHealth - _e.damage <= 0;
         if(_oWorldBody.intersects(_e.worldAttackZone) && onPlayerHit(_e.itemUsed,_bWouldDie))
         {
            if(_e.damage > 0)
            {
               _bRet = true;
               nHealth -= _e.damage;
               if(_bWouldDie)
               {
                  dispatchEvent(new HurtEvent(HurtEvent.EVENT_ENEMY_DIE,_e.damage,_e.agressor,this));
                  die();
               }
               else
               {
                  dispatchEvent(new HurtEvent(HurtEvent.EVENT_ENEMY_HITTED,_e.damage,_e.agressor,this));
               }
            }
            bump(_e.worldFrom.x,_e.worldFrom.y);
         }
         return _bRet;
      }
      
      private function setHurtState(_sState:String) : void
      {
         sStateHurt = _sState;
      }
      
      protected function onPlayerMove(_e:MovingBodyEvent) : void
      {
         if(isDying())
         {
            return;
         }
         var _oHitZone:Rectangle = _e.localBodyZone.clone();
         _oHitZone.offsetPoint(_e.newWorldPosition);
         if(_oHitZone.intersects(getWorldBodyZone()))
         {
            triggerHitMovingPlayer();
         }
      }
      
      private function getWorldBodyZone() : Rectangle
      {
         var _oRet:Rectangle = oLocalBodyZone.clone();
         _oRet.offset(mcEnemy.x,mcEnemy.y);
         return _oRet;
      }
      
      private function updateBump() : void
      {
         if(!canBump() || !isBumping())
         {
            return;
         }
         var _nLastX:Number = mcEnemy.x;
         var _nLastY:Number = mcEnemy.y;
         mcEnemy.x += oBumpNormal.x * nBUMP_SPEED * nSPF;
         mcEnemy.y += oBumpNormal.y * nBUMP_SPEED * nSPF;
         nBumpDist += Math.sqrt(Math.pow(mcEnemy.x - _nLastX,2) + Math.pow(mcEnemy.y - _nLastY,2));
      }
      
      protected function die() : void
      {
         if(oActivator != null)
         {
            oActivator.destroy();
            oActivator = null;
         }
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_ATTACK,onPlayerAttack);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         bIsDying = true;
         setState(sStateHurt);
         oEffectDie = new EffectDie(mcEnemy,onHidingDie,onFinishDie);
      }
      
      private function canBump() : Boolean
      {
         return bCanBump;
      }
      
      private function onPlayerProjectile(_e:AttackEvent) : void
      {
         if(onPlayerAttack(_e))
         {
            _e.stopImmediatePropagation();
         }
      }
      
      public function isDying() : Boolean
      {
         return bIsDying;
      }
      
      protected function triggerHitMovingPlayer() : void
      {
         var _oPos:Point = new Point(mcEnemy.x,mcEnemy.y);
         dispatchEvent(new MovingBodyEvent(MovingBodyEvent.EVENT_ENEMY_HIT_MOVING_PLAYER,this,_oPos,_oPos,oLocalFeetZone,oLocalBodyZone,nHitDamage));
      }
      
      override public function resume(_e:Event = null) : void
      {
         if(isDying())
         {
            super.resume(_e);
            oEffectDie.resume(_e);
         }
         else
         {
            super.resume(_e);
         }
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function bump(_nWorldBumpSourceX:Number, _nWorldBumpSourceY:Number) : void
      {
         if(!canBump())
         {
            return;
         }
         oBumpNormal.x = mcEnemy.x - _nWorldBumpSourceX;
         oBumpNormal.y = mcEnemy.y - _nWorldBumpSourceY;
         oBumpNormal.normalize(1);
         nBumpDist = 0;
      }
      
      protected function setLocalBodyZone(_oLocalBodyZone:Rectangle) : void
      {
         if(_oLocalBodyZone == null)
         {
            return;
         }
         oLocalBodyZone = _oLocalBodyZone.clone();
      }
      
      public function onWallCollide(_oLast:Point, _oContact:Point, _oBump:Point, _oSlide:Point, _uTries:uint) : void
      {
         var _oEffect:Point = null;
         if(isBumping())
         {
            if(_uTries >= uNUM_COLLISION_TO_FORCE_BUMP)
            {
               mcEnemy.x = _oLast.x;
               mcEnemy.y = _oLast.y;
               return;
            }
            _oEffect = _oBump;
            oBumpNormal.x = _oBump.x - _oContact.x;
            oBumpNormal.y = _oBump.y - _oContact.y;
            oBumpNormal.normalize(1);
            if(_uTries <= 1)
            {
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndBounce3.wav",1,1,false);
            }
         }
         else
         {
            _oEffect = _oSlide;
         }
         var _oEv:MovingBodyEvent = new MovingBodyEvent(MovingBodyEvent.EVENT_ENEMY_MOVE,this,_oLast,_oEffect,oLocalFeetZone,oLocalBodyZone,nHitDamage,_uTries);
         mcEnemy.x = _oEffect.x;
         mcEnemy.y = _oEffect.y;
         dispatchEvent(_oEv);
      }
      
      protected function setLocalFeetZone(_oLocalFeetZone:Rectangle) : void
      {
         if(_oLocalFeetZone == null)
         {
            return;
         }
         oLocalFeetZone = _oLocalFeetZone.clone();
      }
      
      private function triggerMoveIfMoved() : void
      {
         var _oLastWPos:Point = null;
         var _oNewWPos:Point = null;
         if(mcEnemy == null)
         {
            return;
         }
         if(nLastPosX != mcEnemy.x || nLastPosY != mcEnemy.y)
         {
            _oLastWPos = new Point(nLastPosX,nLastPosY);
            _oNewWPos = new Point(mcEnemy.x,mcEnemy.y);
            dispatchEvent(new MovingBodyEvent(MovingBodyEvent.EVENT_ENEMY_MOVE,this,_oLastWPos,_oNewWPos,oLocalFeetZone,oLocalBodyZone,nHitDamage));
         }
         nLastPosX = mcEnemy.x;
         nLastPosY = mcEnemy.y;
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function onFinishDie() : void
      {
         oRoom.removeAnEnemy();
         if(uItem != ItemID.uNULL_ITEM)
         {
            dispatchEvent(new DropItemEvent(DropItemEvent.EVENT_DROP_ITEM,uItem,mcRef.x,mcRef.y,oRoom,oSource));
         }
         destroy();
      }
      
      protected function onPlayerHit(_uItemUsed:uint, _bWouldDie:Boolean = false) : Boolean
      {
         return true;
      }
      
      private function onActivation() : void
      {
         if(isDying())
         {
            return;
         }
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.addWeakEventListener(AttackEvent.EVENT_PLAYER_ATTACK,onPlayerAttack);
         _oGameDisp.addWeakEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onEnemyMove,false,1,true);
      }
      
      public function getRoom() : Room
      {
         return oRoom;
      }
      
      private function onDeactivation() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_ATTACK,onPlayerAttack);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onEnemyMove);
      }
      
      private function throwPeeble() : uint
      {
         var _uThrow:uint = MoreMath.getRandomRange(1,100);
         var _uRet:uint = ItemID.uNULL_ITEM;
         if(_uThrow <= Data.nPEEBLE_DROP_10)
         {
            _uRet = ItemID.uPEEBLES_10;
         }
         else if(_uThrow + Data.nPEEBLE_DROP_10 <= Data.nPEEBLE_DROP_5)
         {
            _uRet = ItemID.uPEEBLES_5;
         }
         else if(_uThrow + Data.nPEEBLE_DROP_10 + Data.nPEEBLE_DROP_5 <= Data.nPEEBLE_DROP_1)
         {
            _uRet = ItemID.uPEBBLE_1;
         }
         return _uRet;
      }
      
      public function onHidingDie() : void
      {
         setState(sDEFAULT_STATE_HIDE);
      }
      
      public function onEnemyMove(_e:MovingBodyEvent) : void
      {
         if(!isDying())
         {
            return;
         }
         if(_e.mover == this)
         {
            _e.stopImmediatePropagation();
         }
      }
      
      override public function update(_e:Event) : void
      {
         if(!isDying())
         {
            super.update(_e);
            updateBump();
            triggerMoveIfMoved();
         }
         else
         {
            if(mcState != null)
            {
               trace("__",mcState.currentFrame);
            }
            super.update(_e);
            updateBump();
            triggerMoveIfMoved();
            oEffectDie.update(_e);
         }
      }
      
      private function stateHide() : void
      {
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      override public function pause(_e:Event = null) : void
      {
         if(!isDying())
         {
            super.pause(_e);
         }
         else
         {
            oEffectDie.pause(_e);
         }
      }
      
      private function stateLoadHide() : void
      {
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Enemy : destroy");
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_ENEMY,this));
         oLocalBodyZone = null;
         oLocalFeetZone = null;
         oBumpNormal = null;
         if(oEffectDie != null)
         {
            oEffectDie.destroy(_e);
            oEffectDie = null;
         }
         oEventDisp = null;
         if(mcEnemy.parent != null)
         {
            mcEnemy.parent.removeChild(mcEnemy);
            mcEnemy = null;
         }
         if(oActivator != null)
         {
            oActivator.destroy();
            oActivator = null;
         }
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(GameEvent.EVENT_DESTROY,destroy);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_ATTACK,onPlayerAttack);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onPlayerProjectile);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
      }
      
      protected function throwItemFromDropTable(_aDropTable:Array) : uint
      {
         if(_aDropTable == null || _aDropTable.length < 5)
         {
            return ItemID.uNULL_ITEM;
         }
         var _uThrow:uint = MoreMath.getRandomRange(1,100);
         var _uRet:uint = ItemID.uNULL_ITEM;
         var _uOffset:uint = 0;
         if(_aDropTable[Data.uDROP_TABLE_INDEX_KEY] > _uThrow)
         {
            _uRet = ItemID.uDOOR_KEY;
         }
         else
         {
            _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_KEY];
            if(_aDropTable[Data.uDROP_TABLE_INDEX_HEALTH] + _uOffset > _uThrow)
            {
               _uRet = ItemID.uHEARTH;
            }
            else
            {
               _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_HEALTH];
               if(_aDropTable[Data.uDROP_TABLE_INDEX_PEEBLE] + _uOffset > _uThrow)
               {
                  _uRet = throwPeeble();
               }
               else
               {
                  _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_PEEBLE];
                  if(_aDropTable[Data.uDROP_TABLE_INDEX_SEA_URCHIN] + _uOffset > _uThrow)
                  {
                     _uRet = ItemID.uSEA_URCHIN;
                  }
                  else
                  {
                     _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_SEA_URCHIN];
                     if(_aDropTable[Data.uDROP_TABLE_INDEX_VOLC_URCHIN] + _uOffset > _uThrow)
                     {
                        _uRet = ItemID.uVOLCANIC_URCHIN;
                     }
                     else
                     {
                        _uRet = ItemID.uNULL_ITEM;
                     }
                  }
               }
            }
         }
         return _uRet;
      }
      
      private function getWorldFeetZone() : Rectangle
      {
         var _oRet:Rectangle = oLocalFeetZone.clone();
         _oRet.offset(mcEnemy.x,mcEnemy.y);
         return _oRet;
      }
   }
}
