package popups
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import gameplay.Game;
   import gameplay.GameDispatcher;
   import gameplay.ItemID;
   import gameplay.events.GameEvent;
   import gameplay.events.InventoryPopupEvent;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   
   public class PopupInventory implements Idestroyable, IEventDispatcher
   {
      
      public static const sSTATE_IDLE:String = "idle";
      
      public static const sSTATE_APPEAR:String = "appear";
      
      public static const sSTATE_DISAPPEAR:String = "disappear";
       
      
      private var mcIdle:MovieClip;
      
      private var state:String;
      
      private var btnWeapon1:DisplayObject;
      
      private var btnWeapon2:DisplayObject;
      
      private var btnWeapon4:DisplayObject;
      
      private var mcRef:MovieClip;
      
      private var btnWeapon6:DisplayObject;
      
      private var btnWeapon7:DisplayObject;
      
      private var btnWeapon8:DisplayObject;
      
      private var btnWeapon9:DisplayObject;
      
      private var btnWeapon3:DisplayObject;
      
      private var mcState:MovieClip;
      
      private var btnWeapon5:DisplayObject;
      
      private var oEventDisp:EventDispatcher;
      
      private var bPaused:Boolean;
      
      private var mcDisappear:MovieClip;
      
      private var mcAppear:MovieClip;
      
      private var btnBottles:DisplayObject;
      
      public function PopupInventory(_mcRef:MovieClip)
      {
         super();
         trace("Inventory");
         mcRef = _mcRef;
         mcState = null;
         bPaused = false;
         mcAppear = new mcPopup2InventoryAppear();
         mcIdle = new mcPopup2InventoryIdle();
         mcDisappear = new mcPopup2InventoryDisappear();
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addEventListener(GameEvent.EVENT_PAUSE,removeKeyboardListener,false,0,true);
         _oGameDisp.addEventListener(GameEvent.EVENT_RESUME,addKeyboardListener,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         oEventDisp = new EventDispatcher(this);
         Game.Instance.listenToInventory(this);
         setState(sSTATE_APPEAR);
      }
      
      private function updateKeyChamberIcon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasBossChamberKey();
         mcState.mcPopup.mcKeyBossChamber.visible = _bTmp;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function tryRemovingMouseListenerFrom(_mcRef:DisplayObject) : void
      {
         if(_mcRef != null)
         {
            if(_mcRef.stage != null)
            {
               _mcRef.stage.focus = null;
            }
            _mcRef.removeEventListener(MouseEvent.CLICK,onClick,false);
            _mcRef.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
            _mcRef.removeEventListener(MouseEvent.ROLL_OUT,onRollOut,false);
         }
      }
      
      public function updateVisual() : void
      {
      }
      
      private function addMouseListeners() : void
      {
         btnBottles = mcState.mcPopup.mcBottles;
         btnWeapon1 = mcState.mcPopup.mcWeapon1;
         btnWeapon2 = mcState.mcPopup.mcWeapon2;
         btnWeapon3 = mcState.mcPopup.mcWeapon3;
         btnWeapon4 = mcState.mcPopup.mcWeapon4;
         btnWeapon5 = mcState.mcPopup.mcWeapon5;
         btnWeapon6 = mcState.mcPopup.mcWeapon6;
         btnWeapon7 = mcState.mcPopup.mcWeapon7;
         btnWeapon8 = mcState.mcPopup.mcWeapon8;
         btnWeapon9 = mcState.mcPopup.mcWeapon9;
         tryAddingMouseListenerTo(btnBottles);
         tryAddingMouseListenerTo(btnWeapon1);
         tryAddingMouseListenerTo(btnWeapon2);
         tryAddingMouseListenerTo(btnWeapon3);
         tryAddingMouseListenerTo(btnWeapon4);
         tryAddingMouseListenerTo(btnWeapon5);
         tryAddingMouseListenerTo(btnWeapon6);
         tryAddingMouseListenerTo(btnWeapon7);
         tryAddingMouseListenerTo(btnWeapon8);
         tryAddingMouseListenerTo(btnWeapon9);
         tryAddingMouseListenerTo(mcState.mcPopup.btnQuit);
         tryAddingMouseListenerTo(mcState.mcPopup.btnClose);
      }
      
      public function dispatchCloseEvent() : void
      {
         var _e:InventoryPopupEvent = new InventoryPopupEvent(InventoryPopupEvent.EVENT_CLOSE_POPUP_INVENTORY);
         dispatchEvent(_e);
      }
      
      private function equipSecondary(_no:Number) : void
      {
         switch(_no)
         {
            case 1:
               if(!Profile.Instance.equipSecondaryWeapon(3))
               {
               }
               break;
            case 2:
               if(!Profile.Instance.equipSecondaryWeapon(4))
               {
               }
               break;
            case 3:
               if(!Profile.Instance.equipSecondaryWeapon(5))
               {
               }
               break;
            case 4:
               if(!Profile.Instance.equipSecondaryWeapon(6))
               {
               }
               break;
            case 5:
               if(!Profile.Instance.equipSecondaryWeapon(7))
               {
               }
               break;
            case 6:
               if(!Profile.Instance.equipSecondaryWeapon(8))
               {
               }
               break;
            case 7:
               if(!Profile.Instance.equipSecondaryWeapon(9))
               {
               }
         }
      }
      
      private function updateWeapon1Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(1);
         mcState.mcPopup.mcWeapon1.visible = _bTmp;
      }
      
      private function updateWeapon2Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(2);
         mcState.mcPopup.mcWeapon2.visible = _bTmp;
      }
      
      private function updateWeapon3Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(3);
         mcState.mcPopup.mcWeapon3.visible = _bTmp;
      }
      
      private function updateWeapon4Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(4);
         mcState.mcPopup.mcWeapon4.visible = _bTmp;
      }
      
      private function updateWeapon7Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(7);
         mcState.mcPopup.mcWeapon7.visible = _bTmp;
      }
      
      public function dispatchOpenEvent() : void
      {
         var _e:InventoryPopupEvent = new InventoryPopupEvent(InventoryPopupEvent.EVENT_OPEN_POPUP_INVENTORY);
         dispatchEvent(_e);
      }
      
      private function updateWeapon6Icon() : void
      {
         var _uTmp:uint = 0;
         _uTmp = Profile.Instance.getWeapon(6);
         updateLimitedIcon(mcState.mcPopup.mcWeapon6,_uTmp,ItemID.uVOLCANIC_URCHIN);
      }
      
      private function equipPrimary(_no:Number) : void
      {
         switch(_no)
         {
            case 1:
               if(!Profile.Instance.equipPrimaryWeapon(1))
               {
               }
               break;
            case 2:
               if(!Profile.Instance.equipPrimaryWeapon(2))
               {
               }
         }
      }
      
      private function updateKeyDungeonIcon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.getBossDungeonKey(1);
         if(mcState.mcPopup.mcKeyBoss1 != null)
         {
            mcState.mcPopup.mcKeyBoss1.visible = _bTmp;
         }
         _bTmp = Profile.Instance.getBossDungeonKey(2);
         if(mcState.mcPopup.mcKeyBoss2 != null)
         {
            mcState.mcPopup.mcKeyBoss2.visible = _bTmp;
         }
      }
      
      private function removeMouseListeners() : void
      {
         tryRemovingMouseListenerFrom(btnBottles);
         tryRemovingMouseListenerFrom(btnWeapon1);
         tryRemovingMouseListenerFrom(btnWeapon2);
         tryRemovingMouseListenerFrom(btnWeapon3);
         tryRemovingMouseListenerFrom(btnWeapon4);
         tryRemovingMouseListenerFrom(btnWeapon5);
         tryRemovingMouseListenerFrom(btnWeapon6);
         tryRemovingMouseListenerFrom(btnWeapon7);
         tryRemovingMouseListenerFrom(btnWeapon8);
         tryRemovingMouseListenerFrom(btnWeapon9);
         btnBottles = null;
         btnWeapon1 = null;
         btnWeapon2 = null;
         btnWeapon3 = null;
         btnWeapon4 = null;
         btnWeapon5 = null;
         btnWeapon6 = null;
         btnWeapon7 = null;
         btnWeapon8 = null;
         btnWeapon9 = null;
         tryAddingMouseListenerTo(mcState.mcPopup.btnQuit);
         tryAddingMouseListenerTo(mcState.mcPopup.btnClose);
      }
      
      public function onRollOut(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         _e.target.filters = [];
      }
      
      private function updateToolsIcon() : void
      {
         var _uTmp:uint = 0;
         _uTmp = Profile.Instance.getToolsAmount();
         updateLimitedIcon(mcState.mcPopup.mcTool,_uTmp,ItemID.uSANDY_TOOLS);
      }
      
      private function closeInventory() : void
      {
         setState(sSTATE_DISAPPEAR);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function onKeyUp(_e:KeyboardEvent) : void
      {
         switch(_e.keyCode)
         {
            case Keyboard.SPACE:
               closeInventory();
         }
      }
      
      private function updateLimitedIcon(_mc:MovieClip, _nValue:uint, _uID:uint) : void
      {
         if(_mc != null)
         {
            if(_nValue > 0)
            {
               _mc.visible = true;
               if(_mc.txtValue != null)
               {
                  _mc.txtValue.text = String(_nValue);
               }
            }
            else
            {
               if(_mc.txtValue != null)
               {
                  _mc.txtValue.text = String(_nValue);
               }
               if(!Profile.Instance.canPickUpItem(_uID))
               {
                  _mc.filters = [];
                  _mc.visible = false;
                  tryRemovingMouseListenerFrom(_mc);
               }
               else
               {
                  _mc.visible = true;
                  _mc.filters = [];
                  tryRemovingMouseListenerFrom(_mc);
               }
            }
         }
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function updateWeapon8Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(8);
         mcState.mcPopup.mcWeapon8.visible = _bTmp;
      }
      
      private function updateWeapon9Icon() : void
      {
         var _bTmp:Boolean = false;
         _bTmp = Profile.Instance.hasWeapon(9);
         mcState.mcPopup.mcWeapon9.visible = _bTmp;
      }
      
      public function update(_e:Event = null) : void
      {
         if(!bPaused)
         {
            switch(state)
            {
               case sSTATE_APPEAR:
                  if(stateComplete)
                  {
                     setState(sSTATE_IDLE);
                  }
                  break;
               case sSTATE_DISAPPEAR:
                  if(stateComplete)
                  {
                     dispatchCloseEvent();
                     Main.instance.removePopup(this);
                  }
            }
         }
      }
      
      private function updateIcons() : void
      {
         updateBottlesIcon();
         updateWeapon1Icon();
         updateWeapon2Icon();
         updateWeapon3Icon();
         updateWeapon4Icon();
         updateWeapon5Icon();
         updateWeapon6Icon();
         updateWeapon7Icon();
         updateWeapon8Icon();
         updateWeapon9Icon();
         updateKeyDungeonIcon();
         updateKeyChamberIcon();
         updateToolsIcon();
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         removeMouseListeners();
         removeKeyboardListener();
         switch(state)
         {
            case sSTATE_APPEAR:
               dispatchOpenEvent();
               break;
            case sSTATE_IDLE:
               addMouseListeners();
               addKeyboardListener();
               break;
            case sSTATE_DISAPPEAR:
         }
         updateIcons();
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function updateWeapon5Icon() : void
      {
         var _uTmp:uint = 0;
         _uTmp = Profile.Instance.getWeapon(5);
         updateLimitedIcon(mcState.mcPopup.mcWeapon5,_uTmp,ItemID.uSEA_URCHIN);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function setState(_sState:String) : void
      {
         if(state != _sState)
         {
            if(mcState != null)
            {
               mcRef.removeChild(mcState);
            }
            switch(_sState)
            {
               case sSTATE_APPEAR:
                  mcAppear.gotoAndPlay(1);
                  mcState = mcAppear;
                  break;
               case sSTATE_DISAPPEAR:
                  mcDisappear.gotoAndPlay(1);
                  mcState = mcDisappear;
                  break;
               case sSTATE_IDLE:
                  mcState = mcIdle;
            }
            if(mcState.mcBlocker != null)
            {
               mcState.mcBlocker.useHandCursor = false;
            }
            updateIcons();
            mcRef.addChild(mcState);
            state = _sState;
            loadState();
         }
      }
      
      private function removeKeyboardListener(_e:GameEvent = null) : void
      {
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp,false);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         var _mcRef:Object = _e.target.parent;
         if(_mcRef == mcState.mcPopup)
         {
            _mcRef = _e.target;
         }
         trace("Click " + _e.currentTarget);
         switch(_e.currentTarget)
         {
            case btnBottles:
               drinkBottle();
               break;
            case btnWeapon1:
               trace("Weapon ");
               equipPrimary(1);
               break;
            case btnWeapon2:
               equipPrimary(2);
               break;
            case btnWeapon3:
               equipSecondary(1);
               break;
            case btnWeapon4:
               equipSecondary(2);
               break;
            case btnWeapon5:
               equipSecondary(3);
               break;
            case btnWeapon6:
               equipSecondary(4);
               break;
            case btnWeapon7:
               equipSecondary(5);
               break;
            case btnWeapon8:
               equipSecondary(6);
               break;
            case btnWeapon9:
               equipSecondary(7);
               break;
            case mcState.mcPopup.btnQuit:
            case mcState.mcPopup.btnClose:
               setState(sSTATE_DISAPPEAR);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      public function get stateComplete() : Boolean
      {
         var _bComplete:Boolean = false;
         if(mcState != null)
         {
            if(mcState.currentFrame >= mcState.totalFrames)
            {
               mcState.stop();
               _bComplete = true;
            }
         }
         return _bComplete;
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         _e.target.filters = [Data.oINVENTORY_FILTER];
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      private function tryAddingMouseListenerTo(_mcRef:Object) : void
      {
         if(_mcRef != null)
         {
            _mcRef.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
            _mcRef.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
            _mcRef.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         removeMouseListeners();
         removeKeyboardListener();
         Game.Instance.stopListenToInventory(this);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addEventListener(GameEvent.EVENT_PAUSE,removeKeyboardListener,false,0,true);
         _oGameDisp.addEventListener(GameEvent.EVENT_RESUME,addKeyboardListener,false,0,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
      }
      
      private function addKeyboardListener(_e:GameEvent = null) : void
      {
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
      }
      
      private function updateBottlesIcon() : void
      {
         var _uTmp:uint = 0;
         _uTmp = Profile.Instance.getBottlesAmount();
         updateLimitedIcon(mcState.mcPopup.mcBottles,_uTmp,ItemID.uHEALTH_BOTTLE);
      }
      
      private function drinkBottle() : void
      {
         var _nNbr:Number = NaN;
         var _nMax:Number = NaN;
         var _uBottles:Number = NaN;
         _nNbr = Profile.Instance.getHearts();
         _nMax = Profile.Instance.getHearthsCapacity();
         _uBottles = Profile.Instance.getBottlesAmount();
         if(_uBottles > 0)
         {
            Profile.Instance.useBottle();
            updateLimitedIcon(mcState.mcPopup.mcBottles,Profile.Instance.getBottlesAmount(),ItemID.uHEALTH_BOTTLE);
         }
      }
   }
}
