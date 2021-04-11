package gameplay.bosses
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.Boss;
   import gameplay.GameDispatcher;
   import gameplay.Room;
   import gameplay.Storyline;
   import gameplay.events.AttackEvent;
   import gameplay.events.HurtEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.ThrowEvent;
   import library.sounds.SoundManager;
   import library.utils.MoreMath;
   
   public class GaseousRock extends Boss
   {
      
      private static const uARM_ATTACK_AT_FRAME:uint = 20;
      
      private static const sSTATE_GAS_SPOUT:String = "gasSpout";
      
      private static const aGAS_CLOUD_ATTACK_ANGLES:Array = [Math.PI * 0.5,Math.PI * 0.6,Math.PI * 0.7,Math.PI * 0.8,Math.PI * 0.9,Math.PI * 1,Math.PI * 1.1,Math.PI * 1.2,Math.PI * 1.3,Math.PI * 1.4,Math.PI * 1.5];
      
      private static const sSTATE_GAS_CLOUD:String = "gasCloud";
      
      private static const uNUM_FRAME_FORGIVENESS_PERIOD:uint = 2;
      
      private static const sSTATE_HURT:String = "hurt";
      
      private static const uGAS_CLOUD_ATTACK_AT_FRAME:uint = 29;
      
      private static const sSTATE_IDLE:String = "idle";
      
      private static const uGAS_SPOUT_ATTACK_AT_FRAME:uint = 33;
      
      private static const sSTATE_ARM_SWING:String = "armSwing";
       
      
      private var nNextCooldownTime:Number;
      
      private var nForgiveTimer:Number;
      
      private var oWorldProjSource:Point;
      
      private var nDistanceToPlayerSq:Number;
      
      private var nPlayerPositionX:Number;
      
      private var nPlayerPositionY:Number;
      
      private var mcBoss:MovieClip;
      
      private var oWorldZone:Rectangle;
      
      private var nSecsPerFrame:Number;
      
      private var uForgiveFrame:uint;
      
      private var nSPF:Number;
      
      private var uNumGasSpoutThrowed:uint;
      
      private var nTimeCoeff:Number;
      
      private var oRoom:Room;
      
      private var oWorldArmAttackZone:Rectangle;
      
      private var sPreviousAttack:String;
      
      private var bInitialMove:Boolean;
      
      private var nTimer:Number;
      
      public function GaseousRock(_mcRef:MovieClip, _oRoom:Room)
      {
         super(_mcRef,_oRoom,Data.nGASEOUS_ROCK_INIT_HEALTH,Data.nGASEOUS_ROCK_HIT_DAMAGE);
         mcBoss = _mcRef;
         nSPF = 1 / mcBoss.stage.frameRate;
         oWorldZone = mcBoss.getBounds(mcBoss);
         oWorldZone.inflate(-10,-10);
         setLocalBodyZone(oWorldZone);
         setLocalFeetZone(oWorldZone);
         oWorldZone.offset(mcBoss.x,mcBoss.y);
         oWorldArmAttackZone = oWorldZone.clone();
         oWorldArmAttackZone.inflate(Data.iTILE_WIDTH,Data.iTILE_HEIGHT);
         oWorldProjSource = new Point(-Data.iTILE_WIDTH / 2,0);
         oWorldProjSource.offset(mcBoss.x,mcBoss.y);
         oRoom = _oRoom;
         nForgiveTimer = 0;
         nSecsPerFrame = 1 / mcBoss.stage.frameRate;
         nTimer = 0;
         nTimeCoeff = 1;
         addState(sSTATE_IDLE,stateIdle,stateLoadIdle);
         addState(sSTATE_ARM_SWING,stateArmSwing,stateLoadArmSwing);
         addState(sSTATE_GAS_SPOUT,stateGasSpout,stateLoadGasSpout);
         addState(sSTATE_GAS_CLOUD,stateGasCloud,stateLoadGasCloud);
         addState(sSTATE_HURT,stateHurt,stateLoadHurt);
         addState(sSTATE_DIE,stateDie,stateLoadDie);
         coolDown(Data.nGASEOUS_ROCK_INITIAL_COOLDOWN_LENGTH);
         bInitialMove = true;
         uNumGasSpoutThrowed = 0;
         GameDispatcher.Instance.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerToMove);
         GameDispatcher.Instance.addWeakEventListener(HurtEvent.EVENT_PLAYER_HITTED,onPlayerHitted);
      }
      
      private function launchGasSpoutAttack() : void
      {
         var _oEv:ThrowEvent = null;
         var _nAngle:Number = Math.atan2(-(nPlayerPositionY - oWorldProjSource.y),nPlayerPositionX - oWorldProjSource.x);
         _oEv = new ThrowEvent(ThrowEvent.EVENT_ENEMY_THROW_PROJECTILE,ThrowEvent.uPROJECTILE_GAS_SPOUT,oWorldProjSource.x,oWorldProjSource.y,_nAngle);
         dispatchEvent(_oEv);
      }
      
      private function stateIdle() : void
      {
         nTimer -= nSecsPerFrame;
         if(nTimer <= 0)
         {
            gotoNextStateFromAI();
         }
      }
      
      private function stateLoadIdle() : void
      {
      }
      
      private function stateGasCloud() : void
      {
         if(stateComplete)
         {
            coolDown(nNextCooldownTime);
         }
         else if(mcState.currentFrame == uGAS_CLOUD_ATTACK_AT_FRAME)
         {
            launchGasCloudAttack();
         }
      }
      
      private function coolDown(_nTime:Number = 3) : void
      {
         nTimer = _nTime;
         setState(sSTATE_IDLE);
      }
      
      private function stateLoadGasCloud() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndGaseousRockCloud",1,1,true);
      }
      
      private function isForgiven() : Boolean
      {
         return nForgiveTimer > 0;
      }
      
      private function updateForgiveness() : void
      {
         if(isForgiven())
         {
            --uForgiveFrame;
            if(uForgiveFrame == 0)
            {
               mcBoss.visible = !mcBoss.visible;
               uForgiveFrame = uNUM_FRAME_FORGIVENESS_PERIOD;
            }
            nForgiveTimer -= nSPF;
            if(nForgiveTimer <= 0)
            {
               mcBoss.visible = true;
            }
         }
      }
      
      private function stateGasSpout() : void
      {
         if(stateComplete && uNumGasSpoutThrowed >= 3)
         {
            uNumGasSpoutThrowed = 0;
            coolDown(nNextCooldownTime);
         }
         else if(mcState.currentFrame == uGAS_SPOUT_ATTACK_AT_FRAME)
         {
            ++uNumGasSpoutThrowed;
            launchGasSpoutAttack();
         }
      }
      
      private function onPlayerToMove(_e:MovingBodyEvent) : void
      {
         nDistanceToPlayerSq = MoreMath.getDistanceSq(mcBoss.x,mcBoss.y,_e.newWorldPosition.x,_e.newWorldPosition.y);
         nPlayerPositionX = _e.newWorldPosition.x;
         nPlayerPositionY = _e.newWorldPosition.y;
      }
      
      private function stateDie() : void
      {
         if(stateComplete)
         {
            destroy();
            Storyline.play("Boss");
         }
      }
      
      private function stateLoadArmSwing() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndGaseousRockArm",1,1,true);
      }
      
      private function stateArmSwing() : void
      {
         var _oEv:AttackEvent = null;
         if(stateComplete)
         {
            coolDown(nNextCooldownTime);
         }
         else if(mcState.currentFrame == uARM_ATTACK_AT_FRAME)
         {
            _oEv = new AttackEvent(AttackEvent.EVENT_ENEMY_ATTACK,this,Data.nGASEOUS_ROCK_ARM_SWING_DAMAGE,oWorldArmAttackZone,new Point(mcBoss.x,mcBoss.y));
            dispatchEvent(_oEv);
         }
      }
      
      private function stateLoadGasSpout() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndGaseousRockSpout",1,1,true);
      }
      
      override public function update(_e:Event) : void
      {
         super.update(_e);
         if(mcRef != null)
         {
            updateForgiveness();
         }
      }
      
      private function stateLoadHurt() : void
      {
      }
      
      private function throwAttack(_aAITable:Array) : String
      {
         var _sRet:String = null;
         var _uRand:uint = MoreMath.getRandomRange(1,100);
         var _uOffset:uint = 0;
         var _iState:int = -1;
         var i:uint = 0;
         while(_iState == -1 && i < 3)
         {
            if(_aAITable[i].luck + _uOffset >= _uRand)
            {
               _iState = i;
               nNextCooldownTime = _aAITable[i].cool;
            }
            else
            {
               _uOffset += _aAITable[i].luck;
            }
            i++;
         }
         if(!playerSeen())
         {
            _iState = 2;
            nNextCooldownTime = _aAITable[2].cool;
         }
         switch(_iState)
         {
            case -1:
               trace("Gaseous Rock : PROBLEMATIC SOLUTION : THROW DIDN\'T GIVE ANY ACTION");
               break;
            case 0:
               _sRet = sSTATE_ARM_SWING;
               break;
            case 1:
               _sRet = sSTATE_GAS_SPOUT;
               break;
            case 2:
               _sRet = sSTATE_GAS_CLOUD;
         }
         return _sRet;
      }
      
      private function stateHurt() : void
      {
         if(stateComplete)
         {
            startForgiveness();
            gotoNextStateFromAI();
         }
      }
      
      override protected function onPlayerHit(_uItemUsed:uint, _bWouldDie:Boolean = false) : Boolean
      {
         if(!canBeHurt())
         {
            return false;
         }
         if(!_bWouldDie)
         {
            setState(sSTATE_HURT);
         }
         return true;
      }
      
      private function stopForgiveness() : void
      {
         nForgiveTimer = 0;
         mcBoss.visible = true;
      }
      
      private function launchGasCloudAttack() : void
      {
         var _oEv:ThrowEvent = null;
         for(var i:uint = 0; i < aGAS_CLOUD_ATTACK_ANGLES.length; i++)
         {
            _oEv = new ThrowEvent(ThrowEvent.EVENT_ENEMY_THROW_PROJECTILE,ThrowEvent.uPROJECTILE_GAS_CLOUD,oWorldProjSource.x,oWorldProjSource.y,aGAS_CLOUD_ATTACK_ANGLES[i]);
            dispatchEvent(_oEv);
         }
      }
      
      private function onPlayerHitted(_e:HurtEvent) : void
      {
         if(state == sSTATE_ARM_SWING)
         {
            SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndHit1.wav",1,1,true);
         }
      }
      
      private function canBeHurt() : Boolean
      {
         return !isForgiven() && state != sSTATE_HURT && state != sSTATE_DIE && !isDying();
      }
      
      private function stateLoadDie() : void
      {
         GameDispatcher.Instance.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerToMove);
         Main.instance.switchToDungeonMusic();
      }
      
      private function startForgiveness() : void
      {
         uForgiveFrame = uNUM_FRAME_FORGIVENESS_PERIOD;
         nForgiveTimer = Data.nPLAYER_FORGIVENESS;
         mcBoss.visible = false;
      }
      
      private function gotoNextStateFromAI() : void
      {
         var _sState:String = null;
         if(bInitialMove)
         {
            bInitialMove = false;
            _sState = throwAttack(Data.aGASEOUS_ROCK_AI_INITIAL_MOVE);
            sPreviousAttack = _sState;
         }
         else
         {
            bInitialMove = true;
            switch(sPreviousAttack)
            {
               case sSTATE_ARM_SWING:
                  _sState = throwAttack(Data.aGASEOUS_ROCK_AI_AFTER_ARM_SWING);
                  break;
               case sSTATE_GAS_SPOUT:
                  _sState = throwAttack(Data.aGASEOUS_ROCK_AI_AFTER_GAS_SPOUT);
                  break;
               case sSTATE_GAS_CLOUD:
                  _sState = throwAttack(Data.aGASEOUS_ROCK_AI_AFTER_GAS_CLOUD);
            }
         }
         setState(_sState);
      }
      
      override public function destroy(_e:Event = null) : void
      {
         GameDispatcher.Instance.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerToMove);
         GameDispatcher.Instance.removeEventListener(HurtEvent.EVENT_PLAYER_HITTED,onPlayerHitted);
         super.destroy(_e);
      }
      
      private function playerSeen() : Boolean
      {
         return nDistanceToPlayerSq <= Math.pow(Data.nGASEOUS_ROCK_FIELD_OF_VIEW,2);
      }
   }
}
