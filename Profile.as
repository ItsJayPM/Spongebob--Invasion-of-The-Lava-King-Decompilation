package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.net.ObjectEncoding;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import gameplay.GameDispatcher;
   import gameplay.ItemID;
   import gameplay.Storyline;
   import gameplay.bosses.GaseousRock;
   import gameplay.enemies.Eel;
   import gameplay.enemies.Jellyfish;
   import gameplay.events.ChestEvent;
   import gameplay.events.DoorEvent;
   import gameplay.events.DropItemEvent;
   import gameplay.events.HurtEvent;
   import gameplay.events.ItemEvent;
   import gameplay.events.ProfileEvent;
   import gameplay.events.RoomEvent;
   import gameplay.events.ShopTransactEvent;
   import gameplay.events.ThrowEvent;
   
   public class Profile implements IEventDispatcher
   {
      
      public static var oLoadedMap:Object = new Object();
      
      private static var bVolcanicUrchinFound:Boolean;
      
      private static var oSO:SharedObject;
      
      private static var bFlagTutorial:Boolean;
      
      private static var bSeaUrchinFound:Boolean;
      
      public static var Instance:Profile;
      
      public static const uNUM_PROFILES:uint = 3;
      
      private static const uSCORE_LIMIT:uint = 999999999;
      
      private static var uNumBeatenBoss:uint;
       
      
      public var sPlayerWeaponSecond:String;
      
      private var aItemsAmount:Array;
      
      private var iProfileID:int;
      
      private var uScore:uint;
      
      private var uNumberHelpingSandy:uint;
      
      private var iNumToolAtShop1:int;
      
      private var iNumToolAtShop2:int;
      
      private var iNumToolAtShop3:int;
      
      private var uPebbleAmount:uint;
      
      private var iNumHealthBottleAtShop1:int;
      
      private var iNumHealthBottleAtShop2:int;
      
      private var iNumHealthBottleAtShop3:int;
      
      private var uPrimaryWeapon:uint;
      
      private var iNumKeysAtShop1:int;
      
      private var iNumKeysAtShop2:int;
      
      private var iNumKeysAtShop3:int;
      
      private var uSecondaryWeapon:uint;
      
      private var oEventDisp:EventDispatcher;
      
      private var uEpisode:uint;
      
      private var nHeartsCapacity:Number;
      
      private var aItems:Array;
      
      private var sLoadedMap:String;
      
      private var sPlayerName:String;
      
      private var sSavedMap:String;
      
      private var uNumberHelpingSquidward:uint;
      
      private var oUniqueData:Object;
      
      private var nHearts:Number;
      
      public var sPlayerWeaponPrime:String;
      
      public function Profile(_iProfileId:int)
      {
         super();
         iProfileID = _iProfileId;
         if(Instance != null)
         {
            Instance.destroy();
         }
         aItems = new Array();
         aItemsAmount = new Array();
         oUniqueData = new Object();
         Storyline.init();
         loadData(_iProfileId);
         oEventDisp = new EventDispatcher(this);
         addListeners();
         Instance = this;
      }
      
      private static function loadSOIfNotLoaded() : void
      {
         if(oSO == null)
         {
            trace(">>>>> Profile !!!! LOAD SO IF NOT LOADED");
            oSO = SharedObject.getLocal(Data.sPROFILE_SO_NAME,"/");
            oSO.objectEncoding = ObjectEncoding.AMF0;
         }
      }
      
      public static function reloadCurrentProfile() : void
      {
         if(Instance == null)
         {
            return;
         }
         var _iId:int = Instance.iProfileID;
         Instance.destroy();
         Instance = null;
         new Profile(_iId);
      }
      
      public static function initNewProfile(_iProfileId:int, _sPlayerName:String) : void
      {
         trace("PROFILE : initNewProfile ***");
         loadSOIfNotLoaded();
         oSO.data["profile" + _iProfileId] = new Object();
         oSO.data["profile" + _iProfileId].sPlayerName = _sPlayerName;
         oSO.data["profile" + _iProfileId].nHearts = Data.nLIVES_DEFAULT_START;
         oSO.data["profile" + _iProfileId].nHeartsCapacity = Data.nLIVES_DEFAULT_MAXIMUM;
         oSO.data["profile" + _iProfileId].uPebbleAmount = 0;
         oSO.data["profile" + _iProfileId].uScore = 0;
         oSO.data["profile" + _iProfileId].uPrimaryWeapon = 0;
         oSO.data["profile" + _iProfileId].uSecondaryWeapon = 0;
         oSO.data["profile" + _iProfileId].uEpisode = 1;
         oSO.data["profile" + _iProfileId].sSavedMap = Data.sFILE_WORLD;
         oSO.data["profile" + _iProfileId].oUniqueData = new Object();
         oSO.data["profile" + _iProfileId].iNumKeysAtShop1 = Data.uDEFAULT_SHOP1_KEYS;
         oSO.data["profile" + _iProfileId].iNumKeysAtShop2 = Data.uDEFAULT_SHOP2_KEYS;
         oSO.data["profile" + _iProfileId].iNumKeysAtShop3 = Data.uDEFAULT_SHOP3_KEYS;
         oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop1 = Data.uDEFAULT_SHOP1_BOTTLES;
         oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop2 = Data.uDEFAULT_SHOP2_BOTTLES;
         oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop3 = Data.uDEFAULT_SHOP3_BOTTLES;
         oSO.data["profile" + _iProfileId].iNumToolAtShop1 = Data.uDEFAULT_SHOP1_TOOL;
         oSO.data["profile" + _iProfileId].iNumToolAtShop2 = Data.uDEFAULT_SHOP2_TOOL;
         oSO.data["profile" + _iProfileId].iNumToolAtShop3 = Data.uDEFAULT_SHOP3_TOOL;
         oSO.data["profile" + _iProfileId].uNumberHelpingSandy = 0;
         oSO.data["profile" + _iProfileId].uNumberHelpingSquidward = 0;
         oSO.data["profile" + _iProfileId].aItems = new Array();
         oSO.data["profile" + _iProfileId].aItemsAmount = new Array();
         Storyline.init();
         oSO.data["profile" + _iProfileId].oStorylineData = Storyline.oStorylineData;
         oSO.data["profile" + _iProfileId].bFlagTutorial = true;
         oSO.data["profile" + _iProfileId].uNumBeatenBoss = 0;
         oSO.data["profile" + _iProfileId].sPlayerWeaponPrime = Data.sSTATE_WEAPONS0;
         oSO.data["profile" + _iProfileId].sPlayerWeaponSecond = Data.sSTATE_WEAPONS0;
         oSO.data["profile" + _iProfileId].bSeaUrchinFound = false;
         oSO.data["profile" + _iProfileId].bVolcanicUrchinFound = false;
         oSO.flush();
      }
      
      public static function loadHeader(_iProfileId:int) : Object
      {
         loadSOIfNotLoaded();
         var _oRet:Object = new Object();
         return oSO.data["profile" + _iProfileId] as Object;
      }
      
      public static function deleteProfile(_iProfileId:int) : void
      {
         trace("PROFILE : deleteProfile ***");
         loadSOIfNotLoaded();
         oSO.data["profile" + _iProfileId] = null;
         oSO.flush();
      }
      
      public function getMiniMapItem() : Boolean
      {
         return hasItem(ItemID.uMINI_MAP);
      }
      
      public function addToScore(_uScoresToAdd:uint) : void
      {
         uScore += _uScoresToAdd;
         if(uScore > uSCORE_LIMIT)
         {
            uScore = uSCORE_LIMIT;
         }
         dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_SCORE));
      }
      
      private function isItemWeapon(_uItemID:uint) : Boolean
      {
         return isItemPrimaryWeapon(_uItemID) || isItemSecondaryWeapon(_uItemID);
      }
      
      public function getShopToolsAmount() : int
      {
         var _iNbr:int = 0;
         switch(uEpisode)
         {
            case 1:
               _iNbr = iNumToolAtShop1;
               break;
            case 2:
               _iNbr = iNumToolAtShop2;
               break;
            case 3:
               _iNbr = iNumToolAtShop3;
         }
         return _iNbr;
      }
      
      public function stealShopBottle() : Boolean
      {
         switch(uEpisode)
         {
            case 1:
               --iNumHealthBottleAtShop1;
               break;
            case 2:
               --iNumHealthBottleAtShop2;
               break;
            case 3:
               --iNumHealthBottleAtShop3;
         }
         return addBottle();
      }
      
      public function getCurrentScore() : uint
      {
         return uScore;
      }
      
      public function getUniqueData(_iC:int, _iR:int) : Boolean
      {
         var _bUsed:Boolean = false;
         if(oUniqueData != null)
         {
            if(oUniqueData[sLoadedMap] != undefined)
            {
               if(oUniqueData[sLoadedMap]["X" + _iC + "Y" + _iR])
               {
                  _bUsed = true;
               }
            }
         }
         return _bUsed;
      }
      
      public function getWeapon(_uWeaponNo:uint) : uint
      {
         return getItemAmount(convertWeaponNoToItemNo(_uWeaponNo));
      }
      
      public function getNbrKillBoss() : uint
      {
         return uNumBeatenBoss;
      }
      
      public function getSecondaryWeaponID() : uint
      {
         if(uSecondaryWeapon <= 0)
         {
            uSecondaryWeapon = 0;
         }
         return uint(convertWeaponNoToItemNo(uSecondaryWeapon));
      }
      
      public function getShopBottlesAmount() : int
      {
         var _iNbr:int = 0;
         switch(uEpisode)
         {
            case 1:
               _iNbr = iNumHealthBottleAtShop1;
               break;
            case 2:
               _iNbr = iNumHealthBottleAtShop2;
               break;
            case 3:
               _iNbr = iNumHealthBottleAtShop3;
         }
         return _iNbr;
      }
      
      public function hasSeaUrchin() : Boolean
      {
         return getNumSeaUrchin() > 0;
      }
      
      public function setWeapon(_uWeaponNo:uint, _uAmount:uint = 1) : Boolean
      {
         var _uMaxWeapon:uint = 0;
         var _bNewWeapon:Boolean = false;
         var _bFlagWeapon:Boolean = hasWeapon(_uWeaponNo);
         switch(_uWeaponNo)
         {
            case 1:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON1;
               break;
            case 2:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON2;
               break;
            case 3:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON3;
               break;
            case 4:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON4;
               break;
            case 5:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON5;
               break;
            case 6:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON6;
               break;
            case 7:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON7;
               break;
            case 8:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON8;
               break;
            case 9:
               _uMaxWeapon = Data.uINVENTORY_MAXIMUM_WEAPON9;
         }
         if(_uAmount > 0)
         {
            if(_bFlagWeapon == false)
            {
               _bNewWeapon = true;
               if(_uAmount > _uMaxWeapon)
               {
                  _uAmount = _uMaxWeapon;
               }
            }
         }
         storeItem(convertWeaponNoToItemNo(_uWeaponNo),_uAmount);
         if(_bNewWeapon)
         {
            Storyline.play("Weapon" + String(_uWeaponNo));
         }
         return _bNewWeapon;
      }
      
      public function dispatchNewItemEvent(_uItemID:uint) : void
      {
         var _e:ProfileEvent = new ProfileEvent(ProfileEvent.EVENT_GET_NEW_ITEM,_uItemID);
         dispatchEvent(_e);
         trace("Profile.dispatchNewItemEvent(" + _uItemID + ")");
      }
      
      public function removeListeners() : void
      {
         var oGameDisp:GameDispatcher = null;
         trace("___PROFILE___");
         if(GameDispatcher.Instance)
         {
            oGameDisp = GameDispatcher.Instance;
            oGameDisp.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onPickupItem);
            oGameDisp.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,onPickupItem);
            oGameDisp.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_WITH_BOOMERANG,onPickupItem);
            oGameDisp.removeEventListener(HurtEvent.EVENT_ENEMY_DIE,onEnemyDie);
            oGameDisp.removeEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR,onIndoorUnlocking);
            oGameDisp.removeEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR_FROM_OTHER_SIDE,onIndoorUnlockingFromOutside);
            oGameDisp.removeEventListener(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,onDoorCleared);
            oGameDisp.removeEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onPuzzleTile);
            oGameDisp.removeEventListener(RoomEvent.EVENT_ROOM_INTRO_TILE,onIntroTile);
            oGameDisp.removeEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onTutorialTile);
            oGameDisp.removeEventListener(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,onProjectileThrown);
            oGameDisp.removeEventListener(DropItemEvent.EVENT_FOUND_ITEM_IN_CHEST,onFoundInChest);
            trace("remove listeners .. done");
         }
         else
         {
            trace("remove listeners .. fail");
         }
         trace("_____________");
      }
      
      public function getPrimaryWeaponID() : uint
      {
         if(uPrimaryWeapon <= 0)
         {
            uPrimaryWeapon = 0;
         }
         trace(">>> !!! Get primary weapon : ",uPrimaryWeapon);
         return uint(convertWeaponNoToItemNo(uPrimaryWeapon));
      }
      
      public function addPebbles(_uPebbles:uint) : void
      {
         uPebbleAmount += _uPebbles;
         oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_PEEBLE,ItemID.uPEBBLES));
      }
      
      public function getNumSeaUrchin() : uint
      {
         return getItemAmount(ItemID.uSEA_URCHIN);
      }
      
      public function getNormalKeysAmount() : uint
      {
         return getItemAmount(ItemID.uDOOR_KEY);
      }
      
      private function onIntroTile(_e:RoomEvent) : void
      {
         saveUniqueData(_e.worldPosition);
      }
      
      public function dispatchGetItemEvent(_uItemID:uint) : void
      {
         var _e:ProfileEvent = new ProfileEvent(ProfileEvent.EVENT_GET_ITEM,_uItemID);
         dispatchEvent(_e);
         trace("Profile.dispatchGetItemEvent(" + _uItemID + ")");
      }
      
      public function stealShopTool() : Boolean
      {
         switch(uEpisode)
         {
            case 1:
               --iNumToolAtShop1;
               break;
            case 2:
               --iNumToolAtShop2;
               break;
            case 3:
               --iNumToolAtShop3;
         }
         return addTool();
      }
      
      public function useBottle() : Boolean
      {
         var _uID:uint = ItemID.uHEALTH_BOTTLE;
         var _uAmount:uint = getItemAmount(_uID) - 1;
         if(_uAmount < 0)
         {
            return false;
         }
         storeItem(_uID,_uAmount);
         setHearts(getHearts() + Data.nBOTTLE_AMOUNT_OF_HEART_GIVEN);
         return true;
      }
      
      public function get loadedMap() : String
      {
         return sLoadedMap;
      }
      
      public function setBossChamberKey() : Boolean
      {
         return storeItem(ItemID.uBOSS_CHAMBER_KEY);
      }
      
      public function useNormalKey() : Boolean
      {
         var _uID:uint = ItemID.uDOOR_KEY;
         trace("> use key am",getItemAmount(_uID));
         var _uAmount:uint = getItemAmount(_uID) - 1;
         trace("> use key am",getItemAmount(_uID));
         if(_uAmount < 0)
         {
            return false;
         }
         trace("> store key amount",_uAmount);
         storeItem(_uID,_uAmount);
         oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_KEY,ItemID.uDOOR_KEY));
         return true;
      }
      
      public function getCurrentEpisode() : uint
      {
         return uEpisode;
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function set loadedMap(_sMapName:String) : void
      {
         sLoadedMap = _sMapName;
      }
      
      private function patchData() : void
      {
         if(oUniqueData["dungeon11a"] != null && oUniqueData["dungeon11a"]["X34Y27"])
         {
            oUniqueData["dungeon11a"]["X33Y26"] = true;
         }
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function getItemAmount(_uItemID:uint) : uint
      {
         var _iIndex:int = 0;
         var _uAmount:uint = 0;
         if(aItems)
         {
            _iIndex = aItems.indexOf(_uItemID);
            if(_iIndex >= 0)
            {
               _uAmount = aItemsAmount[_iIndex];
            }
         }
         else
         {
            aItems = new Array();
            aItemsAmount = new Array();
         }
         return _uAmount;
      }
      
      public function setPebbles(_uPebbles:uint) : void
      {
         uPebbleAmount = _uPebbles;
      }
      
      public function setCurrentEpisode(_uEpisode:uint) : void
      {
         uEpisode = _uEpisode;
      }
      
      public function getNbrHelpSquidward() : uint
      {
         return uNumberHelpingSquidward;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      private function onIndoorUnlocking(_e:DoorEvent) : void
      {
         switch(_e.unlockedBy)
         {
            case DoorEvent.uDOOR_UNLOCKED_BY_KEY:
               useNormalKey();
               break;
            case DoorEvent.uDOOR_UNLOCKED_BY_DUNGEON_KEYS:
               storeItem(ItemID.uBOSS_DUNGEON_KEY_1,0);
               storeItem(ItemID.uBOSS_DUNGEON_KEY_2,0);
               break;
            case DoorEvent.uDOOR_UNLOCKED_BY_CHAMBER_KEY:
               storeItem(ItemID.uBOSS_CHAMBER_KEY,0);
         }
         saveUniqueData(_e.worldSource);
      }
      
      public function inventoryFullOf(_uItem:uint) : Boolean
      {
         var _bRet:* = false;
         switch(_uItem)
         {
            case ItemID.uDOOR_KEY:
               _bRet = getNormalKeysAmount() >= Data.uINVENTORY_MAXIMUM_KEYS;
               break;
            case ItemID.uSEA_URCHIN:
               _bRet = getNumSeaUrchin() >= Data.uINVENTORY_MAXIMUM_WEAPON5;
               break;
            case ItemID.uVOLCANIC_URCHIN:
               _bRet = getNumVolcanicUrchin() >= Data.uINVENTORY_MAXIMUM_WEAPON6;
               break;
            case ItemID.uHEALTH_BOTTLE:
               _bRet = getBottlesAmount() >= Data.uINVENTORY_MAXIMUM_BOTTLES;
         }
         return _bRet;
      }
      
      public function stealShopKey() : Boolean
      {
         switch(uEpisode)
         {
            case 1:
               --iNumKeysAtShop1;
               break;
            case 2:
               --iNumKeysAtShop2;
               break;
            case 3:
               --iNumKeysAtShop3;
         }
         return addNormalKey();
      }
      
      public function get savedMap() : String
      {
         return sSavedMap;
      }
      
      public function hasWeapon(_uWeaponNo:uint) : Boolean
      {
         if(_uWeaponNo == 0)
         {
            return true;
         }
         return hasItem(convertWeaponNoToItemNo(_uWeaponNo));
      }
      
      public function adjustHearts(_nByHearts:Number) : void
      {
         setHearts(nHearts + _nByHearts);
      }
      
      public function addNormalKey() : Boolean
      {
         var _uID:uint = ItemID.uDOOR_KEY;
         trace(">>> ADD NORMAL KEY !",getItemAmount(_uID));
         var _uAmount:uint = getItemAmount(_uID) + 1;
         if(_uAmount > Data.uINVENTORY_MAXIMUM_KEYS)
         {
            _uAmount = Data.uINVENTORY_MAXIMUM_KEYS;
            return false;
         }
         var _bTest:Boolean = storeItem(_uID,_uAmount);
         oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_KEY,ItemID.uDOOR_KEY));
         return _bTest;
      }
      
      public function equipSecondaryWeapon(_uWeaponNo:uint = 0) : Boolean
      {
         var _bSwapWeapon:Boolean = false;
         if(_uWeaponNo == 0 || _uWeaponNo > 2 && getWeapon(_uWeaponNo) > 0)
         {
            if(uSecondaryWeapon != _uWeaponNo)
            {
               _bSwapWeapon = true;
            }
            switch(_uWeaponNo)
            {
               case 0:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS0;
                  break;
               case 3:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS3;
                  break;
               case 4:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS4;
                  break;
               case 5:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS5;
                  break;
               case 6:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS6;
                  break;
               case 7:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS7;
                  break;
               case 8:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS8;
                  break;
               case 9:
                  Profile.Instance.sPlayerWeaponSecond = Data.sSTATE_WEAPONS9;
            }
            uSecondaryWeapon = _uWeaponNo;
            oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_SECONDARYWEAPON,convertWeaponNoToItemNo(_uWeaponNo)));
         }
         return _bSwapWeapon;
      }
      
      private function isItemPrimaryWeapon(_uItemID:uint) : Boolean
      {
         var _bFlagItemWeapon:Boolean = false;
         switch(_uItemID)
         {
            case ItemID.uSWORD_LV_1:
            case ItemID.uSWORD_LV_2:
               _bFlagItemWeapon = true;
         }
         return _bFlagItemWeapon;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function onPuzzleTile(_e:RoomEvent) : void
      {
         saveUniqueData(_e.worldPosition);
      }
      
      public function hasKey() : Boolean
      {
         return getNormalKeysAmount() > 0;
      }
      
      public function doHelpSandy() : Boolean
      {
         trace("uNumberHelpingSandy+1 : " + uNumberHelpingSandy + 1);
         trace("uEpisode : " + uEpisode);
         if(uNumberHelpingSandy + 1 == uEpisode)
         {
            trace("BEFORE USE TOOL");
            if(useTool())
            {
               trace("USE TOOL");
               uNumberHelpingSandy = uEpisode;
               return true;
            }
         }
         return false;
      }
      
      public function equipPrimaryWeapon(_uWeaponNo:uint = 0) : Boolean
      {
         var _bSwapWeapon:Boolean = false;
         if(_uWeaponNo == 0 || _uWeaponNo <= 2 && getWeapon(_uWeaponNo) > 0)
         {
            if(uPrimaryWeapon != _uWeaponNo)
            {
               _bSwapWeapon = true;
            }
            switch(_uWeaponNo)
            {
               case 0:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS0;
                  break;
               case 1:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS1;
                  break;
               case 2:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS2;
                  break;
               case 3:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS3;
                  break;
               case 4:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS4;
                  break;
               case 5:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS5;
                  break;
               case 6:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS6;
                  break;
               case 7:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS7;
                  break;
               case 8:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS8;
                  break;
               case 9:
                  Profile.Instance.sPlayerWeaponPrime = Data.sSTATE_WEAPONS9;
            }
            uPrimaryWeapon = _uWeaponNo;
            trace("###########!!! equip primary weapon : ",uPrimaryWeapon);
            oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_PRIMARYWEAPON,convertWeaponNoToItemNo(_uWeaponNo)));
         }
         trace(">>> !!! equip primary weapon : ",uPrimaryWeapon);
         return _bSwapWeapon;
      }
      
      public function getBottlesAmount() : uint
      {
         return getItemAmount(ItemID.uHEALTH_BOTTLE);
      }
      
      public function endTutorial() : void
      {
         bFlagTutorial = false;
      }
      
      public function getHearthsCapacity() : Number
      {
         return nHeartsCapacity;
      }
      
      public function hasBossChamberKey() : Boolean
      {
         return hasItem(ItemID.uBOSS_CHAMBER_KEY);
      }
      
      public function hasVolcanicUrchin() : Boolean
      {
         return getNumVolcanicUrchin() > 0;
      }
      
      private function onFoundInChest(_e:DropItemEvent) : void
      {
         switch(_e.itemId)
         {
            case ItemID.uSEA_URCHIN:
               if(!bSeaUrchinFound)
               {
                  bSeaUrchinFound = true;
               }
               break;
            case ItemID.uVOLCANIC_URCHIN:
               if(!bVolcanicUrchinFound)
               {
                  bVolcanicUrchinFound = true;
               }
         }
      }
      
      private function convertWeaponNoToItemNo(_uWeaponNo:uint) : uint
      {
         var _uItemID:uint = ItemID.uNULL_ITEM;
         switch(_uWeaponNo)
         {
            case 1:
               _uItemID = ItemID.uSWORD_LV_1;
               break;
            case 2:
               _uItemID = ItemID.uSWORD_LV_2;
               break;
            case 3:
               _uItemID = ItemID.uSHIELD_LV_1;
               break;
            case 4:
               _uItemID = ItemID.uSHIELD_LV_2;
               break;
            case 5:
               _uItemID = ItemID.uSEA_URCHIN;
               break;
            case 6:
               _uItemID = ItemID.uVOLCANIC_URCHIN;
               break;
            case 7:
               _uItemID = ItemID.uFORK;
               break;
            case 8:
               _uItemID = ItemID.uBOOMERANG;
               break;
            case 9:
               _uItemID = ItemID.uWAND;
         }
         return _uItemID;
      }
      
      private function onOutdoorUnlocking(_e:DoorEvent) : void
      {
         switch(_e.unlockedBy)
         {
            case DoorEvent.uDOOR_UNLOCKED_BY_KEY:
               useNormalKey();
               break;
            case DoorEvent.uDOOR_UNLOCKED_BY_DUNGEON_KEYS:
               storeItem(ItemID.uBOSS_DUNGEON_KEY_1,0);
               storeItem(ItemID.uBOSS_DUNGEON_KEY_2,0);
               break;
            case DoorEvent.uDOOR_UNLOCKED_BY_CHAMBER_KEY:
               storeItem(ItemID.uBOSS_CHAMBER_KEY,0);
         }
         saveUniqueData(_e.worldSource);
      }
      
      public function isSandyNeedHelp() : Boolean
      {
         if(uNumberHelpingSandy + 1 == uEpisode)
         {
            return true;
         }
         return false;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      public function saveUniqueData(_oPoint:Point) : void
      {
         trace("Profile : saveUniqueData ",_oPoint);
         var _bUsed:Boolean = false;
         if(oUniqueData[sLoadedMap] == undefined)
         {
            oUniqueData[sLoadedMap] = new Object();
         }
         var _iC:Number = Math.floor(_oPoint.x / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_oPoint.y / Data.iTILE_HEIGHT);
         oUniqueData[sLoadedMap]["X" + _iC + "Y" + _iR] = true;
      }
      
      public function getBossDungeonKey(_uPart:uint) : Boolean
      {
         var _id:uint = ItemID.uNULL_ITEM;
         switch(_uPart)
         {
            case 1:
               _id = ItemID.uBOSS_DUNGEON_KEY_1;
               break;
            case 2:
               _id = ItemID.uBOSS_DUNGEON_KEY_2;
         }
         if(_id != ItemID.uNULL_ITEM)
         {
            return hasItem(_id);
         }
         return false;
      }
      
      private function onProjectileThrown(_e:ThrowEvent) : void
      {
         switch(_e.projectileType)
         {
            case ThrowEvent.uPROJECTILE_SEA_URCHIN:
               storeItem(ItemID.uSEA_URCHIN,getNumSeaUrchin() - 1);
               break;
            case ThrowEvent.uPROJECTILE_VOLCANIC_URCHIN:
               storeItem(ItemID.uVOLCANIC_URCHIN,getNumVolcanicUrchin() - 1);
         }
      }
      
      public function getNbrHelpSandy() : uint
      {
         return uNumberHelpingSandy;
      }
      
      private function isItemSecondaryWeapon(_uItemID:uint) : Boolean
      {
         var _bFlagItemWeapon:Boolean = false;
         switch(_uItemID)
         {
            case ItemID.uSHIELD_LV_1:
            case ItemID.uSHIELD_LV_2:
            case ItemID.uSEA_URCHIN:
            case ItemID.uVOLCANIC_URCHIN:
            case ItemID.uFORK:
            case ItemID.uBOOMERANG:
            case ItemID.uWAND:
               _bFlagItemWeapon = true;
         }
         return _bFlagItemWeapon;
      }
      
      public function setBossDungeonKey(_uPart:uint) : Boolean
      {
         var _id:uint = ItemID.uNULL_ITEM;
         switch(_uPart)
         {
            case 1:
               _id = ItemID.uBOSS_DUNGEON_KEY_1;
               break;
            case 2:
               _id = ItemID.uBOSS_DUNGEON_KEY_2;
         }
         if(_id != ItemID.uNULL_ITEM)
         {
            return storeItem(_id);
         }
         return false;
      }
      
      public function addListeners() : void
      {
         var oGameDisp:GameDispatcher = null;
         trace("___PROFILE___");
         if(GameDispatcher.Instance)
         {
            oGameDisp = GameDispatcher.Instance;
            oGameDisp.addWeakEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onPickupItem);
            oGameDisp.addWeakEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,onPickupItem);
            oGameDisp.addWeakEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_WITH_BOOMERANG,onPickupItem);
            oGameDisp.addWeakEventListener(HurtEvent.EVENT_ENEMY_DIE,onEnemyDie);
            oGameDisp.addWeakEventListener(HurtEvent.EVENT_PLAYER_DIE,onPlayerDie);
            oGameDisp.addWeakEventListener(HurtEvent.EVENT_PLAYER_HITTED,onPlayerHurt);
            oGameDisp.addWeakEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR,onIndoorUnlocking);
            oGameDisp.addWeakEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR_FROM_OTHER_SIDE,onIndoorUnlockingFromOutside);
            oGameDisp.addWeakEventListener(DoorEvent.EVENT_UNLOCK_OUTDOOR_DOOR,onOutdoorUnlocking);
            oGameDisp.addWeakEventListener(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,onDoorCleared);
            oGameDisp.addWeakEventListener(ChestEvent.EVENT_UNLOCK_CHEST,onUnlockChest);
            oGameDisp.addWeakEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onPuzzleTile);
            oGameDisp.addWeakEventListener(RoomEvent.EVENT_ROOM_INTRO_TILE,onIntroTile);
            oGameDisp.addWeakEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onTutorialTile);
            oGameDisp.addWeakEventListener(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,onProjectileThrown);
            oGameDisp.addWeakEventListener(DropItemEvent.EVENT_FOUND_ITEM_IN_CHEST,onFoundInChest);
            trace("add listeners .. done");
         }
         else
         {
            trace("add listeners .. fail");
         }
         trace("_____________");
      }
      
      public function doHelpSquidward() : Boolean
      {
         if(uNumberHelpingSquidward + 1 == uEpisode)
         {
            uNumberHelpingSquidward = uEpisode;
            return true;
         }
         return false;
      }
      
      public function storeItem(_uItemID:uint, _uAmount:uint = 1) : Boolean
      {
         var _bFlagNewItem:Boolean = true;
         var _iIndex:int = aItems.indexOf(_uItemID);
         if(_iIndex >= 0)
         {
            _bFlagNewItem = false;
            aItemsAmount[_iIndex] = _uAmount;
         }
         else
         {
            aItems.push(_uItemID);
            _iIndex = aItems.indexOf(_uItemID);
            aItemsAmount[_iIndex] = _uAmount;
         }
         switch(_uItemID)
         {
            case ItemID.uSEA_URCHIN:
               dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_SEA_URCHIN_NUM,ItemID.uSEA_URCHIN));
               break;
            case ItemID.uVOLCANIC_URCHIN:
               dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_VOLCANIC_URCHIN_NUM,ItemID.uVOLCANIC_URCHIN));
               break;
            case ItemID.uHEALTH_BOTTLE:
               dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_BOTTLE_NUM,ItemID.uHEALTH_BOTTLE));
         }
         return _bFlagNewItem;
      }
      
      public function isTutorial() : Boolean
      {
         return bFlagTutorial;
      }
      
      private function onTutorialTile(_e:RoomEvent) : void
      {
         saveUniqueData(_e.worldPosition);
      }
      
      public function pickupItem(_uItemID:uint, _uAmount:uint = 1) : Boolean
      {
         trace("Profile.pickupItem(" + _uItemID + "[" + _uAmount + "])");
         var _bNewWeapon:Boolean = false;
         var _bFlagNewItem:Boolean = false;
         var _uWeaponNo:uint = convertItemNoToWeaponNo(_uItemID);
         if(_uWeaponNo > 0)
         {
            if(isItemPrimaryWeapon(_uItemID))
            {
               _bNewWeapon = storeItem(_uItemID,_uAmount);
               _bFlagNewItem = equipPrimaryWeapon(_uWeaponNo);
               if(_bNewWeapon)
               {
                  dispatchNewItemEvent(_uItemID);
               }
            }
            if(isItemSecondaryWeapon(_uItemID))
            {
               trace("equipSecondaryWeapon[" + _uItemID + "]");
               if(_uItemID == ItemID.uSEA_URCHIN)
               {
                  if(getNumSeaUrchin() < Data.uINVENTORY_MAXIMUM_WEAPON5)
                  {
                     _bNewWeapon = storeItem(_uItemID,getNumSeaUrchin() + 1);
                  }
               }
               else if(_uItemID == ItemID.uVOLCANIC_URCHIN)
               {
                  if(getNumVolcanicUrchin() < Data.uINVENTORY_MAXIMUM_WEAPON6)
                  {
                     _bNewWeapon = storeItem(_uItemID,getNumVolcanicUrchin() + 1);
                  }
               }
               else
               {
                  _bNewWeapon = storeItem(_uItemID,_uAmount);
               }
               _bFlagNewItem = equipSecondaryWeapon(_uWeaponNo);
               if(_bNewWeapon)
               {
                  dispatchNewItemEvent(_uItemID);
               }
            }
            trace(">>>>>>>>>>>>>>>> 2222222222222222222 NUMber Sea urchin : ",getNumSeaUrchin());
         }
         else
         {
            switch(_uItemID)
            {
               case ItemID.uBOSS_CHAMBER_KEY:
                  _bFlagNewItem = setBossChamberKey();
                  if(_bFlagNewItem)
                  {
                     dispatchNewItemEvent(_uItemID);
                  }
                  break;
               case ItemID.uBOSS_DUNGEON_KEY_1:
                  _bFlagNewItem = setBossDungeonKey(1);
                  if(_bFlagNewItem)
                  {
                     dispatchNewItemEvent(_uItemID);
                  }
                  break;
               case ItemID.uBOSS_DUNGEON_KEY_2:
                  _bFlagNewItem = setBossDungeonKey(2);
                  if(_bFlagNewItem)
                  {
                     dispatchNewItemEvent(_uItemID);
                  }
                  break;
               case ItemID.uDOOR_KEY:
                  _bFlagNewItem = addNormalKey();
                  if(_bFlagNewItem)
                  {
                     dispatchNewItemEvent(_uItemID);
                  }
                  break;
               case ItemID.uHEALTH_BOTTLE:
                  _bFlagNewItem = addBottle();
                  if(!_bFlagNewItem)
                  {
                  }
                  break;
               case ItemID.uHEART_CONTAINER:
                  setHearthsCapacity(getHearthsCapacity() + 1);
                  setHearts(getHearthsCapacity());
                  _bFlagNewItem = true;
                  trace("New heart container");
                  break;
               case ItemID.uHEARTH:
                  setHearts(getHearts() + 1);
                  _bFlagNewItem = true;
                  break;
               case ItemID.uMINI_MAP:
                  _bFlagNewItem = setMinimap();
                  if(!_bFlagNewItem)
                  {
                  }
                  break;
               case ItemID.uPEBBLE_1:
                  addPebbles(1);
                  _bFlagNewItem = true;
                  break;
               case ItemID.uPEEBLES_5:
                  addPebbles(5);
                  _bFlagNewItem = true;
                  break;
               case ItemID.uPEEBLES_10:
                  addPebbles(10);
                  _bFlagNewItem = true;
                  break;
               case ItemID.uSANDY_ITEM_1:
               case ItemID.uSANDY_ITEM_2:
               case ItemID.uSANDY_ITEM_3:
               case ItemID.uSANDY_TOOLS:
                  _bFlagNewItem = addTool();
                  if(_bFlagNewItem)
                  {
                     dispatchNewItemEvent(_uItemID);
                  }
            }
         }
         return _bFlagNewItem;
      }
      
      public function getNumVolcanicUrchin() : uint
      {
         return getItemAmount(ItemID.uVOLCANIC_URCHIN);
      }
      
      private function loadData(_iProfileId:int) : void
      {
         loadSOIfNotLoaded();
         var _oByteArray:ByteArray = new ByteArray();
         sPlayerName = oSO.data["profile" + _iProfileId].sPlayerName;
         nHearts = oSO.data["profile" + _iProfileId].nHearts;
         nHeartsCapacity = oSO.data["profile" + _iProfileId].nHeartsCapacity;
         uPebbleAmount = oSO.data["profile" + _iProfileId].uPebbleAmount;
         uScore = oSO.data["profile" + _iProfileId].uScore;
         uPrimaryWeapon = oSO.data["profile" + _iProfileId].uPrimaryWeapon;
         uSecondaryWeapon = oSO.data["profile" + _iProfileId].uSecondaryWeapon;
         uEpisode = oSO.data["profile" + _iProfileId].uEpisode;
         sSavedMap = oSO.data["profile" + _iProfileId].sSavedMap;
         _oByteArray.writeObject(oSO.data["profile" + _iProfileId].oUniqueData);
         iNumKeysAtShop1 = oSO.data["profile" + _iProfileId].iNumKeysAtShop1;
         iNumKeysAtShop2 = oSO.data["profile" + _iProfileId].iNumKeysAtShop2;
         iNumKeysAtShop3 = oSO.data["profile" + _iProfileId].iNumKeysAtShop3;
         iNumHealthBottleAtShop1 = oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop1;
         iNumHealthBottleAtShop2 = oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop2;
         iNumHealthBottleAtShop3 = oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop3;
         iNumToolAtShop1 = oSO.data["profile" + _iProfileId].iNumToolAtShop1;
         iNumToolAtShop2 = oSO.data["profile" + _iProfileId].iNumToolAtShop2;
         iNumToolAtShop3 = oSO.data["profile" + _iProfileId].iNumToolAtShop3;
         uNumberHelpingSandy = oSO.data["profile" + _iProfileId].uNumberHelpingSandy;
         uNumberHelpingSquidward = oSO.data["profile" + _iProfileId].uNumberHelpingSquidward;
         _oByteArray.writeObject(oSO.data["profile" + _iProfileId].aItems);
         _oByteArray.writeObject(oSO.data["profile" + _iProfileId].aItemsAmount);
         Storyline.oStorylineData = oSO.data["profile" + _iProfileId].oStorylineData;
         bFlagTutorial = oSO.data["profile" + _iProfileId].bFlagTutorial;
         sPlayerWeaponPrime = oSO.data["profile" + _iProfileId].sPlayerWeaponPrime;
         sPlayerWeaponSecond = oSO.data["profile" + _iProfileId].sPlayerWeaponSecond;
         bSeaUrchinFound = oSO.data["profile" + _iProfileId].bSeaUrchinFound;
         bVolcanicUrchinFound = oSO.data["profile" + _iProfileId].bVolcanicUrchinFound;
         uNumBeatenBoss = oSO.data["profile" + _iProfileId].uNumBeatenBoss;
         _oByteArray.position = 0;
         oUniqueData = _oByteArray.readObject();
         aItems = _oByteArray.readObject();
         aItemsAmount = _oByteArray.readObject();
         loadedMap = sSavedMap;
         patchData();
         oSO = null;
      }
      
      public function isSquidwardNeedHelp() : Boolean
      {
         if(uNumberHelpingSquidward == uEpisode - 1)
         {
            return true;
         }
         return false;
      }
      
      public function useTool() : Boolean
      {
         var _bTool:Boolean = false;
         var _uItemID:uint = ItemID.uSANDY_TOOLS;
         var _uNumber:uint = getItemAmount(_uItemID);
         if(_uNumber > 0)
         {
            _bTool = true;
            storeItem(_uItemID,_uNumber - 1);
         }
         return _bTool;
      }
      
      public function onPlayerDie(_e:HurtEvent) : void
      {
         adjustHearts(0);
         trace("################ !!!! GAME OVER !!!!!!!!!!!!!!!!!!!!!!!");
      }
      
      public function substractPebbles(_uPebbles:uint) : Boolean
      {
         var _bFlag:Boolean = false;
         if(uPebbleAmount >= _uPebbles)
         {
            uPebbleAmount -= _uPebbles;
            _bFlag = true;
         }
         oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_PEEBLE,ItemID.uPEBBLES));
         return _bFlag;
      }
      
      private function saveData(_iProfileId:int) : void
      {
         loadSOIfNotLoaded();
         var _oByteArray:ByteArray = new ByteArray();
         _oByteArray.writeObject(oUniqueData);
         _oByteArray.writeObject(aItems);
         _oByteArray.writeObject(aItemsAmount);
         _oByteArray.position = 0;
         trace("Profile : saveData");
         trace(">>>>>>> SAVE PRI WPN !!!!! ",uPrimaryWeapon);
         oSO.data["profile" + _iProfileId].sPlayerName = sPlayerName;
         oSO.data["profile" + _iProfileId].nHearts = nHeartsCapacity;
         oSO.data["profile" + _iProfileId].nHeartsCapacity = nHeartsCapacity;
         oSO.data["profile" + _iProfileId].uPebbleAmount = uPebbleAmount;
         oSO.data["profile" + _iProfileId].uScore = uScore;
         oSO.data["profile" + _iProfileId].uPrimaryWeapon = uPrimaryWeapon;
         oSO.data["profile" + _iProfileId].uSecondaryWeapon = uSecondaryWeapon;
         oSO.data["profile" + _iProfileId].uEpisode = uEpisode;
         oSO.data["profile" + _iProfileId].sSavedMap = sSavedMap;
         oSO.data["profile" + _iProfileId].oUniqueData = _oByteArray.readObject();
         oSO.data["profile" + _iProfileId].iNumKeysAtShop1 = iNumKeysAtShop1;
         oSO.data["profile" + _iProfileId].iNumKeysAtShop2 = iNumKeysAtShop2;
         oSO.data["profile" + _iProfileId].iNumKeysAtShop3 = iNumKeysAtShop3;
         oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop1 = iNumHealthBottleAtShop1;
         oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop2 = iNumHealthBottleAtShop2;
         oSO.data["profile" + _iProfileId].iNumHealthBottleAtShop3 = iNumHealthBottleAtShop3;
         oSO.data["profile" + _iProfileId].iNumToolAtShop1 = iNumToolAtShop1;
         oSO.data["profile" + _iProfileId].iNumToolAtShop2 = iNumToolAtShop2;
         oSO.data["profile" + _iProfileId].iNumToolAtShop3 = iNumToolAtShop3;
         oSO.data["profile" + _iProfileId].uNumberHelpingSandy = uNumberHelpingSandy;
         oSO.data["profile" + _iProfileId].uNumberHelpingSquidward = uNumberHelpingSquidward;
         oSO.data["profile" + _iProfileId].aItems = _oByteArray.readObject();
         oSO.data["profile" + _iProfileId].aItemsAmount = _oByteArray.readObject();
         oSO.data["profile" + _iProfileId].oStorylineData = Storyline.oStorylineData;
         oSO.data["profile" + _iProfileId].bFlagTutorial = bFlagTutorial;
         oSO.data["profile" + _iProfileId].uNumBeatenBoss = uNumBeatenBoss;
         oSO.data["profile" + _iProfileId].sPlayerWeaponPrime = sPlayerWeaponPrime;
         oSO.data["profile" + _iProfileId].sPlayerWeaponSecond = sPlayerWeaponSecond;
         oSO.data["profile" + _iProfileId].bSeaUrchinFound = bSeaUrchinFound;
         oSO.data["profile" + _iProfileId].bVolcanicUrchinFound = bVolcanicUrchinFound;
      }
      
      public function saveCurrentProfile() : Boolean
      {
         trace("PROFILE : saveCurrentProfile ***");
         loadSOIfNotLoaded();
         if(Instance == null)
         {
            return false;
         }
         saveData(iProfileID);
         oSO.flush();
         oSO = null;
         return true;
      }
      
      public function addBottle() : Boolean
      {
         var _uID:uint = ItemID.uHEALTH_BOTTLE;
         var _uAmount:uint = getItemAmount(_uID) + 1;
         if(_uAmount > Data.uINVENTORY_MAXIMUM_BOTTLES)
         {
            _uAmount = Data.uINVENTORY_MAXIMUM_BOTTLES;
            return false;
         }
         return storeItem(_uID,_uAmount);
      }
      
      public function getPebbles() : uint
      {
         return uPebbleAmount;
      }
      
      private function convertItemNoToWeaponNo(_uItemID:uint) : uint
      {
         var _uWeaponNo:uint = 0;
         switch(_uItemID)
         {
            case ItemID.uSWORD_LV_1:
               _uWeaponNo = 1;
               break;
            case ItemID.uSWORD_LV_2:
               _uWeaponNo = 2;
               break;
            case ItemID.uSHIELD_LV_1:
               _uWeaponNo = 3;
               break;
            case ItemID.uSHIELD_LV_2:
               _uWeaponNo = 4;
               break;
            case ItemID.uSEA_URCHIN:
               _uWeaponNo = 5;
               break;
            case ItemID.uVOLCANIC_URCHIN:
               _uWeaponNo = 6;
               break;
            case ItemID.uFORK:
               _uWeaponNo = 7;
               break;
            case ItemID.uBOOMERANG:
               _uWeaponNo = 8;
               break;
            case ItemID.uWAND:
               _uWeaponNo = 9;
         }
         return _uWeaponNo;
      }
      
      public function addTool() : Boolean
      {
         var _uItemID:uint = ItemID.uSANDY_TOOLS;
         var _uNumber:uint = getItemAmount(_uItemID) + 1;
         if(_uNumber > Data.uINVENTORY_MAXIMUM_TOOLS)
         {
            _uNumber = Data.uINVENTORY_MAXIMUM_TOOLS;
         }
         return storeItem(_uItemID,_uNumber);
      }
      
      private function onBuyItem(_e:ShopTransactEvent) : void
      {
      }
      
      public function hasItem(_uItemID:uint) : Boolean
      {
         var _iIndex:int = 0;
         if(aItems)
         {
            _iIndex = aItems.indexOf(_uItemID);
            return _iIndex > 0;
         }
         aItems = new Array();
         aItemsAmount = new Array();
         return false;
      }
      
      public function getToolsAmount() : uint
      {
         return getItemAmount(ItemID.uSANDY_TOOLS);
      }
      
      public function hasBothDungeonKeyParts() : Boolean
      {
         return hasItem(ItemID.uBOSS_DUNGEON_KEY_1) && hasItem(ItemID.uBOSS_DUNGEON_KEY_2);
      }
      
      public function canPickUpItem(_uItemId:uint) : Boolean
      {
         var _bRet:Boolean = true;
         switch(_uItemId)
         {
            case ItemID.uSEA_URCHIN:
               _bRet = bSeaUrchinFound;
               break;
            case ItemID.uVOLCANIC_URCHIN:
               _bRet = bVolcanicUrchinFound;
               break;
            case ItemID.uHEALTH_BOTTLE:
               _bRet = true;
               break;
            case ItemID.uSANDY_TOOLS:
               _bRet = false;
         }
         return _bRet;
      }
      
      public function setMinimap() : Boolean
      {
         return storeItem(ItemID.uMINI_MAP);
      }
      
      private function onIndoorUnlockingFromOutside(_e:DoorEvent) : void
      {
         saveUniqueData(_e.worldSource);
      }
      
      public function setHearthsCapacity(_nHeartsCapacity:Number) : void
      {
         nHeartsCapacity = _nHeartsCapacity;
         nHearts = _nHeartsCapacity;
         oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_HEALTH_CONTAINER,ItemID.uHEART_CONTAINER));
         trace("HeartContainer");
      }
      
      public function getHearts() : Number
      {
         return nHearts;
      }
      
      private function onDoorCleared(_e:DoorEvent) : void
      {
         saveUniqueData(_e.worldSource);
      }
      
      private function onPickupItem(_e:ItemEvent) : void
      {
         trace("PICKUP ITEM: " + _e.itemId);
         pickupItem(_e.itemId);
         if(_e.worldSource != null)
         {
            saveUniqueData(_e.worldSource);
         }
      }
      
      public function setHearts(_nHearts:Number) : void
      {
         if(_nHearts > nHeartsCapacity)
         {
            _nHearts = nHeartsCapacity;
         }
         if(_nHearts < 0)
         {
            _nHearts = 0;
         }
         nHearts = _nHearts;
         oEventDisp.dispatchEvent(new ProfileEvent(ProfileEvent.EVENT_UPDATE_HEALTH,ItemID.uHEARTH));
         trace("Heart");
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      private function onUnlockChest(_e:ChestEvent = null) : void
      {
         if(!hasKey())
         {
            return;
         }
         useNormalKey();
      }
      
      public function getShopKeysAmount() : int
      {
         var _iNbr:int = 0;
         switch(uEpisode)
         {
            case 1:
               _iNbr = iNumKeysAtShop1;
               break;
            case 2:
               _iNbr = iNumKeysAtShop2;
               break;
            case 3:
               _iNbr = iNumKeysAtShop3;
         }
         return _iNbr;
      }
      
      private function onEnemyDie(_e:HurtEvent) : void
      {
         var _oJ:Jellyfish = null;
         var _uScore:uint = 0;
         var _oVictim:Object = _e.victim;
         if(_oVictim is Jellyfish)
         {
            _oJ = _oVictim as Jellyfish;
            switch(_oJ.getJellyfishType())
            {
               case Jellyfish.uTYPE_LIGHT:
                  _uScore = Data.uSCORE_JELLYFISH_LIGHT;
                  break;
               case Jellyfish.uTYPE_MID:
                  _uScore = Data.uSCORE_JELLYFISH_MID;
                  break;
               case Jellyfish.uTYPE_HIGH:
                  _uScore = Data.uSCORE_JELLYFISH_HIGH;
            }
         }
         else if(_oVictim is Eel)
         {
            _uScore = Data.uSCORE_EEL;
         }
         else if(_oVictim is GaseousRock)
         {
            uNumBeatenBoss = 1;
         }
         if(_uScore != 0)
         {
            addToScore(_uScore);
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         iProfileID = 0;
         aItems = null;
         aItemsAmount = null;
         oUniqueData = null;
         oEventDisp = null;
         removeListeners();
         oSO = null;
         Instance = null;
      }
      
      public function onPlayerHurt(_e:HurtEvent) : void
      {
         adjustHearts(-_e.damage);
      }
   }
}
