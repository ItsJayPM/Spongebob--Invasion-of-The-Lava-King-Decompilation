package gameplay
{
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import gameplay.events.DoorEvent;
   import gameplay.events.LevelEvent;
   import gameplay.events.TransitionFocusEvent;
   import library.utils.Base64;
   import library.utils.Path;
   
   public class Level implements IEventDispatcher
   {
      
      public static var Instance:Level = null;
       
      
      private var oEnemiesData:Object;
      
      private var oCharactersData:Object;
      
      private var mcRef:DisplayObjectContainer;
      
      private var oDestructablesData:Object;
      
      private var oDoorsData:Object;
      
      private var oChestsData:Object;
      
      private var oEventDisp:EventDispatcher;
      
      private var oEventsData:Object;
      
      private var oMapData:Object;
      
      private var uLevelKind:uint;
      
      private var oPuzzlesData:Object;
      
      private var oCurrentDoor:Object;
      
      private var oItemsData:Object;
      
      private var oLoader:URLLoader;
      
      private var oMap:Map;
      
      private var oWandablesData:Object;
      
      private var sLoadedFile:String;
      
      public function Level(_mcRef:DisplayObjectContainer)
      {
         super();
         mcRef = _mcRef;
         oEventDisp = new EventDispatcher(this);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(DoorEvent.EVENT_ENTERING_OUTDOOR_DOOR,onOutdoorEntering);
         _oGameDisp.addWeakEventListener(TransitionFocusEvent.EVENT_TRANSITION_MIDDLE,onTransitionFocusFull);
         Instance = this;
      }
      
      private function buildLevelData(_sData:String) : void
      {
         var _oXML:XML = null;
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
         var _oDoorStartPosition:Point = null;
         var _oPosition:Object = null;
         XML.ignoreWhitespace = true;
         var _oFixedObjectsData:Object = new Object();
         if(_sData != "")
         {
            Profile.Instance.loadedMap = sLoadedFile;
            if(Profile.oLoadedMap[sLoadedFile] == null)
            {
               Profile.oLoadedMap[sLoadedFile] = _sData;
            }
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
                     if(AssetData.getAssetData(_oData.sLinkage).sLinkType == undefined && AssetData.getAssetData(_oData.sLinkage).bWandable == undefined && AssetData.getAssetData(_oData.sLinkage).bContainer == undefined && AssetData.getAssetData(_oData.sLinkage).bDestructable == undefined)
                     {
                        _oFixedObjectsData["X" + _iC + "Y" + _iR] = {
                           "linkage":AssetData.getAssetData(_oData.sLinkage).sLinkage,
                           "matrix":_oData.oMatrix
                        };
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
            oMap = new Map(mcRef);
            oMap.buildFloor(oMapData);
            oEventsData = setEventsData(_oXML);
            oWandablesData = setWandablesData(_oXML);
            oDestructablesData = setDestructablesData(_oXML);
            oCharactersData = setCharactersData(_oXML);
            oDoorsData = setDoorsData(_oXML);
            oEnemiesData = setEnemiesData(_oXML);
            oChestsData = setChestsData(_oXML);
            oItemsData = setItemsData(_oXML);
            oPuzzlesData = setPuzzlesData(_oXML);
            if(oCurrentDoor == null)
            {
               oMap.playerStartPosition = getStartPosition();
               _oDoorStartPosition = getStartPosition();
               ++_oDoorStartPosition.y;
               trace(_oDoorStartPosition);
               oMap.doorStartPosition = _oDoorStartPosition;
               oMap.playerStartRoom = getStartRoom();
            }
            else
            {
               _oPosition = getExitDoorPosition();
               oMap.playerStartPosition = new Point(_oPosition.px,_oPosition.py);
               oMap.doorStartPosition = new Point(_oPosition.dx,_oPosition.dy);
               oMap.playerStartRoom = getExitDoorRoom();
               oCurrentDoor = null;
            }
            dispatchEvent(new LevelEvent(LevelEvent.EVENT_CREATE_MAP,oMap));
            oMap.mapData = oMapData;
            oMap.createFixedObjects(_oFixedObjectsData);
            oMap.createEnemies(oEnemiesData);
            oMap.createDoors(oDoorsData,uLevelKind);
            oMap.createPuzzles(oPuzzlesData);
            oMap.createWandables(oWandablesData);
            oMap.createDestructables(oDestructablesData);
            oMap.createCharacters(oCharactersData);
            oMap.createChests(oChestsData);
            oMap.createItems(oItemsData);
            oMap.createEvents(oEventsData);
            oMap.linkIndoorDoors();
            oMap.linkMovingBlocks();
            oMap.enterRoom();
            oMap.swapDepth();
         }
         else
         {
            trace("ERROR : NO MAP FOUND");
         }
      }
      
      public function getViewPositionFromWorld(_nWorldX:Number, _nWorldY:Number) : Point
      {
         if(oMap == null)
         {
            return null;
         }
         return oMap.getViewPositionFromWorld(_nWorldX,_nWorldY);
      }
      
      public function setCurrentDoor(_oPoint:Point) : void
      {
         var _sType:String = null;
         var _iC:Number = Math.floor(_oPoint.x / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_oPoint.y / Data.iTILE_HEIGHT);
         var _oData:Object = getData(AssetData.sTYPE_OBJECT,_iC,_iR);
         oCurrentDoor = new Object();
         oCurrentDoor.sDoorLink = _oData.oLinkedMap.sDoorLink;
         oCurrentDoor.sMap = _oData.oLinkedMap.sMap;
         Profile.Instance.loadedMap = oCurrentDoor.sMap;
         oCurrentDoor.sType = AssetData.sLINK_OUTDOOR;
      }
      
      private function setDestructablesData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _uID:uint = 0;
         var _oData:Object = null;
         var _oDestructablesData:Object = new Object();
         var _sItemLinkage:String = null;
         var _uItemID:uint = 0;
         for(var _iIndex:int = 0; _iIndex < _oXML.des.de.length(); _iIndex++)
         {
            _sItemLinkage = null;
            _uItemID = 0;
            _oData = getData(AssetData.sTYPE_OBJECT,_oXML.des.child(_iIndex).@c,_oXML.des.child(_iIndex).@r);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            if(_oXML.des.child(_iIndex).@i != undefined && !Profile.Instance.getUniqueData(_oXML.des.child(_iIndex).@c,_oXML.des.child(_iIndex).@r))
            {
               _sItemLinkage = AssetData.getAssetData(_oXML.des.child(_iIndex).@i).sLinkage;
               _uItemID = AssetData.getAssetData(_sItemLinkage).sID;
            }
            _oDestructablesData[_iIndex] = {
               "linkage":_sLinkage,
               "id":_uID,
               "matrix":_oData.oMatrix,
               "itemLinkage":_sItemLinkage,
               "itemID":_uItemID
            };
         }
         return _oDestructablesData;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      private function setDoorsData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _oMatrixExit:Matrix = null;
         var _nPosX:Number = NaN;
         var _nPosY:Number = NaN;
         var _oData:Object = null;
         var _oDataExit:Object = null;
         var _sMap:String = null;
         var _uID:uint = 0;
         var _bOpen:Boolean = false;
         var _oDoorsData:Object = new Object();
         for(var _iIndex:int = 0; _iIndex < _oXML.ds.d.length(); _iIndex++)
         {
            _bOpen = false;
            _sMap = null;
            _oMatrixExit = null;
            _oData = getData(AssetData.sTYPE_OBJECT,_oXML.ds.child(_iIndex).@c,_oXML.ds.child(_iIndex).@r);
            if(_oXML.ds.child(_iIndex).@type == AssetData.sLINK_INDOOR)
            {
               _oDataExit = getData(AssetData.sTYPE_OBJECT,_oXML.ds.child(_iIndex).@exit_c,_oXML.ds.child(_iIndex).@exit_r);
               _oMatrixExit = _oDataExit.oMatrix.clone();
               _sMap = _oXML.ds.child(_iIndex).@map;
            }
            _bOpen = Profile.Instance.getUniqueData(_oXML.ds.child(_iIndex).@c,_oXML.ds.child(_iIndex).@r);
            trace(">> Check door : ",_oXML.ds.child(_iIndex).@c,_oXML.ds.child(_iIndex).@r);
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            if(!_bOpen)
            {
               if(_uID == Data.uDOOR_SANDY)
               {
                  if(Profile.Instance.getNbrHelpSandy() >= Profile.Instance.getCurrentEpisode() - 1)
                  {
                     _bOpen = true;
                  }
               }
               else if(_uID == Data.uDOOR_SQUIDWARD)
               {
                  if(Profile.Instance.getNbrHelpSquidward() >= Profile.Instance.getCurrentEpisode() - 1)
                  {
                     _bOpen = true;
                  }
               }
               else if(_uID == Data.uDOOR_EPISODE)
               {
                  if(Profile.Instance.getCurrentEpisode() < Data.uHIGHEST_EPISODE_UNLOCKED)
                  {
                     if(Profile.Instance.getNbrKillBoss() >= Profile.Instance.getCurrentEpisode())
                     {
                        _bOpen = true;
                     }
                  }
               }
               else if(oCurrentDoor != null && _oXML.ds.child(_iIndex).@type == oCurrentDoor.sType && _oXML.ds.child(_iIndex).@doorLink == oCurrentDoor.sDoorLink)
               {
                  Profile.Instance.saveUniqueData(new Point(_oData.oMatrix.tx,_oData.oMatrix.ty));
                  _bOpen = true;
               }
            }
            trace("_oData.nRoom : " + _oData.nRoom);
            _oDoorsData[_iIndex] = {
               "linkage":_sLinkage,
               "id":_uID,
               "room":_oData.nRoom,
               "type":_oXML.ds.child(_iIndex).@type,
               "doorLink":_oXML.ds.child(_iIndex).@doorLink,
               "map":_sMap,
               "matrix":_oData.oMatrix.clone(),
               "matrixExit":_oMatrixExit,
               "open":_bOpen
            };
         }
         return _oDoorsData;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function setEnemiesData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _uID:uint = 0;
         var _sItemLinkage:String = null;
         var _uItemID:uint = 0;
         var _oData:Object = null;
         var _bCreate:Boolean = false;
         var l:* = null;
         var _oEnemiesData:Object = new Object();
         for(var _iIndex:int = 0; _iIndex < _oXML.es.e.length(); _iIndex++)
         {
            _bCreate = true;
            _uItemID = 0;
            _sItemLinkage = null;
            _oData = getData(AssetData.sTYPE_CHARACTER,_oXML.es.child(_iIndex).@c,_oXML.es.child(_iIndex).@r);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            if(_oXML.es.child(_iIndex).@i != undefined && !Profile.Instance.getUniqueData(_oXML.es.child(_iIndex).@c,_oXML.es.child(_iIndex).@r))
            {
               _sItemLinkage = AssetData.getAssetData(_oXML.es.child(_iIndex).@i).sLinkage;
               _uItemID = AssetData.getAssetData(_sItemLinkage).sID;
            }
            for(l in oCharactersData)
            {
               if(oCharactersData[l].id == Data.uCHARACTER_SQUIDWARD)
               {
                  if(Profile.Instance.getNbrHelpSquidward() >= Profile.Instance.getCurrentEpisode())
                  {
                     _bCreate = false;
                     break;
                  }
               }
            }
            if(_bCreate)
            {
               if(_uID == Data.uBOSS_GASEOUS_ROCK && Profile.Instance.getNbrKillBoss() >= Profile.Instance.getCurrentEpisode())
               {
                  _bCreate = false;
               }
            }
            if(_bCreate)
            {
               _oEnemiesData[_iIndex] = {
                  "linkage":_sLinkage,
                  "id":_uID,
                  "room":_oData.nRoom,
                  "matrix":_oData.oMatrix,
                  "itemLinkage":_sItemLinkage,
                  "itemID":_uItemID
               };
            }
         }
         return _oEnemiesData;
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
      
      private function setCharactersData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _uID:uint = 0;
         var _oData:Object = null;
         var _oCharactersData:Object = new Object();
         var _uEpisode:uint = Profile.Instance.getCurrentEpisode();
         for(var _iIndex:int = 0; _iIndex < _oXML.chs.ch.length(); _iIndex++)
         {
            _oData = getData(AssetData.sTYPE_CHARACTER,_oXML.chs.child(_iIndex).@c,_oXML.chs.child(_iIndex).@r);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            _oCharactersData[_iIndex] = {
               "linkage":_sLinkage,
               "id":_uID,
               "room":_oData.nRoom,
               "episode":_uEpisode,
               "matrix":_oData.oMatrix
            };
         }
         return _oCharactersData;
      }
      
      public function getTilePushable(_oPoint:Point, _sDirection:String) : Boolean
      {
         var _bPushable:Boolean = false;
         switch(_sDirection)
         {
            case "Up":
               break;
            case "Down":
               break;
            case "Left":
               break;
            case "Right":
         }
         return _bPushable;
      }
      
      public function getSnapshot() : BitmapData
      {
         if(oMap == null)
         {
            return null;
         }
         return oMap.snapshot();
      }
      
      public function loadLevel(_sFileName:String) : void
      {
         var _oRequest:URLRequest = null;
         trace("Level : loadLevel",_sFileName);
         initMapData();
         if(oMap != null)
         {
            oMap.destroy();
            oMap = null;
         }
         sLoadedFile = _sFileName;
         trace("sLoadedFile : " + sLoadedFile);
         if(sLoadedFile.indexOf("dungeon") != -1)
         {
            uLevelKind = Data.uLEVEL_DUNGEON;
            Main.instance.switchToDungeonMusic();
         }
         else if(sLoadedFile.indexOf("boss") != -1)
         {
            uLevelKind = Data.uLEVEL_DUNGEON;
            if(Profile.Instance.getNbrKillBoss() >= Profile.Instance.getCurrentEpisode())
            {
               Main.instance.switchToGameMusic();
            }
            else
            {
               Main.instance.switchToBossMusic();
            }
         }
         else if(sLoadedFile.indexOf("world") != -1)
         {
            uLevelKind = Data.uLEVEL_WORLD;
            Main.instance.switchToGameMusic();
         }
         else
         {
            uLevelKind = Data.uLEVEL_DUNGEON;
            Main.instance.switchToGameMusic();
         }
         oLoader = new URLLoader();
         if(Profile.oLoadedMap[sLoadedFile] == null)
         {
            _sFileName = Data.sFILE_FOLDER_PATH + _sFileName + Data.sFILE_EXTENSION;
            _oRequest = new URLRequest(Path.getPath(Main.instance.stage) + _sFileName);
            oLoader.addEventListener(Event.COMPLETE,onLoadXML,false,0,true);
            oLoader.load(_oRequest);
         }
         else
         {
            oLoader = null;
            buildLevelData(Profile.oLoadedMap[sLoadedFile]);
            dispatchEvent(new LevelEvent(LevelEvent.EVENT_FINISH_MAP_CREATION,oMap));
         }
      }
      
      private function getStartRoom() : uint
      {
         var i:* = null;
         var _uRoom:uint = 0;
         for(i in oCharactersData)
         {
            if(oCharactersData[i].id == Data.uCHARACTER_SPONGEBOB)
            {
               _uRoom = oCharactersData[i].room;
            }
         }
         return _uRoom;
      }
      
      public function getTileBlocker(_oPoint:Point) : Object
      {
         var _oBlocker:Object = null;
         var _iC:Number = Math.floor(_oPoint.x / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_oPoint.y / Data.iTILE_HEIGHT);
         var _oData:Object = getData(AssetData.sTYPE_MISC,_iC,_iR);
         if(_oData.sLinkage != null)
         {
            _oBlocker = new Object();
            _oBlocker.sType = AssetData.getAssetData(_oData.sLinkage).sBlocker;
            _oBlocker.oMatrix = _oData.oMatrix;
         }
         return _oBlocker;
      }
      
      private function onOutdoorEntering(_e:DoorEvent) : void
      {
         setCurrentDoor(_e.worldSource);
      }
      
      private function setItemsData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _uID:uint = 0;
         var _oData:Object = null;
         var _bTaken:Boolean = false;
         var _oItemsData:Object = new Object();
         for(var _iIndex:int = 0; _iIndex < _oXML.its.it.length(); _iIndex++)
         {
            _bTaken = false;
            _oData = getData(AssetData.sTYPE_ITEM,_oXML.its.child(_iIndex).@c,_oXML.its.child(_iIndex).@r);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            trace(">>>>>>> set Items Data : ",_uID,Profile.Instance.getUniqueData(_oXML.its.child(_iIndex).@c,_oXML.its.child(_iIndex).@r));
            if(!Profile.Instance.getUniqueData(_oXML.its.child(_iIndex).@c,_oXML.its.child(_iIndex).@r))
            {
               _oItemsData[_iIndex] = {
                  "linkage":_sLinkage,
                  "id":_uID,
                  "room":_oData.nRoom,
                  "matrix":_oData.oMatrix,
                  "taken":_bTaken
               };
            }
         }
         return _oItemsData;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function getExitDoorPosition() : Object
      {
         var i:* = null;
         var _oPoint:Point = null;
         var _oPosition:Object = new Object();
         for(i in oDoorsData)
         {
            if(oDoorsData[i].type == oCurrentDoor.sType && oDoorsData[i].doorLink == oCurrentDoor.sDoorLink)
            {
               _oPosition.dx = oDoorsData[i].matrix.tx;
               _oPosition.dy = oDoorsData[i].matrix.ty;
               _oPoint = oDoorsData[i].matrix.transformPoint(new Point(0,Data.iTILE_HEIGHT));
               _oPosition.px = _oPoint.x;
               _oPosition.py = _oPoint.y;
            }
         }
         return _oPosition;
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function onTransitionFocusFull(_e:TransitionFocusEvent = null) : void
      {
         if(!Player.Instance.isDying())
         {
            loadLevel(Profile.Instance.loadedMap);
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function get map() : Map
      {
         return oMap;
      }
      
      public function getExitDoorRoom() : uint
      {
         var i:* = null;
         var _uRoom:uint = 0;
         for(i in oDoorsData)
         {
            if(oDoorsData[i].type == oCurrentDoor.sType && oDoorsData[i].doorLink == oCurrentDoor.sDoorLink)
            {
               _uRoom = oDoorsData[i].room;
            }
         }
         return _uRoom;
      }
      
      private function setChestsData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _uID:uint = 0;
         var _sItemLinkage:String = null;
         var _uItemID:uint = 0;
         var _oData:Object = null;
         var _bOpen:Boolean = false;
         var _oChestsData:Object = new Object();
         for(var _iIndex:int = 0; _iIndex < _oXML.cs.c.length(); _iIndex++)
         {
            _bOpen = false;
            _uItemID = 0;
            _sItemLinkage = null;
            _oData = getData(AssetData.sTYPE_OBJECT,_oXML.cs.child(_iIndex).@c,_oXML.cs.child(_iIndex).@r);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            if(_oXML.cs.child(_iIndex).@i != undefined && !Profile.Instance.getUniqueData(_oXML.cs.child(_iIndex).@c,_oXML.cs.child(_iIndex).@r))
            {
               _sItemLinkage = AssetData.getAssetData(_oXML.cs.child(_iIndex).@i).sLinkage;
               _uItemID = AssetData.getAssetData(_sItemLinkage).sID;
            }
            if(Profile.Instance.getUniqueData(_oXML.cs.child(_iIndex).@c,_oXML.cs.child(_iIndex).@r))
            {
               _bOpen = true;
            }
            _oChestsData[_iIndex] = {
               "linkage":_sLinkage,
               "id":_uID,
               "room":_oData.nRoom,
               "matrix":_oData.oMatrix,
               "itemLinkage":_sItemLinkage,
               "itemID":_uItemID,
               "open":_bOpen
            };
         }
         return _oChestsData;
      }
      
      public function removeDoorMask() : void
      {
         if(oMap != null)
         {
            oMap.onRemoveDoorMask();
         }
      }
      
      private function setEventsData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _uID:uint = 0;
         var _oData:Object = null;
         var _bCreate:Boolean = false;
         var _oEventsData:Object = new Object();
         trace("_oXML.evs.ev.length() : " + _oXML.evs.ev.length());
         for(var _iIndex:int = 0; _iIndex < _oXML.evs.ev.length(); _iIndex++)
         {
            _oData = getData(AssetData.sTYPE_MISC,_oXML.evs.child(_iIndex).@c,_oXML.evs.child(_iIndex).@r);
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            _bCreate = true;
            if(_uID == Data.uEVENT_GAP1 || _uID == Data.uEVENT_GAP2 || _uID == Data.uEVENT_GAP3)
            {
               switch(_uID)
               {
                  case _uID == Data.uEVENT_GAP1:
                     Profile.Instance.setCurrentEpisode(1);
                     break;
                  case _uID == Data.uEVENT_GAP2:
                     Profile.Instance.setCurrentEpisode(2);
                     break;
                  case _uID == Data.uEVENT_GAP3:
                     Profile.Instance.setCurrentEpisode(3);
               }
            }
            else
            {
               if(Profile.Instance.getUniqueData(_oXML.evs.child(_iIndex).@c,_oXML.evs.child(_iIndex).@r))
               {
                  _bCreate = false;
               }
               if(_bCreate)
               {
                  _oEventsData[_iIndex] = {
                     "id":_uID,
                     "room":_oData.nRoom,
                     "matrix":_oData.oMatrix
                  };
               }
            }
         }
         return _oEventsData;
      }
      
      private function setWandablesData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _oData:Object = null;
         var _oWandablesData:Object = new Object();
         for(var _iIndex:int = 0; _iIndex < _oXML.ws.w.length(); _iIndex++)
         {
            _oData = getData(AssetData.sTYPE_OBJECT,_oXML.ws.child(_iIndex).@c,_oXML.ws.child(_iIndex).@r);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _oWandablesData[_iIndex] = {
               "linkage":_sLinkage,
               "room":_oData.nRoom,
               "matrix":_oData.oMatrix
            };
         }
         return _oWandablesData;
      }
      
      private function onLoadXML(_e:Event = null) : void
      {
         buildLevelData(_e.target.data);
         oLoader.removeEventListener(Event.COMPLETE,onLoadXML,false);
         oLoader = null;
         dispatchEvent(new LevelEvent(LevelEvent.EVENT_FINISH_MAP_CREATION,oMap));
      }
      
      private function getStartPosition() : Point
      {
         var i:* = null;
         var _oPoint:Point = null;
         for(i in oCharactersData)
         {
            if(oCharactersData[i].id == Data.uCHARACTER_SPONGEBOB)
            {
               _oPoint = new Point();
               _oPoint.x = oCharactersData[i].matrix.tx;
               _oPoint.y = oCharactersData[i].matrix.ty;
            }
         }
         return _oPoint;
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
      
      public function destroy(_e:Event = null) : void
      {
         Instance = null;
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(DoorEvent.EVENT_ENTERING_OUTDOOR_DOOR,onOutdoorEntering);
         _oGameDisp.removeEventListener(TransitionFocusEvent.EVENT_TRANSITION_MIDDLE,onTransitionFocusFull);
         oMapData = null;
         oDoorsData = null;
         oChestsData = null;
         oEnemiesData = null;
         oCharactersData = null;
         oItemsData = null;
         oDestructablesData = null;
         oPuzzlesData = null;
         oEventsData = null;
         oLoader = null;
         oMap.destroy();
         oMap = null;
      }
      
      private function setPuzzlesData(_oXML:XML) : Object
      {
         var _sLinkage:String = null;
         var _oMatrixExit:Matrix = null;
         var _nPosX:Number = NaN;
         var _nPosY:Number = NaN;
         var _uID:uint = 0;
         var _oData:Object = null;
         var _bSolved:Boolean = false;
         var l:* = null;
         var i:* = null;
         trace("SET PUZZLES");
         var _oPuzzlesData:Object = new Object();
         for(var _iIndex:int = 0; _iIndex < _oXML.ps.p.length(); _iIndex++)
         {
            _bSolved = true;
            _oData = getData(AssetData.sTYPE_OBJECT,_oXML.ps.child(_iIndex).@c,_oXML.ps.child(_iIndex).@r);
            for(l in _oData)
            {
               trace("key : " + l + ", value : " + _oData[l]);
            }
            trace("_oData : " + _oData);
            trace("_oData.sLinkage : " + _oData.sLinkage);
            _sLinkage = AssetData.getAssetData(_oData.sLinkage).sLinkage;
            _uID = AssetData.getAssetData(_oData.sLinkage).sID;
            _oMatrixExit = _oData.oMatrix.clone();
            _nPosX = _oXML.ps.child(_iIndex).@spC * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
            _nPosY = _oXML.ps.child(_iIndex).@spR * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
            _oMatrixExit.tx = _nPosX;
            _oMatrixExit.ty = _nPosY;
            for(i in oEventsData)
            {
               trace("_oData.nRoom : " + _oData.nRoom);
               trace("oEventsData[i].room : " + oEventsData[i].room);
               if(oEventsData[i].id == Data.uEVENT_PUZZLE_SOLVED && oEventsData[i].room == _oData.nRoom)
               {
                  _bSolved = false;
                  break;
               }
            }
            trace("_bSolved : " + _bSolved);
            _oPuzzlesData[_iIndex] = {
               "linkage":_sLinkage,
               "id":_uID,
               "room":_oData.nRoom,
               "matrix":_oData.oMatrix,
               "matrixExit":_oMatrixExit,
               "bSolved":_bSolved
            };
         }
         return _oPuzzlesData;
      }
   }
}
