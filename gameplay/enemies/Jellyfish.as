package gameplay.enemies
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import gameplay.Enemy;
   import gameplay.ItemID;
   import gameplay.Room;
   import gameplay.interfaces.ILevelCollidable;
   import library.sounds.SoundManager;
   import library.utils.MoreMath;
   
   public class Jellyfish extends Enemy implements ILevelCollidable
   {
      
      public static const uTYPE_LIGHT:uint = 1;
      
      private static const sSTATE_MOVE_RIGHT:String = "moveRight";
      
      private static const sSTATE_MOVE_LEFT:String = "moveLeft";
      
      private static const sSTATE_MOVE_DOWN:String = "moveDown";
      
      private static const sSTATE_MOVE_UP:String = "moveUp";
      
      public static const uTYPE_MID:uint = 2;
      
      public static const uTYPE_HIGH:uint = 3;
      
      private static const sSTATE_HURT:String = "hurt";
       
      
      private var uJellyType:uint;
      
      private var nSpeed:Number;
      
      private var nPhaseTimer:Number;
      
      private var nPhaseTimeMin:Number;
      
      private var iDirH:int;
      
      private var mcJelly:MovieClip;
      
      private var nPhaseTimeMax:Number;
      
      private var iDirV:int;
      
      public function Jellyfish(_mcRef:MovieClip, _oRoom:Room, _uJellyType:uint = 1, _uItemToDrop:uint = 0)
      {
         var _nInitHealth:Number = NaN;
         var _nDamage:Number = NaN;
         var _aDropTable:Array = null;
         mcJelly = _mcRef;
         trace("Jellyfish : creation ");
         uJellyType = _uJellyType;
         nPhaseTimer = 0;
         iDirH = 0;
         iDirV = 0;
         var _sInitState:String = sSTATE_MOVE_DOWN;
         switch(_uJellyType)
         {
            case uTYPE_LIGHT:
               _nInitHealth = Data.nENEMY_JELLYFISH_INIT_HEALTH_LIGHT;
               _nDamage = Data.nENEMY_JELLYFISH_DAMAGE_LIGHT;
               nPhaseTimeMin = Data.nENEMY_JELLYFISH_PHASE_CHANGE_MIN_LIGHT;
               nPhaseTimeMax = Data.nENEMY_JELLYFISH_PHASE_CHANGE_MAX_LIGHT;
               nSpeed = Data.nENEMY_JELLYFISH_SPEED_LIGHT;
               _aDropTable = Data.aJELLYFISH_LIGHT_DROP_TABLE;
               break;
            case uTYPE_MID:
               _nInitHealth = Data.nENEMY_JELLYFISH_INIT_HEALTH_MID;
               _nDamage = Data.nENEMY_JELLYFISH_DAMAGE_MID;
               nPhaseTimeMin = Data.nENEMY_JELLYFISH_PHASE_CHANGE_MIN_MID;
               nPhaseTimeMax = Data.nENEMY_JELLYFISH_PHASE_CHANGE_MAX_MID;
               nSpeed = Data.nENEMY_JELLYFISH_SPEED_MID;
               _aDropTable = Data.aJELLYFISH_MID_DROP_TABLE;
               break;
            case uTYPE_HIGH:
               _nInitHealth = Data.nENEMY_JELLYFISH_INIT_HEALTH_HIGH;
               _nDamage = Data.nENEMY_JELLYFISH_DAMAGE_HIGH;
               nPhaseTimeMin = Data.nENEMY_JELLYFISH_PHASE_CHANGE_MIN_HIGH;
               nPhaseTimeMax = Data.nENEMY_JELLYFISH_PHASE_CHANGE_MAX_HIGH;
               nSpeed = Data.nENEMY_JELLYFISH_SPEED_HIGH;
               _aDropTable = Data.aJELLYFISH_HIGH_DROP_TABLE;
         }
         var _uItem:uint = _uItemToDrop;
         if(_uItem == ItemID.uNULL_ITEM)
         {
            _uItem = throwItemFromDropTable(_aDropTable);
         }
         super(_mcRef,_oRoom,_nInitHealth,_nDamage,true,_uItem);
         addState(sSTATE_MOVE_UP,stateMove);
         addState(sSTATE_MOVE_DOWN,stateMove);
         addState(sSTATE_MOVE_LEFT,stateMove);
         addState(sSTATE_MOVE_RIGHT,stateMove);
         addState(sSTATE_HURT,stateHurt);
         setState(sSTATE_MOVE_DOWN);
      }
      
      private function stateHurt() : void
      {
         if(!isDying() && stateComplete)
         {
            gotoNewDirection();
         }
      }
      
      private function stateMove() : void
      {
         updatePosition();
         if(!isDying() && !updatePhaseTimer())
         {
            gotoNewDirection();
         }
      }
      
      private function gotoNewDirection() : void
      {
         var _iRand:Number = NaN;
         var _sState:String = null;
         var _iLastDirV:int = iDirV;
         var _iLastDirH:int = iDirH;
         do
         {
            _iRand = MoreMath.getRandomRange(1,4);
            switch(_iRand)
            {
               case 1:
                  iDirH = 0;
                  iDirV = 1;
                  _sState = sSTATE_MOVE_DOWN;
                  break;
               case 2:
                  iDirH = 0;
                  iDirV = -1;
                  _sState = sSTATE_MOVE_UP;
                  break;
               case 3:
                  iDirH = 1;
                  iDirV = 0;
                  _sState = sSTATE_MOVE_RIGHT;
                  break;
               case 4:
                  iDirH = -1;
                  iDirV = 0;
                  _sState = sSTATE_MOVE_LEFT;
                  break;
            }
         }
         while(_iLastDirH == iDirH && _iLastDirV == iDirV);
         
         getNewPhaseTimer();
         setState(_sState);
      }
      
      private function updatePhaseTimer() : Boolean
      {
         if(nPhaseTimer <= 0)
         {
            return false;
         }
         nPhaseTimer -= nSPF;
         if(nPhaseTimer <= 0)
         {
            return false;
         }
         return true;
      }
      
      private function updatePosition() : void
      {
         if(isBumping())
         {
            return;
         }
         if(iDirV != 0)
         {
            mcJelly.y += nSPF * nSpeed * iDirV;
         }
         else
         {
            mcJelly.x += nSPF * nSpeed * iDirH;
         }
      }
      
      override protected function onPlayerHit(_uItemUsed:uint, _bWouldDie:Boolean = false) : Boolean
      {
         if(!_bWouldDie)
         {
            setState(sSTATE_HURT);
            SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndJellyDie.wav",1,1,false);
         }
         return true;
      }
      
      public function getJellyfishType() : uint
      {
         return uJellyType;
      }
      
      private function getNewPhaseTimer() : void
      {
         nPhaseTimer = MoreMath.getRandomRangeFloat(nPhaseTimeMin,nPhaseTimeMax);
      }
      
      override public function destroy(_e:Event = null) : void
      {
         super.destroy(_e);
         mcJelly = null;
      }
      
      override public function onWallCollide(_oLast:Point, _oContact:Point, _oBump:Point, _oSlide:Point, _uTries:uint) : void
      {
         super.onWallCollide(_oLast,_oContact,_oBump,_oSlide,_uTries);
         if(!isDying())
         {
            gotoNewDirection();
         }
      }
   }
}
