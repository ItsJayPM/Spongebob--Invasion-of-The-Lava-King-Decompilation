package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.GameEvent;
   import gameplay.events.ItemEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.projectiles.Boomerang;
   import library.basic.StateManaged;
   
   public class FloorItem extends StateManaged implements IEventDispatcher
   {
      
      public static const sSTATE_IDLE:String = "idle";
      
      public static const sSTATE_PICK_UP:String = "pickUp";
      
      public static const sSTATE_FLOOR_APPEAR:String = "floorAppear";
      
      private static const uFLASH_AT_FRAME_PERIOD:uint = 2;
      
      private static var bShowingItem:Boolean = false;
       
      
      private var bOnItem:Boolean;
      
      private var oWorldBody:Rectangle;
      
      private var uItem:uint;
      
      private var oEventDisp:EventDispatcher;
      
      private var bPaused:Boolean;
      
      private var bSendEvent:Boolean;
      
      private var nSecsPerFrame:Number;
      
      private var bCanDisappear:Boolean;
      
      private var mcItem:MovieClip;
      
      private var bFromChest:Boolean;
      
      private var oWorldSource:Point;
      
      private var bPlayedFullMessage:Boolean;
      
      private var oActivator:Activator;
      
      private var bPlayerRendering:Boolean;
      
      private var nTimerFlashGoal:Number;
      
      private var oRoom:Room;
      
      private var oPlayerBody:Rectangle;
      
      private var nTimer:Number;
      
      private var uTimerFlashState:Number;
      
      public function FloorItem(_mcRef:MovieClip, _uItem:uint, _oRoom:Room = null, _bIsBeingDropped:Boolean = false, _bCanDisappear:Boolean = false, _bFromChest:Boolean = false, _oWorldSource:Point = null)
      {
         super(_mcRef);
         mcItem = _mcRef;
         bOnItem = false;
         oRoom = _oRoom;
         oActivator = new Activator(mcItem,oRoom);
         oEventDisp = new EventDispatcher(this);
         bPlayedFullMessage = false;
         uItem = _uItem;
         bPaused = false;
         bPlayerRendering = false;
         if(_oWorldSource != null)
         {
            oWorldSource = _oWorldSource.clone();
         }
         else
         {
            oWorldSource = new Point(mcItem.x,mcItem.y);
         }
         var _nW:Number = Data.iTILE_WIDTH;
         var _nH:Number = Data.iTILE_HEIGHT;
         oWorldBody = new Rectangle(-_nW / 2,-_nH / 2,_nW,_nH);
         oWorldBody.offset(mcItem.x,mcItem.y);
         bCanDisappear = _bCanDisappear;
         addState(sSTATE_IDLE,stateIdle);
         addState(sSTATE_PICK_UP,statePickUp);
         addState(sSTATE_FLOOR_APPEAR,stateFloorAppear,stateLoadFloorAppear);
         bFromChest = _bFromChest;
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_DESTROY,destroy);
         if(bFromChest)
         {
            bPlayerRendering = true;
            bSendEvent = false;
            bShowingItem = true;
            setState(sSTATE_PICK_UP);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onShowedItem);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onShowedItem);
         }
         else
         {
            _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
            _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onPlayerProjectile);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onShowedItem);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onShowedItem);
            if(bCanDisappear)
            {
               nTimer = Data.nITEM_DROP_TIMEOUT;
               nTimerFlashGoal = Data.nITEM_DROP_FLASH_TIMEOUT;
               uTimerFlashState = 0;
               nSecsPerFrame = 1 / mcItem.stage.frameRate;
            }
            if(_bIsBeingDropped)
            {
               setState(sSTATE_FLOOR_APPEAR);
            }
            else
            {
               setState(sSTATE_IDLE);
            }
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
         if(_oGameDisp.isPaused())
         {
            pause();
         }
         setRenderingEvents();
      }
      
      private function setRenderingEvents() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         if(bPlayerRendering)
         {
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_PLAYER_UPDATE,update);
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_PLAYER_PAUSE,pause);
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_PLAYER_RESUME,resume);
            _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
            _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
            _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         }
         else
         {
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_PAUSE,pause);
            _oGameDisp.addWeakEventListener(GameEvent.EVENT_RESUME,resume);
            _oGameDisp.removeEventListener(GameEvent.EVENT_PLAYER_UPDATE,update);
            _oGameDisp.removeEventListener(GameEvent.EVENT_PLAYER_PAUSE,pause);
            _oGameDisp.removeEventListener(GameEvent.EVENT_PLAYER_RESUME,resume);
         }
      }
      
      public function stateIdle() : void
      {
         refreshDisappearTimer();
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function onPlayerMove(_e:MovingBodyEvent = null) : void
      {
         if(bShowingItem)
         {
            return;
         }
         var _oBody:Rectangle = _e.localBodyZone.clone();
         _oBody.offsetPoint(_e.newWorldPosition);
         oPlayerBody = _oBody.clone();
         if(_oBody.intersects(oWorldBody))
         {
            if(Profile.Instance.inventoryFullOf(uItem))
            {
               if(!bPlayedFullMessage)
               {
                  Storyline.play("NoMoreItem");
                  bPlayedFullMessage = true;
               }
            }
            else
            {
               pickUp(_oBody);
            }
            bOnItem = true;
         }
         else
         {
            bOnItem = false;
         }
      }
      
      public function statePickUp() : void
      {
         mcItem.visible = true;
         if(bFromChest && !bSendEvent)
         {
            bSendEvent = true;
            dispatchEvent(new ItemEvent(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,uItem,oWorldSource));
         }
         if(stateComplete)
         {
            stopAnim();
         }
      }
      
      private function refreshDisappearTimer() : void
      {
         if(!bCanDisappear)
         {
            return;
         }
         nTimer -= nSecsPerFrame;
         if(nTimer <= 0)
         {
            disappear();
         }
         else if(nTimer <= nTimerFlashGoal)
         {
            --uTimerFlashState;
            if(uTimerFlashState <= 0)
            {
               uTimerFlashState = uFLASH_AT_FRAME_PERIOD;
               mcItem.visible = !mcItem.visible;
            }
         }
      }
      
      public function disappear(_e:Event = null) : void
      {
         destroy();
      }
      
      private function onPlayerProjectile(_e:MovingBodyEvent) : void
      {
         var _oBody:Rectangle = null;
         var _sEv:String = null;
         if(state != sSTATE_IDLE)
         {
            return;
         }
         if(_e.mover is Boomerang)
         {
            _oBody = _e.localBodyZone.clone();
            _oBody.offsetPoint(_e.newWorldPosition);
            if(_oBody.intersects(oWorldBody))
            {
               _sEv = ItemEvent.EVENT_PICKING_UP_ITEM_WITH_BOOMERANG;
               dispatchEvent(new ItemEvent(_sEv,uItem,oWorldSource));
               disappear();
            }
         }
      }
      
      public function stateLoadFloorAppear() : void
      {
         if(GameDispatcher.Instance.isPaused())
         {
            pause();
         }
      }
      
      private function pickUp(_oBody:Rectangle) : void
      {
         var _sEv:String = ItemEvent.EVENT_PICKING_UP_ITEM;
         if(bFromChest)
         {
            _sEv = ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST;
            dispatchEvent(new ItemEvent(_sEv,uItem,oWorldSource));
            setState(sSTATE_PICK_UP);
            bShowingItem = true;
         }
         else
         {
            if(uItem == ItemID.uPEBBLE_1 || uItem == ItemID.uPEEBLES_5 || uItem == ItemID.uPEEBLES_10 || uItem == ItemID.uHEARTH || uItem == ItemID.uHEART_CONTAINER)
            {
               disappear();
            }
            else
            {
               bPlayerRendering = true;
               setRenderingEvents();
               setState(sSTATE_PICK_UP);
               bShowingItem = true;
            }
            dispatchEvent(new ItemEvent(_sEv,uItem,oWorldSource));
         }
         if(bShowingItem)
         {
            mcItem.x = _oBody.x + Data.iTILE_WIDTH / 2 + -20;
            mcItem.y = _oBody.y + Data.iTILE_HEIGHT / 2 + -20;
         }
      }
      
      override public function resume(_e:Event = null) : void
      {
         if(!bPaused)
         {
            super.resume(_e);
         }
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function stopAnim() : void
      {
         trace(">>> !!! STOP ANIM !!!");
         if(bPaused)
         {
            return;
         }
         bPaused = true;
         super.pause();
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function onShowedItem(_e:Event) : void
      {
         if(state == sSTATE_PICK_UP)
         {
            bShowingItem = false;
            disappear();
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function onActivation() : void
      {
         setRenderingEvents();
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         if(bFromChest)
         {
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onShowedItem);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onShowedItem);
         }
         else
         {
            _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
            _oGameDisp.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onPlayerProjectile);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onShowedItem);
            _oGameDisp.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onShowedItem);
         }
      }
      
      private function onDeactivation() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,resume);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PLAYER_UPDATE,update);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PLAYER_PAUSE,pause);
         _oGameDisp.removeEventListener(GameEvent.EVENT_PLAYER_RESUME,resume);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onShowedItem);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onShowedItem);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onPlayerProjectile);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onShowedItem);
         _oGameDisp.removeEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onShowedItem);
      }
      
      override public function update(_e:Event) : void
      {
         super.update(_e);
      }
      
      private function resumeAnim() : void
      {
         if(!bPaused)
         {
            return;
         }
         bPaused = false;
         super.resume();
      }
      
      public function stateFloorAppear() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_IDLE);
         }
      }
      
      override public function pause(_e:Event = null) : void
      {
         super.pause(_e);
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("FloorItem : destroy");
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_FLOOR_ITEM,this));
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
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onPlayerProjectile);
         if(mcItem.parent != null)
         {
            mcItem.parent.removeChild(mcItem);
         }
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
   }
}
