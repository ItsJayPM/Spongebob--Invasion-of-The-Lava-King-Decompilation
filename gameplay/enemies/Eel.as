package gameplay.enemies
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.Enemy;
   import gameplay.ItemID;
   import gameplay.Room;
   import gameplay.events.AttackEvent;
   import gameplay.events.MovingBodyEvent;
   import library.sounds.SoundManager;
   import library.utils.MoreMath;
   
   public class Eel extends Enemy
   {
      
      private static const sSTATE_HIDE:String = "hide";
      
      private static const nOUTER_RADIUS:Number = 68;
      
      private static const nINNER_RADIUS:Number = 39;
      
      private static const nELECTRIC_FIELD_ON_HIT:Number = 300;
      
      private static const sSTATE_HURT:String = "hurt";
      
      private static const nEND_WIDTH:Number = 3;
      
      private static const sSTATE_IDLE:String = "idle";
      
      private static const sSTATE_ATTACK:String = "attack";
      
      private static const sSTATE_WARNING:String = "warning";
      
      private static const uNUM_FRAME_HURT_INTERVAL:Number = 3;
       
      
      private var nSecsPerFrame:Number;
      
      private var nHeadPolarAngle:Number;
      
      private var bPlayerInEel:Boolean;
      
      private var nPlayerX:Number;
      
      private var nPlayerY:Number;
      
      private var oAttackZoneOnHit:Rectangle;
      
      private var mcEel:MovieClip;
      
      private var oTail:Point;
      
      private var oAttackZone:Rectangle;
      
      private var oHead:Point;
      
      private var nTailPolarAngle:Number;
      
      private var iHurtFrame:int;
      
      private var nTimer:Number;
      
      private var oEndZone:Rectangle;
      
      private var oBodyZone:Rectangle;
      
      public function Eel(_mcRef:MovieClip, _oRoom:Room, _uItemToDrop:uint = 0)
      {
         mcEel = _mcRef;
         mcEel.mcEel.stop();
         oTail = new Point();
         oHead = new Point();
         bPlayerInEel = false;
         nSecsPerFrame = 1 / _mcRef.stage.frameRate;
         var _uItem:uint = _uItemToDrop;
         if(_uItem == ItemID.uNULL_ITEM)
         {
            _uItem = throwItemFromDropTable(Data.aEEL_DROP_TABLE);
         }
         super(mcEel,_oRoom,Data.nENEMY_EEL_INIT_HEALTH,Data.nENEMY_EEL_DAMAGE,false,_uItem);
         oAttackZone = new Rectangle(-nINNER_RADIUS,-nINNER_RADIUS,nINNER_RADIUS * 2,nINNER_RADIUS * 2);
         oAttackZone.offset(mcEel.x,mcEel.y);
         oAttackZoneOnHit = new Rectangle(-nELECTRIC_FIELD_ON_HIT / 2,-nELECTRIC_FIELD_ON_HIT / 2,nELECTRIC_FIELD_ON_HIT,nELECTRIC_FIELD_ON_HIT);
         oAttackZoneOnHit.offset(mcEel.x,mcEel.y);
         oEndZone = new Rectangle(-nEND_WIDTH / 2,-nEND_WIDTH / 2,nEND_WIDTH,nEND_WIDTH);
         oBodyZone = new Rectangle(-nOUTER_RADIUS,-nOUTER_RADIUS,nOUTER_RADIUS * 2,nOUTER_RADIUS * 2);
         setLocalBodyZone(oBodyZone.clone());
         setLocalFeetZone(oBodyZone.clone());
         oBodyZone.offset(mcEel.x,mcEel.y);
         addState(sSTATE_IDLE,stateIdle,stateLoadIdle);
         addState(sSTATE_ATTACK,stateAttack);
         addState(sSTATE_HURT,stateHurt,stateLoadHurt);
         addState(sSTATE_WARNING,stateWarning);
         throwAttackTimer();
         setState(sSTATE_IDLE);
      }
      
      private function stateIdle() : void
      {
         nTimer -= nSecsPerFrame;
         if(nTimer <= 0)
         {
            setState(sSTATE_WARNING);
         }
         else
         {
            refreshEel();
            refreshHeadAndTail();
            attackIfPlayerOnEel();
         }
      }
      
      public function stateLoadIdle() : void
      {
         mcEel.mcEel.mcTail.visible = false;
         mcEel.mcEel.mcHead.visible = false;
         mcEel.mcEel.visible = true;
         stopEel();
         throwAttackTimer();
      }
      
      private function attackIfPlayerOnEel() : void
      {
         if(!bPlayerInEel)
         {
            return;
         }
         if(positionCollidesWithEel(nPlayerX,nPlayerY))
         {
            triggerHitMovingPlayer();
         }
      }
      
      private function stateHurt() : void
      {
         nTimer -= nSecsPerFrame;
         if(nTimer < 0)
         {
            setState(sSTATE_IDLE);
         }
         else
         {
            --iHurtFrame;
            if(iHurtFrame <= 0)
            {
               mcEel.mcEel.visible = !mcEel.mcEel.visible;
               mcEel.mcEelHurt.visible = !mcEel.mcEel.visible;
               iHurtFrame = uNUM_FRAME_HURT_INTERVAL;
            }
         }
      }
      
      private function throwAttackTimer() : void
      {
         var _nTime:Number = MoreMath.getRandomRangeFloat(Data.nENEMY_EEL_MIN_TIME_TO_ATTACK,Data.nENEMY_EEL_MAX_TIME_TO_ATTACK);
         nTimer = _nTime;
         trace("EEL : Throp attack timer ",nTimer);
      }
      
      private function refreshEel() : void
      {
         mcEel.mcEel.stop();
         if(mcEel.mcEel.currentFrame == mcEel.mcEel.totalFrames)
         {
            mcEel.mcEel.gotoAndStop(1);
         }
         else
         {
            mcEel.mcEel.nextFrame();
         }
         mcEel.mcEel.mcTail.visible = false;
         mcEel.mcEel.mcHead.visible = false;
      }
      
      private function stateLoadHurt() : void
      {
         stopEel();
         mcEel.mcEelHurt.mcTail.visible = false;
         mcEel.mcEelHurt.mcHead.visible = false;
         nTimer = Data.nENEMY_EEL_HURT_DURATION;
         iHurtFrame = uNUM_FRAME_HURT_INTERVAL;
         mcEel.mcEel.visible = false;
         mcEel.mcEelHurt.visible = true;
      }
      
      private function positionCollidesWithEel(_nWorldX:Number, _nWorldY:Number) : Boolean
      {
         var _nPolarAngle:Number = NaN;
         var _bRet:Boolean = false;
         var _nLocalX:Number = _nWorldX - mcEel.x;
         var _nLocalY:Number = _nWorldY - mcEel.y;
         var _nLenSq:Number = Math.pow(_nLocalX,2) + Math.pow(_nLocalY,2);
         if(_nLenSq <= nINNER_RADIUS * nINNER_RADIUS)
         {
            _bRet = false;
         }
         else if(_nLenSq <= nOUTER_RADIUS * nOUTER_RADIUS)
         {
            _nPolarAngle = Math.atan2(-_nLocalY,_nLocalX);
            while(_nPolarAngle < nTailPolarAngle)
            {
               _nPolarAngle += Math.PI * 2;
            }
            if(_nPolarAngle <= nHeadPolarAngle)
            {
               _bRet = false;
            }
            else
            {
               _bRet = true;
            }
         }
         return _bRet;
      }
      
      override protected function onPlayerMove(_e:MovingBodyEvent) : void
      {
         var _oWorldBody:Rectangle = _e.localBodyZone;
         _oWorldBody.offsetPoint(_e.newWorldPosition);
         var _oWorldFeet:Rectangle = _e.localFeetZone;
         _oWorldFeet.offsetPoint(_e.newWorldPosition);
         if(collidesWithEel(_oWorldFeet,_oWorldBody))
         {
            super.onPlayerMove(_e);
         }
      }
      
      private function isPositionThroughtEel(_nWorldX:Number, _nWorldY:Number) : Boolean
      {
         var _nLocalX:Number = mcEel.x - _nWorldX;
         var _nLocalY:Number = mcEel.y - _nWorldY;
         var _nLenSq:Number = Math.pow(_nLocalX,2) + Math.pow(_nLocalY,2);
         return _nLenSq <= nOUTER_RADIUS * nOUTER_RADIUS;
      }
      
      private function stateWarning() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_ATTACK);
            SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndEelAttack",1,1,true);
         }
         else
         {
            refreshEel();
            refreshHeadAndTail();
            attackIfPlayerOnEel();
         }
      }
      
      private function collidesWithEel(_oWorldFeet:Rectangle, _oWorldBody:Rectangle) : Boolean
      {
         var _oPos:Point = null;
         var _oCenter:Point = null;
         if(_oWorldFeet == null || _oWorldBody == null)
         {
            return false;
         }
         var _bThroughtEel:Boolean = false;
         var _bRet:Boolean = false;
         var _aFeetPos:Array = [_oWorldFeet.topLeft,_oWorldFeet.bottomRight,new Point(_oWorldFeet.right,_oWorldFeet.top),new Point(_oWorldFeet.left,_oWorldFeet.bottom)];
         var i:uint = 0;
         while(!_bThroughtEel && i < 4)
         {
            _oPos = _aFeetPos[i];
            if(isPositionThroughtEel(_oPos.x,_oPos.y))
            {
               _bThroughtEel = true;
            }
            i++;
         }
         bPlayerInEel = _bThroughtEel;
         if(_bThroughtEel)
         {
            _oCenter = new Point(_oWorldBody.left + _oWorldBody.width / 2,_oWorldBody.top + _oWorldBody.height / 2);
            nPlayerX = _oCenter.x;
            nPlayerY = _oCenter.y;
            _bRet = positionCollidesWithEel(_oCenter.x,_oCenter.y);
         }
         return _bRet;
      }
      
      override protected function onPlayerHit(_uItemUsed:uint, _bWouldDie:Boolean = false) : Boolean
      {
         var _bRet:Boolean = false;
         if(_uItemUsed == ItemID.uSWORD_LV_1 || _uItemUsed == ItemID.uSWORD_LV_2 || _uItemUsed == ItemID.uWAND)
         {
            dispatchEvent(new AttackEvent(AttackEvent.EVENT_ENEMY_ATTACK,this,Data.nENEMY_EEL_DAMAGE,oAttackZoneOnHit,new Point(mcEel.x,mcEel.y),AttackEvent.uENEMY_EFFECT_ELECTRIFY));
         }
         _bRet = true;
         if(!_bWouldDie)
         {
            setState(sSTATE_HURT);
         }
         return _bRet;
      }
      
      private function electrifyPlayerInEel() : void
      {
         if(!bPlayerInEel)
         {
            return;
         }
         if(isPositionThroughtEel(nPlayerX,nPlayerY))
         {
            dispatchEvent(new AttackEvent(AttackEvent.EVENT_ENEMY_ATTACK,this,Data.nENEMY_EEL_DAMAGE,oAttackZone,new Point(mcEel.x,mcEel.y),AttackEvent.uENEMY_EFFECT_ELECTRIFY));
         }
      }
      
      private function stopEel() : void
      {
         mcEel.mcEel.stop();
         if(mcEel.mcEelHurt != null)
         {
            mcEel.mcEelHurt.gotoAndStop(mcEel.mcEel.currentFrame);
         }
      }
      
      private function stateAttack() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_IDLE);
         }
         else
         {
            electrifyPlayerInEel();
            refreshEel();
            refreshHeadAndTail();
            attackIfPlayerOnEel();
         }
      }
      
      private function refreshHeadAndTail() : void
      {
         var _nLastTailX:Number = oTail.x;
         var _nLastTailY:Number = oTail.y;
         var _nLastHeadX:Number = oHead.x;
         var _nLastHeadY:Number = oHead.y;
         mcEel.mcEel.mcTail.visible = false;
         mcEel.mcEel.mcHead.visible = false;
         oTail.x = mcEel.mcEel.mcTail.x;
         oTail.y = mcEel.mcEel.mcTail.y;
         oHead.x = mcEel.mcEel.mcHead.x;
         oHead.y = mcEel.mcEel.mcHead.y;
         oTail.offset(mcEel.x,mcEel.y);
         oHead.offset(mcEel.x,mcEel.y);
         if(_nLastHeadX != oHead.x || _nLastHeadY != oHead.y || _nLastTailX != oTail.x || _nLastTailY != oTail.y)
         {
            nTailPolarAngle = Math.atan2(-(oTail.y - mcEel.y),oTail.x - mcEel.x);
            nHeadPolarAngle = Math.atan2(-(oHead.y - mcEel.y),oHead.x - mcEel.x);
            while(nHeadPolarAngle < nTailPolarAngle)
            {
               nHeadPolarAngle += Math.PI * 2;
            }
         }
      }
   }
}
