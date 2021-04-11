package gameplay
{
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.AttackEvent;
   import gameplay.events.CameraEvent;
   import gameplay.events.ChestEvent;
   import gameplay.events.DoorEvent;
   import gameplay.events.DropItemEvent;
   import gameplay.events.HurtEvent;
   import gameplay.events.InventoryPopupEvent;
   import gameplay.events.ItemEvent;
   import gameplay.events.LevelEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MenuPopupEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.PlayerEvent;
   import gameplay.events.ProfileEvent;
   import gameplay.events.ProjectileEvent;
   import gameplay.events.RoomEvent;
   import gameplay.events.SavePopupEvent;
   import gameplay.events.ShopPopupEvent;
   import gameplay.events.ShopTransactEvent;
   import gameplay.events.StoryPopupEvent;
   import gameplay.events.TextboxEvent;
   import gameplay.events.ThrowEvent;
   import gameplay.events.TransitionFocusEvent;
   import library.events.MainEvent;
   import library.utils.DepthManager;
   import library.utils.Tools;
   
   public class Game
   {
      
      public static const sDEPTH_OVERLAY:String = "overlay";
      
      public static var Instance:Game = null;
      
      public static const sDEPTH_HUD:String = "hud";
      
      public static const sDEPTH_LEVEL:String = "level";
      
      public static const sDEPTH_TRANSITION_FOCUS:String = "transitionFocus";
       
      
      private var oHud:Hud;
      
      private var oTransitionFocus:TransitionFocus;
      
      private var mcRef:MovieClip;
      
      private var oPlayer:Player;
      
      private var bPaused:Boolean;
      
      private var oGameDisp:GameDispatcher;
      
      private var oLevel:Level;
      
      private var oDepthManager:DepthManager;
      
      public function Game(_mcRef:MovieClip)
      {
         super();
         mcRef = _mcRef;
         oDepthManager = new DepthManager();
         oDepthManager.addDepthLayer(sDEPTH_LEVEL,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_HUD,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_TRANSITION_FOCUS,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_OVERLAY,mcRef);
         Main.instance.stage.focus = Main.instance.stage;
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         oGameDisp = new GameDispatcher();
         Instance = this;
         bPaused = false;
         Profile.Instance.addListeners();
         listenToProfile(Profile.Instance);
      }
      
      private function listenToPatrick(_oChara:IEventDispatcher) : void
      {
         _oChara.addEventListener(MapGenerateEvent.EVENT_DESTROY_PATRICK,onPatrickDestroy,false,0,true);
      }
      
      private function onIndoorDoorDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToIndoorDoor(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function listenToSandy(_oChara:IEventDispatcher) : void
      {
         _oChara.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onEventToDispatch,false,0,true);
         _oChara.addEventListener(MapGenerateEvent.EVENT_DESTROY_SANDY,onSandyDestroy,false,0,true);
      }
      
      private function listenToEnemy(_oEn:Enemy) : void
      {
         trace("Game : listenToEnemy ",_oEn);
         _oEn.addWeakEventListener(HurtEvent.EVENT_ENEMY_HITTED,onEnemyHitted);
         _oEn.addWeakEventListener(HurtEvent.EVENT_ENEMY_DIE,onEnemyDie);
         _oEn.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_ENEMY,onEnemyDestroy);
         _oEn.addWeakEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onEventToDispatch);
         _oEn.addWeakEventListener(MovingBodyEvent.EVENT_ENEMY_HIT_MOVING_PLAYER,onEventToDispatch);
         _oEn.addWeakEventListener(AttackEvent.EVENT_ENEMY_ATTACK,onEventToDispatch);
         _oEn.addWeakEventListener(DropItemEvent.EVENT_DROP_ITEM,onEventToDispatch);
         _oEn.addWeakEventListener(ThrowEvent.EVENT_ENEMY_THROW_PROJECTILE,onEventToDispatch);
      }
      
      private function onTransitionFocusCompleted(_e:TransitionFocusEvent) : void
      {
         trace("Game : onTransitionFocusCompleted");
         doResume();
         oPlayer.releaseControl();
         oGameDisp.dispatchEvent(_e);
         oGameDisp.dispatchStart();
      }
      
      private function onDummy(_e:Event) : void
      {
         trace("DUMMY EVENT TRIGGERED : " + _e.type + " from " + _e.currentTarget);
      }
      
      private function onPlayerAttack(_e:AttackEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToSandy(_oChara:IEventDispatcher) : void
      {
         _oChara.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onEventToDispatch);
         _oChara.removeEventListener(MapGenerateEvent.EVENT_DESTROY_SANDY,onSandyDestroy);
      }
      
      public function stopListenToTextBox(_oTextBox:IEventDispatcher) : void
      {
         _oTextBox.removeEventListener(TextboxEvent.EVENT_OPEN_TEXTBOX,onOpenIngamePopup);
         _oTextBox.removeEventListener(TextboxEvent.EVENT_CLOSE_TEXTBOX,onCloseIngamePopup);
      }
      
      private function onOutdoorDoorDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToOutdoorDoor(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToTutorialTile(_oTile:IEventDispatcher) : void
      {
         _oTile.removeEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onEventToDispatch);
         _oTile.removeEventListener(MapGenerateEvent.EVENT_DESTROY_TUTORIAL_NODE,onTutorialTileDestroy);
      }
      
      private function onIntroTileCreation(_e:MapGenerateEvent) : void
      {
         listenToIntroTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onFloorItemCreation(_e:MapGenerateEvent) : void
      {
         listenToFloorItem(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function listenToMenu(_oPopup:IEventDispatcher) : void
      {
         _oPopup.addEventListener(MenuPopupEvent.EVENT_OPEN_POPUP_MENU,onOpenIngamePopup,false,0,true);
         _oPopup.addEventListener(MenuPopupEvent.EVENT_CLOSE_POPUP_MENU,onCloseIngamePopup,false,0,true);
      }
      
      private function onFixedTileCreation(_e:MapGenerateEvent) : void
      {
         listenToFixedTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onPatrickCreation(_e:MapGenerateEvent) : void
      {
         listenToPatrick(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function doPause() : void
      {
         trace("********* pause pred : ",bPaused);
         trace("******************************************** do pause");
         bPaused = true;
         oGameDisp.dispatchPause();
         if(!oGameDisp.isPlayerPaused())
         {
            oGameDisp.dispatchPlayerPause();
         }
      }
      
      private function listenToSquidward(_oChara:IEventDispatcher) : void
      {
         _oChara.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onEventToDispatch,false,0,true);
         _oChara.addEventListener(MapGenerateEvent.EVENT_DESTROY_SQUIDWARD,onSquidwardDestroy,false,0,true);
      }
      
      private function onPlayerFinishDie(_e:PlayerEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
         var _oBit:BitmapData = getSnapshot();
         Main.instance.lose(_oBit);
      }
      
      private function onPuzzleTileDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToPuzzleTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onMapCreated(_e:LevelEvent) : void
      {
         trace("Game : onMapCreated");
         var _oMap:Map = _e.map;
         oHud.mcRef.txtLevel.visible = false;
         _oMap.attachPlayerToMap(oPlayer);
         var _mcPlayer:MovieClip = oPlayer.getMC();
         var _oPos:Point = _mcPlayer.localToGlobal(new Point(0,0));
         oTransitionFocus.focusAt(_oPos.x,_oPos.y);
         bPaused = false;
         doPause();
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onChestDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToChest(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function stopListenProjectile(_oProj:IEventDispatcher) : void
      {
         _oProj.removeEventListener(ProjectileEvent.EVENT_DESTROY,onProjectileDestroy);
         _oProj.removeEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onEventToDispatch);
         _oProj.removeEventListener(AttackEvent.EVENT_ENEMY_ATTACK,onEventToDispatch);
         _oProj.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onEventToDispatch);
         _oProj.removeEventListener(AttackEvent.EVENT_PLAYER_ATTACK,onEventToDispatch);
      }
      
      private function getSnapshot() : BitmapData
      {
         var _oRet:BitmapData = new BitmapData(Data.iSTAGE_WIDTH,Data.iSTAGE_HEIGHT,false);
         _oRet.draw(mcRef,mcRef.transform.matrix,null,null,new Rectangle(0,0,Data.iSTAGE_WIDTH,Data.iSTAGE_HEIGHT));
         return _oRet;
      }
      
      private function onBreakablePropCreation(_e:MapGenerateEvent) : void
      {
         listenToBreakableProp(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function listenToSave(_oInventory:IEventDispatcher) : void
      {
         _oInventory.addEventListener(SavePopupEvent.EVENT_OPEN_POPUP_SAVE,onOpenIngamePopup,false,0,true);
         _oInventory.addEventListener(SavePopupEvent.EVENT_CLOSE_POPUP_SAVE,onCloseIngamePopup,false,0,true);
      }
      
      private function onSandyDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToSandy(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToProfile(_oProfile:Profile) : void
      {
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_HEALTH_CONTAINER,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_HEALTH,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_PEEBLE,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_SCORE,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_KEY,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_PRIMARYWEAPON,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_SECONDARYWEAPON,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_GET_ITEM,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_GET_NEW_ITEM,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_SEA_URCHIN_NUM,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_VOLCANIC_URCHIN_NUM,onEventToDispatch);
         _oProfile.removeEventListener(ProfileEvent.EVENT_UPDATE_BOTTLE_NUM,onEventToDispatch);
      }
      
      private function onKrabCreation(_e:MapGenerateEvent) : void
      {
         listenToKrab(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onFinishedShowingItem(_e:ItemEvent) : void
      {
         doResume();
         oGameDisp.dispatchEvent(_e);
      }
      
      public function stopListenToMenu(_oPopup:IEventDispatcher) : void
      {
         _oPopup.removeEventListener(MenuPopupEvent.EVENT_OPEN_POPUP_MENU,onOpenIngamePopup);
         _oPopup.removeEventListener(MenuPopupEvent.EVENT_CLOSE_POPUP_MENU,onCloseIngamePopup);
      }
      
      private function onCloseIngamePopup(_e:Event) : void
      {
         doResume();
         oGameDisp.dispatchEvent(_e);
      }
      
      public function listenToProjectile(_oProj:IEventDispatcher, _bIsEnemy:Boolean) : void
      {
         _oProj.addEventListener(ProjectileEvent.EVENT_DESTROY,onProjectileDestroy,false,0,true);
         if(_bIsEnemy)
         {
            _oProj.addEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onEventToDispatch,false,0,true);
            _oProj.addEventListener(AttackEvent.EVENT_ENEMY_PROJECTILE_ATTACK,onEventToDispatch,false,0,true);
         }
         else
         {
            _oProj.addEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onEventToDispatch,false,0,true);
            _oProj.addEventListener(AttackEvent.EVENT_PLAYER_PROJECTILE_ATTACK,onEventToDispatch,false,0,true);
         }
      }
      
      private function listenToPuzzleTile(_oPuzzleTile:IEventDispatcher) : void
      {
         _oPuzzleTile.addEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onEventToDispatch,false,0,true);
         _oPuzzleTile.addEventListener(MapGenerateEvent.EVENT_DESTROY_PUZZLE_NODE,onPuzzleTileDestroy,false,0,true);
      }
      
      private function onPuzzleTileCreation(_e:MapGenerateEvent) : void
      {
         listenToPuzzleTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onFixedTileDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToFixedTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToSquidward(_oChara:IEventDispatcher) : void
      {
         _oChara.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onEventToDispatch);
         _oChara.removeEventListener(MapGenerateEvent.EVENT_DESTROY_SQUIDWARD,onSquidwardDestroy);
      }
      
      private function onMovingBlockDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToMovingBlock(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function listenToTextBox(_oTextBox:IEventDispatcher) : void
      {
         _oTextBox.addEventListener(TextboxEvent.EVENT_OPEN_TEXTBOX,onOpenIngamePopup,false,0,true);
         _oTextBox.addEventListener(TextboxEvent.EVENT_CLOSE_TEXTBOX,onCloseIngamePopup,false,0,true);
      }
      
      private function onPatrickDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToPatrick(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onIntroTileDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToIntroTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onPlayerHitted(_e:HurtEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onChestCreation(_e:MapGenerateEvent) : void
      {
         listenToChest(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function addLevel() : void
      {
         trace("Game : addLevel");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_LEVEL);
         oLevel = new Level(_dpLayer);
         oLevel.addEventListener(LevelEvent.EVENT_CREATE_MAP,onMapCreation,false,0,true);
         oLevel.addEventListener(LevelEvent.EVENT_FINISH_MAP_CREATION,onMapCreated,false,0,true);
      }
      
      private function stopListenToOutdoorDoor(_oDoor:IEventDispatcher) : void
      {
         _oDoor.removeEventListener(DoorEvent.EVENT_UNLOCK_OUTDOOR_DOOR,onEventToDispatch);
         _oDoor.removeEventListener(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,onEventToDispatch);
         _oDoor.removeEventListener(DoorEvent.EVENT_IN_OUTDOOR_DOOR,onOutdoorEntered);
         _oDoor.removeEventListener(DoorEvent.EVENT_ENTERING_OUTDOOR_DOOR,onEventToDispatch);
         _oDoor.removeEventListener(MapGenerateEvent.EVENT_DESTROY_OUTDOOR_DOOR,onOutdoorDoorDestroy);
      }
      
      public function stopListenToSave(_oPopup:IEventDispatcher) : void
      {
         _oPopup.removeEventListener(SavePopupEvent.EVENT_OPEN_POPUP_SAVE,onOpenIngamePopup);
         _oPopup.removeEventListener(SavePopupEvent.EVENT_CLOSE_POPUP_SAVE,onCloseIngamePopup);
      }
      
      private function listenToBreakableProp(_oProp:IEventDispatcher) : void
      {
         _oProp.addEventListener(MapGenerateEvent.EVENT_DESTROY_BREAKABLE_PROP,onBreakablePropDestroy,false,0,true);
         _oProp.addEventListener(DropItemEvent.EVENT_DROP_ITEM,onEventToDispatch,false,0,true);
      }
      
      private function onOutdoorDoorCreation(_e:MapGenerateEvent) : void
      {
         listenToOutdoorDoor(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onSquidwardDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToSquidward(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onEventToDispatch(_e:Event) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      public function listenToStory(_oPopup:IEventDispatcher) : void
      {
         _oPopup.addEventListener(StoryPopupEvent.EVENT_OPEN_POPUP_STORY,onOpenIngamePopup,false,0,true);
         _oPopup.addEventListener(StoryPopupEvent.EVENT_CLOSE_POPUP_STORY,onCloseIngamePopup,false,0,true);
      }
      
      public function initObject() : void
      {
         addHUD();
         addPlayer();
         addTransitionFocus();
         addLevel();
      }
      
      private function stopListenToMovingBlock(_oMovingBlock:IEventDispatcher) : void
      {
         _oMovingBlock.removeEventListener(MapGenerateEvent.EVENT_DESTROY_MOVING_BLOCK,onMovingBlockDestroy);
      }
      
      private function onPickingUp(_e:ItemEvent) : void
      {
         if(!Tools.isItemInArray(Data.aITEMS_WITHOUT_EFFECT,_e.itemId))
         {
            doPauseButRenderPlayer();
         }
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onMovingBlockCreation(_e:MapGenerateEvent) : void
      {
         listenToMovingBlock(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToIndoorDoor(_oDoor:IEventDispatcher) : void
      {
         _oDoor.removeEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR,onEventToDispatch);
         _oDoor.removeEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR_FROM_OTHER_SIDE,onEventToDispatch);
         _oDoor.removeEventListener(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,onEventToDispatch);
         _oDoor.removeEventListener(MapGenerateEvent.EVENT_DESTROY_INDOOR_DOOR,onIndoorDoorDestroy);
      }
      
      private function onActionButton(_e:PlayerEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      private function listenToKrab(_oChara:IEventDispatcher) : void
      {
         _oChara.addEventListener(MapGenerateEvent.EVENT_DESTROY_KRAB,onKrabDestroy,false,0,true);
      }
      
      public function doPauseButRenderPlayer() : void
      {
         if(!bPaused)
         {
            oGameDisp.dispatchPause();
            bPaused = true;
         }
      }
      
      private function onSquidwardCreation(_e:MapGenerateEvent) : void
      {
         listenToSquidward(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function stopListenToStory(_oPopup:IEventDispatcher) : void
      {
         _oPopup.removeEventListener(StoryPopupEvent.EVENT_OPEN_POPUP_STORY,onOpenIngamePopup);
         _oPopup.removeEventListener(StoryPopupEvent.EVENT_CLOSE_POPUP_STORY,onCloseIngamePopup);
      }
      
      private function onTransitionFocusBlackOut(_e:TransitionFocusEvent) : void
      {
         doDestroy();
         oGameDisp.dispatchEvent(_e);
      }
      
      private function addHUD() : void
      {
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_HUD);
         var _mcHUD:MovieClip = new mcHUD();
         _dpLayer.addChild(_mcHUD);
         oHud = new Hud(_mcHUD,oGameDisp);
      }
      
      private function listenToChest(_oChest:IEventDispatcher) : void
      {
         _oChest.addEventListener(ChestEvent.EVENT_UNLOCK_CHEST,onEventToDispatch,false,0,true);
         _oChest.addEventListener(DropItemEvent.EVENT_FOUND_ITEM_IN_CHEST,onEventToDispatch,false,0,true);
         _oChest.addEventListener(MapGenerateEvent.EVENT_DESTROY_CHEST,onChestDestroy,false,0,true);
      }
      
      public function doResume() : void
      {
         trace("********************************************* do resume");
         if(bPaused)
         {
            bPaused = false;
            oGameDisp.dispatchResume();
         }
         if(oGameDisp.isPlayerPaused())
         {
            oGameDisp.dispatchPlayerResume();
         }
      }
      
      private function onOutdoorEntered(_e:DoorEvent) : void
      {
         var _mcPlayer:MovieClip = oPlayer.getMC();
         var _oPos:Point = _mcPlayer.localToGlobal(new Point(0,0));
         if(_oPos != null)
         {
            oTransitionFocus.focusAt(_oPos.x,_oPos.y);
         }
         doPause();
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToChest(_oChest:IEventDispatcher) : void
      {
         _oChest.removeEventListener(ChestEvent.EVENT_UNLOCK_CHEST,onEventToDispatch);
         _oChest.removeEventListener(DropItemEvent.EVENT_FOUND_ITEM_IN_CHEST,onEventToDispatch);
         _oChest.removeEventListener(MapGenerateEvent.EVENT_DESTROY_CHEST,onChestDestroy);
      }
      
      private function stopListenToPatrick(_oChara:IEventDispatcher) : void
      {
         _oChara.removeEventListener(MapGenerateEvent.EVENT_DESTROY_PATRICK,onPatrickDestroy);
      }
      
      private function addTransitionFocus() : void
      {
         trace("Game : addTransitionFocus");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_TRANSITION_FOCUS);
         var _mcRef:MovieClip = new mcTransitionFocus();
         _dpLayer.addChild(_mcRef);
         oTransitionFocus = new TransitionFocus(_mcRef);
         oTransitionFocus.addEventListener(TransitionFocusEvent.EVENT_TRANSITION_MIDDLE,onTransitionFocusBlackOut,false,1,true);
         oTransitionFocus.addEventListener(TransitionFocusEvent.EVENT_TRANSITION_COMPLETED,onTransitionFocusCompleted,false,0,true);
      }
      
      public function loseGame() : void
      {
         doDestroy();
      }
      
      private function onTutorialTile(_e:RoomEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToKrab(_oChara:IEventDispatcher) : void
      {
         _oChara.removeEventListener(MapGenerateEvent.EVENT_DESTROY_KRAB,onKrabDestroy);
      }
      
      private function listenToProfile(_oProfile:Profile) : void
      {
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_HEALTH_CONTAINER,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_HEALTH,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_PEEBLE,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_SCORE,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_KEY,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_PRIMARYWEAPON,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_SECONDARYWEAPON,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_GET_ITEM,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_GET_NEW_ITEM,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_SEA_URCHIN_NUM,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_VOLCANIC_URCHIN_NUM,onEventToDispatch);
         _oProfile.addWeakEventListener(ProfileEvent.EVENT_UPDATE_BOTTLE_NUM,onEventToDispatch);
      }
      
      private function onTutorialTileCreation(_e:MapGenerateEvent) : void
      {
         listenToTutorialTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onProjectileDestroy(_e:ProjectileEvent) : void
      {
         var _oProj:IEventDispatcher = _e.projectile as IEventDispatcher;
         stopListenProjectile(_oProj);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onKrabDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToKrab(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListeningToEnemy(_oEn:Enemy) : void
      {
         _oEn.removeEventListener(HurtEvent.EVENT_ENEMY_HITTED,onEnemyHitted);
         _oEn.removeEventListener(HurtEvent.EVENT_ENEMY_DIE,onEnemyDie);
         _oEn.removeEventListener(MapGenerateEvent.EVENT_DESTROY_ENEMY,onEventToDispatch);
         _oEn.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onEventToDispatch);
         _oEn.removeEventListener(MovingBodyEvent.EVENT_ENEMY_HIT_MOVING_PLAYER,onEventToDispatch);
         _oEn.removeEventListener(AttackEvent.EVENT_ENEMY_ATTACK,onEventToDispatch);
         _oEn.removeEventListener(DropItemEvent.EVENT_DROP_ITEM,onEventToDispatch);
         _oEn.removeEventListener(ThrowEvent.EVENT_ENEMY_THROW_PROJECTILE,onEventToDispatch);
         trace("#### stop listening to enemy : ",_oEn);
      }
      
      public function listenToShop(_oShop:IEventDispatcher) : void
      {
         _oShop.addEventListener(ShopPopupEvent.EVENT_OPEN_POPUP_SHOP,onOpenIngamePopup,false,0,true);
         _oShop.addEventListener(ShopPopupEvent.EVENT_CLOSE_POPUP_SHOP,onCloseIngamePopup,false,0,true);
      }
      
      private function onFloorItemDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToFloorItem(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function listenToFloorItem(_oItem:IEventDispatcher) : void
      {
         _oItem.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onPickingUp,false,0,true);
         _oItem.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,onPickingUp,false,0,true);
         _oItem.addEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_WITH_BOOMERANG,onEventToDispatch,false,0,true);
         _oItem.addEventListener(MapGenerateEvent.EVENT_DESTROY_FLOOR_ITEM,onFloorItemDestroy,false,0,true);
      }
      
      private function listenToIntroTile(_oTile:IEventDispatcher) : void
      {
         _oTile.addEventListener(RoomEvent.EVENT_ROOM_INTRO_TILE,onEventToDispatch,false,0,true);
         _oTile.addEventListener(MapGenerateEvent.EVENT_DESTROY_INTRO_NODE,onIntroTileDestroy,false,0,true);
      }
      
      private function onPlayerDie(_e:HurtEvent) : void
      {
         var _mcPlayer:MovieClip = oPlayer.getMC();
         var _oPos:Point = _mcPlayer.localToGlobal(new Point(0,0));
         oTransitionFocus.focusAt(_oPos.x,_oPos.y);
         var _mcPlay:MovieClip = oPlayer.getMC();
         oLevel.map.disableCameraOnPlayer();
         Hud.disable();
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_OVERLAY);
         oPlayer.setPosition(_oPos.x,_oPos.y);
         _dpLayer.addChild(_mcPlay);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function listenToFixedTile(_oO:IEventDispatcher) : void
      {
         _oO.addEventListener(MapGenerateEvent.EVENT_DESTROY_FIXED_OBJECT,onFixedTileDestroy,false,0,true);
      }
      
      private function listenToOutdoorDoor(_oDoor:IEventDispatcher) : void
      {
         _oDoor.addEventListener(DoorEvent.EVENT_UNLOCK_OUTDOOR_DOOR,onEventToDispatch);
         _oDoor.addEventListener(DoorEvent.EVENT_IN_OUTDOOR_DOOR,onOutdoorEntered);
         _oDoor.addEventListener(DoorEvent.EVENT_ENTERING_OUTDOOR_DOOR,onEventToDispatch);
         _oDoor.addEventListener(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,onEventToDispatch,false,0,true);
         _oDoor.addEventListener(MapGenerateEvent.EVENT_DESTROY_OUTDOOR_DOOR,onOutdoorDoorDestroy);
      }
      
      private function update(_e:Event) : void
      {
         if(!bPaused)
         {
            oGameDisp.dispatchUpdate();
         }
         if(!oGameDisp.isPlayerPaused())
         {
            oGameDisp.dispatchPlayerUpdate();
         }
      }
      
      private function onOpenIngamePopup(_e:Event) : void
      {
         trace("PAUSE GAME");
         doPause();
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onTutorialTileDestroy(_e:MapGenerateEvent) : void
      {
         stopListenToTutorialTile(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onEnemyDestroy(_e:MapGenerateEvent) : void
      {
         var _oEn:Enemy = _e.instance as Enemy;
         stopListeningToEnemy(_oEn);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onSandyCreation(_e:MapGenerateEvent) : void
      {
         listenToSandy(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenToIntroTile(_oTile:IEventDispatcher) : void
      {
         _oTile.removeEventListener(RoomEvent.EVENT_ROOM_INTRO_TILE,onEventToDispatch);
         _oTile.removeEventListener(MapGenerateEvent.EVENT_DESTROY_INTRO_NODE,onIntroTileDestroy);
      }
      
      private function onEnemyDie(_e:HurtEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      public function onBuyItem(_e:ShopTransactEvent) : void
      {
         onEventToDispatch(_e);
      }
      
      private function stopListenToFloorItem(_oItem:IEventDispatcher) : void
      {
         _oItem.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM,onEventToDispatch);
         _oItem.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_FROM_CHEST,onEventToDispatch);
         _oItem.removeEventListener(ItemEvent.EVENT_PICKING_UP_ITEM_WITH_BOOMERANG,onEventToDispatch);
         _oItem.removeEventListener(MapGenerateEvent.EVENT_DESTROY_FLOOR_ITEM,onFloorItemDestroy);
      }
      
      private function listenToMovingBlock(_oMovingBlock:IEventDispatcher) : void
      {
         _oMovingBlock.addEventListener(MapGenerateEvent.EVENT_DESTROY_MOVING_BLOCK,onMovingBlockDestroy,false,0,true);
      }
      
      private function stopListenToFixedTile(_oO:IEventDispatcher) : void
      {
         _oO.removeEventListener(MapGenerateEvent.EVENT_DESTROY_FIXED_OBJECT,onFixedTileDestroy);
      }
      
      private function onIndoorDoorCreation(_e:MapGenerateEvent) : void
      {
         listenToIndoorDoor(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function stopListenToShop(_oShop:IEventDispatcher) : void
      {
         _oShop.removeEventListener(ShopPopupEvent.EVENT_OPEN_POPUP_SHOP,onOpenIngamePopup);
         _oShop.removeEventListener(ShopPopupEvent.EVENT_CLOSE_POPUP_SHOP,onCloseIngamePopup);
      }
      
      private function addPlayer() : void
      {
         var _mcPlayer:MovieClip = new mcPlayer();
         oPlayer = new Player(_mcPlayer);
         oPlayer.addWeakEventListener(AttackEvent.EVENT_PLAYER_ATTACK,onPlayerAttack);
         oPlayer.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionButton);
         oPlayer.addWeakEventListener(HurtEvent.EVENT_PLAYER_DIE,onPlayerDie);
         oPlayer.addWeakEventListener(HurtEvent.EVENT_PLAYER_HITTED,onPlayerHitted);
         oPlayer.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_FINISH_DIE_ANIM,onPlayerFinishDie);
         oPlayer.addWeakEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onEventToDispatch);
         oPlayer.addWeakEventListener(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,onEventToDispatch);
         oPlayer.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_ITEM,onFinishedShowingItem);
         oPlayer.addWeakEventListener(ItemEvent.EVENT_FINISH_SHOWING_NEW_ITEM,onFinishedShowingItem);
      }
      
      private function listenToIndoorDoor(_oDoor:IEventDispatcher) : void
      {
         _oDoor.addEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR,onEventToDispatch,false,0,true);
         _oDoor.addEventListener(DoorEvent.EVENT_UNLOCK_INDOOR_DOOR_FROM_OTHER_SIDE,onEventToDispatch,false,0,true);
         _oDoor.addEventListener(DoorEvent.EVENT_OPEN_DOOR_TO_CLEAR,onEventToDispatch,false,0,true);
         _oDoor.addEventListener(MapGenerateEvent.EVENT_DESTROY_INDOOR_DOOR,onIndoorDoorDestroy,false,0,true);
      }
      
      private function onEnemyCreation(_e:MapGenerateEvent) : void
      {
         var _oEnn:Enemy = _e.instance as Enemy;
         listenToEnemy(_oEnn);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function listenToInventory(_oPopup:IEventDispatcher) : void
      {
         _oPopup.addEventListener(InventoryPopupEvent.EVENT_OPEN_POPUP_INVENTORY,onOpenIngamePopup,false,0,true);
         _oPopup.addEventListener(InventoryPopupEvent.EVENT_CLOSE_POPUP_INVENTORY,onCloseIngamePopup,false,0,true);
      }
      
      private function listenToTutorialTile(_oTile:IEventDispatcher) : void
      {
         _oTile.addEventListener(RoomEvent.EVENT_ROOM_TUTORIAL_TILE,onTutorialTile,false,0,true);
         _oTile.addEventListener(MapGenerateEvent.EVENT_DESTROY_TUTORIAL_NODE,onTutorialTileDestroy,false,0,true);
      }
      
      public function doDestroy() : void
      {
         oGameDisp.dispatchDestroy();
      }
      
      private function onEnemyHitted(_e:HurtEvent) : void
      {
         oGameDisp.dispatchEvent(_e);
      }
      
      private function stopListenBreakableProp(_oProp:IEventDispatcher) : void
      {
         _oProp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_BREAKABLE_PROP,onBreakablePropDestroy);
         _oProp.removeEventListener(DropItemEvent.EVENT_DROP_ITEM,onEventToDispatch);
      }
      
      private function stopListenToPuzzleTile(_oPuzzleTile:IEventDispatcher) : void
      {
         _oPuzzleTile.removeEventListener(RoomEvent.EVENT_ROOM_PUZZLE_SOLVED,onEventToDispatch);
         _oPuzzleTile.removeEventListener(MapGenerateEvent.EVENT_DESTROY_PUZZLE_NODE,onPuzzleTileDestroy);
      }
      
      public function isPaused() : Boolean
      {
         return bPaused;
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Game Destroyed");
         doDestroy();
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         stopListenToProfile(Profile.Instance);
         Profile.Instance.removeListeners();
         oDepthManager.destroy();
         oDepthManager = null;
         oPlayer = null;
         oHud = null;
         oLevel = null;
         oTransitionFocus = null;
         mcRef = null;
      }
      
      private function onMapCreation(_e:LevelEvent) : void
      {
         trace("Game : onMapCreation");
         var _oMap:Map = _e.map;
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_ENEMY,onEnemyCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_INTRO_NODE,onIntroTileCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_TUTORIAL_NODE,onTutorialTileCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_FLOOR_ITEM,onFloorItemCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_FIXED_OBJECT,onFixedTileCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_BREAKABLE_PROP,onBreakablePropCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_INDOOR_DOOR,onIndoorDoorCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_OUTDOOR_DOOR,onOutdoorDoorCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_CHEST,onChestCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_MOVING_BLOCK,onMovingBlockCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_PUZZLE_NODE,onPuzzleTileCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_PATRICK,onPatrickCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_SANDY,onSandyCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_SQUIDWARD,onSquidwardCreation);
         _oMap.addWeakEventListener(MapGenerateEvent.EVENT_CREATE_KRAB,onKrabCreation);
         _oMap.addWeakEventListener(CameraEvent.EVENT_CAMERA_MOVE,onEventToDispatch);
         oGameDisp.dispatchEvent(_e);
      }
      
      private function onBreakablePropDestroy(_e:MapGenerateEvent) : void
      {
         trace("Game : breakable destroy");
         stopListenBreakableProp(_e.instance as IEventDispatcher);
         oGameDisp.dispatchEvent(_e);
      }
      
      public function stopListenToInventory(_oPopup:IEventDispatcher) : void
      {
         _oPopup.removeEventListener(InventoryPopupEvent.EVENT_OPEN_POPUP_INVENTORY,onOpenIngamePopup);
         _oPopup.removeEventListener(InventoryPopupEvent.EVENT_CLOSE_POPUP_INVENTORY,onCloseIngamePopup);
      }
   }
}
