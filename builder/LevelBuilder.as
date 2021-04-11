package builder
{
   import builder.events.BuilderEvent;
   import builder.popups.PopupIndoor;
   import builder.popups.PopupOutdoor;
   import builder.popups.PopupPuzzle;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.utils.Base64;
   import library.utils.DepthManager;
   import library.utils.MoreMath;
   import library.utils.Path;
   import mdm.Application;
   import mdm.Dialogs;
   import mdm.FileSystem;
   
   public class LevelBuilder extends EventDispatcher implements Idestroyable
   {
      
      public static const sTOOL_ERASER:String = "erasing";
      
      public static const sPOPUP_PUZZLE:String = "puzzle";
      
      public static const sDEPTH_OBJECTS:String = "object";
      
      public static const sTOOL_MAP:String = "mapping";
      
      public static const sTOOL_ROTATE:String = "rotating";
      
      public static const sTOOL_SCALE_X:String = "Flip Horizontal";
      
      public static const sDEPTH_ENEMIES:String = "enemies";
      
      public static const sPOPUP_INDOOR:String = "indoor";
      
      public static const sDEPTH_POPUP:String = "popups";
      
      public static const sTOOL_SCALE_Y:String = "Flip Vertical";
      
      public static const sDEPTH_CURSOR:String = "cursor";
      
      public static const sTOOL_SELECT:String = "selecting";
      
      public static const sDEPTH_ITEMS:String = "items";
      
      public static const sTOOL_LINK:String = "linking";
      
      public static const sDEPTH_TILES:String = "tiles";
      
      public static const sPOPUP_OUTDOOR:String = "outdoor";
      
      public static const sDEPTH_MISC:String = "misc";
      
      public static const sDEPTH_MAPPING:String = "mapping";
       
      
      private var oLink:Object;
      
      private var sAssetType:String;
      
      private var oPopupPuzzle:PopupPuzzle;
      
      private var mcRef:MovieClip;
      
      private var aPuzzlesData:Array;
      
      private var oSelectionData:Object;
      
      private var aItemsData:Array;
      
      private var oFileReader:FileReader;
      
      private var oPopupIndoor:PopupIndoor;
      
      private var sCurrentTool:String;
      
      private var oLevel:LBLevel;
      
      private var oLoader:URLLoader;
      
      private var aDestructablesData:Array;
      
      private var aDoorsData:Array;
      
      private var oDepthManager:DepthManager;
      
      private var sFileLoaded:String;
      
      public const nZOOM_OUT_VALUE:Number = 0.13333333333333333;
      
      private var sPreviousAsset:String;
      
      private const sERROR_MORE_DOOR_OUTDOOR:String = "There\'s more than 1 outdoor-type door with the index: ";
      
      private var aChestsData:Array;
      
      private var nCurrentZoom:Number;
      
      private var aEventsData:Array;
      
      private var oCursor:LBCursor;
      
      private var oAssetManager:AssetManager;
      
      private var oRoomData:Object;
      
      private var oMapData:Object;
      
      private var oPopupOutdoor:PopupOutdoor;
      
      private var aWandablesData:Array;
      
      private const sERROR_MORE_DOOR_INDOOR:String = "There\'s more than 2 indoor-type door with index: ";
      
      private var aEnemiesData:Array;
      
      private var sAssetBeforeSelection:String;
      
      private var oFileWriter:FileWriter;
      
      private const sERROR_MISS_DOOR_INDOOR:String = "There\'s a indoor-type door without an exit";
      
      public const nZOOM_IN_VALUE:Number = 1;
      
      private var sCurrentLinkType:String;
      
      private var aCharactersData:Array;
      
      public function LevelBuilder(_mcRef:MovieClip)
      {
         super();
         mcRef = _mcRef;
         oDepthManager = new DepthManager();
         oDepthManager.addDepthLayer(sDEPTH_POPUP,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_CURSOR,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_TILES,mcRef.mcLevel);
         oDepthManager.addDepthLayer(sDEPTH_OBJECTS,mcRef.mcLevel);
         oDepthManager.addDepthLayer(sDEPTH_MISC,mcRef.mcLevel);
         oDepthManager.addDepthLayer(sDEPTH_ENEMIES,mcRef.mcLevel);
         oDepthManager.addDepthLayer(sDEPTH_ITEMS,mcRef.mcLevel);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_MISC);
         _dpLayer.filters = [new GlowFilter(10027008,1,10,10,4,1,false,true)];
         oDepthManager.addDepthLayer(sDEPTH_MAPPING,mcRef.mcLevel);
         oLink = null;
         Main.instance.stage.focus = Main.instance.stage;
         Main.instance.stage.addEventListener(FocusEvent.FOCUS_OUT,onLoseFocus,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Builder Destroyed");
         destroyMap();
         dispatchEvent(new BuilderEvent(BuilderEvent.EVENT_DESTROY,false,false));
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         Main.instance.stage.removeEventListener(FocusEvent.FOCUS_OUT,onLoseFocus,false);
         setButton(mcRef.btnTilesMapLv1,true);
         setButton(mcRef.btnTilesMapLv2,true);
         setButton(mcRef.btnTilesMapLv3,true);
         setButton(mcRef.btnTilesLairLv1,true);
         setButton(mcRef.btnTilesLairLv2,true);
         setButton(mcRef.btnTilesLairLv3,true);
         setButton(mcRef.btnObjectsLv1,true);
         setButton(mcRef.btnObjectsLv2,true);
         setButton(mcRef.btnObjectsLv3,true);
         setButton(mcRef.btnDoorsLv1,true);
         setButton(mcRef.btnDoorsLv2,true);
         setButton(mcRef.btnDoorsLv3,true);
         setButton(mcRef.btnCharacters,true);
         setButton(mcRef.btnItems,true);
         setButton(mcRef.btnKeyItems,true);
         setButton(mcRef.btnPuzzle,true);
         setButton(mcRef.btnEnemies,true);
         setButton(mcRef.btnMisc,true);
         setButton(mcRef.btnSave,true);
         setButton(mcRef.btnLoad,true);
         setButton(mcRef.btnZoomIn,true);
         setButton(mcRef.btnZoomOut,true);
         setButton(mcRef.btnToolMap,true);
         setButton(mcRef.btnToolSelect,true);
         setButton(mcRef.btnToolErase,true);
         setButton(mcRef.btnToolRotate,true);
         setButton(mcRef.btnToolLink,true);
         setButton(mcRef.btnToolScaleX,true);
         setButton(mcRef.btnToolScaleY,true);
         oLevel = null;
         oCursor = null;
         oLink = null;
         oSelectionData = null;
         oPopupIndoor = null;
         oPopupOutdoor = null;
         oPopupPuzzle = null;
         oDepthManager.destroy();
         oDepthManager = null;
         mcRef = null;
         oFileReader = null;
         oFileWriter = null;
         oLoader = null;
      }
      
      private function destroyMap() : void
      {
         var _oData:Object = null;
         var c:int = 0;
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         for(var r:int = 0; r < _nRowMax; r++)
         {
            for(c = 0; c < _nColumnMax; c++)
            {
               _oData = getData(AssetData.sTYPE_TILE,c,r);
               destroyMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_OBJECT,c,r);
               destroyMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_CHARACTER,c,r);
               destroyMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_ITEM,c,r);
               destroyMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_MISC,c,r);
               destroyMapAsset(_oData,c,r);
            }
         }
      }
      
      public function get popupPuzzle() : PopupPuzzle
      {
         return oPopupPuzzle;
      }
      
      private function showError(_sError:String) : void
      {
         mcRef.txtError.text = _sError;
      }
      
      public function getDepth(_dpLayer:DisplayObjectContainer, _iC:int, _iR:int) : Number
      {
         var _nIndex:Number = NaN;
         var _nChildC:Number = NaN;
         var _nChildR:Number = NaN;
         var _nChildDepth:Number = NaN;
         var _nDepthByColumn:Number = 1000;
         var _nChildren:Number = _dpLayer.numChildren;
         var _nDepth:Number = -1;
         var _nTargetDepth:Number = _iC + _iR * _nDepthByColumn;
         if(_nChildren > 0)
         {
            for(_nIndex = 0; _nIndex < _nChildren; _nIndex++)
            {
               _nChildC = Math.floor(_dpLayer.getChildAt(_nIndex).x / Data.iTILE_WIDTH);
               _nChildR = Math.floor(_dpLayer.getChildAt(_nIndex).y / Data.iTILE_HEIGHT);
               _nChildDepth = _nChildC + _nChildR * _nDepthByColumn;
               if(_nChildDepth > _nTargetDepth)
               {
                  _nDepth = _nIndex;
                  _nIndex = Number.POSITIVE_INFINITY;
               }
            }
         }
         else
         {
            _nDepth = 0;
         }
         if(_nDepth == -1)
         {
            _nDepth = _nChildren;
         }
         return _nDepth;
      }
      
      private function buildMap() : void
      {
         var _oData:Object = null;
         var c:int = 0;
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         for(var r:int = 0; r < _nRowMax; r++)
         {
            for(c = 0; c < _nColumnMax; c++)
            {
               _oData = getData(AssetData.sTYPE_TILE,c,r);
               buildMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_OBJECT,c,r);
               buildMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_CHARACTER,c,r);
               buildMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_ITEM,c,r);
               buildMapAsset(_oData,c,r);
               _oData = getData(AssetData.sTYPE_MISC,c,r);
               buildMapAsset(_oData,c,r);
            }
         }
      }
      
      private function startContamination(_iLastC:int, _iLastR:int, _uRoomIndex:uint) : void
      {
         var _oData:Object = null;
         var _bContaminated:Boolean = false;
         var _sLinkType:String = null;
         var _iC:int = 0;
         var _iR:int = 0;
         var _aRoomTile:Array = new Array();
         _aRoomTile.push({
            "iC":_iLastC,
            "iR":_iLastR
         });
         while(_aRoomTile.length > 0)
         {
            _oData = new Object();
            _bContaminated = true;
            _sLinkType = "";
            _iC = _aRoomTile[0].iC;
            _iR = _aRoomTile[0].iR;
            if(oRoomData["X" + _aRoomTile[0].iC + "Y" + _aRoomTile[0].iR] == undefined)
            {
               oRoomData["X" + _aRoomTile[0].iC + "Y" + _aRoomTile[0].iR] = _uRoomIndex;
            }
            _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
            if(_oData.sLinkage != null)
            {
               _sLinkType = AssetData.getAssetData(_oData.sLinkage).sLinkType;
               if(_sLinkType == AssetData.sLINK_INDOOR || _sLinkType == AssetData.sLINK_OUTDOOR)
               {
                  _bContaminated = false;
               }
            }
            trace("_bContaminated: " + _bContaminated);
            if(_bContaminated)
            {
               _bContaminated = validContaminatedTile(_iC,_iR - 1);
               if(_bContaminated)
               {
                  _aRoomTile.push({
                     "iC":_iC,
                     "iR":_iR - 1
                  });
                  oRoomData["X" + _iC + "Y" + (_iR - 1)] = _uRoomIndex;
               }
               _bContaminated = validContaminatedTile(_iC + 1,_iR);
               if(_bContaminated)
               {
                  _aRoomTile.push({
                     "iC":_iC + 1,
                     "iR":_iR
                  });
                  oRoomData["X" + (_iC + 1) + "Y" + _iR] = _uRoomIndex;
               }
               _bContaminated = validContaminatedTile(_iC,_iR + 1);
               if(_bContaminated)
               {
                  _aRoomTile.push({
                     "iC":_iC,
                     "iR":_iR + 1
                  });
                  oRoomData["X" + _iC + "Y" + (_iR + 1)] = _uRoomIndex;
               }
               _bContaminated = validContaminatedTile(_iC - 1,_iR);
               if(_bContaminated)
               {
                  _aRoomTile.push({
                     "iC":_iC - 1,
                     "iR":_iR
                  });
                  oRoomData["X" + (_iC - 1) + "Y" + _iR] = _uRoomIndex;
               }
            }
            _aRoomTile.splice(0,1);
         }
         locateRooms(_iLastC,_iLastR,_uRoomIndex);
      }
      
      private function destroyMapAsset(_oData:Object, _nC:int, _nR:int) : void
      {
         var _dpLayer:DisplayObjectContainer = null;
         var _sLinkage:String = null;
         var _sType:String = null;
         _sLinkage = _oData.sLinkage;
         if(_sLinkage == "null")
         {
            _sLinkage = null;
         }
         if(_sLinkage != null)
         {
            _sType = AssetData.getAssetData(_sLinkage).sType;
            _dpLayer = getDepthLayer(_sType);
            _dpLayer.removeChild(_oData.mcRef);
            _oData.mcRef = null;
            _oData.sLinkage = null;
         }
      }
      
      public function locateEvents() : String
      {
         var _sType:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aEventsData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oMisc;
               if(_oData.sLinkage != null)
               {
                  if(AssetData.getAssetData(_oData.sLinkage).sBlocker == AssetData.sBLOCKER_NONE)
                  {
                     aEventsData.push({
                        "iC":_iC,
                        "iR":_iR
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      public function get popupIndoor() : PopupIndoor
      {
         return oPopupIndoor;
      }
      
      private function getData(_sType:String, _iC:int, _iR:int) : Object
      {
         var _oData:Object = null;
         switch(_sType)
         {
            case AssetData.sTYPE_TILE:
               _oData = oMapData["X" + _iC + "Y" + _iR].oTile;
               break;
            case AssetData.sTYPE_OBJECT:
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               break;
            case AssetData.sTYPE_CHARACTER:
               _oData = oMapData["X" + _iC + "Y" + _iR].oCharacter;
               break;
            case AssetData.sTYPE_ITEM:
               _oData = oMapData["X" + _iC + "Y" + _iR].oItem;
               break;
            case AssetData.sTYPE_MISC:
               _oData = oMapData["X" + _iC + "Y" + _iR].oMisc;
         }
         return _oData;
      }
      
      public function setTool(_sTool:String) : void
      {
         sCurrentTool = _sTool;
         mcRef.txtTool.text = sCurrentTool;
         switch(sCurrentTool)
         {
            case sTOOL_MAP:
               oCursor.setState(LBCursor.sSTATE_MAP);
               break;
            case sTOOL_SELECT:
               oCursor.setState(LBCursor.sSTATE_SELECT);
               break;
            case sTOOL_ERASER:
               oCursor.setState(LBCursor.sSTATE_ERASER);
               break;
            case sTOOL_ROTATE:
               oCursor.setState(LBCursor.sSTATE_ROTATE);
               break;
            case sTOOL_LINK:
               oCursor.setState(LBCursor.sSTATE_LINK);
               break;
            case sTOOL_SCALE_X:
               oCursor.setState(LBCursor.sSTATE_SCALE_X);
               break;
            case sTOOL_SCALE_Y:
               oCursor.setState(LBCursor.sSTATE_SCALE_Y);
         }
      }
      
      public function get mappingLayer() : DisplayObjectContainer
      {
         return oDepthManager.getDepthLayer(sDEPTH_MAPPING);
      }
      
      public function setButton(_btnButton:DisplayObject, _bDestroy:Boolean = false) : void
      {
         if(_bDestroy == false)
         {
            _btnButton.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
            _btnButton.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         }
         else
         {
            _btnButton.removeEventListener(MouseEvent.CLICK,onClick,false);
            _btnButton.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
         }
      }
      
      public function locateWandables() : String
      {
         var _sType:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aWandablesData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               if(_oData.sLinkage != null)
               {
                  if(AssetData.getAssetData(_oData.sLinkage).bWandable)
                  {
                     aWandablesData.push({
                        "iC":_iC,
                        "iR":_iR
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      private function getDepthLayer(_sType:String) : DisplayObjectContainer
      {
         var _dpLayer:DisplayObjectContainer = null;
         switch(_sType)
         {
            case AssetData.sTYPE_TILE:
               _dpLayer = oDepthManager.getDepthLayer(sDEPTH_TILES);
               break;
            case AssetData.sTYPE_OBJECT:
               _dpLayer = oDepthManager.getDepthLayer(sDEPTH_OBJECTS);
               break;
            case AssetData.sTYPE_CHARACTER:
               _dpLayer = oDepthManager.getDepthLayer(sDEPTH_ENEMIES);
               break;
            case AssetData.sTYPE_ITEM:
               _dpLayer = oDepthManager.getDepthLayer(sDEPTH_ITEMS);
               break;
            case AssetData.sTYPE_MISC:
               _dpLayer = oDepthManager.getDepthLayer(sDEPTH_MISC);
         }
         return _dpLayer;
      }
      
      public function setLinkData(_sLink:String, _sMap:String) : void
      {
         switch(sCurrentLinkType)
         {
            case AssetData.sLINK_INDOOR:
               oLink.oLinkedMap.sMap = sFileLoaded;
               oLink.oLinkedMap.sDoorLink = _sLink;
               break;
            case AssetData.sLINK_OUTDOOR:
               if(Application.path != null && Application.path != "")
               {
                  Dialogs.prompt(String(FileSystem.fileExists(Data.sFILE_FOLDER_PATH + _sMap + Data.sFILE_EXTENSION)));
                  if(!FileSystem.fileExists(Data.sFILE_FOLDER_PATH + _sMap + Data.sFILE_EXTENSION) && _sMap != null)
                  {
                     oFileWriter.save(_sMap,"");
                  }
               }
               oLink.oLinkedMap.sMap = _sMap;
               oLink.oLinkedMap.sDoorLink = _sLink;
               break;
            case AssetData.sLINK_PUZZLE:
            case AssetData.sLINK_PUZZLE_SLOT:
               oLink.sPuzzleLink = _sLink;
         }
         oLink.mcRef.txtIndex.text = _sLink;
         dispatchEvent(new BuilderEvent(BuilderEvent.EVENT_RESUME,false,false));
      }
      
      public function getLinkData(_nPosX:Number, _nPosY:Number) : void
      {
         var _sType:String = null;
         var _sLinkType:String = null;
         var _oData:Object = null;
         var _iC:Number = Math.floor(_nPosX / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_nPosY / Data.iTILE_HEIGHT);
         getHigherObject(_nPosX,_nPosY);
         _sType = AssetData.getAssetData(asset).sType;
         _sLinkType = AssetData.getAssetData(asset).sLinkType;
         if(_sType == AssetData.sTYPE_OBJECT)
         {
            _oData = getData(_sType,_iC,_iR);
            if(_sLinkType == AssetData.sLINK_INDOOR)
            {
               oLink = _oData;
               sCurrentLinkType = _sLinkType;
               addPopup(sPOPUP_INDOOR);
            }
            else if(_sLinkType == AssetData.sLINK_OUTDOOR)
            {
               oLink = _oData;
               sCurrentLinkType = _sLinkType;
               addPopup(sPOPUP_OUTDOOR);
            }
            else if(_sLinkType == AssetData.sLINK_PUZZLE || _sLinkType == AssetData.sLINK_PUZZLE_SLOT)
            {
               oLink = _oData;
               sCurrentLinkType = _sLinkType;
               addPopup(sPOPUP_PUZZLE);
            }
            dispatchEvent(new BuilderEvent(BuilderEvent.EVENT_PAUSE,false,false));
            asset = sPreviousAsset;
         }
      }
      
      public function locateDestructables() : String
      {
         var _sType:String = null;
         var _sItemLinkage:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aDestructablesData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               if(_oData.sLinkage != null)
               {
                  if(AssetData.getAssetData(_oData.sLinkage).bDestructable)
                  {
                     _sItemLinkage = null;
                     _sItemLinkage = oMapData["X" + _iC + "Y" + _iR].oItem.sLinkage;
                     aDestructablesData.push({
                        "iC":_iC,
                        "iR":_iR,
                        "sItemLinkage":_sItemLinkage
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      public function locateDoors() : String
      {
         var _sType:String = null;
         var _sLinkType:String = null;
         var _sItemLinkage:String = null;
         var _oData:Object = null;
         var _sDoorLink:String = null;
         var _sMap:String = null;
         var i:* = null;
         var o:* = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         var _oDoors:Object = new Object();
         _oDoors[AssetData.sLINK_INDOOR] = new Object();
         _oDoors[AssetData.sLINK_OUTDOOR] = new Object();
         aDoorsData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               if(_oData.sLinkage != null)
               {
                  _sLinkType = AssetData.getAssetData(_oData.sLinkage).sLinkType;
                  if(_sLinkType == AssetData.sLINK_INDOOR)
                  {
                     _sMap = _oData.oLinkedMap.sMap;
                     _sDoorLink = _oData.oLinkedMap.sDoorLink;
                     if(_oDoors[_sLinkType][_sDoorLink] == null)
                     {
                        _oDoors[_sLinkType][_sDoorLink] = new Object();
                        _oDoors[_sLinkType][_sDoorLink].type = _sLinkType;
                        _oDoors[_sLinkType][_sDoorLink].map = _sMap;
                     }
                     if(_oDoors[_sLinkType][_sDoorLink].iC == undefined)
                     {
                        _oDoors[_sLinkType][_sDoorLink].iC = _iC;
                        _oDoors[_sLinkType][_sDoorLink].iR = _iR;
                     }
                     else if(_oDoors[_sLinkType][_sDoorLink].iExitC == undefined)
                     {
                        _oDoors[_sLinkType][_sDoorLink].iExitC = _iC;
                        _oDoors[_sLinkType][_sDoorLink].iExitR = _iR;
                     }
                     else
                     {
                        _sError = sERROR_MORE_DOOR_INDOOR + _sDoorLink;
                     }
                  }
                  else if(_sLinkType == AssetData.sLINK_OUTDOOR)
                  {
                     _sMap = _oData.oLinkedMap.sMap;
                     _sDoorLink = _oData.oLinkedMap.sDoorLink;
                     if(_oDoors[_sLinkType][_sDoorLink] == undefined)
                     {
                        _oDoors[_sLinkType][_sDoorLink] = new Object();
                        _oDoors[_sLinkType][_sDoorLink].type = _sLinkType;
                        _oDoors[_sLinkType][_sDoorLink].map = _sMap;
                     }
                     if(_oDoors[_sLinkType][_sDoorLink].iC == undefined)
                     {
                        _oDoors[_sLinkType][_sDoorLink].iC = _iC;
                        _oDoors[_sLinkType][_sDoorLink].iR = _iR;
                     }
                     else
                     {
                        _sError = sERROR_MORE_DOOR_OUTDOOR + _sDoorLink;
                     }
                  }
               }
            }
         }
         _sLinkType = AssetData.sLINK_INDOOR;
         for(i in _oDoors[AssetData.sLINK_INDOOR])
         {
            if(_oDoors[_sLinkType][i].iExitC == undefined)
            {
               _sError = sERROR_MISS_DOOR_INDOOR;
            }
            else
            {
               aDoorsData.push({
                  "sType":_oDoors[_sLinkType][i].type,
                  "sDoorLink":i,
                  "sMap":_oDoors[_sLinkType][i].map,
                  "iC":_oDoors[_sLinkType][i].iC,
                  "iR":_oDoors[_sLinkType][i].iR,
                  "iExitC":_oDoors[_sLinkType][i].iExitC,
                  "iExitR":_oDoors[_sLinkType][i].iExitR
               });
            }
         }
         _sLinkType = AssetData.sLINK_OUTDOOR;
         for(o in _oDoors[AssetData.sLINK_OUTDOOR])
         {
            aDoorsData.push({
               "sType":_oDoors[_sLinkType][o].type,
               "sDoorLink":o,
               "sMap":_oDoors[_sLinkType][o].map,
               "iC":_oDoors[_sLinkType][o].iC,
               "iR":_oDoors[_sLinkType][o].iR
            });
         }
         return _sError;
      }
      
      public function get cursor() : LBCursor
      {
         return oCursor;
      }
      
      public function loadXML(_sXmlFile:String) : void
      {
         var oRequest:URLRequest = new URLRequest(Path.getPath(Main.instance.stage) + _sXmlFile);
         oLoader = new URLLoader();
         oLoader.dataFormat = URLLoaderDataFormat.TEXT;
         oLoader.addEventListener(Event.COMPLETE,onLoadXML,false,0,true);
         oLoader.load(oRequest);
      }
      
      public function locatePuzzles() : String
      {
         var _sType:String = null;
         var _sLinkType:String = null;
         var _oData:Object = null;
         var _sPuzzleLink:String = null;
         var i:* = null;
         var _iC:int = 0;
         trace("locatePuzzle");
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         var _oPuzzles:Object = new Object();
         aPuzzlesData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               if(_oData.sLinkage != null)
               {
                  _sLinkType = AssetData.getAssetData(_oData.sLinkage).sLinkType;
                  if(_sLinkType == AssetData.sLINK_PUZZLE)
                  {
                     _sPuzzleLink = _oData.sPuzzleLink;
                     if(_oPuzzles[_sPuzzleLink] == null)
                     {
                        _oPuzzles[_sPuzzleLink] = new Object();
                     }
                     _oPuzzles[_sPuzzleLink].iC = _iC;
                     _oPuzzles[_sPuzzleLink].iR = _iR;
                  }
                  else if(_sLinkType == AssetData.sLINK_PUZZLE_SLOT)
                  {
                     _sPuzzleLink = _oData.sPuzzleLink;
                     if(_oPuzzles[_sPuzzleLink] == null)
                     {
                        _oPuzzles[_sPuzzleLink] = new Object();
                     }
                     _oPuzzles[_sPuzzleLink].iSafePlaceC = _iC;
                     _oPuzzles[_sPuzzleLink].iSafePlaceR = _iR;
                  }
               }
            }
         }
         for(i in _oPuzzles)
         {
            aPuzzlesData.push({
               "iC":_oPuzzles[i].iC,
               "iR":_oPuzzles[i].iR,
               "iSafePlaceC":_oPuzzles[i].iSafePlaceC,
               "iSafePlaceR":_oPuzzles[i].iSafePlaceR
            });
            trace("Puzzle: ",_oPuzzles[i].iC,_oPuzzles[i].iR,_oPuzzles[i].iSafePlaceC,_oPuzzles[i].iSafePlaceR);
         }
         return _sError;
      }
      
      public function locateCharacters() : String
      {
         var _sType:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aCharactersData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oCharacter;
               if(_oData.sLinkage != null)
               {
                  if(!AssetData.getAssetData(_oData.sLinkage).bEnemy)
                  {
                     aCharactersData.push({
                        "iC":_iC,
                        "iR":_iR
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      public function setMapData(_nPosX:Number, _nPosY:Number) : void
      {
         var _sType:String = null;
         var bRandomMatrix:Boolean = false;
         var _dpLayer:DisplayObjectContainer = null;
         var _oData:Object = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         var _nDepth:Number = NaN;
         var _bFlipable:Boolean = false;
         var _bRotatable:Boolean = false;
         var _uLoop:uint = 0;
         var _iC:Number = Math.floor(_nPosX / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_nPosY / Data.iTILE_HEIGHT);
         if(tool == sTOOL_ERASER || tool == sTOOL_ROTATE || tool == sTOOL_SCALE_X || tool == sTOOL_SCALE_Y)
         {
            getHigherObject(_nPosX,_nPosY);
            if(asset != null)
            {
               _sType = AssetData.getAssetData(asset).sType;
            }
         }
         else
         {
            _sType = AssetData.getAssetData(asset).sType;
         }
         if(_sType != null && _iC >= 0 && _iR >= 0)
         {
            _oData = getData(_sType,_iC,_iR);
            _dpLayer = getDepthLayer(_sType);
            switch(tool)
            {
               case sTOOL_MAP:
                  if(_oData.mcRef != null)
                  {
                     _dpLayer.removeChild(_oData.mcRef);
                  }
                  if(Main.instance.builderManager.asset != null)
                  {
                     _cClass = getDefinitionByName(Main.instance.builderManager.asset) as Class;
                     _mcRef = new _cClass();
                     _nDepth = getDepth(_dpLayer,_iC,_iR);
                     _dpLayer.addChildAt(_mcRef,_nDepth);
                     _mcRef.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                     _mcRef.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                     if(_oData.oLinkedMap != null)
                     {
                        _oData.oLinkedMap.sMap = "--";
                        _oData.oLinkedMap.sDoorLink = "--";
                     }
                     if(_oData.sPuzzleLink != null)
                     {
                        _oData.sPuzzleLink = "--";
                     }
                     _oData.mcRef = _mcRef;
                     _oData.sLinkage = asset;
                     _oData.oMatrix = _oData.mcRef.transform.matrix;
                     if(AssetData.getAssetData(asset).bRandomMatrix != null)
                     {
                        _uLoop = MoreMath.getRandomRange(0,4);
                        while(_uLoop > 0)
                        {
                           if(MoreMath.getRandomRange(0,1) == 0)
                           {
                              _oData.oMatrix.scale(1,-1);
                           }
                           else
                           {
                              _oData.oMatrix.rotate(Math.PI / 2);
                           }
                           _oData.mcRef.transform.matrix = _oData.oMatrix;
                           _uLoop--;
                        }
                        _oData.mcRef.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                        _oData.mcRef.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                     }
                     _oData.mcRef = _mcRef;
                     _oData.sLinkage = asset;
                     _oData.oMatrix = _oData.mcRef.transform.matrix;
                     oCursor.removeAsset();
                  }
                  break;
               case sTOOL_SELECT:
                  if(_oData.mcRef != null)
                  {
                     _dpLayer.removeChild(_oData.mcRef);
                     _oData.mcRef = null;
                     _oData.sLinkage = null;
                     _oData.oMatrix = null;
                  }
                  if(assetSelection != null)
                  {
                     _cClass = getDefinitionByName(assetSelection) as Class;
                     _mcRef = new _cClass();
                     _nDepth = getDepth(_dpLayer,_iC,_iR);
                     _dpLayer.addChildAt(_mcRef,_nDepth);
                     _oData.mcRef = _mcRef;
                     _oData.oMatrix = oSelectionData.oMatrix;
                     _oData.mcRef.transform.matrix = _oData.oMatrix;
                     _oData.mcRef.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                     _oData.mcRef.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                     _oData.sLinkage = oSelectionData.sAsset;
                     if(_oData.oLinkedMap != null)
                     {
                        _oData.oLinkedMap.sMap = oSelectionData.sMap;
                     }
                     if(_oData.oLinkedMap != null)
                     {
                        _oData.oLinkedMap.sDoorLink = oSelectionData.sDoorLink;
                     }
                     if(_oData.sPuzzleLink != null)
                     {
                        _oData.sPuzzleLink = oSelectionData.sPuzzleLink;
                     }
                     switch(sCurrentLinkType)
                     {
                        case AssetData.sLINK_INDOOR:
                        case AssetData.sLINK_OUTDOOR:
                           if(_oData.mcRef.txtIndex != null)
                           {
                              _oData.mcRef.txtIndex.text = oSelectionData.sDoorLink;
                           }
                           break;
                        case AssetData.sLINK_PUZZLE:
                        case AssetData.sLINK_PUZZLE_SLOT:
                           if(_oData.mcRef.txtIndex != null)
                           {
                              _oData.mcRef.txtIndex.text = oSelectionData.sPuzzleLink;
                           }
                     }
                     resetSelection();
                     oCursor.removeAsset();
                  }
                  break;
               case sTOOL_ERASER:
                  if(_oData.mcRef != null)
                  {
                     _dpLayer.removeChild(_oData.mcRef);
                     _oData.mcRef = null;
                     _oData.sLinkage = null;
                     _oData.oMatrix = null;
                     if(_oData.oLinkedMap != null)
                     {
                        _oData.oLinkedMap = {
                           "sMap":null,
                           "sDoorLink":null
                        };
                     }
                  }
                  asset = sPreviousAsset;
                  break;
               case sTOOL_ROTATE:
                  _bRotatable = AssetData.getAssetData(asset).bRotatable;
                  if(_oData.mcRef != null && _bRotatable)
                  {
                     _oData.oMatrix.rotate(Math.PI / 2);
                     _oData.mcRef.transform.matrix = _oData.oMatrix;
                     _oData.mcRef.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                     _oData.mcRef.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                     _oData.oMatrix = _oData.mcRef.transform.matrix;
                  }
                  asset = sPreviousAsset;
                  break;
               case sTOOL_SCALE_X:
                  _bFlipable = AssetData.getAssetData(asset).bFlipable;
                  if(_oData.mcRef != null && _bFlipable)
                  {
                     _oData.oMatrix.scale(-1,1);
                     _oData.mcRef.transform.matrix = _oData.oMatrix;
                     _oData.mcRef.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                     _oData.mcRef.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                     _oData.oMatrix = _oData.mcRef.transform.matrix;
                  }
                  asset = sPreviousAsset;
                  break;
               case sTOOL_SCALE_Y:
                  _bFlipable = AssetData.getAssetData(asset).bFlipable;
                  if(_oData.mcRef != null && _bFlipable)
                  {
                     _oData.oMatrix.scale(1,-1);
                     _oData.mcRef.transform.matrix = _oData.oMatrix;
                     _oData.mcRef.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                     _oData.mcRef.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                     _oData.oMatrix = _oData.mcRef.transform.matrix;
                  }
                  asset = sPreviousAsset;
            }
         }
      }
      
      public function get zoomIn() : Number
      {
         return nZOOM_IN_VALUE;
      }
      
      public function getRoom(_iC:int, _iR:int) : Number
      {
         var _nRoom:Number = oRoomData["X" + _iC + "Y" + _iR];
         if(isNaN(_nRoom))
         {
            _nRoom = 0;
         }
         return _nRoom;
      }
      
      public function getHigherObject(_nPosX:Number, _nPosY:Number) : void
      {
         var _iC:Number = Math.floor(_nPosX / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_nPosY / Data.iTILE_HEIGHT);
         if(getData(AssetData.sTYPE_ITEM,_iC,_iR).mcRef != null)
         {
            sPreviousAsset = asset;
            Main.instance.builderManager.asset = getData(AssetData.sTYPE_ITEM,_iC,_iR).sLinkage;
         }
         else if(getData(AssetData.sTYPE_CHARACTER,_iC,_iR).mcRef != null)
         {
            sPreviousAsset = asset;
            Main.instance.builderManager.asset = getData(AssetData.sTYPE_CHARACTER,_iC,_iR).sLinkage;
         }
         else if(getData(AssetData.sTYPE_OBJECT,_iC,_iR).mcRef != null)
         {
            sPreviousAsset = asset;
            Main.instance.builderManager.asset = getData(AssetData.sTYPE_OBJECT,_iC,_iR).sLinkage;
         }
         else if(getData(AssetData.sTYPE_MISC,_iC,_iR).mcRef != null)
         {
            sPreviousAsset = asset;
            Main.instance.builderManager.asset = getData(AssetData.sTYPE_MISC,_iC,_iR).sLinkage;
         }
         else if(getData(AssetData.sTYPE_TILE,_iC,_iR).mcRef != null)
         {
            sPreviousAsset = asset;
            Main.instance.builderManager.asset = getData(AssetData.sTYPE_TILE,_iC,_iR).sLinkage;
         }
      }
      
      public function setZoom(_nZoom:Number) : void
      {
         nCurrentZoom = _nZoom;
         switch(_nZoom)
         {
            case nZOOM_IN_VALUE:
               mcRef.mcLevel.x = mcRef.mcZoomIn.x;
               mcRef.mcLevel.y = mcRef.mcZoomIn.y;
               break;
            case nZOOM_OUT_VALUE:
               mcRef.mcLevel.x = mcRef.mcZoomOut.x;
               mcRef.mcLevel.y = mcRef.mcZoomOut.y;
         }
         mcRef.mcLevel.scaleX = _nZoom;
         mcRef.mcLevel.scaleY = _nZoom;
      }
      
      public function initObject() : void
      {
         if(Application.path != null && Application.path != "")
         {
            oFileReader = new FileReader();
            oFileWriter = new FileWriter();
         }
         mcRef.mcButtonBlocker.useHandCursor = false;
         mcRef.mcZoomIn.visible = false;
         mcRef.mcZoomOut.visible = false;
         mcRef.mcCursorZone.visible = false;
         oAssetManager = new AssetManager(mcRef.mcAssets);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_CURSOR);
         var _mcCursor:MovieClip = new mcLBCursor();
         var _oBounds:Object = {
            "xMin":mcRef.mcCursorZone.x,
            "xMax":mcRef.mcCursorZone.x + mcRef.mcCursorZone.width,
            "yMin":mcRef.mcCursorZone.y,
            "yMax":mcRef.mcCursorZone.y + mcRef.mcCursorZone.height
         };
         _dpLayer.addChild(_mcCursor);
         oCursor = new LBCursor(_mcCursor,mcRef.mcLevel,_oBounds);
         oLevel = new LBLevel(mcRef.mcLevel,_oBounds);
         var _mcGrid:MovieClip = mcRef.mcLevel.mcLevelGrid;
         mcRef.mcLevel.removeChild(_mcGrid);
         mcRef.mcLevel.addChild(_mcGrid);
         setButton(mcRef.btnTilesMapLv1);
         setButton(mcRef.btnTilesMapLv2);
         setButton(mcRef.btnTilesMapLv3);
         setButton(mcRef.btnTilesLairLv1);
         setButton(mcRef.btnTilesLairLv2);
         setButton(mcRef.btnTilesLairLv3);
         setButton(mcRef.btnObjectsLv1);
         setButton(mcRef.btnObjectsLv2);
         setButton(mcRef.btnObjectsLv3);
         setButton(mcRef.btnDoorsLv1);
         setButton(mcRef.btnDoorsLv2);
         setButton(mcRef.btnDoorsLv3);
         setButton(mcRef.btnCharacters);
         setButton(mcRef.btnItems);
         setButton(mcRef.btnKeyItems);
         setButton(mcRef.btnPuzzle);
         setButton(mcRef.btnEnemies);
         setButton(mcRef.btnMisc);
         setButton(mcRef.btnSave);
         setButton(mcRef.btnLoad);
         setButton(mcRef.btnZoomIn);
         setButton(mcRef.btnZoomOut);
         setButton(mcRef.btnToolMap);
         setButton(mcRef.btnToolSelect);
         setButton(mcRef.btnToolErase);
         setButton(mcRef.btnToolRotate);
         setButton(mcRef.btnToolLink);
         setButton(mcRef.btnToolScaleX);
         setButton(mcRef.btnToolScaleY);
         setZoom(nZOOM_IN_VALUE);
         setTool(sTOOL_MAP);
         oSelectionData = null;
         asset = "mcLBTileGrass00Lv1";
         sPreviousAsset = asset;
         initMapData();
         loadXML(Data.sFILE_FOLDER_PATH + Data.sFILE_WORLD + Data.sFILE_EXTENSION);
         sFileLoaded = Data.sFILE_WORLD;
      }
      
      private function onLoadXML(_e:Event) : void
      {
         var _oXML:XML = null;
         var _sData:String = null;
         var _oBA:ByteArray = null;
         var _oLexique:Object = null;
         var i:* = null;
         var _oData:Object = null;
         var _oColumnList:XMLList = null;
         var _oRowList:XMLList = null;
         var _iR:int = 0;
         var _iC:int = 0;
         var _nPosX:Number = NaN;
         var _nPosY:Number = NaN;
         XML.ignoreWhitespace = true;
         if(_e.target.data != "")
         {
            _sData = _e.target.data;
            _oBA = Base64.decodeToByteArray(_sData);
            _oBA.uncompress();
            _oXML = new XML(_oBA.toString());
            _oLexique = new Object();
            for(i in _oXML.lex.d)
            {
               _oLexique[_oXML.lex.d[i].@id] = _oXML.lex.d[i].@l;
            }
            _oRowList = _oXML.m.r;
            for(_iR = 0; _iR < _oRowList.length(); _iR++)
            {
               _oColumnList = _oRowList[_iR].c;
               for(_iC = 0; _iC < _oColumnList.length(); _iC++)
               {
                  _nPosX = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
                  _nPosY = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
                  _oData = oMapData["X" + _iC + "Y" + _iR].oTile;
                  if(_oColumnList[_iC].t != undefined)
                  {
                     _oData.sLinkage = _oLexique[_oColumnList[_iC].t.@l];
                     _oData.nRoom = Number(_oColumnList[_iC].t.@rm);
                     _oData.oMatrix = null;
                     if(_oData.sLinkage != null)
                     {
                        _oData.oMatrix = new Matrix();
                        if(_oColumnList[_iC].t.@ma != undefined)
                        {
                           _oData.oMatrix.a = _oColumnList[_iC].t.@ma;
                           _oData.oMatrix.b = _oColumnList[_iC].t.@mb;
                           _oData.oMatrix.c = _oColumnList[_iC].t.@mc;
                           _oData.oMatrix.d = _oColumnList[_iC].t.@md;
                        }
                        _oData.oMatrix.tx = _nPosX;
                        _oData.oMatrix.ty = _nPosY;
                     }
                  }
                  _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
                  if(_oColumnList[_iC].o != undefined)
                  {
                     _oData.sLinkage = _oLexique[_oColumnList[_iC].o.@l];
                     _oData.nRoom = Number(_oColumnList[_iC].o.@rm);
                     _oData.oMatrix = null;
                     if(_oData.sLinkage != null)
                     {
                        _oData.oMatrix = new Matrix();
                        if(_oColumnList[_iC].o.@ma != undefined)
                        {
                           _oData.oMatrix.a = _oColumnList[_iC].o.@ma;
                           _oData.oMatrix.b = _oColumnList[_iC].o.@mb;
                           _oData.oMatrix.c = _oColumnList[_iC].o.@mc;
                           _oData.oMatrix.d = _oColumnList[_iC].o.@md;
                        }
                        _oData.oMatrix.tx = _nPosX;
                        _oData.oMatrix.ty = _nPosY;
                     }
                     if(_oColumnList[_iC].o.@pl != undefined)
                     {
                        _oData.sPuzzleLink = _oColumnList[_iC].o.@pl;
                     }
                     if(_oColumnList[_iC].o.@m != undefined)
                     {
                        _oData.oLinkedMap.sMap = _oColumnList[_iC].o.@m;
                     }
                     if(_oColumnList[_iC].o.@dl != undefined)
                     {
                        _oData.oLinkedMap.sDoorLink = _oColumnList[_iC].o.@dl;
                     }
                  }
                  _oData = oMapData["X" + _iC + "Y" + _iR].oCharacter;
                  if(_oColumnList[_iC].c != undefined)
                  {
                     _oData.sLinkage = _oLexique[_oColumnList[_iC].c.@l];
                     _oData.nRoom = Number(_oColumnList[_iC].c.@rm);
                     _oData.oMatrix = null;
                     if(_oData.sLinkage != null)
                     {
                        _oData.oMatrix = new Matrix();
                        if(_oColumnList[_iC].c.@ma != undefined)
                        {
                           _oData.oMatrix.a = _oColumnList[_iC].c.@ma;
                           _oData.oMatrix.b = _oColumnList[_iC].c.@mb;
                           _oData.oMatrix.c = _oColumnList[_iC].c.@mc;
                           _oData.oMatrix.d = _oColumnList[_iC].c.@md;
                        }
                        _oData.oMatrix.tx = _nPosX;
                        _oData.oMatrix.ty = _nPosY;
                     }
                  }
                  _oData = oMapData["X" + _iC + "Y" + _iR].oItem;
                  if(_oColumnList[_iC].i != undefined)
                  {
                     _oData.sLinkage = _oLexique[_oColumnList[_iC].i.@l];
                     _oData.nRoom = Number(_oColumnList[_iC].i.@rm);
                     _oData.oMatrix = null;
                     if(_oData.sLinkage != null)
                     {
                        _oData.oMatrix = new Matrix();
                        if(_oColumnList[_iC].i.@ma != undefined)
                        {
                           _oData.oMatrix.a = _oColumnList[_iC].i.@ma;
                           _oData.oMatrix.b = _oColumnList[_iC].i.@mb;
                           _oData.oMatrix.c = _oColumnList[_iC].i.@mc;
                           _oData.oMatrix.d = _oColumnList[_iC].i.@md;
                        }
                        _oData.oMatrix.tx = _nPosX;
                        _oData.oMatrix.ty = _nPosY;
                     }
                  }
                  _oData = oMapData["X" + _iC + "Y" + _iR].oMisc;
                  if(_oColumnList[_iC].m != undefined)
                  {
                     _oData.sLinkage = _oLexique[_oColumnList[_iC].m.@l];
                     if(_oData.sLinkage == "null")
                     {
                        _oData.sLinkage = null;
                     }
                     _oData.nRoom = Number(_oColumnList[_iC].m.@rm);
                     _oData.oMatrix = null;
                     if(_oData.sLinkage != null)
                     {
                        _oData.oMatrix = new Matrix();
                        if(_oColumnList[_iC].m.@ma != undefined)
                        {
                           _oData.oMatrix.a = _oColumnList[_iC].m.@ma;
                           _oData.oMatrix.b = _oColumnList[_iC].m.@mb;
                           _oData.oMatrix.c = _oColumnList[_iC].m.@mc;
                           _oData.oMatrix.d = _oColumnList[_iC].m.@md;
                        }
                        _oData.oMatrix.tx = _nPosX;
                        _oData.oMatrix.ty = _nPosY;
                     }
                  }
               }
            }
            buildMap();
         }
         oLoader.removeEventListener(Event.COMPLETE,onLoadXML,false);
      }
      
      public function locateEnemies() : String
      {
         var _sType:String = null;
         var _sItemLinkage:String = null;
         var _bEnemy:Boolean = false;
         var _oData:Object = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aEnemiesData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oCharacter;
               if(_oData.sLinkage != null)
               {
                  _bEnemy = AssetData.getAssetData(_oData.sLinkage).bEnemy;
                  if(_bEnemy)
                  {
                     _sItemLinkage = null;
                     _sItemLinkage = oMapData["X" + _iC + "Y" + _iR].oItem.sLinkage;
                     aEnemiesData.push({
                        "iC":_iC,
                        "iR":_iR,
                        "sItemLinkage":_sItemLinkage
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      private function save() : String
      {
         var _nRoom:Number = NaN;
         var _oData:Object = null;
         var _sIndex:* = null;
         var c:int = 0;
         var _sSavedString:* = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         var _oLexique:Object = new Object();
         var _uLexIndex:uint = 0;
         var _uLexIndexToUse:uint = _uLexIndex;
         _sSavedString += "<d>";
         _sSavedString += "<m>";
         for(var r:int = 0; r < _nRowMax; r++)
         {
            _sSavedString += "<r>";
            for(c = 0; c < _nColumnMax; c++)
            {
               _nRoom = getRoom(c,r);
               _sSavedString += "<c>";
               _oData = oMapData["X" + c + "Y" + r].oTile;
               if(_oData.sLinkage != null)
               {
                  if(_oLexique[_oData.sLinkage] == undefined)
                  {
                     _uLexIndex++;
                     _oLexique[_oData.sLinkage] = _uLexIndex;
                     _uLexIndexToUse = _uLexIndex;
                  }
                  else
                  {
                     _uLexIndexToUse = _oLexique[_oData.sLinkage];
                  }
                  _sSavedString += "<t l=\"" + _uLexIndexToUse + "\" ";
                  _sSavedString += "rm=\"" + _nRoom + "\" ";
                  if(_oData.oMatrix.a != 1 || _oData.oMatrix.b != 0 || _oData.oMatrix.c != 0 || _oData.oMatrix.d != 1)
                  {
                     _sSavedString += "ma=\"" + _oData.oMatrix.a + "\" ";
                     _sSavedString += "mb=\"" + _oData.oMatrix.b + "\" ";
                     _sSavedString += "mc=\"" + _oData.oMatrix.c + "\" ";
                     _sSavedString += "md=\"" + _oData.oMatrix.d + "\" ";
                  }
                  _sSavedString += "/>";
               }
               _oData = oMapData["X" + c + "Y" + r].oObject;
               if(_oData.sLinkage != null)
               {
                  if(_oLexique[_oData.sLinkage] == undefined)
                  {
                     _uLexIndex++;
                     _oLexique[_oData.sLinkage] = _uLexIndex;
                     _uLexIndexToUse = _uLexIndex;
                  }
                  else
                  {
                     _uLexIndexToUse = _oLexique[_oData.sLinkage];
                  }
                  _sSavedString += "<o l=\"" + _uLexIndexToUse + "\" ";
                  _sSavedString += "rm=\"" + _nRoom + "\" ";
                  if(_oData.oLinkedMap.sMap != null)
                  {
                     _sSavedString += "m=\"" + _oData.oLinkedMap.sMap + "\" ";
                  }
                  if(_oData.oLinkedMap.sDoorLink != null)
                  {
                     _sSavedString += "dl=\"" + _oData.oLinkedMap.sDoorLink + "\" ";
                  }
                  if(_oData.sPuzzleLink != null)
                  {
                     _sSavedString += "pl=\"" + _oData.sPuzzleLink + "\" ";
                  }
                  if(_oData.oMatrix.a != 1 || _oData.oMatrix.b != 0 || _oData.oMatrix.c != 0 || _oData.oMatrix.d != 1)
                  {
                     _sSavedString += "ma=\"" + _oData.oMatrix.a + "\" ";
                     _sSavedString += "mb=\"" + _oData.oMatrix.b + "\" ";
                     _sSavedString += "mc=\"" + _oData.oMatrix.c + "\" ";
                     _sSavedString += "md=\"" + _oData.oMatrix.d + "\" ";
                  }
                  _sSavedString += "/>";
               }
               _oData = oMapData["X" + c + "Y" + r].oCharacter;
               if(_oData.sLinkage != null)
               {
                  if(_oLexique[_oData.sLinkage] == undefined)
                  {
                     _uLexIndex++;
                     _oLexique[_oData.sLinkage] = _uLexIndex;
                     _uLexIndexToUse = _uLexIndex;
                  }
                  else
                  {
                     _uLexIndexToUse = _oLexique[_oData.sLinkage];
                  }
                  _sSavedString += "<c l=\"" + _uLexIndexToUse + "\" ";
                  _sSavedString += "rm=\"" + _nRoom + "\" ";
                  if(_oData.oMatrix.a != 1 || _oData.oMatrix.b != 0 || _oData.oMatrix.c != 0 || _oData.oMatrix.d != 1)
                  {
                     _sSavedString += "ma=\"" + _oData.oMatrix.a + "\" ";
                     _sSavedString += "mb=\"" + _oData.oMatrix.b + "\" ";
                     _sSavedString += "mc=\"" + _oData.oMatrix.c + "\" ";
                     _sSavedString += "md=\"" + _oData.oMatrix.d + "\" ";
                  }
                  _sSavedString += "/>";
               }
               _oData = oMapData["X" + c + "Y" + r].oItem;
               if(_oData.sLinkage != null)
               {
                  if(_oLexique[_oData.sLinkage] == undefined)
                  {
                     _uLexIndex++;
                     _oLexique[_oData.sLinkage] = _uLexIndex;
                     _uLexIndexToUse = _uLexIndex;
                  }
                  else
                  {
                     _uLexIndexToUse = _oLexique[_oData.sLinkage];
                  }
                  _sSavedString += "<i l=\"" + _uLexIndexToUse + "\" ";
                  _sSavedString += "rm=\"" + _nRoom + "\" ";
                  if(_oData.oMatrix.a != 1 || _oData.oMatrix.b != 0 || _oData.oMatrix.c != 0 || _oData.oMatrix.d != 1)
                  {
                     _sSavedString += "ma=\"" + _oData.oMatrix.a + "\" ";
                     _sSavedString += "mb=\"" + _oData.oMatrix.b + "\" ";
                     _sSavedString += "mc=\"" + _oData.oMatrix.c + "\" ";
                     _sSavedString += "md=\"" + _oData.oMatrix.d + "\" ";
                  }
                  _sSavedString += "/>";
               }
               _oData = oMapData["X" + c + "Y" + r].oMisc;
               if(_oData.sLinkage != null)
               {
                  if(_oLexique[_oData.sLinkage] == undefined)
                  {
                     _uLexIndex++;
                     _oLexique[_oData.sLinkage] = _uLexIndex;
                     _uLexIndexToUse = _uLexIndex;
                  }
                  else
                  {
                     _uLexIndexToUse = _oLexique[_oData.sLinkage];
                  }
                  _sSavedString += "<m l=\"" + _uLexIndexToUse + "\" ";
                  _sSavedString += "rm=\"" + _nRoom + "\" ";
                  if(_oData.oMatrix.a != 1 || _oData.oMatrix.b != 0 || _oData.oMatrix.c != 0 || _oData.oMatrix.d != 1)
                  {
                     _sSavedString += "ma=\"" + _oData.oMatrix.a + "\" ";
                     _sSavedString += "mb=\"" + _oData.oMatrix.b + "\" ";
                     _sSavedString += "mc=\"" + _oData.oMatrix.c + "\" ";
                     _sSavedString += "md=\"" + _oData.oMatrix.d + "\" ";
                  }
                  _sSavedString += "/>";
               }
               _sSavedString += "</c>";
            }
            _sSavedString += "</r>";
         }
         _sSavedString += "</m>";
         _sSavedString += "<ds>";
         for(_sIndex in aDoorsData)
         {
            if(aDoorsData[_sIndex].sType == AssetData.sLINK_INDOOR)
            {
               _sSavedString += "<d type=\"" + aDoorsData[_sIndex].sType + "\" doorLink=\"" + aDoorsData[_sIndex].sDoorLink + "\" c=\"" + aDoorsData[_sIndex].iC + "\" r=\"" + aDoorsData[_sIndex].iR + "\"  exit_c=\"" + aDoorsData[_sIndex].iExitC + "\"  exit_r=\"" + aDoorsData[_sIndex].iExitR + "\"/>";
               _sSavedString += "<d type=\"" + aDoorsData[_sIndex].sType + "\" doorLink=\"" + aDoorsData[_sIndex].sDoorLink + "\" c=\"" + aDoorsData[_sIndex].iExitC + "\" r=\"" + aDoorsData[_sIndex].iExitR + "\"  exit_c=\"" + aDoorsData[_sIndex].iC + "\"  exit_r=\"" + aDoorsData[_sIndex].iR + "\"/>";
            }
            else
            {
               _sSavedString += "<d type=\"" + aDoorsData[_sIndex].sType + "\" doorLink=\"" + aDoorsData[_sIndex].sDoorLink + "\" c=\"" + aDoorsData[_sIndex].iC + "\" r=\"" + aDoorsData[_sIndex].iR + "\" map=\"" + aDoorsData[_sIndex].sMap + "\"/>";
            }
         }
         _sSavedString += "</ds>";
         _sSavedString += "<es>";
         for(_sIndex in aEnemiesData)
         {
            _sSavedString += "<e c=\"" + aEnemiesData[_sIndex].iC + "\" r=\"" + aEnemiesData[_sIndex].iR + "\" ";
            if(aEnemiesData[_sIndex].sItemLinkage != null)
            {
               _sSavedString += "i=\"" + aEnemiesData[_sIndex].sItemLinkage + "\"/>";
            }
            else
            {
               _sSavedString += "/>";
            }
         }
         _sSavedString += "</es>";
         _sSavedString += "<chs>";
         for(_sIndex in aCharactersData)
         {
            _sSavedString += "<ch c=\"" + aCharactersData[_sIndex].iC + "\" r=\"" + aCharactersData[_sIndex].iR + "\"/>";
         }
         _sSavedString += "</chs>";
         _sSavedString += "<cs>";
         for(_sIndex in aChestsData)
         {
            _sSavedString += "<c c=\"" + aChestsData[_sIndex].iC + "\" r=\"" + aChestsData[_sIndex].iR + "\" ";
            if(aChestsData[_sIndex].sItemLinkage != null)
            {
               _sSavedString += "i=\"" + aChestsData[_sIndex].sItemLinkage + "\"/>";
            }
            else
            {
               _sSavedString += "/>";
            }
         }
         _sSavedString += "</cs>";
         _sSavedString += "<ps>";
         for(_sIndex in aPuzzlesData)
         {
            _sSavedString += "<p c=\"" + aPuzzlesData[_sIndex].iC + "\" r=\"" + aPuzzlesData[_sIndex].iR + "\"  spC=\"" + aPuzzlesData[_sIndex].iSafePlaceC + "\" spR=\"" + aPuzzlesData[_sIndex].iSafePlaceR + "\"/>";
         }
         _sSavedString += "</ps>";
         _sSavedString += "<its>";
         for(_sIndex in aItemsData)
         {
            _sSavedString += "<it c=\"" + aItemsData[_sIndex].iC + "\" r=\"" + aItemsData[_sIndex].iR + "\"/>";
         }
         _sSavedString += "</its>";
         _sSavedString += "<evs>";
         for(_sIndex in aEventsData)
         {
            _sSavedString += "<ev c=\"" + aEventsData[_sIndex].iC + "\" r=\"" + aEventsData[_sIndex].iR + "\"/>";
         }
         _sSavedString += "</evs>";
         _sSavedString += "<ws>";
         for(_sIndex in aWandablesData)
         {
            _sSavedString += "<w c=\"" + aWandablesData[_sIndex].iC + "\" r=\"" + aWandablesData[_sIndex].iR + "\"/>";
         }
         _sSavedString += "</ws>";
         _sSavedString += "<des>";
         for(_sIndex in aDestructablesData)
         {
            _sSavedString += "<de c=\"" + aDestructablesData[_sIndex].iC + "\" r=\"" + aDestructablesData[_sIndex].iR + "\" ";
            if(aDestructablesData[_sIndex].sItemLinkage != null)
            {
               _sSavedString += "i=\"" + aDestructablesData[_sIndex].sItemLinkage + "\"/>";
            }
            else
            {
               _sSavedString += "/>";
            }
         }
         _sSavedString += "</des>";
         for(_sIndex in _oLexique)
         {
            _sSavedString += "<lex>";
            _sSavedString += "<d id=\"" + _oLexique[_sIndex] + "\" l=\"" + _sIndex + "\" />";
            _sSavedString += "</lex>";
         }
         _sSavedString += "</d>";
         trace(_sSavedString);
         return _sSavedString;
      }
      
      private function validContaminatedTile(_iC:int, _iR:int) : Boolean
      {
         var _sType:String = null;
         var _sLinkType:String = null;
         var _sBlocker:String = null;
         var _oData:Object = null;
         var _bContaminated:Boolean = true;
         if(oRoomData["X" + _iC + "Y" + _iR] != undefined)
         {
            _bContaminated = false;
         }
         if(oMapData["X" + _iC + "Y" + _iR] == undefined)
         {
            _bContaminated = false;
         }
         if(_bContaminated)
         {
            _oData = oMapData["X" + _iC + "Y" + _iR].oMisc;
            if(_oData.sLinkage != null)
            {
               _sBlocker = AssetData.getAssetData(_oData.sLinkage).sBlocker;
               if(_sBlocker == AssetData.sBLOCKER_FULL || _sBlocker == AssetData.sBLOCKER_HALF)
               {
                  _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
                  if(_oData.sLinkage != null)
                  {
                     _sLinkType = AssetData.getAssetData(_oData.sLinkage).sLinkType;
                     if(_sLinkType != AssetData.sLINK_INDOOR && _sLinkType != AssetData.sLINK_OUTDOOR)
                     {
                        _bContaminated = false;
                     }
                  }
                  else
                  {
                     _bContaminated = false;
                  }
               }
            }
         }
         return _bContaminated;
      }
      
      public function generateRooms() : void
      {
         var _bFound:Boolean = false;
         var i:Number = NaN;
         var _iC:int = 0;
         var _oFormat:TextFormat = null;
         var txtFrameRate:TextField = null;
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_OBJECTS);
         var _bAllErased:Boolean = false;
         while(_bAllErased == false)
         {
            _bFound = false;
            for(i = 0; i < _dpLayer.numChildren; i++)
            {
               if(_dpLayer.getChildAt(i) is TextField)
               {
                  _bFound = true;
                  _dpLayer.removeChild(_dpLayer.getChildAt(i));
                  break;
               }
            }
            if(!_bFound)
            {
               _bAllErased = true;
            }
            trace("_bAllErased : " + _bAllErased);
         }
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oFormat = new TextFormat();
               _oFormat.font = "Verdana";
               _oFormat.color = 16777215;
               _oFormat.size = 20;
               _oFormat.align = TextFormatAlign.LEFT;
               txtFrameRate = new TextField();
               txtFrameRate.x = _iC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
               txtFrameRate.y = _iR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
               txtFrameRate.width = 50;
               txtFrameRate.height = 50;
               txtFrameRate.selectable = false;
               txtFrameRate.defaultTextFormat = _oFormat;
               if(oRoomData["X" + _iC + "Y" + _iR] != undefined)
               {
                  txtFrameRate.text = oRoomData["X" + _iC + "Y" + _iR];
               }
               _dpLayer.addChild(txtFrameRate);
            }
         }
      }
      
      public function get selectionMatrix() : Matrix
      {
         return oSelectionData.oMatrix;
      }
      
      private function buildMapAsset(_oData:Object, _nC:int, _nR:int) : void
      {
         var _dpLayer:DisplayObjectContainer = null;
         var _sLinkType:String = null;
         var _sLinkageToAdd:String = null;
         var _sLinkage:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         var _nDepth:Number = NaN;
         var _sType:String = null;
         _sLinkage = _oData.sLinkage;
         if(_sLinkage == "null")
         {
            _sLinkage = null;
         }
         if(_sLinkage != null)
         {
            _sType = AssetData.getAssetData(_sLinkage).sType;
            _dpLayer = getDepthLayer(_sType);
            _sLinkageToAdd = AssetData.getAssetData(_sLinkage).sLBLinkage;
            _sLinkType = AssetData.getAssetData(_sLinkage).sLinkType;
            _cClass = getDefinitionByName(_sLinkageToAdd) as Class;
            _mcRef = new _cClass();
            _nDepth = getDepth(_dpLayer,_nC,_nR);
            _dpLayer.addChildAt(_mcRef,_nDepth);
            _oData.mcRef = _mcRef;
            _oData.mcRef.transform.matrix = _oData.oMatrix;
            if(_sType == AssetData.sTYPE_OBJECT)
            {
               if(_oData.mcRef.txtIndex != null)
               {
                  switch(_sLinkType)
                  {
                     case AssetData.sLINK_INDOOR:
                     case AssetData.sLINK_OUTDOOR:
                        _oData.mcRef.txtIndex.text = _oData.oLinkedMap.sDoorLink;
                        break;
                     case AssetData.sLINK_PUZZLE:
                     case AssetData.sLINK_PUZZLE_SLOT:
                        _oData.mcRef.txtIndex.text = _oData.sPuzzleLink;
                  }
               }
            }
         }
      }
      
      public function get zoomOut() : Number
      {
         return nZOOM_OUT_VALUE;
      }
      
      public function locateItems() : String
      {
         var _bEnemy:Boolean = false;
         var _bDestructable:Boolean = false;
         var _bContainer:Boolean = false;
         var _sType:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _bFloorItem:Boolean = false;
         trace("Locate Items");
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aItemsData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _bFloorItem = true;
               _oData = oMapData["X" + _iC + "Y" + _iR].oItem;
               if(_oData.sLinkage != null)
               {
                  _oData = oMapData["X" + _iC + "Y" + _iR].oCharacter;
                  if(_oData.sLinkage != null)
                  {
                     if(AssetData.getAssetData(_oData.sLinkage).bEnemy)
                     {
                        _bFloorItem = false;
                     }
                  }
                  if(_bFloorItem)
                  {
                     _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
                     if(_oData.sLinkage != null)
                     {
                        if(AssetData.getAssetData(_oData.sLinkage).bDestructable || AssetData.getAssetData(_oData.sLinkage).bContainer)
                        {
                           _bFloorItem = false;
                        }
                     }
                  }
                  if(_bFloorItem)
                  {
                     aItemsData.push({
                        "iC":_iC,
                        "iR":_iR
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      public function removePopup(_oPopup:Popup) : void
      {
         if(_oPopup != null)
         {
            switch(_oPopup)
            {
               case oPopupIndoor:
                  trace("Remove popup: oPopupIndoor");
                  if(oPopupIndoor != null)
                  {
                     oPopupIndoor.destroy(null);
                  }
                  oPopupIndoor = null;
                  break;
               case oPopupOutdoor:
                  trace("Remove popup: oPopupOutdoor");
                  if(oPopupOutdoor != null)
                  {
                     oPopupOutdoor.destroy(null);
                  }
                  oPopupOutdoor = null;
               case oPopupPuzzle:
                  trace("Remove popup: oPopupPuzzle");
                  if(oPopupPuzzle != null)
                  {
                     oPopupPuzzle.destroy(null);
                  }
                  oPopupPuzzle = null;
            }
         }
      }
      
      public function addPopup(_sID:String) : void
      {
         var _mcPopup:MovieClip = null;
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_POPUP);
         switch(_sID)
         {
            case sPOPUP_INDOOR:
               _mcPopup = new mcPopupIndoor();
               oPopupIndoor = new PopupIndoor(_mcPopup);
               break;
            case sPOPUP_OUTDOOR:
               _mcPopup = new mcPopupOutdoor();
               oPopupOutdoor = new PopupOutdoor(_mcPopup);
               break;
            case sPOPUP_PUZZLE:
               _mcPopup = new mcPopupPuzzle();
               oPopupPuzzle = new PopupPuzzle(_mcPopup);
         }
         _dpLayer.addChild(_mcPopup);
      }
      
      public function locateChests() : String
      {
         var _sType:String = null;
         var _sItemLinkage:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _sError:String = "";
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         aChestsData = new Array();
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               if(_oData.sLinkage != null)
               {
                  if(AssetData.getAssetData(_oData.sLinkage).sID == Data.uCHEST_NORMAL || AssetData.getAssetData(_oData.sLinkage).sID == Data.uCHEST_KEY || AssetData.getAssetData(_oData.sLinkage).sID == Data.uCHEST_KILL)
                  {
                     _sItemLinkage = null;
                     _sItemLinkage = oMapData["X" + _iC + "Y" + _iR].oItem.sLinkage;
                     aChestsData.push({
                        "iC":_iC,
                        "iR":_iR,
                        "sItemLinkage":_sItemLinkage
                     });
                  }
               }
            }
         }
         return _sError;
      }
      
      public function get assetSelection() : String
      {
         var _sAsset:String = null;
         if(oSelectionData != null)
         {
            _sAsset = oSelectionData.sAsset;
         }
         return _sAsset;
      }
      
      public function get tool() : String
      {
         return sCurrentTool;
      }
      
      public function get selectionLink() : String
      {
         var _sLink:String = null;
         switch(sCurrentLinkType)
         {
            case AssetData.sLINK_INDOOR:
            case AssetData.sLINK_OUTDOOR:
               _sLink = oSelectionData.sDoorLink;
               break;
            case AssetData.sLINK_PUZZLE:
            case AssetData.sLINK_PUZZLE_SLOT:
               _sLink = oSelectionData.sPuzzleLink;
         }
         return _sLink;
      }
      
      private function onLoseFocus(_e:FocusEvent) : void
      {
         Main.instance.stage.focus = Main.instance.stage;
      }
      
      public function get popupOutdoor() : PopupOutdoor
      {
         return oPopupOutdoor;
      }
      
      public function get currentPuzzleLink() : String
      {
         return oLink.sPuzzleLink;
      }
      
      public function getSelectData(_nPosX:Number, _nPosY:Number) : void
      {
         var _sType:String = null;
         var _sLinkType:String = null;
         var _dpLayer:DisplayObjectContainer = null;
         var _oData:Object = null;
         var _iC:Number = Math.floor(_nPosX / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_nPosY / Data.iTILE_HEIGHT);
         getHigherObject(_nPosX,_nPosY);
         _sType = AssetData.getAssetData(asset).sType;
         _sLinkType = AssetData.getAssetData(asset).sLinkType;
         if(_sType != null)
         {
            _dpLayer = getDepthLayer(_sType);
            _oData = getData(_sType,_iC,_iR);
            if(_oData.mcRef != null)
            {
               oSelectionData = new Object();
               oSelectionData.oMatrix = _oData.mcRef.transform.matrix;
               oSelectionData.sAsset = getQualifiedClassName(_oData.mcRef);
               oSelectionData.sMap = null;
               oSelectionData.sDoorLink = null;
               oSelectionData.sPuzzleLink = null;
               if(_oData.sPuzzleLink != null)
               {
                  oSelectionData.sPuzzleLink = _oData.sPuzzleLink;
               }
               sCurrentLinkType = _sLinkType;
               if(_oData.oLinkedMap != null)
               {
                  oSelectionData.sMap = _oData.oLinkedMap.sMap;
                  _oData.oLinkedMap.sMap = null;
               }
               if(_oData.oLinkedMap != null)
               {
                  oSelectionData.sDoorLink = _oData.oLinkedMap.sDoorLink;
                  _oData.oLinkedMap.sDoorLink = null;
               }
               _dpLayer.removeChild(_oData.mcRef);
               _oData.mcRef = null;
               _oData.sLinkage = null;
               _oData.oMatrix = null;
            }
         }
      }
      
      public function locateRooms(_iCStart:int = 0, _iRStart:int = 0, _uRoomIndex:uint = 0) : void
      {
         var _sType:String = null;
         var _sLinkType:String = null;
         var _oData:Object = null;
         var _iC:int = 0;
         var _oMatrix:Matrix = null;
         var _oPoint:Point = null;
         var _iAdjacentC:Number = NaN;
         var _iAdjacentR:Number = NaN;
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         var _bFound:Boolean = false;
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = oMapData["X" + _iC + "Y" + _iR].oObject;
               if(_oData.sLinkage != null)
               {
                  _sLinkType = AssetData.getAssetData(_oData.sLinkage).sLinkType;
                  if(_sLinkType == AssetData.sLINK_INDOOR || _sLinkType == AssetData.sLINK_OUTDOOR)
                  {
                     if(oRoomData["X" + _iC + "Y" + _iR] == null)
                     {
                        _bFound = true;
                        break;
                     }
                  }
               }
            }
            if(_bFound)
            {
               break;
            }
         }
         if(_bFound)
         {
            _uRoomIndex++;
            trace(_uRoomIndex + " differents rooms.");
            oRoomData["X" + _iC + "Y" + _iR] = _uRoomIndex;
            _oMatrix = _oData.oMatrix;
            _oPoint = _oMatrix.transformPoint(new Point(0,Data.iTILE_HEIGHT));
            _iAdjacentC = Math.floor(_oPoint.x / Data.iTILE_WIDTH);
            _iAdjacentR = Math.floor(_oPoint.y / Data.iTILE_HEIGHT);
            startContamination(_iAdjacentC,_iAdjacentR,_uRoomIndex);
         }
      }
      
      public function get currentDoor() : Object
      {
         return oLink.oLinkedMap;
      }
      
      private function update(_e:Event) : void
      {
         dispatchEvent(new BuilderEvent(BuilderEvent.EVENT_UPDATE,false,false));
      }
      
      public function get zoom() : Number
      {
         return nCurrentZoom;
      }
      
      public function set asset(_sNextAsset:String) : void
      {
         sAssetType = _sNextAsset;
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         var _sError:String = null;
         switch(_e.target)
         {
            case mcRef.btnTilesMapLv1:
               oAssetManager.setState(AssetManager.sSTATE_TILES_MAP_LV1);
               break;
            case mcRef.btnTilesMapLv2:
               oAssetManager.setState(AssetManager.sSTATE_TILES_MAP_LV2);
               break;
            case mcRef.btnTilesMapLv3:
               oAssetManager.setState(AssetManager.sSTATE_TILES_MAP_LV3);
               break;
            case mcRef.btnTilesLairLv1:
               oAssetManager.setState(AssetManager.sSTATE_TILES_LAIR_LV1);
               break;
            case mcRef.btnTilesLairLv2:
               oAssetManager.setState(AssetManager.sSTATE_TILES_LAIR_LV2);
               break;
            case mcRef.btnTilesLairLv3:
               oAssetManager.setState(AssetManager.sSTATE_TILES_LAIR_LV3);
               break;
            case mcRef.btnObjectsLv1:
               oAssetManager.setState(AssetManager.sSTATE_OBJECTS_LV1);
               break;
            case mcRef.btnObjectsLv2:
               oAssetManager.setState(AssetManager.sSTATE_OBJECTS_LV2);
               break;
            case mcRef.btnObjectsLv3:
               oAssetManager.setState(AssetManager.sSTATE_OBJECTS_LV3);
               break;
            case mcRef.btnDoorsLv1:
               oAssetManager.setState(AssetManager.sSTATE_DOORS_LV1);
               break;
            case mcRef.btnDoorsLv2:
               oAssetManager.setState(AssetManager.sSTATE_DOORS_LV2);
               break;
            case mcRef.btnDoorsLv3:
               oAssetManager.setState(AssetManager.sSTATE_DOORS_LV3);
               break;
            case mcRef.btnCharacters:
               oAssetManager.setState(AssetManager.sSTATE_CHARACTERS);
               break;
            case mcRef.btnItems:
               oAssetManager.setState(AssetManager.sSTATE_ITEMS);
               break;
            case mcRef.btnKeyItems:
               oAssetManager.setState(AssetManager.sSTATE_KEYITEMS);
               break;
            case mcRef.btnPuzzle:
               oAssetManager.setState(AssetManager.sSTATE_PUZZLE);
               break;
            case mcRef.btnEnemies:
               oAssetManager.setState(AssetManager.sSTATE_ENEMIES);
               break;
            case mcRef.btnMisc:
               oAssetManager.setState(AssetManager.sSTATE_MISC);
               break;
            case mcRef.btnSave:
               _sError = "";
               showError(_sError);
               _sError = locateDoors();
               if(_sError == "")
               {
                  _sError = locateEnemies();
               }
               if(_sError == "")
               {
                  _sError = locateCharacters();
               }
               if(_sError == "")
               {
                  _sError = locateChests();
               }
               if(_sError == "")
               {
                  _sError = locatePuzzles();
               }
               if(_sError == "")
               {
                  _sError = locateDestructables();
               }
               if(_sError == "")
               {
                  _sError = locateWandables();
               }
               if(_sError == "")
               {
                  _sError = locateEvents();
               }
               if(_sError == "")
               {
                  _sError = locateItems();
               }
               oRoomData = new Object();
               if(_sError == "")
               {
                  locateRooms();
               }
               generateRooms();
               showError(_sError);
               save();
               if(Application.path != null && Application.path != "")
               {
                  oFileWriter.save(sFileLoaded,save());
               }
               break;
            case mcRef.btnLoad:
               if(Application.path != null && Application.path != "")
               {
                  sFileLoaded = oFileReader.loadFile();
               }
               destroyMap();
               loadXML(Data.sFILE_FOLDER_PATH + sFileLoaded + Data.sFILE_EXTENSION);
               break;
            case mcRef.btnZoomIn:
               setZoom(nZOOM_IN_VALUE);
               break;
            case mcRef.btnZoomOut:
               setZoom(nZOOM_OUT_VALUE);
               break;
            case mcRef.btnToolMap:
               setTool(sTOOL_MAP);
               break;
            case mcRef.btnToolSelect:
               setTool(sTOOL_SELECT);
               break;
            case mcRef.btnToolErase:
               setTool(sTOOL_ERASER);
               break;
            case mcRef.btnToolRotate:
               setTool(sTOOL_ROTATE);
               break;
            case mcRef.btnToolLink:
               setTool(sTOOL_LINK);
               break;
            case mcRef.btnToolScaleX:
               setTool(sTOOL_SCALE_X);
               break;
            case mcRef.btnToolScaleY:
               setTool(sTOOL_SCALE_Y);
         }
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
      }
      
      private function initMapData() : void
      {
         var _iC:int = 0;
         oMapData = new Object();
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               oMapData["X" + _iC + "Y" + _iR] = new Object();
               oMapData["X" + _iC + "Y" + _iR].oTile = {
                  "mcRef":null,
                  "sLinkage":null,
                  "nRoom":0,
                  "oMatrix":null
               };
               oMapData["X" + _iC + "Y" + _iR].oObject = {
                  "mcRef":null,
                  "sLinkage":null,
                  "nRoom":0,
                  "oMatrix":null,
                  "sPuzzleLink":null,
                  "oLinkedMap":{
                     "sMap":null,
                     "sDoorLink":null
                  }
               };
               oMapData["X" + _iC + "Y" + _iR].oCharacter = {
                  "mcRef":null,
                  "sLinkage":null,
                  "nRoom":0,
                  "oMatrix":null
               };
               oMapData["X" + _iC + "Y" + _iR].oItem = {
                  "mcRef":null,
                  "sLinkage":null,
                  "nRoom":0,
                  "oMatrix":null
               };
               oMapData["X" + _iC + "Y" + _iR].oMisc = {
                  "mcRef":null,
                  "sLinkage":null,
                  "nRoom":0,
                  "oMatrix":null
               };
            }
         }
      }
      
      public function get asset() : String
      {
         return sAssetType;
      }
      
      public function resetSelection() : void
      {
         asset = sPreviousAsset;
         oSelectionData = null;
      }
   }
}
