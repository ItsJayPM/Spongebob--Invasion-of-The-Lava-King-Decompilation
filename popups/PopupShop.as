package popups
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import gameplay.Game;
   import gameplay.Storyline;
   import gameplay.events.ShopPopupEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   
   public class PopupShop extends Popup implements Idestroyable, IEventDispatcher
   {
       
      
      private var oEventDisp:EventDispatcher;
      
      public function PopupShop(_mcRef:MovieClip)
      {
         super(_mcRef);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         oEventDisp = new EventDispatcher(this);
         Game.Instance.listenToShop(this);
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndKrabShop.mp3",1,1,true);
         setState(sSTATE_APPEAR);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function destroy(_e:Event = null) : void
      {
         Main.instance.stage.focus = Main.instance.stage;
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Game.Instance.stopListenToShop(this);
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
      }
      
      private function addKeyboardListener() : void
      {
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
      }
      
      private function removeMouseListeners() : void
      {
         tryRemovingMouseListenerFrom(mcState.mcPopup.mcShopKeys);
         tryRemovingMouseListenerFrom(mcState.mcPopup.mcShopBottles);
         tryRemovingMouseListenerFrom(mcState.mcPopup.mcShopWeapon5);
         tryRemovingMouseListenerFrom(mcState.mcPopup.mcShopWeapon6);
         tryRemovingMouseListenerFrom(mcState.mcPopup.mcShopTool);
         tryRemovingMouseListenerFrom(mcState.mcPopup.btnQuit);
         tryRemovingMouseListenerFrom(mcState.mcPopup.btnClose);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function tryRemovingMouseListenerFrom(_mcRef:Object) : void
      {
         if(_mcRef != null)
         {
            _mcRef.removeEventListener(MouseEvent.CLICK,onClick,false);
            _mcRef.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         updateIcons();
         removeMouseListeners();
         removeKeyboardListener();
         switch(state)
         {
            case sSTATE_APPEAR:
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupIn.wav",1,1,true);
               dispatchOpenEvent();
               break;
            case sSTATE_IDLE:
               addMouseListeners();
               addKeyboardListener();
               break;
            case sSTATE_DISAPPEAR:
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupOut.wav",1,1,true);
         }
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function closeShop() : void
      {
         setState(sSTATE_DISAPPEAR);
      }
      
      private function updateIcons() : void
      {
         updateLimitedIcon(mcState.mcPopup.mcShopKeys,Profile.Instance.getShopKeysAmount());
         updateLimitedIcon(mcState.mcPopup.mcShopBottles,Profile.Instance.getShopBottlesAmount());
         updateLimitedIcon(mcState.mcPopup.mcShopTool,Profile.Instance.getShopToolsAmount());
         if(Profile.Instance.hasWeapon(5))
         {
            updateLimitedIcon(mcState.mcPopup.mcShopWeapon5,1);
         }
         else
         {
            mcState.mcPopup.mcShopWeapon5.visible = false;
         }
         if(Profile.Instance.hasWeapon(6))
         {
            updateLimitedIcon(mcState.mcPopup.mcShopWeapon6,1);
         }
         else
         {
            mcState.mcPopup.mcShopWeapon6.visible = false;
         }
         updateLimitedIcon(mcState.mcPopup.mcTool,Profile.Instance.getToolsAmount());
         updateLimitedIcon(mcState.mcPopup.mcBottles,Profile.Instance.getBottlesAmount());
         if(Profile.Instance.hasWeapon(5))
         {
            updateLimitedIcon(mcState.mcPopup.mcWeapon5,Profile.Instance.getWeapon(5));
         }
         else
         {
            mcState.mcPopup.mcWeapon5.visible = false;
         }
         if(Profile.Instance.hasWeapon(6))
         {
            updateLimitedIcon(mcState.mcPopup.mcWeapon6,Profile.Instance.getWeapon(6));
         }
         else
         {
            mcState.mcPopup.mcWeapon6.visible = false;
         }
      }
      
      private function addMouseListeners() : void
      {
         tryAddingMouseListenerTo(mcState.mcPopup.mcShopKeys);
         tryAddingMouseListenerTo(mcState.mcPopup.mcShopBottles);
         tryAddingMouseListenerTo(mcState.mcPopup.mcShopWeapon5);
         tryAddingMouseListenerTo(mcState.mcPopup.mcShopWeapon6);
         tryAddingMouseListenerTo(mcState.mcPopup.mcShopTool);
         tryAddingMouseListenerTo(mcState.mcPopup.btnQuit);
         tryAddingMouseListenerTo(mcState.mcPopup.btnClose);
      }
      
      public function dispatchCloseEvent() : void
      {
         var _e:ShopPopupEvent = new ShopPopupEvent(ShopPopupEvent.EVENT_CLOSE_POPUP_SHOP);
         dispatchEvent(_e);
      }
      
      public function dispatchOpenEvent() : void
      {
         trace("PAUSED");
         var _e:ShopPopupEvent = new ShopPopupEvent(ShopPopupEvent.EVENT_OPEN_POPUP_SHOP);
         dispatchEvent(_e);
      }
      
      private function removeKeyboardListener() : void
      {
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp,false);
      }
      
      private function confirmBuy(fCallbackYes:Function) : void
      {
         fCallbackYes();
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         var _mcRef:Object = _e.target.parent;
         if(_mcRef == mcState.mcPopup)
         {
            _mcRef = _e.target;
         }
         switch(_mcRef)
         {
            case mcState.mcPopup.mcShopBottles:
               confirmBuy(this.buyBottle);
               break;
            case mcState.mcPopup.mcShopKeys:
               confirmBuy(this.buyKey);
               break;
            case mcState.mcPopup.mcShopWeapon5:
               confirmBuy(this.buyWeapon5);
               break;
            case mcState.mcPopup.mcShopWeapon6:
               confirmBuy(this.buyWeapon6);
               break;
            case mcState.mcPopup.mcShopTool:
               confirmBuy(this.buyTool);
               break;
            case mcState.mcPopup.btnQuit:
            case mcState.mcPopup.btnClose:
               setState(sSTATE_DISAPPEAR);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      private function updateLimitedIcon(_mc:MovieClip, _nValue:uint) : void
      {
         if(_mc != null)
         {
            if(_nValue > 0)
            {
               _mc.visible = true;
               if(_nValue > 1)
               {
                  if(_mc.txtValue != null)
                  {
                     _mc.txtValue.text = String(_nValue);
                  }
               }
               else if(_mc.txtValue != null)
               {
                  _mc.txtValue.text = "";
               }
            }
            else
            {
               _mc.visible = false;
               tryRemovingMouseListenerFrom(_mc);
            }
         }
      }
      
      private function buyBottle() : void
      {
         trace("buy bottle");
         if(Profile.Instance.getBottlesAmount() < Data.uINVENTORY_MAXIMUM_BOTTLES)
         {
            if(Profile.Instance.substractPebbles(Data.uPRICE_BOTTLE))
            {
               Profile.Instance.stealShopBottle();
               updateIcons();
            }
            else
            {
               Storyline.play("NoMoney");
            }
         }
         else
         {
            Storyline.play("InventoryFull");
         }
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      private function playBuySfx() : void
      {
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndKrabBuy.wav",1,1,true);
      }
      
      private function buyWeapon6() : void
      {
         trace("buy weapon5");
         if(Profile.Instance.getWeapon(6) < Data.uINVENTORY_MAXIMUM_WEAPON6)
         {
            if(Profile.Instance.substractPebbles(Data.uPRICE_WEAPON6))
            {
               Profile.Instance.setWeapon(6,Profile.Instance.getWeapon(6) + 1);
               updateIcons();
            }
            else
            {
               Storyline.play("NoMoney");
            }
         }
         else
         {
            Storyline.play("InventoryFull");
         }
      }
      
      override protected function state_disappear() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         if(stateComplete)
         {
            dispatchCloseEvent();
            Main.instance.removePopup(this);
         }
      }
      
      private function tryAddingMouseListenerTo(_mcRef:Object) : void
      {
         if(_mcRef != null)
         {
            _mcRef.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
            _mcRef.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         }
      }
      
      private function buyKey() : void
      {
         trace("buy key");
         if(Profile.Instance.getNormalKeysAmount() < Data.uINVENTORY_MAXIMUM_KEYS)
         {
            if(Profile.Instance.substractPebbles(Data.uPRICE_KEY))
            {
               Profile.Instance.stealShopKey();
               updateIcons();
            }
            else
            {
               Storyline.play("NoMoney");
            }
         }
         else
         {
            Storyline.play("InventoryFull");
         }
      }
      
      private function buyWeapon5() : void
      {
         trace("buy weapon5");
         if(Profile.Instance.getWeapon(5) < Data.uINVENTORY_MAXIMUM_WEAPON5)
         {
            if(Profile.Instance.substractPebbles(Data.uPRICE_WEAPON5))
            {
               Profile.Instance.setWeapon(5,Profile.Instance.getWeapon(5) + 1);
               updateIcons();
            }
            else
            {
               Storyline.play("NoMoney");
            }
         }
         else
         {
            Storyline.play("InventoryFull");
         }
      }
      
      public function onKeyUp(_e:KeyboardEvent) : void
      {
         switch(_e.keyCode)
         {
            case Keyboard.BACKSPACE:
               closeShop();
         }
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function buyTool() : void
      {
         trace("buy tool");
         if(Profile.Instance.substractPebbles(Data.uPRICE_TOOL))
         {
            Profile.Instance.stealShopTool();
            updateIcons();
         }
         else
         {
            Storyline.play("NoMoney");
         }
      }
   }
}
