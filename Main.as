package
{
   import builder.LevelBuilder;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import gameplay.Game;
   import library.basic.Screen;
   import library.basic.Transition;
   import library.events.MainEvent;
   import library.events.TransitionEvent;
   import library.sounds.SoundItem;
   import library.sounds.SoundManager;
   import library.utils.DepthManager;
   import popups.PopupBlocker;
   import popups.PopupDelete;
   import popups.PopupHS;
   import popups.PopupHSTitle;
   import popups.PopupHelp;
   import popups.PopupInventory;
   import popups.PopupLose;
   import popups.PopupMenu;
   import popups.PopupProfile;
   import popups.PopupQuit;
   import popups.PopupSave;
   import popups.PopupSaveConfirm;
   import popups.PopupShop;
   import popups.PopupStory;
   import popups.PopupTextbox;
   import screens.TitleScreen;
   import screens.WinScreen;
   
   public class Main extends Sprite
   {
      
      public static const sPOPUP_SAVE:String = "save";
      
      public static const sSTATE_LOADED:String = "loaded";
      
      public static const sPOPUP_HS_TITLE:String = "highscoreTitle";
      
      public static const sPOPUP_STORY:String = "story";
      
      public static const sPOPUP_HS:String = "highscore";
      
      public static const sDEPTH_SNAPSHOT:String = "snapshot";
      
      public static const sSTATE_TITLE:String = "title";
      
      public static const sPOPUP_TEXTBOX:String = "textbox";
      
      public static const sSTATE_BUILDER:String = "builder";
      
      public static const sPOPUP_LOSE:String = "lose";
      
      public static const sDEPTH_POPUP:String = "popup";
      
      public static const sPOPUP_BLOCKER:String = "blocker";
      
      private static var oInstance:Main;
      
      public static const sPOPUP_DELETE:String = "delete";
      
      public static const sSTATE_GAME:String = "game";
      
      public static const sDEPTH_BORDER:String = "border";
      
      public static const sPOPUP_PROFILE:String = "profile";
      
      public static const sPOPUP_HELP:String = "help";
      
      public static const bSTAND_ALONE:Boolean = false;
      
      public static const sPOPUP_QUIT:String = "quit";
      
      public static const sDEPTH_LOGIN:String = "login";
      
      public static const sSTATE_WIN:String = "win";
      
      public static const sDEPTH_TRANSITION:String = "transition";
      
      public static const sPOPUP_MENU:String = "menu";
      
      public static const sPOPUP_SAVE_CONFIRM:String = "saveConfirm";
      
      public static const sDEPTH_SCREEN:String = "screen";
      
      public static const sPOPUP_SHOP:String = "shop";
      
      public static const sPOPUP_INVENTORY:String = "inventory";
       
      
      private var oGame:Game;
      
      private var oMusicBoss:SoundItem;
      
      private var oPopupDelete:PopupDelete;
      
      public var oNickServices:NickServices;
      
      private var oPopupShop:PopupShop;
      
      private var sStateTransit:String;
      
      private var oPopupSave:PopupSave;
      
      private var oTransition:Transition;
      
      private var oBuilder:LevelBuilder;
      
      private var oMusicPack:SoundItem;
      
      private var oPopupLose:PopupLose;
      
      private var oScreen:Screen;
      
      private var oPopupBlocker:PopupBlocker;
      
      private var oPopupTextbox:PopupTextbox;
      
      private var oPopupSaveConfirm:PopupSaveConfirm;
      
      private var oMusicInGame:SoundItem;
      
      private var oPopupHS:PopupHS;
      
      private var oSnapshot:Bitmap;
      
      private var oPopupInventory:PopupInventory;
      
      private var oMusicDungeon:SoundItem;
      
      private var oPopupHelp:PopupHelp;
      
      private var oPopupQuit:PopupQuit;
      
      private var sState:String;
      
      private var oPopupHSTitle:PopupHSTitle;
      
      private var oPopupProfile:PopupProfile;
      
      public var oDepthManager:DepthManager;
      
      private var oPopupMenu:PopupMenu;
      
      private var oPopupStory:PopupStory;
      
      public function Main()
      {
         super();
         oInstance = this;
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage,false,0,true);
         addEventListener(Event.ENTER_FRAME,update,false,0,true);
         addEventListener(Event.UNLOAD,unload,false,0,true);
      }
      
      public static function get instance() : Main
      {
         return oInstance;
      }
      
      public function addPopup(_sID:String) : void
      {
         var _mcPopup:MovieClip = null;
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_POPUP);
         switch(_sID)
         {
            case sPOPUP_PROFILE:
               _mcPopup = new mcPopupProfile();
               oPopupProfile = new PopupProfile(_mcPopup);
               break;
            case sPOPUP_DELETE:
               _mcPopup = new mcPopupDelete();
               oPopupDelete = new PopupDelete(_mcPopup);
               break;
            case sPOPUP_HS:
               _mcPopup = new mcPopupHS();
               oPopupHS = new PopupHS(_mcPopup);
               break;
            case sPOPUP_HS_TITLE:
               _mcPopup = new mcPopupHSTitle();
               oPopupHSTitle = new PopupHSTitle(_mcPopup);
               break;
            case sPOPUP_MENU:
               _mcPopup = new mcPopupMenu();
               oPopupMenu = new PopupMenu(_mcPopup);
               break;
            case sPOPUP_HELP:
               _mcPopup = new mcPopupHelp();
               oPopupHelp = new PopupHelp(_mcPopup);
               break;
            case sPOPUP_QUIT:
               _mcPopup = new mcPopupQuit();
               oPopupQuit = new PopupQuit(_mcPopup);
               break;
            case sPOPUP_TEXTBOX:
               _mcPopup = new mcPopupTextbox();
               oPopupTextbox = new PopupTextbox(_mcPopup);
               break;
            case sPOPUP_INVENTORY:
               _mcPopup = new mcPopupInventory();
               oPopupInventory = new PopupInventory(_mcPopup);
               break;
            case sPOPUP_SHOP:
               _mcPopup = new mcPopupShop();
               oPopupShop = new PopupShop(_mcPopup);
               break;
            case sPOPUP_BLOCKER:
               _mcPopup = new mcPopupBlocker();
               oPopupBlocker = new PopupBlocker(_mcPopup);
               break;
            case sPOPUP_SAVE:
               _mcPopup = new mcPopupSave();
               oPopupSave = new PopupSave(_mcPopup);
               break;
            case sPOPUP_SAVE_CONFIRM:
               _mcPopup = new mcPopupSaveConfirm();
               oPopupSaveConfirm = new PopupSaveConfirm(_mcPopup);
               break;
            case sPOPUP_STORY:
               _mcPopup = new mcPopupStory();
               oPopupStory = new PopupStory(_mcPopup);
               break;
            case sPOPUP_LOSE:
               _mcPopup = new mcPopupLose();
               oPopupLose = new PopupLose(_mcPopup);
         }
         _dpLayer.addChild(_mcPopup);
      }
      
      public function get popupHelp() : PopupHelp
      {
         return oPopupHelp;
      }
      
      private function unload(_e:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,update,false);
         removeEventListener(Event.UNLOAD,unload,false);
         dispatchEvent(new MainEvent(MainEvent.EVENT_DESTROY,false,false));
         oDepthManager.destroy(null);
         oDepthManager = null;
         oPopupDelete = null;
         oPopupProfile = null;
         oPopupHS = null;
         oPopupHSTitle = null;
         oPopupMenu = null;
         oPopupHelp = null;
         oPopupQuit = null;
         oPopupTextbox = null;
         oPopupInventory = null;
         oPopupShop = null;
         oPopupBlocker = null;
         oPopupSave = null;
         oPopupSaveConfirm = null;
         oPopupStory = null;
         oPopupLose = null;
         oNickServices = null;
         oTransition = null;
         oScreen = null;
         oGame = null;
      }
      
      public function removePopup(_oPopup:Object) : void
      {
         if(_oPopup != null)
         {
            switch(_oPopup)
            {
               case oPopupProfile:
                  trace("Remove popup: Profile");
                  if(oPopupProfile != null)
                  {
                     oPopupProfile.destroy(null);
                  }
                  oPopupProfile = null;
                  break;
               case oPopupDelete:
                  trace("Remove popup: Delete");
                  if(oPopupDelete != null)
                  {
                     oPopupDelete.destroy(null);
                  }
                  oPopupDelete = null;
                  break;
               case oPopupHS:
                  trace("Remove popup: PopupHS");
                  if(oPopupHS != null)
                  {
                     oPopupHS.destroy(null);
                  }
                  oPopupHS = null;
                  break;
               case oPopupHSTitle:
                  trace("Remove popup: PopupHSTitle");
                  if(oPopupHSTitle != null)
                  {
                     oPopupHSTitle.destroy(null);
                  }
                  oPopupHSTitle = null;
                  break;
               case oPopupMenu:
                  trace("Remove popup: Menu");
                  if(oPopupMenu != null)
                  {
                     oPopupMenu.destroy(null);
                  }
                  oPopupMenu = null;
                  break;
               case oPopupHelp:
                  trace("Remove popup: Help");
                  if(oPopupHelp != null)
                  {
                     oPopupHelp.destroy(null);
                  }
                  oPopupHelp = null;
                  break;
               case oPopupQuit:
                  trace("Remove popup: Quit");
                  if(oPopupQuit != null)
                  {
                     oPopupQuit.destroy(null);
                  }
                  oPopupQuit = null;
                  break;
               case oPopupTextbox:
                  trace("Remove popup: Textbox");
                  if(oPopupTextbox != null)
                  {
                     oPopupTextbox.destroy(null);
                  }
                  oPopupTextbox = null;
                  break;
               case oPopupInventory:
                  trace("Remove popup: Inventory");
                  if(oPopupInventory != null)
                  {
                     oPopupInventory.destroy(null);
                  }
                  oPopupInventory = null;
                  break;
               case oPopupShop:
                  trace("Remove popup: Shop");
                  if(oPopupShop != null)
                  {
                     oPopupShop.destroy(null);
                  }
                  oPopupShop = null;
                  break;
               case oPopupBlocker:
                  trace("Remove popup: Blocker");
                  if(oPopupBlocker != null)
                  {
                     oPopupBlocker.destroy(null);
                  }
                  oPopupBlocker = null;
                  break;
               case oPopupSave:
                  trace("Remove popup: Save");
                  if(oPopupSave != null)
                  {
                     oPopupSave.destroy(null);
                  }
                  oPopupSave = null;
                  break;
               case oPopupSaveConfirm:
                  trace("Remove popup: Save Confirm");
                  if(oPopupSaveConfirm != null)
                  {
                     oPopupSaveConfirm.destroy(null);
                  }
                  oPopupSaveConfirm = null;
                  break;
               case oPopupStory:
                  trace("Remove popup: Story");
                  if(oPopupStory != null)
                  {
                     oPopupStory.destroy(null);
                  }
                  oPopupStory = null;
                  break;
               case oPopupLose:
                  trace("Remove popup: Lose");
                  if(oPopupLose != null)
                  {
                     oPopupLose.destroy(null);
                  }
                  oPopupLose = null;
            }
         }
      }
      
      public function switchToPackagingMusic() : void
      {
         if(SoundManager.isSoundPlaying(Data.sMUSIC_PACKAGING).bPlaying == false)
         {
            oMusicPack = SoundManager.playSoundInCat(Data.sCATEGORY_MUSIC_LINKAGE,Data.sMUSIC_PACKAGING,0,9999,false);
            oMusicPack.setFadeRate(0.05);
            oMusicPack.fadeTo(1,false);
         }
         fadeOutMusic(oMusicInGame);
         fadeOutMusic(oMusicDungeon);
         fadeOutMusic(oMusicBoss);
      }
      
      public function get state() : String
      {
         return sState;
      }
      
      public function get builderManager() : LevelBuilder
      {
         return oBuilder;
      }
      
      public function get popupQuit() : PopupQuit
      {
         return oPopupQuit;
      }
      
      public function lose(_oPic:BitmapData) : void
      {
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_SNAPSHOT);
         oSnapshot = new Bitmap(_oPic,"auto",false);
         _dpLayer.addChild(oSnapshot);
         oGame.destroy();
         oGame = null;
         addPopup(sPOPUP_LOSE);
      }
      
      public function get popupInventory() : PopupInventory
      {
         return oPopupInventory;
      }
      
      private function onAddedToStage(_e:Event) : void
      {
         oDepthManager = new DepthManager();
         oDepthManager.addDepthLayer(sDEPTH_SCREEN,this);
         oDepthManager.addDepthLayer(sDEPTH_SNAPSHOT,this);
         oDepthManager.addDepthLayer(sDEPTH_POPUP,this);
         oDepthManager.addDepthLayer(sDEPTH_TRANSITION,this);
         oDepthManager.addDepthLayer(sDEPTH_BORDER,this);
         oDepthManager.addDepthLayer(sDEPTH_LOGIN,this);
         oNickServices = new NickServices();
         var _mcRef:Sprite = new Sprite();
         addChild(_mcRef);
         SoundManager.init(_mcRef);
         SoundManager.addCategory(Data.sCATEGORY_MUSIC_LINKAGE,Data.iCATEGORY_MUSIC_VOLUME);
         SoundManager.addCategory(Data.sCATEGORY_SOUND_LINKAGE,Data.iCATEGORY_SOUND_VOLUME);
         oDepthManager.getDepthLayer(sDEPTH_BORDER).addChild(new mcBorder());
         setState(sSTATE_LOADED);
         removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage,false);
      }
      
      public function switchToDungeonMusic() : void
      {
         if(SoundManager.isSoundPlaying(Data.sMUSIC_DUNGEON).bPlaying == false)
         {
            oMusicDungeon = SoundManager.playSoundInCat(Data.sCATEGORY_MUSIC_LINKAGE,Data.sMUSIC_DUNGEON,0,9999,false);
            oMusicDungeon.setFadeRate(0.05);
            oMusicDungeon.fadeTo(1,false);
         }
         fadeOutMusic(oMusicPack);
         fadeOutMusic(oMusicInGame);
         fadeOutMusic(oMusicBoss);
      }
      
      public function switchToBossMusic() : void
      {
         if(SoundManager.isSoundPlaying(Data.sMUSIC_BOSS).bPlaying == false)
         {
            oMusicBoss = SoundManager.playSoundInCat(Data.sCATEGORY_MUSIC_LINKAGE,Data.sMUSIC_BOSS,0,9999,false);
            oMusicBoss.setFadeRate(0.05);
            oMusicBoss.fadeTo(1,false);
         }
         fadeOutMusic(oMusicPack);
         fadeOutMusic(oMusicInGame);
         fadeOutMusic(oMusicDungeon);
      }
      
      public function fadeOutMusic(_oMusic:SoundItem) : void
      {
         if(_oMusic != null)
         {
            _oMusic.setFadeRate(0.05);
            _oMusic.fadeTo(0,true);
         }
      }
      
      public function transitTo(_sNextState:String) : void
      {
         var _dpLayer:DisplayObjectContainer = null;
         var _mcTransition:MovieClip = null;
         if(oTransition == null)
         {
            _dpLayer = oDepthManager.getDepthLayer(sDEPTH_TRANSITION);
            _mcTransition = new mcTransition();
            _dpLayer.addChild(_mcTransition);
            sStateTransit = _sNextState;
            oTransition = new Transition(_mcTransition);
            oTransition.addEventListener(TransitionEvent.EVENT_FULL_SCREEN,onTransitionFull,false,0,true);
            oTransition.addEventListener(TransitionEvent.EVENT_COMPLETE,onTransitionComplete,false,0,true);
         }
      }
      
      public function get popupBlocker() : PopupBlocker
      {
         return oPopupBlocker;
      }
      
      public function get popupHS() : PopupHS
      {
         return oPopupHS;
      }
      
      public function get popupTextbox() : PopupTextbox
      {
         return oPopupTextbox;
      }
      
      public function get popupMenu() : PopupMenu
      {
         return oPopupMenu;
      }
      
      public function get popupShop() : PopupShop
      {
         return oPopupShop;
      }
      
      public function switchToGameMusic() : void
      {
         trace("Pack");
         if(SoundManager.isSoundPlaying(Data.sMUSIC_GAME).bPlaying == false)
         {
            oMusicInGame = SoundManager.playSoundInCat(Data.sCATEGORY_MUSIC_LINKAGE,Data.sMUSIC_GAME,0,9999,false);
            oMusicInGame.setFadeRate(0.05);
            oMusicInGame.fadeTo(1,false);
         }
         fadeOutMusic(oMusicPack);
         fadeOutMusic(oMusicDungeon);
         fadeOutMusic(oMusicBoss);
      }
      
      private function update(_e:Event) : void
      {
         dispatchEvent(new MainEvent(MainEvent.EVENT_UPDATE,false,false));
      }
      
      private function onTransitionFull(_e:Event) : void
      {
         setState(sStateTransit);
         oTransition.removeEventListener(TransitionEvent.EVENT_FULL_SCREEN,onTransitionFull,false);
      }
      
      private function loadState() : void
      {
         var _mcScreen:MovieClip = null;
         trace("===============================");
         trace("LOAD MAIN STATE: " + state);
         switch(state)
         {
            case sSTATE_LOADED:
               addScreen();
               transitTo(sSTATE_TITLE);
               switchToPackagingMusic();
               break;
            case sSTATE_TITLE:
               _mcScreen = addScreen();
               oScreen = new TitleScreen(_mcScreen);
               switchToPackagingMusic();
               break;
            case sSTATE_BUILDER:
               AssetData.initAssetData();
               _mcScreen = addScreen();
               oBuilder = new LevelBuilder(_mcScreen);
               oBuilder.initObject();
               break;
            case sSTATE_GAME:
               AssetData.initAssetData();
               _mcScreen = addScreen();
               startGame();
               break;
            case sSTATE_WIN:
               _mcScreen = addScreen();
               oScreen = new WinScreen(_mcScreen);
               switchToPackagingMusic();
         }
      }
      
      private function onTransitionComplete(_e:Event) : void
      {
         oTransition.destroy(null);
         oTransition.removeEventListener(TransitionEvent.EVENT_COMPLETE,onTransitionComplete,false);
         oTransition = null;
      }
      
      private function unloadState() : void
      {
         switch(state)
         {
            case sSTATE_LOADED:
               break;
            case sSTATE_TITLE:
               break;
            case sSTATE_BUILDER:
               oBuilder.destroy(null);
               oBuilder = null;
               break;
            case sSTATE_GAME:
               oGame.destroy(null);
               oGame = null;
               break;
            case sSTATE_WIN:
         }
         removePopup(oPopupProfile);
         removePopup(oPopupDelete);
         removePopup(oPopupHS);
         removePopup(oPopupHSTitle);
         removePopup(oPopupMenu);
         removePopup(oPopupHelp);
         removePopup(oPopupQuit);
         removePopup(oPopupTextbox);
         removePopup(oPopupInventory);
         removePopup(oPopupShop);
         removePopup(oPopupBlocker);
         removePopup(oPopupSave);
         removePopup(oPopupSaveConfirm);
         removePopup(oPopupStory);
         removePopup(oPopupLose);
         trace("UNLOAD MAIN STATE: " + state);
      }
      
      public function setState(_sNextState:String) : void
      {
         if(_sNextState != state)
         {
            if(state != null)
            {
               unloadState();
            }
            sState = _sNextState;
            loadState();
         }
      }
      
      public function get gameManager() : Game
      {
         return oGame;
      }
      
      public function get popupProfile() : PopupProfile
      {
         return oPopupProfile;
      }
      
      public function get popupHSTitle() : PopupHSTitle
      {
         return oPopupHSTitle;
      }
      
      public function get popupLose() : PopupLose
      {
         return oPopupLose;
      }
      
      private function addScreen() : MovieClip
      {
         var _mcScreen:MovieClip = null;
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_SCREEN);
         if(oScreen != null)
         {
            if(oScreen.mcRef != null)
            {
               _dpLayer.removeChild(oScreen.mcRef);
            }
            oScreen.destroy(null);
            oScreen = null;
         }
         switch(sState)
         {
            case sSTATE_LOADED:
               _mcScreen = new mcScreenLoaded();
               break;
            case sSTATE_TITLE:
               _mcScreen = new mcScreenTitle();
               break;
            case sSTATE_BUILDER:
               _mcScreen = new mcScreenBuilder();
               break;
            case sSTATE_GAME:
               _mcScreen = new mcScreenGame();
               break;
            case sSTATE_WIN:
               _mcScreen = new mcScreenWin();
         }
         _dpLayer.addChild(_mcScreen);
         return _mcScreen;
      }
      
      public function startGame() : void
      {
         var _dpLayer:DisplayObjectContainer = null;
         if(oGame != null)
         {
            return;
         }
         if(oSnapshot != null)
         {
            _dpLayer = oDepthManager.getDepthLayer(sDEPTH_SNAPSHOT);
            _dpLayer.removeChild(oSnapshot);
            oSnapshot = null;
         }
         if(Profile.Instance != null)
         {
            Profile.reloadCurrentProfile();
         }
         var _mcScreen:MovieClip = addScreen();
         oGame = new Game(_mcScreen);
         oGame.initObject();
      }
      
      public function get popupDelete() : PopupDelete
      {
         return oPopupDelete;
      }
   }
}
