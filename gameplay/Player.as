package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.AttackEvent;
   import gameplay.events.DoorEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.HurtEvent;
   import gameplay.events.ItemEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.PlayerEvent;
   import gameplay.events.ProfileEvent;
   import gameplay.events.TextboxEvent;
   import gameplay.events.ThrowEvent;
   import gameplay.interfaces.ILevelCollidable;
   import gameplay.projectiles.Boomerang;
   import gameplay.projectiles.SeaUrchin;
   import library.basic.InputManager;
   import library.basic.StateManaged;
   import library.sounds.SoundManager;
   import library.utils.MoreMath;
   
   public class Player extends StateManaged implements IEventDispatcher, ILevelCollidable
   {
      
      public static const nANGLE_LEFT:Number = Math.PI;
      
      public static const iKEY_DOWN:uint = InputManager.DOWN;
      
      public static const uNUM_FRAME_FORGIVENESS_PERIOD:uint = 2;
      
      private static const nDIAGONAL_DISTANCE:Number = Math.sin(Math.PI / 4);
      
      public static const sSTATE_SHIELD_LV1:String = "shield1";
      
      public static const sSTATE_SHIELD_LV2:String = "shield2";
      
      public static const nANGLE_UP:Number = Math.PI / 2;
      
      public static const sSTATE_ELECTRIFY:String = "electrify";
      
      public static const sSTATE_SHIELD_BUMP_LV1:String = "shield1Bump";
      
      public static const sSTATE_SHIELD_BUMP_LV2:String = "shield2Bump";
      
      public static const sSTATE_SUFFIX_UP:String = "Up";
      
      private static const nBUMP_DISTANCE:Number = 30;
      
      public static const iDEBUG_KEY_PEEBLE:uint = InputManager.P;
      
      public static const nANGLE_RIGHT:Number = 0;
      
      public static const iKEY_UP:uint = InputManager.UP;
      
      public static const iKEY_PRIMARY_WEAPON:uint = InputManager.A;
      
      public static const sSTATE_SUFFIX_RIGHT:String = "Right";
      
      public static const nANGLE_UP_RIGHT:Number = Math.PI / 4;
      
      public static const sSTATE_SUFFIX_LEFT:String = "Left";
      
      public static const iKEY_SECONDARY_WEAPON:uint = InputManager.S;
      
      public static const sSTATE_URCHIN_SEA:String = "urchinSea";
      
      private static const nSHIELD_TIMEOUT:Number = Data.nSHIELD_TIMEOUT;
      
      public static const sSTATE_SWORD_LV1:String = "sword1";
      
      public static const sSTATE_SWORD_LV2:String = "sword2";
      
      private static const uFACE_DOWN:uint = 3;
      
      public static const iKEY_LEFT:uint = InputManager.LEFT;
      
      public static const iDEBUG_KEY_KEY:uint = InputManager.K;
      
      public static const sSTATE_DIE:String = "die";
      
      public static const sSTATE_FORK:String = "fork";
      
      public static const sSTATE_WALK:String = "walk";
      
      public static const iDEBUG_KEY_HEART:uint = InputManager.H;
      
      private static const uNUM_COLLISION_TO_FORCE_BUMP:uint = 5;
      
      public static const sSTATE_IDLE:String = "idle";
      
      public static const nANGLE_DOWN_RIGHT:Number = -Math.PI / 4;
      
      public static const nFPS:Number = Main.instance.stage.frameRate;
      
      public static const nSPF:Number = 1 / nFPS;
      
      public static const nANGLE_DOWN:Number = -Math.PI / 2;
      
      private static const nPLAYER_WALK_SPEED:Number = Data.nPLAYER_WALK_SPEED;
      
      public static const sSTATE_NEW_ITEM:String = "newItem";
      
      public static var Instance:Player = null;
      
      private static const uFACE_UP:uint = 1;
      
      public static const iKEY_RIGHT:uint = InputManager.RIGHT;
      
      private static const nSECS_PER_FRAME:Number = 1 / Main.instance.stage.frameRate;
      
      public static const sSTATE_BOOMERANG:String = "boomerang";
      
      private static const nBUMP_SPEED:Number = 900;
      
      private static const uFACE_RIGHT:uint = 2;
      
      public static const sSTATE_HURT:String = "hurt";
      
      public static const nANGLE_DOWN_LEFT:Number = -Math.PI * 3 / 4;
      
      public static const sSTATE_WAND:String = "wand";
      
      private static const uFACE_LEFT:uint = 0;
      
      public static const sSTATE_URCHIN_VOLC:String = "urchinVolc";
      
      public static const sSTATE_SUFFIX_DOWN:String = "Down";
      
      public static const nANGLE_UP_LEFT:Number = Math.PI * 3 / 4;
       
      
      private var iSecondaryWeapon:int;
      
      private var oLocalFeet:Rectangle;
      
      private var mcPlayer:MovieClip;
      
      private var bUnderCtrl:Boolean;
      
      private var nCtrlGoalX:Number;
      
      private var nCtrlGoalY:Number;
      
      private var bPaused:Boolean;
      
      private var oProfile:Profile;
      
      private var uForgiveFrame:uint;
      
      private var _nLastPosX:Number;
      
      private var _nLastPosY:Number;
      
      private var bActionNotNested:Boolean;
      
      private var fCtrlOnFinish:Function;
      
      private var sLastState:String;
      
      private var bPickingNewItem:Boolean;
      
      private var nBumpDist:Number;
      
      private var oBumpNormal:Point;
      
      private var nShieldBlockTimer:Number;
      
      private var iUsingWeapon:int;
      
      private var nForgiveTimer:Number;
      
      private var oEventDisp:EventDispatcher;
      
      private var nDirection:Number;
      
      private var oInputMan:InputManager;
      
      private var uItemPicked:uint;
      
      private var iPrimaryWeapon:int;
      
      private var oSeaUrchin:SeaUrchin;
      
      private var bDying:Boolean;
      
      private var oLocalBody:Rectangle;
      
      public function Player(_mcRef:MovieClip)
      {
         trace("Player : Creation");
         super(_mcRef);
         mcPlayer = _mcRef;
         oEventDisp = new EventDispatcher(this);
         bDying = false;
         oLocalBody = new Rectangle();
         oLocalBody.x = -25;
         oLocalBody.y = -50;
         oLocalBody.right = 25;
         oLocalBody.bottom = 0;
         oLocalBody.inflate(-20,-20);
         oLocalFeet = new Rectangle();
         oLocalFeet.x = -15;
         oLocalFeet.y = -10;
         oLocalFeet.right = 15;
         oLocalFeet.bottom = 10;
         addState(sSTATE_IDLE + sSTATE_SUFFIX_UP,stateIdle,stateLoadIlde);
         addState(sSTATE_IDLE + sSTATE_SUFFIX_DOWN,stateIdle,stateLoadIlde);
         addState(sSTATE_IDLE + sSTATE_SUFFIX_LEFT,stateIdle,stateLoadIlde);
         addState(sSTATE_IDLE + sSTATE_SUFFIX_RIGHT,stateIdle,stateLoadIlde);
         addState(sSTATE_WALK + sSTATE_SUFFIX_UP,stateWalk,stateLoadWalk);
         addState(sSTATE_WALK + sSTATE_SUFFIX_DOWN,stateWalk,stateLoadWalk);
         addState(sSTATE_WALK + sSTATE_SUFFIX_LEFT,stateWalk,stateLoadWalk);
         addState(sSTATE_WALK + sSTATE_SUFFIX_RIGHT,stateWalk,stateLoadWalk);
         addState(sSTATE_SWORD_LV1 + sSTATE_SUFFIX_UP,stateSword,stateLoadSword);
         addState(sSTATE_SWORD_LV1 + sSTATE_SUFFIX_DOWN,stateSword,stateLoadSword);
         addState(sSTATE_SWORD_LV1 + sSTATE_SUFFIX_LEFT,stateSword,stateLoadSword);
         addState(sSTATE_SWORD_LV1 + sSTATE_SUFFIX_RIGHT,stateSword,stateLoadSword);
         addState(sSTATE_SHIELD_LV1 + sSTATE_SUFFIX_UP,stateShield,stateLoadShield);
         addState(sSTATE_SHIELD_LV1 + sSTATE_SUFFIX_DOWN,stateShield,stateLoadShield);
         addState(sSTATE_SHIELD_LV1 + sSTATE_SUFFIX_LEFT,stateShield,stateLoadShield);
         addState(sSTATE_SHIELD_LV1 + sSTATE_SUFFIX_RIGHT,stateShield,stateLoadShield);
         addState(sSTATE_SHIELD_BUMP_LV1 + sSTATE_SUFFIX_UP,stateShieldBump,stateLoadShieldBump);
         addState(sSTATE_SHIELD_BUMP_LV1 + sSTATE_SUFFIX_DOWN,stateShieldBump,stateLoadShieldBump);
         addState(sSTATE_SHIELD_BUMP_LV1 + sSTATE_SUFFIX_LEFT,stateShieldBump,stateLoadShieldBump);
         addState(sSTATE_SHIELD_BUMP_LV1 + sSTATE_SUFFIX_RIGHT,stateShieldBump,stateLoadShieldBump);
         addState(sSTATE_URCHIN_SEA + sSTATE_SUFFIX_UP,stateSeaUrchin,stateLoadSeaUrchin);
         addState(sSTATE_URCHIN_SEA + sSTATE_SUFFIX_DOWN,stateSeaUrchin,stateLoadSeaUrchin);
         addState(sSTATE_URCHIN_SEA + sSTATE_SUFFIX_LEFT,stateSeaUrchin,stateLoadSeaUrchin);
         addState(sSTATE_URCHIN_SEA + sSTATE_SUFFIX_RIGHT,stateSeaUrchin,stateLoadSeaUrchin);
         addState(sSTATE_BOOMERANG + sSTATE_SUFFIX_UP,stateBoomerang);
         addState(sSTATE_BOOMERANG + sSTATE_SUFFIX_DOWN,stateBoomerang);
         addState(sSTATE_BOOMERANG + sSTATE_SUFFIX_LEFT,stateBoomerang);
         addState(sSTATE_BOOMERANG + sSTATE_SUFFIX_RIGHT,stateBoomerang);
         addState(sSTATE_HURT + sSTATE_SUFFIX_UP,stateHurt);
         addState(sSTATE_HURT + sSTATE_SUFFIX_DOWN,stateHurt);
         addState(sSTATE_HURT + sSTATE_SUFFIX_LEFT,stateHurt);
         addState(sSTATE_HURT + sSTATE_SUFFIX_RIGHT,stateHurt);
         addState(sSTATE_DIE,stateDie);
         addState(sSTATE_ELECTRIFY + sSTATE_SUFFIX_UP,stateElectrify);
         addState(sSTATE_ELECTRIFY + sSTATE_SUFFIX_DOWN,stateElectrify);
         addState(sSTATE_ELECTRIFY + sSTATE_SUFFIX_LEFT,stateElectrify);
         addState(sSTATE_ELECTRIFY + sSTATE_SUFFIX_RIGHT,stateElectrify);
         addState(sSTATE_NEW_ITEM,stateNewItem,stateLoadNewItem);
         oInputMan = new InputManager();
         oInputMan.addKey(iKEY_UP);
         oInputMan.addKey(iKEY_DOWN);
         oInputMan.addKey(iKEY_LEFT);
         oInputMan.addKey(iKEY_RIGHT);
         oInputMan.addKey(iKEY_PRIMARY_WEAPON);
         oInputMan.addKey(iKEY_SECONDARY_WEAPON);
         if(Data.bPLAYER_DEBUG)
         {
            oInputMan.addKey(iDEBUG_KEY_HEART);
            oInputMan.addKey(iDEBUG_KEY_PEEBLE);
            oInputMan.addKey(iDEBUG_KEY_KEY);
         }
         oBumpNormal = new Point();
         nDirection = nANGLE_DOWN;
         nForgiveTimer = 0;
         bPickingNewItem = false;
         bUnderCtrl = false;
         iPrimaryWeapon = Profile.Instance.getPrimaryWeaponID();
         iSecondaryWeapon = Profile.Instance.getSecondaryWeaponID();
         uItemPicked = ItemID.uNULL_ITEM;
         setOrientedState(sSTATE_IDLE);
         bPaused = false;
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PLAYER_UPDATE,update);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PLAYER_PAUSE,pause);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PLAYER_RESUME,resume);
         _oGameDisp.addEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionNotNested,false,-1,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove,false,10,true);
         _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onEnemyMove);
         _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_ENEMY_HIT_MOVING_PLAYER,onCollisionWithEnemy);
         _oGameDisp.addWeakEventListener(AttackEvent.EVENT_ENEMY_ATTACK,onEnemyAttack);
         _oGameDisp.addWeakEventListener(AttackEvent.EVENT_ENEMY_PROJECTILE_ATTACK,onEnemyProjectile);
         _oGameDisp.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onPickUpItem,false,1,true);
         _oGameDisp.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,onPickUpItemFromChest,false,1,true);
         _oGameDisp.addWeakEventListener(ProfileEvent.EVENT_GET_NEW_ITEM,onGetNewItem);
         _oGameDisp.addWeakEventListener(ProfileEvent.EVENT_UPDATE_PRIMARYWEAPON,onPrimaryWeaponUpdate);
         _oGameDisp.addWeakEventListener(ProfileEvent.EVENT_UPDATE_SECONDARYWEAPON,onSecondaryWeaponUpdate);
         _oGameDisp.addWeakEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR,onAccomplishment,-1);
         _oGameDisp.addWeakEventListener(DoorEvent.EVENT_UNLOCK_OUTDOOR_DOOR,onAccomplishment,-1);
         _oGameDisp.addWeakEventListener(DoorEvent.EVENT_ENTERING_OUTDOOR_DOOR,onAccomplishment,-1);
         oProfile = Profile.Instance;
         Instance = this;
      }
      
      public function destroy(_e:Event = null) : void
      {
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         mcRef = null;
      }
      
      private function stateNewItem() : void
      {
         if(stateComplete)
         {
            trace(" NEW ITEM Test",bPickingNewItem);
            if(bPickingNewItem)
            {
               stopAnim();
               GameDispatcher.Instance.addWeakEventListener(TextboxEvent.EVENT_CLOSE_TEXTBOX,onNewItemTextBoxClosed);
               Storyline.goto("New",String(uItemPicked));
               Storyline.play("New");
            }
            else
            {
               dispatchEvent(new ItemEvent(ItemEvent.EVENT_FINISH_SHOWING_ITEM,uItemPicked));
               setOrientedState(sSTATE_IDLE);
            }
         }
      }
      
      private function walkIfControlled() : Boolean
      {
         var _nNextX:Number = NaN;
         var _nNextY:Number = NaN;
         if(!isUnderControl())
         {
            return false;
         }
         var _iDirH:int = 0;
         if(Math.abs(nCtrlGoalX - mcPlayer.x) >= 0.001)
         {
            if(nCtrlGoalX < mcPlayer.x)
            {
               _iDirH = -1;
            }
            else
            {
               _iDirH = 1;
            }
         }
         var _iDirV:int = 0;
         if(Math.abs(nCtrlGoalY - mcPlayer.y) >= 0.001)
         {
            if(nCtrlGoalY < mcPlayer.y)
            {
               _iDirV = -1;
            }
            else
            {
               _iDirV = 1;
            }
         }
         if(_iDirH == 0 && _iDirV == 0)
         {
            bUnderCtrl = false;
            setOrientedState(sSTATE_IDLE);
            fCtrlOnFinish();
         }
         else
         {
            _nNextX = mcPlayer.x;
            _nNextY = mcPlayer.y;
            if(nDirection == nANGLE_LEFT || nDirection == nANGLE_RIGHT)
            {
               _nNextX += nPLAYER_WALK_SPEED * nSECS_PER_FRAME * _iDirH;
               if(_iDirH == 0 || mcPlayer.x < nCtrlGoalX && _nNextX >= nCtrlGoalX || mcPlayer.x > nCtrlGoalX && _nNextX <= nCtrlGoalX)
               {
                  _nNextX = nCtrlGoalX;
                  if(_iDirV != 0)
                  {
                     if(_iDirV == 1)
                     {
                        nDirection = nANGLE_DOWN;
                     }
                     else
                     {
                        nDirection = nANGLE_UP;
                     }
                  }
               }
            }
            else
            {
               _nNextY += nPLAYER_WALK_SPEED * nSECS_PER_FRAME * _iDirV;
               if(_iDirV == 0 || mcPlayer.y < nCtrlGoalY && _nNextY >= nCtrlGoalY || mcPlayer.y > nCtrlGoalY && _nNextY <= nCtrlGoalY)
               {
                  _nNextY = nCtrlGoalY;
                  if(_iDirH != 0)
                  {
                     if(_iDirH == 1)
                     {
                        nDirection = nANGLE_RIGHT;
                     }
                     else
                     {
                        nDirection = nANGLE_LEFT;
                     }
                  }
               }
            }
            mcPlayer.x = _nNextX;
            mcPlayer.y = _nNextY;
            setOrientedState(sSTATE_WALK);
         }
         return isUnderControl();
      }
      
      private function stateIdle() : void
      {
         var _bTest:Boolean = walkIfControlled();
         if(!_bTest)
         {
            _bTest = walkIfIntended();
            if(!_bTest)
            {
               _bTest = weaponIfIntented();
               if(_bTest)
               {
               }
            }
         }
      }
      
      public function onSecondaryWeaponUpdate(_e:ProfileEvent) : void
      {
         iSecondaryWeapon = _e.itemId;
      }
      
      private function setOrientedState(_sStatePrefix:String) : void
      {
         if(_sStatePrefix != sSTATE_WALK && isOnState(sSTATE_WALK))
         {
            nDirection = getOrientationFromOrientedState(state);
         }
         setState(getOrientedState(_sStatePrefix,nDirection));
      }
      
      private function stateSeaUrchin() : void
      {
         var _nAngle:Number = NaN;
         if(stateComplete)
         {
            setOrientedState(sSTATE_IDLE);
         }
         else if(mcState.currentFrame == Data.uSEA_URCHIN_THROW_AT_FRAME)
         {
            _nAngle = getOrientationFromOrientedState(state);
            SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndThrow.wav",1,1,true);
            dispatchEvent(new ThrowEvent(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,ThrowEvent.uPROJECTILE_SEA_URCHIN,mcPlayer.x,mcPlayer.y,_nAngle));
         }
      }
      
      public function onPickUpItemFromChest(_e:ItemEvent) : void
      {
         trace("Player : onPickUpItemFromChest");
         uItemPicked = _e.itemId;
         bPickingNewItem = false;
         setState(sSTATE_NEW_ITEM);
         playJoySfx();
      }
      
      private function walkIfIntended() : Boolean
      {
         var _nDirV:int = 0;
         var _nDirH:int = 0;
         var _iHKey:int = 0;
         var _iVKey:int = 0;
         var _nHHold:Number = NaN;
         var _nVHold:Number = NaN;
         var _bRet:Boolean = false;
         if(oInputMan.isAnyKeyDown())
         {
            _nDirV = 0;
            _nDirH = 0;
            if(oInputMan.isKeyDown(iKEY_UP))
            {
               _nDirV--;
            }
            if(oInputMan.isKeyDown(iKEY_DOWN))
            {
               _nDirV++;
            }
            if(oInputMan.isKeyDown(iKEY_LEFT))
            {
               _nDirH--;
            }
            if(oInputMan.isKeyDown(iKEY_RIGHT))
            {
               _nDirH++;
            }
            if(_nDirH != 0 || _nDirV != 0)
            {
               _bRet = true;
               if(_nDirH != 0 && _nDirV != 0)
               {
                  _iHKey = iKEY_RIGHT;
                  if(_nDirH == -1)
                  {
                     _iHKey = iKEY_LEFT;
                  }
                  _iVKey = iKEY_DOWN;
                  if(_nDirV == -1)
                  {
                     _iVKey = iKEY_UP;
                  }
                  _nHHold = oInputMan.getKeyHoldDuration(_iHKey);
                  _nVHold = oInputMan.getKeyHoldDuration(_iVKey);
                  if(_nHHold > _nVHold)
                  {
                     _nDirV = 0;
                  }
                  else
                  {
                     _nDirH = 0;
                  }
               }
               if(_nDirV == -1)
               {
                  setState(sSTATE_WALK + sSTATE_SUFFIX_UP);
               }
               else if(_nDirV == 1)
               {
                  setState(sSTATE_WALK + sSTATE_SUFFIX_DOWN);
               }
               else if(_nDirH == -1)
               {
                  setState(sSTATE_WALK + sSTATE_SUFFIX_LEFT);
               }
               else if(_nDirH == 1)
               {
                  setState(sSTATE_WALK + sSTATE_SUFFIX_RIGHT);
               }
               else
               {
                  _bRet = false;
               }
            }
         }
         return _bRet;
      }
      
      public function setOrientation(_nAngle:Number) : void
      {
         var _sState:String = null;
         nDirection = MoreMath.adjustAngleRad(_nAngle);
         var _nDir:Number = getOrientationFromOrientedState(state);
         if(!isNaN(_nDir))
         {
            _sState = getStateFromOrientedState(state);
            setOrientedState(_sState);
         }
      }
      
      public function onPickUpItem(_e:ItemEvent) : void
      {
         trace("Player : onPickUpItem");
         if(_e.itemId == ItemID.uPEBBLE_1 || _e.itemId == ItemID.uPEEBLES_5 || _e.itemId == ItemID.uPEEBLES_10 || _e.itemId == ItemID.uHEARTH || _e.itemId == ItemID.uHEART_CONTAINER)
         {
            trace("   < :o)  ");
            if(_e.itemId == ItemID.uPEBBLE_1 || _e.itemId == ItemID.uPEEBLES_5 || _e.itemId == ItemID.uPEEBLES_10)
            {
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPebbles",1,1,true);
            }
            else
            {
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndBobRaiseHand",1,1,true);
            }
            return;
         }
         uItemPicked = _e.itemId;
         bPickingNewItem = false;
         setState(sSTATE_NEW_ITEM);
         playJoySfx();
      }
      
      private function getKeyFromAngle(_nAngle:Number) : Number
      {
         var _nRet:Number = NaN;
         var _nDir:Number = getOrientationFromAngle(_nAngle);
         switch(_nDir)
         {
            case nANGLE_UP:
               _nRet = iKEY_UP;
               break;
            case nANGLE_DOWN:
               _nRet = iKEY_DOWN;
               break;
            case nANGLE_LEFT:
               _nRet = iKEY_LEFT;
               break;
            case nANGLE_RIGHT:
               _nRet = iKEY_RIGHT;
         }
         return _nRet;
      }
      
      private function playHurtSfx() : void
      {
         var _sSfx:String = null;
         var _uRand:uint = MoreMath.getRandomRange(1,7);
         switch(_uRand)
         {
            case 1:
               _sSfx = "sndSBHurt1.wav";
               break;
            case 2:
               _sSfx = "sndSBHurt2.wav";
               break;
            case 3:
               _sSfx = "sndSBHurt3.wav";
               break;
            case 4:
               _sSfx = "sndSBHurt4.wav";
               break;
            case 5:
               _sSfx = "sndSBHurt5.wav";
               break;
            case 6:
               _sSfx = "sndSBAyaye.wav";
               break;
            case 7:
               _sSfx = "sndSBHow.wav";
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,_sSfx,1,1,false);
      }
      
      public function isDying() : Boolean
      {
         return bDying;
      }
      
      public function walkTo(_nWorldToX:Number, _nWorldToY:Number, _bMoveHorizontal1st:Boolean = true, _fOnWalkFinished:Function = null) : void
      {
         bUnderCtrl = true;
         nCtrlGoalX = _nWorldToX;
         nCtrlGoalY = _nWorldToY;
         stopForgiveness();
         if(_bMoveHorizontal1st)
         {
            if(_nWorldToX < mcPlayer.x)
            {
               nDirection = nANGLE_LEFT;
            }
            else
            {
               nDirection = nANGLE_RIGHT;
            }
         }
         else if(_nWorldToY < mcPlayer.y)
         {
            nDirection = nANGLE_UP;
         }
         else
         {
            nDirection = nANGLE_DOWN;
         }
         fCtrlOnFinish = _fOnWalkFinished;
      }
      
      private function stateLoadSword() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndSwordAttack",1,1,true);
      }
      
      public function getControl() : void
      {
         bUnderCtrl = true;
      }
      
      private function getStateFromOrientedState(_sState:String) : String
      {
         var _iFind:int = 0;
         var _sTemp:String = _sState.substring(0);
         _iFind = _sTemp.lastIndexOf(sSTATE_SUFFIX_UP);
         if(_iFind != -1)
         {
            _sTemp = _sTemp.substring(0,_iFind);
         }
         else
         {
            _iFind = _sTemp.lastIndexOf(sSTATE_SUFFIX_DOWN);
            if(_iFind != -1)
            {
               _sTemp = _sTemp.substring(0,_iFind);
            }
            else
            {
               _iFind = _sTemp.lastIndexOf(sSTATE_SUFFIX_LEFT);
               if(_iFind != -1)
               {
                  _sTemp = _sTemp.substring(0,_iFind);
               }
               else
               {
                  _iFind = _sTemp.lastIndexOf(sSTATE_SUFFIX_RIGHT);
                  if(_iFind != -1)
                  {
                     _sTemp = _sTemp.substring(0,_iFind);
                  }
               }
            }
         }
         return _sTemp;
      }
      
      private function stateDie() : void
      {
         if(stateComplete)
         {
            stopAnim();
            dispatchEvent(new PlayerEvent(PlayerEvent.EVENT_TRIGGER_FINISH_DIE_ANIM,mcPlayer.x,mcPlayer.y,nDirection));
         }
      }
      
      override public function resume(_e:Event = null) : void
      {
         super.resume(_e);
      }
      
      private function bump(_nWorldBumpSourceX:Number, _nWorldBumpSourceY:Number) : void
      {
         if(isBumping())
         {
            return;
         }
         oBumpNormal.x = mcPlayer.x - _nWorldBumpSourceX;
         oBumpNormal.y = mcPlayer.y - _nWorldBumpSourceY;
         oBumpNormal.normalize(1);
         nBumpDist = 0;
      }
      
      private function updateForgiveness() : void
      {
         if(isForgiven())
         {
            --uForgiveFrame;
            if(uForgiveFrame == 0)
            {
               mcPlayer.visible = !mcPlayer.visible;
               uForgiveFrame = uNUM_FRAME_FORGIVENESS_PERIOD;
            }
            nForgiveTimer -= nSPF;
            if(nForgiveTimer <= 0)
            {
               mcPlayer.visible = true;
            }
         }
      }
      
      private function refreshDebug() : void
      {
         if(!Data.bPLAYER_DEBUG)
         {
            return;
         }
         if(oInputMan != null)
         {
            if(oInputMan.isKeyJustPressed(iDEBUG_KEY_HEART))
            {
               oProfile.adjustHearts(0.5);
            }
            if(oInputMan.isKeyJustPressed(iDEBUG_KEY_KEY))
            {
               oProfile.addNormalKey();
            }
            if(oInputMan.isKeyDown(iDEBUG_KEY_PEEBLE))
            {
               oProfile.addPebbles(1);
            }
         }
      }
      
      private function displace(_nSpeed:Number = 180) : void
      {
         var _nDistCoeff:Number = 1;
         if(nDirection != nANGLE_DOWN && nDirection != nANGLE_UP && nDirection != nANGLE_LEFT && nDirection != nANGLE_RIGHT)
         {
            _nDistCoeff = nDIAGONAL_DISTANCE;
         }
         var _nVDir:int = 0;
         var _nHDir:int = 0;
         switch(nDirection)
         {
            case nANGLE_LEFT:
            case nANGLE_DOWN_LEFT:
            case nANGLE_UP_LEFT:
               _nHDir--;
               break;
            case nANGLE_RIGHT:
            case nANGLE_DOWN_RIGHT:
            case nANGLE_UP_RIGHT:
               _nHDir++;
         }
         switch(nDirection)
         {
            case nANGLE_UP:
            case nANGLE_UP_LEFT:
            case nANGLE_UP_RIGHT:
               _nVDir--;
               break;
            case nANGLE_DOWN:
            case nANGLE_DOWN_LEFT:
            case nANGLE_DOWN_RIGHT:
               _nVDir++;
         }
         mcPlayer.x += _nSpeed * nSECS_PER_FRAME * _nDistCoeff * _nHDir;
         mcPlayer.y += _nSpeed * nSECS_PER_FRAME * _nDistCoeff * _nVDir;
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function stateLoadSeaUrchin() : void
      {
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function isOrientedState(_sState:String) : Boolean
      {
         if(_sState == null)
         {
            return false;
         }
         return _sState.indexOf(sSTATE_SUFFIX_UP) != -1 || _sState.indexOf(sSTATE_SUFFIX_DOWN) != -1 || _sState.indexOf(sSTATE_SUFFIX_LEFT) != -1 || _sState.indexOf(sSTATE_SUFFIX_RIGHT) != -1;
      }
      
      public function onActionNotNested(_e:PlayerEvent) : void
      {
         bActionNotNested = true;
      }
      
      private function stopAnim() : void
      {
         if(bPaused)
         {
            return;
         }
         bPaused = true;
         pause();
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function blockIfFacingDanger(_nWorldSrcX:Number, _nWorldSrcY:Number) : Boolean
      {
         if(!isUsingShield())
         {
            return false;
         }
         var _bBlock:* = false;
         var _nPlrToDangerX:Number = _nWorldSrcX - mcPlayer.x;
         var _nPlrToDangerY:Number = _nWorldSrcY - mcPlayer.y;
         switch(getOrientationFromAngle(nDirection))
         {
            case nANGLE_RIGHT:
               _bBlock = _nPlrToDangerX > 0;
               break;
            case nANGLE_UP:
               _bBlock = _nPlrToDangerY < 0;
               break;
            case nANGLE_LEFT:
               _bBlock = _nPlrToDangerX < 0;
               break;
            case nANGLE_DOWN:
               _bBlock = _nPlrToDangerY > 0;
         }
         if(_bBlock)
         {
            bump(_nWorldSrcX,_nWorldSrcY);
            if(isOnState(sSTATE_SHIELD_LV1))
            {
               setOrientedState(sSTATE_SHIELD_BUMP_LV1);
            }
            else
            {
               setOrientedState(sSTATE_SHIELD_BUMP_LV2);
            }
         }
         return _bBlock;
      }
      
      override public function setState(_sState:String) : void
      {
         sLastState = state;
         super.setState(_sState);
      }
      
      private function getOrientationFromOrientedState(_sState:String) : Number
      {
         var _nRet:Number = Number.NaN;
         if(_sState.indexOf(sSTATE_SUFFIX_UP) != -1)
         {
            _nRet = nANGLE_UP;
         }
         else if(_sState.indexOf(sSTATE_SUFFIX_DOWN) != -1)
         {
            _nRet = nANGLE_DOWN;
         }
         else if(_sState.indexOf(sSTATE_SUFFIX_LEFT) != -1)
         {
            _nRet = nANGLE_LEFT;
         }
         else if(_sState.indexOf(sSTATE_SUFFIX_RIGHT) != -1)
         {
            _nRet = nANGLE_RIGHT;
         }
         return _nRet;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function releaseControl() : void
      {
         bUnderCtrl = false;
      }
      
      private function stopForgiveness() : void
      {
         nForgiveTimer = 0;
         mcPlayer.visible = true;
      }
      
      private function playJoySfx() : void
      {
         var _sSfx:String = null;
         var _uRand:uint = MoreMath.getRandomRange(1,3);
         switch(_uRand)
         {
            case 1:
               _sSfx = "sndSBLaugh1.wav";
               break;
            case 2:
               _sSfx = "sndSBLaugh2.wav";
               break;
            case 3:
               _sSfx = "sndSBYeh.wav";
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,_sSfx,1,1,false);
      }
      
      private function stateLoadShield() : void
      {
         nShieldBlockTimer = 0;
      }
      
      private function stateShield() : void
      {
         if(!oInputMan.isKeyDown(iKEY_SECONDARY_WEAPON))
         {
            setOrientedState(sSTATE_IDLE);
         }
         else
         {
            nShieldBlockTimer += nSPF;
            if(nShieldBlockTimer > nSHIELD_TIMEOUT)
            {
               setOrientedState(sSTATE_IDLE);
            }
         }
      }
      
      private function getWorldBodyZone() : Rectangle
      {
         var _oRet:Rectangle = oLocalBody.clone();
         _oRet.offset(mcPlayer.x,mcPlayer.y);
         return _oRet;
      }
      
      public function toString() : String
      {
         return "Player";
      }
      
      private function stateHurt() : void
      {
         if(stateComplete)
         {
            setOrientedState(sSTATE_IDLE);
            startForgiveness();
         }
      }
      
      private function isOnState(_sState:String) : Boolean
      {
         if(state == null)
         {
            return false;
         }
         return state.indexOf(_sState) != -1;
      }
      
      private function stateBoomerang() : void
      {
         var _nAngle:Number = NaN;
         if(stateComplete)
         {
            setOrientedState(sSTATE_IDLE);
         }
         else if(mcState.currentFrame == Data.uSEA_URCHIN_THROW_AT_FRAME)
         {
            SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndBoomerang",1,1,true);
            _nAngle = getOrientationFromOrientedState(state);
            dispatchEvent(new ThrowEvent(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,ThrowEvent.uPROJECTILE_BOOMERANG,mcPlayer.x,mcPlayer.y,_nAngle));
         }
      }
      
      public function onEnemyMove(_e:MovingBodyEvent) : void
      {
         if(!canBeHurt())
         {
            return;
         }
         var _oEnWorldZone:Rectangle = _e.localBodyZone.clone();
         _oEnWorldZone.offsetPoint(_e.newWorldPosition);
         if(_oEnWorldZone.intersects(getWorldBodyZone()))
         {
            onCollisionWithEnemy(_e);
         }
      }
      
      public function getMC() : MovieClip
      {
         return mcPlayer;
      }
      
      private function getWeaponDamage(_uWeaponItem:uint) : Number
      {
         var _nRet:Number = 0;
         switch(_uWeaponItem)
         {
            case ItemID.uSWORD_LV_1:
               _nRet = Data.nDAMAGE_SWORD_LV1;
               break;
            case ItemID.uSWORD_LV_2:
               _nRet = Data.nDAMAGE_SWORD_LV2;
               break;
            case ItemID.uSEA_URCHIN:
               _nRet = Data.nDAMAGE_SEA_URCHIN;
               break;
            case ItemID.uVOLCANIC_URCHIN:
               _nRet = Data.nDAMAGE_VOLCANIC_URCHIN;
               break;
            case ItemID.uBOOMERANG:
               _nRet = Data.nDAMAGE_BOOMERANG;
               break;
            case ItemID.uWAND:
               _nRet = Data.nDAMAGE_WAND;
         }
         return _nRet;
      }
      
      private function getWorldFeetZone() : Rectangle
      {
         var _oRet:Rectangle = oLocalFeet.clone();
         _oRet.offset(mcPlayer.x,mcPlayer.y);
         return _oRet;
      }
      
      private function orientatePlayerFromInput() : Boolean
      {
         var _nDirV:int = 0;
         var _nDirH:int = 0;
         if(oInputMan.isKeyDown(iKEY_UP))
         {
            _nDirV--;
         }
         if(oInputMan.isKeyDown(iKEY_DOWN))
         {
            _nDirV++;
         }
         if(oInputMan.isKeyDown(iKEY_RIGHT))
         {
            _nDirH++;
         }
         if(oInputMan.isKeyDown(iKEY_LEFT))
         {
            _nDirH--;
         }
         var _nRet:Boolean = false;
         if(_nDirV != 0 || _nDirH != 0)
         {
            _nRet = true;
            if(_nDirV == -1)
            {
               if(_nDirH == -1)
               {
                  nDirection = nANGLE_UP_LEFT;
               }
               else if(_nDirH == 1)
               {
                  nDirection = nANGLE_UP_RIGHT;
               }
               else
               {
                  nDirection = nANGLE_UP;
               }
            }
            else if(_nDirV == 1)
            {
               if(_nDirH == -1)
               {
                  nDirection = nANGLE_DOWN_LEFT;
               }
               else if(_nDirH == 1)
               {
                  nDirection = nANGLE_DOWN_RIGHT;
               }
               else
               {
                  nDirection = nANGLE_DOWN;
               }
            }
            else if(_nDirH == -1)
            {
               nDirection = nANGLE_LEFT;
            }
            else if(_nDirH == 1)
            {
               nDirection = nANGLE_RIGHT;
            }
         }
         return _nRet;
      }
      
      public function isBumping() : Boolean
      {
         return nBumpDist < nBUMP_DISTANCE;
      }
      
      private function stateLoadWalk() : void
      {
         _nLastPosX = mcPlayer.x;
         _nLastPosY = mcPlayer.y;
      }
      
      private function isUsingShield() : Boolean
      {
         return isOnState(sSTATE_SHIELD_LV1) || isOnState(sSTATE_SHIELD_LV2) || isOnState(sSTATE_SHIELD_BUMP_LV1) || isOnState(sSTATE_SHIELD_BUMP_LV2);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function die(_uEffect:uint = 0) : void
      {
         bDying = true;
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionNotNested);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onEnemyMove);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_HIT_MOVING_PLAYER,onCollisionWithEnemy);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_ENEMY_ATTACK,onEnemyAttack);
         _oGameDisp.removeEventListener(AttackEvent.EVENT_ENEMY_PROJECTILE_ATTACK,onEnemyProjectile);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onPickUpItem);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,onPickUpItemFromChest);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_GET_NEW_ITEM,onGetNewItem);
         if(_uEffect == AttackEvent.uENEMY_EFFECT_ELECTRIFY)
         {
            setOrientedState(sSTATE_ELECTRIFY);
         }
         else
         {
            setState(sSTATE_DIE);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndSBDie.wav",1,1,true);
      }
      
      public function onPlayerMove(_e:MovingBodyEvent) : void
      {
         if(isUnderControl())
         {
            _e.stopImmediatePropagation();
         }
      }
      
      public function onCollisionWithEnemy(_e:MovingBodyEvent) : void
      {
         if(!canBeHurt())
         {
            return;
         }
         if(blockIfFacingDanger(_e.newWorldPosition.x,_e.newWorldPosition.y))
         {
            return;
         }
         trace("Player : onCollisionWithEnemy");
         hitted(_e.mover,_e.hitDamage,0,_e.mover);
      }
      
      public function onEnemyAttack(_e:AttackEvent) : void
      {
         if(!canBeHurt())
         {
            return;
         }
         if(getWorldBodyZone().intersects(_e.worldAttackZone))
         {
            if(blockIfFacingDanger(_e.worldFrom.x,_e.worldFrom.y))
            {
               return;
            }
            if(_e.enemyEffect == 0)
            {
               bump(_e.worldFrom.x,_e.worldFrom.y);
            }
            hitted(_e.agressor,_e.damage,_e.enemyEffect,_e.agressor);
         }
      }
      
      private function stateLoadIlde() : void
      {
         _nLastPosX = mcPlayer.x;
         _nLastPosY = mcPlayer.y;
      }
      
      private function getOrientedState(_sPrefix:String, _nAngle:Number) : String
      {
         var _nDir:Number = getOrientationFromAngle(_nAngle);
         var _sRet:String = _sPrefix;
         switch(_nDir)
         {
            case nANGLE_UP:
               _sRet += sSTATE_SUFFIX_UP;
               break;
            case nANGLE_DOWN:
               _sRet += sSTATE_SUFFIX_DOWN;
               break;
            case nANGLE_LEFT:
               _sRet += sSTATE_SUFFIX_LEFT;
               break;
            case nANGLE_RIGHT:
               _sRet += sSTATE_SUFFIX_RIGHT;
         }
         return _sRet;
      }
      
      private function hitted(_oBy:Object, _nDamage:Number, _uEffect:uint = 0, _oAggr:Object = null) : void
      {
         var _sHurtEv:String = null;
         if(oProfile.getHearts() <= _nDamage)
         {
            oProfile.setHearts(0);
         }
         if(oProfile.getHearts() <= _nDamage)
         {
            _sHurtEv = HurtEvent.EVENT_PLAYER_DIE;
            dispatchEvent(new HurtEvent(_sHurtEv,_nDamage,_oAggr,this));
            die(_uEffect);
         }
         else
         {
            _sHurtEv = HurtEvent.EVENT_PLAYER_HITTED;
            dispatchEvent(new HurtEvent(_sHurtEv,_nDamage,_oAggr,this));
            switch(_uEffect)
            {
               case AttackEvent.uENEMY_EFFECT_ELECTRIFY:
                  SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndEelHurt",1,1,true);
                  setOrientedState(sSTATE_ELECTRIFY);
                  break;
               case AttackEvent.uENEMY_EFFECT_MASHED:
                  break;
               case AttackEvent.uENEMY_EFFECT_SLIME:
                  break;
               default:
                  playHurtSfx();
                  setOrientedState(sSTATE_HURT);
            }
         }
      }
      
      private function isBeingHit() : Boolean
      {
         return isOnState(sSTATE_HURT);
      }
      
      private function updateBump() : void
      {
         if(!isBumping() || isUnderControl())
         {
            return;
         }
         var _nLastX:Number = mcPlayer.x;
         var _nLastY:Number = mcPlayer.y;
         mcPlayer.x += oBumpNormal.x * nBUMP_SPEED * nSPF;
         mcPlayer.y += oBumpNormal.y * nBUMP_SPEED * nSPF;
         nBumpDist += Math.sqrt(Math.pow(mcPlayer.x - _nLastX,2) + Math.pow(mcPlayer.y - _nLastY,2));
      }
      
      public function setPosition(_nPosX:Number, _nPosY:Number) : void
      {
         _nLastPosX = _nPosX;
         _nLastPosY = _nPosY;
         mcPlayer.x = _nPosX;
         mcPlayer.y = _nPosY;
      }
      
      public function isUnderControl() : Boolean
      {
         return bUnderCtrl;
      }
      
      private function stateShieldBump() : void
      {
         nShieldBlockTimer += nSPF;
         if(stateComplete)
         {
            if(isOnState(sSTATE_SHIELD_BUMP_LV1))
            {
               setOrientedState(sSTATE_SHIELD_LV1);
            }
            else
            {
               setOrientedState(sSTATE_SHIELD_LV2);
            }
         }
      }
      
      public function onEnemyProjectile(_e:AttackEvent) : void
      {
         if(!canBeHurt())
         {
            return;
         }
         if(getWorldBodyZone().intersects(_e.worldAttackZone))
         {
            if(!blockIfFacingDanger(_e.worldFrom.x,_e.worldFrom.y))
            {
               bump(_e.worldFrom.x,_e.worldFrom.y);
               hitted(_e.agressor,_e.damage,_e.enemyEffect,_e.agressor);
            }
            _e.stopImmediatePropagation();
         }
      }
      
      private function weaponIfIntented() : Boolean
      {
         var _iWeapon:int = 0;
         var _sState:String = null;
         var _nLvl:int = 0;
         var _bRet:Boolean = false;
         if(oInputMan.isAnyKeyJustPressed())
         {
            _iWeapon = -1;
            if(iPrimaryWeapon == ItemID.uNULL_ITEM && oInputMan.isKeyJustPressed(iKEY_PRIMARY_WEAPON) || iSecondaryWeapon == ItemID.uNULL_ITEM && oInputMan.isKeyJustPressed(iKEY_SECONDARY_WEAPON))
            {
               bActionNotNested = false;
               dispatchEvent(new PlayerEvent(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,mcPlayer.x,mcPlayer.y,getOrientationFromAngle(nDirection)));
               return false;
            }
            if(iPrimaryWeapon != ItemID.uNULL_ITEM && oInputMan.isKeyJustPressed(iKEY_PRIMARY_WEAPON))
            {
               bActionNotNested = false;
               dispatchEvent(new PlayerEvent(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,mcPlayer.x,mcPlayer.y,getOrientationFromAngle(nDirection)));
               if(bActionNotNested)
               {
                  _iWeapon = iPrimaryWeapon;
               }
            }
            else if(iSecondaryWeapon != ItemID.uNULL_ITEM && oInputMan.isKeyJustPressed(iKEY_SECONDARY_WEAPON))
            {
               _iWeapon = iSecondaryWeapon;
            }
            if(_iWeapon != -1)
            {
               _bRet = true;
               iUsingWeapon = _iWeapon;
               switch(_iWeapon)
               {
                  case ItemID.uSWORD_LV_1:
                     setOrientedState(sSTATE_SWORD_LV1);
                     break;
                  case ItemID.uSWORD_LV_2:
                     setOrientedState(sSTATE_SWORD_LV2);
                     break;
                  case ItemID.uSEA_URCHIN:
                     if(oProfile.hasSeaUrchin())
                     {
                        setOrientedState(sSTATE_URCHIN_SEA);
                     }
                     break;
                  case ItemID.uVOLCANIC_URCHIN:
                     if(oProfile.hasVolcanicUrchin())
                     {
                     }
                     break;
                  case ItemID.uSHIELD_LV_1:
                     setOrientedState(sSTATE_SHIELD_LV1);
                     break;
                  case ItemID.uSHIELD_LV_2:
                     setOrientedState(sSTATE_SHIELD_LV2);
                     break;
                  case ItemID.uFORK:
                     break;
                  case ItemID.uBOOMERANG:
                     if(Boomerang.Instance == null)
                     {
                        setOrientedState(sSTATE_BOOMERANG);
                     }
                     break;
                  case ItemID.uWAND:
               }
            }
         }
         return _bRet;
      }
      
      public function onWallCollide(_oLast:Point, _oContact:Point, _oBump:Point, _oSlide:Point, _uTries:uint) : void
      {
         var _oEffect:Point = null;
         if(isBumping() || _uTries == uNUM_COLLISION_TO_FORCE_BUMP)
         {
            _oEffect = _oBump;
            oBumpNormal.x = _oBump.x - _oContact.x;
            oBumpNormal.y = _oBump.y - _oContact.y;
            oBumpNormal.normalize(1);
            if(_uTries <= 1)
            {
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndBounce3.wav",1,1,true);
            }
         }
         else
         {
            if(_uTries > uNUM_COLLISION_TO_FORCE_BUMP)
            {
               mcPlayer.x = _oLast.x;
               mcPlayer.y = _oLast.y;
               return;
            }
            _oEffect = _oSlide;
         }
         _nLastPosX = _oContact.x;
         _nLastPosY = _oContact.y;
         var _oEv:MovingBodyEvent = new MovingBodyEvent(MovingBodyEvent.EVENT_PLAYER_MOVE,this,_oLast,_oEffect,oLocalFeet,oLocalBody,0,_uTries);
         mcPlayer.x = _oEffect.x;
         mcPlayer.y = _oEffect.y;
         dispatchEvent(_oEv);
      }
      
      private function stateLoadShieldBump() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndBounce4.wav",1,1,true);
      }
      
      private function getEffectiveWeaponZone(_uWeaponItem:uint) : Array
      {
         var _oRect:Rectangle = null;
         var _aRet:Array = [];
         var _nFacing:Number = getOrientationFromOrientedState(state);
         _oRect = new Rectangle();
         switch(_uWeaponItem)
         {
            case ItemID.uSWORD_LV_1:
               _oRect.x = 0;
               _oRect.y = 0;
               _oRect.width = 50;
               _oRect.height = 50;
               switch(_nFacing)
               {
                  case nANGLE_LEFT:
                     _oRect.x = oLocalBody.left - _oRect.width;
                     _oRect.y = oLocalBody.y;
                     break;
                  case nANGLE_UP:
                     _oRect.x = oLocalFeet.x;
                     _oRect.y = oLocalFeet.top - _oRect.height;
                     break;
                  case nANGLE_RIGHT:
                     _oRect.y = oLocalBody.y;
                     _oRect.x = oLocalBody.right;
                     break;
                  case nANGLE_DOWN:
                     _oRect.x = oLocalFeet.x;
                     _oRect.y = oLocalFeet.bottom;
               }
               break;
            case ItemID.uSWORD_LV_2:
               _oRect.x = 0;
               _oRect.y = 0;
               switch(_nFacing)
               {
                  case nANGLE_LEFT:
                     _oRect.width = 100;
                     _oRect.height = 50;
                     _oRect.x = oLocalBody.left - _oRect.width;
                     _oRect.y = oLocalBody.y;
                     break;
                  case nANGLE_UP:
                     _oRect.width = 50;
                     _oRect.height = 100;
                     _oRect.x = oLocalFeet.x;
                     _oRect.y = oLocalFeet.top - _oRect.height;
                     break;
                  case nANGLE_RIGHT:
                     _oRect.width = 100;
                     _oRect.height = 50;
                     _oRect.y = oLocalBody.y;
                     _oRect.x = oLocalBody.right;
                     break;
                  case nANGLE_DOWN:
                     _oRect.width = 50;
                     _oRect.height = 100;
                     _oRect.x = oLocalFeet.x;
                     _oRect.y = oLocalFeet.bottom;
               }
         }
         _oRect.offset(mcPlayer.x,mcPlayer.y);
         _aRet.push(_oRect);
         return _aRet;
      }
      
      private function stateLoadNewItem() : void
      {
         trace("Player : state load on New Item");
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndBobRaiseHand",1,1,true);
         stopForgiveness();
      }
      
      private function isForgiven() : Boolean
      {
         return nForgiveTimer > 0;
      }
      
      private function triggerMoveIfMoved() : void
      {
         if(mcPlayer.x == _nLastPosX && mcPlayer.y == _nLastPosY)
         {
            return;
         }
         var _oEventToDisp:Event = new MovingBodyEvent(MovingBodyEvent.EVENT_PLAYER_MOVE,this,new Point(_nLastPosX,_nLastPosY),new Point(mcRef.x,mcRef.y),oLocalFeet,oLocalBody);
         dispatchEvent(_oEventToDisp);
         _nLastPosX = mcPlayer.x;
         _nLastPosY = mcPlayer.y;
      }
      
      override public function update(_e:Event) : void
      {
         oInputMan.update(nSECS_PER_FRAME);
         refreshDebug();
         super.update(_e);
         updateForgiveness();
         updateBump();
         triggerMoveIfMoved();
      }
      
      private function stateElectrify() : void
      {
         if(stateComplete)
         {
            if(isDying())
            {
               setState(sSTATE_DIE);
            }
            else
            {
               setOrientedState(sSTATE_IDLE);
               startForgiveness();
            }
         }
      }
      
      public function getWorldPositionX() : Number
      {
         return mcRef.x;
      }
      
      public function getWorldPositionY() : Number
      {
         return mcRef.y;
      }
      
      public function onPrimaryWeaponUpdate(_e:ProfileEvent) : void
      {
         iPrimaryWeapon = _e.itemId;
      }
      
      private function wasOnState(_sState:String) : Boolean
      {
         return sLastState.indexOf(_sState) != -1;
      }
      
      public function onGetNewItem(_e:ProfileEvent) : void
      {
         trace("Player : onGetNewItem");
         bPickingNewItem = true;
      }
      
      public function onNewItemTextBoxClosed(_e:TextboxEvent) : void
      {
         dispatchEvent(new ItemEvent(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,uItemPicked));
         resumeAnim();
         setOrientedState(sSTATE_IDLE);
         GameDispatcher.Instance.removeEventListener(TextboxEvent.EVENT_CLOSE_TEXTBOX,onNewItemTextBoxClosed);
      }
      
      private function getOrientationFromAngle(_nPolarAngle:Number) : Number
      {
         var _nDiffTest:Number = NaN;
         var _nDir:Number = MoreMath.adjustAngleRad(_nPolarAngle);
         if(_nDir == nANGLE_RIGHT || _nDir == nANGLE_LEFT || _nDir == nANGLE_DOWN || _nDir == nANGLE_UP)
         {
            return _nPolarAngle;
         }
         var _nDiff:Number = Math.abs(_nPolarAngle - nANGLE_RIGHT);
         _nDir = nANGLE_RIGHT;
         _nDiffTest = Math.abs(_nPolarAngle - nANGLE_UP);
         if(_nDiffTest < _nDiff)
         {
            _nDiff = _nDiffTest;
            _nDir = nANGLE_UP;
         }
         _nDiffTest = Math.abs(_nPolarAngle - nANGLE_DOWN);
         if(_nDiffTest < _nDiff)
         {
            _nDiff = _nDiffTest;
            _nDir = nANGLE_DOWN;
         }
         _nDiffTest = Math.abs(_nPolarAngle - nANGLE_LEFT);
         if(_nDiffTest < _nDiff)
         {
            _nDiff = _nDiffTest;
            _nDir = nANGLE_LEFT;
         }
         return _nDir;
      }
      
      public function onAccomplishment(_e:Event) : void
      {
         playJoySfx();
      }
      
      private function canBeHurt() : Boolean
      {
         return !isUnderControl() && !isBeingHit() && !isForgiven() && !isShowingItem();
      }
      
      private function resumeAnim() : void
      {
         if(!bPaused)
         {
            return;
         }
         bPaused = false;
         resume();
      }
      
      private function stateSword() : void
      {
         var _nDamage:Number = NaN;
         var _oZone:Rectangle = null;
         var _oPos:Point = null;
         if(stateComplete)
         {
            setOrientedState(sSTATE_IDLE);
         }
         else if(iUsingWeapon == ItemID.uSWORD_LV_1 && mcState.currentFrame == Data.uSWORD_LV1_ATTACK_AT_FRAME || iUsingWeapon == ItemID.uSWORD_LV_2 && mcState.currentFrame == Data.uSWORD_LV2_ATTACK_AT_FRAME)
         {
            _nDamage = getWeaponDamage(iUsingWeapon);
            _oZone = getEffectiveWeaponZone(iUsingWeapon)[0];
            _oPos = new Point(mcPlayer.x,mcPlayer.y);
            dispatchEvent(new AttackEvent(AttackEvent.EVENT_PLAYER_ATTACK,this,_nDamage,_oZone,_oPos,iUsingWeapon));
         }
      }
      
      private function isShowingItem() : Boolean
      {
         return state == sSTATE_NEW_ITEM;
      }
      
      private function startForgiveness() : void
      {
         uForgiveFrame = uNUM_FRAME_FORGIVENESS_PERIOD;
         nForgiveTimer = Data.nPLAYER_FORGIVENESS;
         mcPlayer.visible = false;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      override public function pause(_e:Event = null) : void
      {
         mcPlayer.visible = true;
         super.pause(_e);
      }
      
      private function stateWalk() : void
      {
         var _bRet:Boolean = false;
         var _nDir:Number = NaN;
         var _nKey:Number = NaN;
         if(!walkIfControlled())
         {
            _bRet = orientatePlayerFromInput();
            if(!_bRet)
            {
               nDirection = getOrientationFromOrientedState(state);
               setOrientedState(sSTATE_IDLE);
            }
            else if(!weaponIfIntented())
            {
               _nDir = getOrientationFromOrientedState(state);
               _nKey = getKeyFromAngle(_nDir);
               if(!oInputMan.isKeyDown(_nKey))
               {
                  _nDir += Math.PI;
                  _nKey = getKeyFromAngle(_nDir);
                  if(oInputMan.isKeyDown(_nKey))
                  {
                     setState(getOrientedState(sSTATE_WALK,getOrientationFromAngle(_nDir)));
                  }
                  else if(oInputMan.isKeyDown(iKEY_LEFT))
                  {
                     setState(getOrientedState(sSTATE_WALK,nANGLE_LEFT));
                  }
                  else if(oInputMan.isKeyDown(iKEY_RIGHT))
                  {
                     setState(getOrientedState(sSTATE_WALK,nANGLE_RIGHT));
                  }
                  else if(oInputMan.isKeyDown(iKEY_UP))
                  {
                     setState(getOrientedState(sSTATE_WALK,nANGLE_UP));
                  }
                  else
                  {
                     setState(getOrientedState(sSTATE_WALK,nANGLE_DOWN));
                  }
               }
               displace();
            }
         }
      }
   }
}
