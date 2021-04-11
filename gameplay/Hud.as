package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import gameplay.events.GameEvent;
   import gameplay.events.ProfileEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   import library.utils.Tools;
   
   public class Hud implements Idestroyable
   {
      
      private static var bServiceEnabled:Boolean;
       
      
      private var oHealthBar:HealthBar;
      
      public var mcRef:MovieClip;
      
      public function Hud(_mcRef:MovieClip, _oGameDisp:GameDispatcher)
      {
         super();
         trace("HUD");
         mcRef = _mcRef;
         oHealthBar = new HealthBar(_mcRef.mcHealthBar);
         _oGameDisp.addEventListener(GameEvent.EVENT_PAUSE,removeKeyboardListener,false,0,true);
         _oGameDisp.addEventListener(GameEvent.EVENT_RESUME,addKeyboardListener,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_GET_NEW_ITEM,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_HEALTH_CONTAINER,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_HEALTH,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_KEY,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_PEEBLE,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_SCORE,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_PRIMARYWEAPON,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_SECONDARYWEAPON,update,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_SEA_URCHIN_NUM,onSeaUrchinUpdate,false,0,true);
         _oGameDisp.addEventListener(ProfileEvent.EVENT_UPDATE_VOLCANIC_URCHIN_NUM,onVolcanicUrchinUpdate,false,0,true);
         trace("Created: " + mcRef.btnMenu);
         mcRef.btnMenu.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         mcRef.btnMenu.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         mcRef.btnInventory.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         mcRef.btnInventory.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         addKeyboardListener();
         enable();
         update();
      }
      
      public static function disable() : void
      {
         bServiceEnabled = false;
      }
      
      public static function enable() : void
      {
         bServiceEnabled = true;
      }
      
      private function openShop() : void
      {
         if(Main.instance.popupShop == null)
         {
            Main.instance.addPopup(Main.sPOPUP_SHOP);
         }
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case mcRef.btnMenu:
               openMenu();
               break;
            case mcRef.btnInventory:
               openInventory();
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      private function addKeyboardListener(_e:GameEvent = null) : void
      {
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
      }
      
      private function onVolcanicUrchinUpdate(_e:ProfileEvent) : void
      {
         if(Profile.Instance.sPlayerWeaponSecond == Data.sSTATE_WEAPONS6)
         {
            updateLimitedIcon(mcRef.mcWeaponSecond,Profile.Instance.getNumVolcanicUrchin());
         }
      }
      
      private function onSeaUrchinUpdate(_e:ProfileEvent) : void
      {
         if(Profile.Instance.sPlayerWeaponSecond == Data.sSTATE_WEAPONS5)
         {
            updateLimitedIcon(mcRef.mcWeaponSecond,Profile.Instance.getNumSeaUrchin());
         }
      }
      
      private function openMenu() : void
      {
         if(Main.instance.popupMenu == null)
         {
            trace("IN");
            Main.instance.addPopup(Main.sPOPUP_MENU);
         }
      }
      
      private function updateLimitedIcon(_mc:MovieClip, _nValue:uint) : void
      {
         var _dtText:TextField = null;
         if(_mc != null)
         {
            _dtText = _mc.getChildByName("txtValue") as TextField;
            _dtText.text = String(_nValue);
            _mc.visible = true;
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         removeKeyboardListener();
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_PAUSE,removeKeyboardListener,false);
         _oGameDisp.removeEventListener(GameEvent.EVENT_RESUME,addKeyboardListener,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_GET_NEW_ITEM,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_HEALTH_CONTAINER,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_HEALTH,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_KEY,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_PEEBLE,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_SCORE,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_PRIMARYWEAPON,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_SECONDARYWEAPON,update,false);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_SEA_URCHIN_NUM,onSeaUrchinUpdate);
         _oGameDisp.removeEventListener(ProfileEvent.EVENT_UPDATE_VOLCANIC_URCHIN_NUM,onVolcanicUrchinUpdate);
         trace("REMOVED" + mcRef.btnMenu);
         mcRef.btnMenu.removeEventListener(MouseEvent.CLICK,onClick,false);
         mcRef.btnMenu.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
         mcRef.btnInventory.removeEventListener(MouseEvent.CLICK,onClick,false);
         mcRef.btnInventory.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
         mcRef = null;
      }
      
      private function openInventory() : void
      {
         Main.instance.addPopup(Main.sPOPUP_INVENTORY);
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         trace("Over: " + _e.target.name);
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      public function update(_e:Event = null) : void
      {
         if(bServiceEnabled)
         {
            oHealthBar.show();
            mcRef.mcKeys.txtValue.text = String(Profile.Instance.getNormalKeysAmount());
            trace("mcRef.mcKeys.txtValue.text : " + mcRef.mcKeys.txtValue.text);
            mcRef.mcPebbles.txtValue.text = String(Profile.Instance.getPebbles());
            mcRef.mcScore.txtValue.text = String(Tools.getFormatedNumber(Profile.Instance.getCurrentScore(),6));
            if(Profile.Instance.sPlayerWeaponSecond == Data.sSTATE_WEAPONS5 || Profile.Instance.sPlayerWeaponSecond == Data.sSTATE_WEAPONS6)
            {
               mcRef.mcWeaponSecond.addEventListener(Event.ADDED,onAddedLimitedIcon,false,0,true);
            }
            mcRef.mcWeaponPrime.gotoAndStop(Profile.Instance.sPlayerWeaponPrime);
            mcRef.mcWeaponSecond.gotoAndStop(Profile.Instance.sPlayerWeaponSecond);
         }
      }
      
      private function onAddedLimitedIcon(_e:Event) : void
      {
         if(_e.target == mcRef.mcWeaponSecond.getChildByName("txtValue"))
         {
            if(Profile.Instance.sPlayerWeaponSecond == Data.sSTATE_WEAPONS5)
            {
               updateLimitedIcon(mcRef.mcWeaponSecond,Profile.Instance.getNumSeaUrchin());
            }
            if(Profile.Instance.sPlayerWeaponSecond == Data.sSTATE_WEAPONS6)
            {
               updateLimitedIcon(mcRef.mcWeaponSecond,Profile.Instance.getNumVolcanicUrchin());
            }
            mcRef.mcWeaponSecond.removeEventListener(Event.ADDED,onAddedLimitedIcon);
         }
      }
      
      public function onKeyUp(_e:KeyboardEvent) : void
      {
         if(bServiceEnabled)
         {
            switch(_e.keyCode)
            {
               case 77:
                  openMenu();
                  break;
               case Keyboard.SPACE:
                  openInventory();
                  break;
               case Keyboard.BACKSPACE:
                  break;
               case 49:
                  if(!Profile.Instance.equipSecondaryWeapon(3))
                  {
                  }
                  break;
               case 50:
                  if(!Profile.Instance.equipSecondaryWeapon(4))
                  {
                  }
                  break;
               case 51:
                  if(!Profile.Instance.equipSecondaryWeapon(5))
                  {
                  }
                  break;
               case 52:
                  if(!Profile.Instance.equipSecondaryWeapon(6))
                  {
                  }
                  break;
               case 53:
                  if(!Profile.Instance.equipSecondaryWeapon(7))
                  {
                  }
                  break;
               case 54:
                  if(!Profile.Instance.equipSecondaryWeapon(8))
                  {
                  }
                  break;
               case 55:
                  if(!Profile.Instance.equipSecondaryWeapon(9))
                  {
                  }
                  break;
               case 57:
                  Storyline.play("TEST");
                  break;
               case 67:
            }
         }
      }
      
      public function get Health() : HealthBar
      {
         return oHealthBar;
      }
      
      private function removeKeyboardListener(_e:GameEvent = null) : void
      {
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp,false);
      }
   }
}
