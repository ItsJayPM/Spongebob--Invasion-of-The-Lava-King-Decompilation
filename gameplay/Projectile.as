package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.AttackEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.ProjectileEvent;
   import library.basic.StateManaged;
   import library.utils.MoreMath;
   
   public class Projectile extends StateManaged implements IEventDispatcher
   {
      
      private static const sSTATE_IDLE_UP:String = "idleUp";
      
      private static const sSTATE_DIE_LEFT:String = "dieLeft";
      
      private static const sSTATE_IDLE_DOWN:String = "idleDown";
      
      private static const sSTATE_IDLE_LEFT:String = "idleLeft";
      
      private static const sSTATE_IDLE_RIGHT:String = "idleRight";
      
      private static const sSTATE_DIE_DOWN:String = "dieDown";
      
      private static const sSTATE_DIE_UP:String = "dieUp";
      
      private static const sSTATE_DIE_RIGHT:String = "dieRight";
       
      
      private var uItemType:uint;
      
      private var oLocalFeet:Rectangle;
      
      private var nNormalStartX:Number;
      
      private var nNormalStartY:Number;
      
      private var mcProj:MovieClip;
      
      private var nDamage:Number;
      
      private var sAttackEventType:String;
      
      private var bDieOnHit:Boolean;
      
      private var nMaxDistance:Number;
      
      private var oEventDisp:EventDispatcher;
      
      private var nLastX:Number;
      
      private var nDist:Number;
      
      private var nLastY:Number;
      
      private var nSecsPerFrame:Number;
      
      private var bHitOpponent:Boolean;
      
      private var sMovingEventType:String;
      
      private var bAutoFacing:Boolean;
      
      private var nSpeed:Number;
      
      private var bDynamic:Boolean;
      
      private var oLocalBody:Rectangle;
      
      public function Projectile(_mcRef:MovieClip, _bIsAnEnemy:Boolean, _nDamage:Number, _nStartingOrientation:Number = 0, _nBodyWidth:Number = 1, _nBodyHeight:Number = 1, _uIsItem:uint = 0, _nMaxDistance:Number = 600, _bDieOnHit:Boolean = true, _nSpeed:Number = 80, _bDynamicRotation:Boolean = false)
      {
         super(_mcRef);
         mcProj = _mcRef;
         oEventDisp = new EventDispatcher(this);
         nDamage = _nDamage;
         uItemType = _uIsItem;
         nMaxDistance = _nMaxDistance;
         nSpeed = _nSpeed;
         bDieOnHit = _bDieOnHit;
         bDynamic = _bDynamicRotation;
         nDist = 0;
         if(_bIsAnEnemy)
         {
            sAttackEventType = AttackEvent.EVENT_ENEMY_PROJECTILE_ATTACK;
            sMovingEventType = MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE;
         }
         else
         {
            sAttackEventType = AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK;
            sMovingEventType = MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE;
         }
         addState(sSTATE_IDLE_UP,stateIdle,stateLoadIdle);
         addState(sSTATE_IDLE_DOWN,stateIdle,stateLoadIdle);
         addState(sSTATE_IDLE_LEFT,stateIdle,stateLoadIdle);
         addState(sSTATE_IDLE_RIGHT,stateIdle,stateLoadIdle);
         addState(sSTATE_DIE_UP,stateDie,stateLoadDie);
         addState(sSTATE_DIE_DOWN,stateDie,stateLoadDie);
         addState(sSTATE_DIE_LEFT,stateDie,stateLoadDie);
         addState(sSTATE_DIE_RIGHT,stateDie,stateLoadDie);
         nNormalStartX = Math.cos(_nStartingOrientation);
         nNormalStartY = -Math.sin(_nStartingOrientation);
         nSecsPerFrame = 1 / _mcRef.stage.frameRate;
         faceFromNormal(nNormalStartX,nNormalStartY);
         Game.Instance.listenToProjectile(this,_bIsAnEnemy);
         oLocalBody = new Rectangle(0,0,_nBodyWidth,_nBodyHeight);
         oLocalBody.offset(-_nBodyWidth / 2,-_nBodyHeight / 2);
         oLocalFeet = new Rectangle(0,0,_nBodyWidth,1);
         oLocalFeet.offset(-_nBodyWidth / 2,0);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_DESTROY,destroy);
         _oGameDisp.addEventListener(sAttackEventType,onAttackNotHitted,false,-1,true);
      }
      
      public function destroy(_e:Event = null) : void
      {
         dispatchEvent(new ProjectileEvent(ProjectileEvent.EVENT_DESTROY,this));
         removeEventListener(sAttackEventType,onAttackNotHitted);
         Game.Instance.stopListenProjectile(this);
         oEventDisp = null;
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(GameEvent.EVENT_DESTROY,destroy);
         mcProj.parent.removeChild(mcProj);
         mcProj = null;
      }
      
      protected function stateIdle() : void
      {
         var _oAttZone:Rectangle = null;
         nLastX = mcProj.x;
         nLastY = mcProj.y;
         move();
         refreshAutoFacing();
         refreshDistance();
         if(nDist >= nMaxDistance)
         {
            die();
         }
         else
         {
            bHitOpponent = true;
            _oAttZone = oLocalBody.clone();
            _oAttZone.offset(mcProj.x,mcProj.y);
            dispatchEvent(new AttackEvent(sAttackEventType,this,nDamage,_oAttZone,new Point(mcProj.x,mcProj.y),uItemType));
            if(bDieOnHit && bHitOpponent)
            {
               die();
            }
            else
            {
               dispatchEvent(new MovingBodyEvent(sMovingEventType,this,new Point(nLastX,nLastY),new Point(mcProj.x,mcProj.y),oLocalFeet,oLocalBody,nDamage));
            }
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      protected function die() : void
      {
         var _nAngle:Number = NaN;
         var _sDieState:String = sSTATE_DIE_RIGHT;
         if(bDynamic)
         {
            _nAngle = Math.atan2(-(mcProj.x - nLastX),mcProj.y - nLastY);
            mcProj.rotation = -_nAngle * 180 / Math.PI;
         }
         else
         {
            switch(state)
            {
               case sSTATE_IDLE_UP:
                  _sDieState = sSTATE_DIE_UP;
                  break;
               case sSTATE_IDLE_LEFT:
                  _sDieState = sSTATE_DIE_LEFT;
                  break;
               case sSTATE_IDLE_DOWN:
                  _sDieState = sSTATE_DIE_DOWN;
            }
         }
         setState(_sDieState);
      }
      
      private function stateLoadIdle() : void
      {
      }
      
      private function onAttackNotHitted(_e:Event) : void
      {
         bHitOpponent = false;
      }
      
      public function faceDown() : void
      {
         setState(sSTATE_IDLE_DOWN);
      }
      
      private function refreshAutoFacing() : void
      {
         if(!bAutoFacing)
         {
            return;
         }
         var _nNormX:Number = mcProj.x - nLastX;
         var _nNormY:Number = mcProj.y - nLastY;
         faceFromNormal(_nNormX,_nNormY);
      }
      
      private function stateDie() : void
      {
         if(stateComplete)
         {
            destroy();
         }
      }
      
      public function faceLeft() : void
      {
         setState(sSTATE_IDLE_LEFT);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function faceRight() : void
      {
         setState(sSTATE_IDLE_RIGHT);
      }
      
      public function onWallCollide(_oLast:Point, _oContact:Point, _oBump:Point, _oSlide:Point, _uTries:uint) : void
      {
         var _oEv:MovingBodyEvent = new MovingBodyEvent(MovingBodyEvent.EVENT_PLAYER_MOVE,this,_oLast,_oContact,oLocalFeet,oLocalBody);
         mcProj.x = _oContact.x;
         mcProj.y = _oContact.y;
         dispatchEvent(_oEv);
         die();
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function enableAutoFacing(_bEnabled:Boolean = true) : void
      {
         if(_bEnabled == false)
         {
            bAutoFacing = false;
         }
         else
         {
            bAutoFacing = true;
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function faceUp() : void
      {
         setState(sSTATE_IDLE_UP);
      }
      
      public function move() : void
      {
         mcProj.x += nNormalStartX * nSpeed * nSecsPerFrame;
         mcProj.y += nNormalStartY * nSpeed * nSecsPerFrame;
      }
      
      private function stateLoadDie() : void
      {
      }
      
      private function faceFromNormal(_nNormX:Number, _nNormY:Number) : void
      {
         var _nAngle:Number = NaN;
         if(bDynamic)
         {
            faceRight();
            _nAngle = Math.atan2(-_nNormY,_nNormX);
            mcProj.rotation = -_nAngle * 180 / Math.PI;
         }
         else if(Math.abs(_nNormX) >= Math.abs(_nNormY))
         {
            if(_nNormX > 0)
            {
               faceRight();
            }
            else
            {
               faceLeft();
            }
         }
         else if(_nNormY > 0)
         {
            faceDown();
         }
         else
         {
            faceUp();
         }
      }
      
      private function refreshDistance() : void
      {
         nDist += MoreMath.getDistance(nLastX,nLastY,mcProj.x,mcProj.y);
      }
      
      public function disableAutoFacing() : void
      {
         enableAutoFacing(false);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
   }
}
