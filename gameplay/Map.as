package gameplay
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import gameplay.bosses.GaseousRock;
   import gameplay.enemies.Eel;
   import gameplay.enemies.Jellyfish;
   import gameplay.events.CameraEvent;
   import gameplay.events.DropItemEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.ProjectileEvent;
   import gameplay.events.RoomEvent;
   import gameplay.events.ThrowEvent;
   import gameplay.interfaces.ILevelCollidable;
   import gameplay.projectiles.Boomerang;
   import gameplay.projectiles.GasCloud;
   import gameplay.projectiles.GasSpout;
   import gameplay.projectiles.SeaUrchin;
   import library.utils.DepthManager;
   import library.utils.MoreMath;
   
   public class Map implements IEventDispatcher
   {
      
      public static const sDEPTH_Z_UNDER:String = "under";
      
      private static const uLOCAL_EYE_Y:uint = Math.round(Data.iSTAGE_HEIGHT / 2);
      
      private static const uZ_BUFFERING_SORT_RATE:uint = 2;
      
      public static const sDEPTH_Z_BUFFERING:String = "buffering";
      
      public static const sDEPTH_Z_OVER:String = "mask";
      
      private static var uId:Number = 1;
      
      public static const uPROJECTILE_BOOMERANG:uint = uId++;
      
      public static const uPROJECTILE_SEA_URCHIN:uint = uId++;
      
      private static const uLOCAL_EYE_X:uint = 280;
      
      public static const sDEPTH_BUBBLE:String = "bubble";
      
      public static const sDEPTH_FLOOR:String = "floor";
       
      
      private var aFixedObjects:Array;
      
      private var oMaskBitmap:Bitmap;
      
      private var aBreakables:Array;
      
      private var mcRef:DisplayObjectContainer;
      
      private var oFloorBitmapData:BitmapData;
      
      private var bNeedZOrdering:Boolean;
      
      private var oCameraZone:Rectangle;
      
      private var uZOrderingSince:uint;
      
      private var aBlocks:Array;
      
      private var uPlayerStartRoom:uint;
      
      private var aChests:Array;
      
      private var bTargetPlayer:Boolean;
      
      private var aFloorItems:Array;
      
      private var aOutdoors:Array;
      
      private var aIndoorsLink:Array;
      
      private var oFloorBitmap:Bitmap;
      
      private var aEnemies:Array;
      
      private var oDepthManager:DepthManager;
      
      private var aProjectiles:Array;
      
      private var oPlayerStartPoint:Point;
      
      private var aCharacters:Array;
      
      private var oCameraLimits:Rectangle;
      
      private var oEventDisp:EventDispatcher;
      
      private var oMapData:Object;
      
      private var oRooms:Object;
      
      private var oMaskBitmapData:BitmapData;
      
      private var aEvents:Array;
      
      private var aIndoors:Array;
      
      private var oDoorStartPoint:Point;
      
      public function Map(_mcRef:DisplayObjectContainer, _iLimitsLeft:int = 0, _iLimitsTop:int = 0, _iLimitsRight:int = 1800, _iLimitsBottom:int = 1800)
      {
         super();
         mcRef = _mcRef;
         oDepthManager = new DepthManager();
         oDepthManager.addDepthLayer(sDEPTH_FLOOR,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_Z_UNDER,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_Z_BUFFERING,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_Z_OVER,mcRef);
         oDepthManager.addDepthLayer(sDEPTH_BUBBLE,mcRef);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _dpLayer.addEventListener(Event.ADDED,onAddingChild,false,-1,true);
         oCameraLimits = new Rectangle();
         oCameraLimits.x = _iLimitsLeft;
         oCameraLimits.y = _iLimitsTop;
         oCameraLimits.right = _iLimitsRight;
         oCameraLimits.bottom = _iLimitsBottom;
         oCameraZone = new Rectangle(0,0,Data.iSTAGE_WIDTH,Data.iSTAGE_HEIGHT);
         oRooms = new Object();
         aEnemies = new Array();
         aProjectiles = new Array();
         aBreakables = new Array();
         aFloorItems = new Array();
         aIndoorsLink = new Array();
         aIndoors = new Array();
         aOutdoors = new Array();
         aFixedObjects = new Array();
         aCharacters = new Array();
         aBlocks = new Array();
         aChests = new Array();
         aEvents = new Array();
         oEventDisp = new EventDispatcher(this);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_ENEMY,onEnemyDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_BREAKABLE_PROP,onBreakableDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_FLOOR_ITEM,onFloorItemDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_INDOOR_DOOR,onIndoorDoorDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_OUTDOOR_DOOR,onOutdoorDoorDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_FIXED_OBJECT,onFixedObjectDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_SANDY,onCharacterDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_PATRICK,onCharacterDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_SQUIDWARD,onCharacterDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_KRAB,onCharacterDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_MOVING_BLOCK,onMovingBlockDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_PUZZLE_NODE,onEventTileDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_INTRO_NODE,onEventTileDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_TUTORIAL_NODE,onEventTileDestroy);
         _oGameDisp.addWeakEventListener(MapGenerateEvent.EVENT_DESTROY_CHEST,onChestDestroy);
         _oGameDisp.addWeakEventListener(ThrowEvent.EVENT_ENEMY_THROW_PROJECTILE,onProjectileThrow);
         _oGameDisp.addWeakEventListener(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,onProjectileThrow);
         _oGameDisp.addWeakEventListener(ProjectileEvent.EVENT_DESTROY,onProjectileDestroy);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.addWeakEventListener(GameEvent.EVENT_PAUSE,pause);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck,false,5,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck,false,999,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck,false,5,true);
         _oGameDisp.addEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck,false,999,true);
         _oGameDisp.addWeakEventListener(DropItemEvent.EVENT_DROP_ITEM,onDropItem);
         _oGameDisp.addWeakEventListener(DropItemEvent.EVENT_FOUND_ITEM_IN_CHEST,onFoundItem);
         disableCameraOnPlayer();
         uZOrderingSince = uZ_BUFFERING_SORT_RATE;
         bNeedZOrdering = false;
      }
      
      private function getActiveEnemiesPositions() : Array
      {
         var _oEn:Enemy = null;
         var i:* = null;
         var _aRet:Array = [];
         for(i in aEnemies)
         {
            _oEn = aEnemies[i];
            _aRet.push(_oEn.mcRef.x,_oEn.mcRef.y);
         }
         return _aRet;
      }
      
      public function getViewPositionFromWorld(_nWorldX:Number, _nWorldY:Number) : Point
      {
         var _oRet:Point = new Point(_nWorldX,_nWorldY);
         return mcRef.localToGlobal(_oRet);
      }
      
      public function createProjectile(_uProjType:uint, _nWorldX:Number, _nWorldY:Number, _nStartingOrientation:Number = 0) : void
      {
         var _mcRef:MovieClip = null;
         var _oProj:Projectile = null;
         trace("Map : Create projectile ",_uProjType);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         switch(_uProjType)
         {
            case ThrowEvent.uPROJECTILE_SEA_URCHIN:
               _mcRef = new mcProjectileSeaUrchin();
               _mcRef.x = _nWorldX;
               _mcRef.y = _nWorldY;
               _dpLayer.addChild(_mcRef);
               _oProj = new SeaUrchin(_mcRef,_nStartingOrientation);
               break;
            case ThrowEvent.uPROJECTILE_BOOMERANG:
               _mcRef = new mcBoomerang();
               _mcRef.x = _nWorldX;
               _mcRef.y = _nWorldY;
               _dpLayer.addChild(_mcRef);
               _oProj = new Boomerang(_mcRef,_nStartingOrientation,getActiveEnemiesPositions(),getActiveFloorItemsPositions());
               break;
            case ThrowEvent.uPROJECTILE_GAS_SPOUT:
               _mcRef = new mcProjectileGasCloud();
               _mcRef.x = _nWorldX;
               _mcRef.y = _nWorldY;
               _dpLayer.addChild(_mcRef);
               _oProj = new GasSpout(_mcRef,_nStartingOrientation);
               break;
            case ThrowEvent.uPROJECTILE_GAS_CLOUD:
               _mcRef = new mcProjectileGasCloud();
               _mcRef.x = _nWorldX;
               _mcRef.y = _nWorldY;
               _dpLayer.addChild(_mcRef);
               _oProj = new GasCloud(_mcRef,_nStartingOrientation);
         }
         aProjectiles.push(_oProj);
      }
      
      private function onIndoorDoorDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Indoor door destroyed : ",_e.instance);
         var _iIndex:int = aIndoors.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aIndoors.splice(_iIndex,1);
         }
      }
      
      public function createDestructable(_sLinkage:String, _uID:uint, _uRoom:uint, _oWorldMatrix:Matrix, _sItemLinkage:String, _uItemID:uint = 0) : void
      {
         var _sEventType:String = null;
         var _oProp:BreakableProp = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create destructables");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         var _uItemToDrop:uint = _uItemID;
         switch(_uID)
         {
            case Data.uDESTRUCTABLE_ORGANIC:
               if(_uItemToDrop == ItemID.uNULL_ITEM)
               {
                  _uItemToDrop = throwItemFromDropTable(Data.aSEAWEED_DROP_TABLE);
               }
               _oProp = new BreakableProp(_mcRef,_oRoom,[ItemID.uSWORD_LV_1,ItemID.uSWORD_LV_2,ItemID.uBOOMERANG,ItemID.uSEA_URCHIN],Data.uSCORE_SEA_WEEDS,_uItemToDrop);
               break;
            case Data.uDESTRUCTABLE_SOLID:
               if(_uItemToDrop == ItemID.uNULL_ITEM)
               {
                  _uItemToDrop = throwItemFromDropTable(Data.aCORAL_DROP_TABLE);
               }
               _oProp = new BreakableProp(_mcRef,_oRoom,[ItemID.uSWORD_LV_2],Data.uSCORE_CORALS,_uItemToDrop);
               break;
            case Data.uDESTRUCTABLE_EXPLOSIVE:
               if(_uItemToDrop == ItemID.uNULL_ITEM)
               {
                  _uItemToDrop = throwItemFromDropTable(Data.aROCK_DROP_TABLE);
               }
               _oProp = new BreakableProp(_mcRef,_oRoom,[ItemID.uVOLCANIC_URCHIN],Data.uSCORE_ROCKS,_uItemToDrop);
         }
         aBreakables.push(_oProp);
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_CREATE_BREAKABLE_PROP,_oProp));
      }
      
      private function onOutdoorDoorDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Outdoor door destroyed : ",_e.instance);
         var _iIndex:int = aOutdoors.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aOutdoors.splice(_iIndex,1);
         }
      }
      
      private function throwPeeble() : uint
      {
         var _uThrow:uint = MoreMath.getRandomRange(1,100);
         var _uRet:uint = ItemID.uNULL_ITEM;
         if(_uThrow <= Data.nPEEBLE_DROP_10)
         {
            _uRet = ItemID.uPEEBLES_10;
         }
         else if(_uThrow + Data.nPEEBLE_DROP_10 <= Data.nPEEBLE_DROP_5)
         {
            _uRet = ItemID.uPEEBLES_5;
         }
         else if(_uThrow + Data.nPEEBLE_DROP_10 + Data.nPEEBLE_DROP_5 <= Data.nPEEBLE_DROP_1)
         {
            _uRet = ItemID.uPEBBLE_1;
         }
         return _uRet;
      }
      
      private function getActiveFloorItemsPositions() : Array
      {
         var _oItem:FloorItem = null;
         var i:* = null;
         var _aRet:Array = [];
         for(i in aFloorItems)
         {
            _oItem = aFloorItems[i];
            _aRet.push(_oItem.mcRef.x,_oItem.mcRef.y);
         }
         return _aRet;
      }
      
      public function createFixedObjects(_oFixedObjectsData:Object) : void
      {
         var i:* = null;
         for(i in _oFixedObjectsData)
         {
            createFixedObject(_oFixedObjectsData[i].linkage,_oFixedObjectsData[i].matrix);
         }
      }
      
      private function bumpOnWall(_oFrom:Point, _oTo:Point, _oWallFrom:Point, _oWallTo:Point) : Object
      {
         var _oI:Point = getIntersectionPoint(_oFrom,_oTo,_oWallFrom,_oWallTo);
         if(_oI == null || isNaN(_oI.x))
         {
            return null;
         }
         var _nLen:Number = Math.sqrt(Math.pow(_oI.x - _oTo.x,2) + Math.pow(_oI.y - _oTo.y,2));
         var _oRet:Object = new Object();
         if(_nLen <= 0)
         {
            _nLen = 0.1;
         }
         _oRet.oBumpResult = new Point();
         var _oN:Point = new Point(-_oWallTo.y + _oWallFrom.y,_oWallTo.x - _oWallFrom.x);
         _oN.normalize(1);
         var _oDisp:Point = _oTo.subtract(_oFrom);
         var _nDot:Number = _oDisp.x * _oN.x + _oDisp.y * _oN.y;
         _oRet.oBumpResult.x = _oDisp.x - 2 * _oN.x * _nDot;
         _oRet.oBumpResult.y = _oDisp.y - 2 * _oN.y * _nDot;
         _oRet.oBumpResult.normalize(_nLen);
         _oRet.oBumpResult.offset(_oI.x,_oI.y);
         var _oU:Point = _oTo.subtract(_oI);
         var _oV:Point = _oWallFrom.subtract(_oI);
         if(Math.abs(_oV.x - 0) <= 0.01 && Math.abs(_oV.y - 0) < 0.01)
         {
            _oV = _oWallTo.subtract(_oI);
         }
         var _nProjScalar:Number = (_oU.x * _oV.x + _oU.y * _oV.y) / (_oV.x * _oV.x + _oV.y * _oV.y);
         var _oSlide:Point = _oV.clone();
         _oSlide.x *= _nProjScalar;
         _oSlide.y *= _nProjScalar;
         var _oAdd:Point = _oFrom.subtract(_oTo);
         _oAdd.normalize(0.1);
         _oI = _oI.add(_oAdd);
         _oRet.oContact = _oI.clone();
         _oRet.oSlideResult = _oSlide.add(_oI);
         return _oRet;
      }
      
      private function getData(_sType:String, _iC:int, _iR:int) : Object
      {
         var _oData:Object = null;
         if(_iC < 0 || _iC * Data.iTILE_WIDTH > Data.iMAP_WIDTH || _iR < 0 || _iR * Data.iTILE_HEIGHT > Data.iMAP_HEIGHT)
         {
            return null;
         }
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
      
      public function onRemoveDoorMask() : void
      {
         var _dpLayer:DisplayObjectContainer = null;
         if(oMaskBitmap != null)
         {
            _dpLayer = oDepthManager.getDepthLayer(sDEPTH_Z_OVER);
            _dpLayer.removeChild(oMaskBitmap);
            oMaskBitmapData.dispose();
            oMaskBitmapData = null;
            oMaskBitmap = null;
         }
      }
      
      private function createRoomIfNotCreated(_uId:uint) : Room
      {
         var oRoomIns:Room = oRooms["r" + _uId] as Room;
         if(oRoomIns == null)
         {
            trace("Map : Create Room # ",_uId);
            oRooms["r" + _uId] = new Room(_uId);
            oRoomIns = oRooms["r" + _uId] as Room;
            oRoomIns.addWeakEventListener(RoomEvent.EVENT_ENTER_ROOM,onEnteringRoom);
            oRoomIns.addWeakEventListener(RoomEvent.EVENT_LEAVE_ROOM,onLeavingRoom);
         }
         return oRoomIns;
      }
      
      public function createItems(_oItemsData:Object) : void
      {
         var i:* = null;
         for(i in _oItemsData)
         {
            createFloorItem(_oItemsData[i].linkage,_oItemsData[i].id,_oItemsData[i].room,_oItemsData[i].matrix);
         }
      }
      
      public function createEvents(_oEventsData:Object) : void
      {
         var i:* = null;
         for(i in _oEventsData)
         {
            createEvent(_oEventsData[i].id,_oEventsData[i].room,_oEventsData[i].matrix);
         }
      }
      
      public function createFixedObject(_sLinkage:String, _oWorldMatrix:Matrix) : void
      {
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create fixed Object");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         var _oFixedObj:FixedTile = new FixedTile(_mcRef);
         aFixedObjects.push(_oFixedObj);
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_CREATE_FIXED_OBJECT,_oFixedObj));
      }
      
      private function onChestDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Chest destroyed");
         var _iIndex:int = aChests.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aChests.splice(_iIndex,1);
         }
      }
      
      private function floatEquals(_n1:Number, _n2:Number) : Boolean
      {
         return Math.abs(_n1 - _n2) < 0.001;
      }
      
      public function buildFloor(_oMapData:Object) : void
      {
         var _sType:String = null;
         var _cClass:Class = null;
         var _iC:int = 0;
         var _oData:Object = null;
         oFloorBitmapData = new BitmapData(Data.iMAP_WIDTH,Data.iMAP_HEIGHT,false,0);
         oFloorBitmap = new Bitmap(oFloorBitmapData,"auto",false);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_FLOOR);
         var _nColumnMax:int = Data.iMAP_WIDTH / Data.iTILE_WIDTH;
         var _nRowMax:int = Data.iMAP_HEIGHT / Data.iTILE_HEIGHT;
         for(var _iR:int = 0; _iR < _nRowMax; _iR++)
         {
            for(_iC = 0; _iC < _nColumnMax; _iC++)
            {
               _oData = _oMapData["X" + _iC + "Y" + _iR].oTile;
               if(_oData.sLinkage != null)
               {
                  _sType = AssetData.getAssetData(_oData.sLinkage).sType;
                  if(_sType == AssetData.sTYPE_TILE)
                  {
                     _cClass = getDefinitionByName(_oData.sLinkage) as Class;
                     oFloorBitmapData.draw(new _cClass(),_oData.oMatrix);
                  }
               }
            }
         }
         _dpLayer.addChild(oFloorBitmap);
      }
      
      public function createMovingBlock(_sLinkage:String, _uRoom:uint, _oWorldMatrix:Matrix, _oWorldMatrixExit:Matrix, _bSolved:Boolean = false) : void
      {
         var _oBlock:MovingBlock = null;
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create moving block");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_UNDER);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         var _oSolvedPos:Point = new Point(0,0);
         _oSolvedPos = _oWorldMatrixExit.transformPoint(_oSolvedPos);
         var _oPos:Point = new Point(_oWorldMatrix.tx,_oWorldMatrix.ty);
         var _bWallUp:* = getTileBlocker(_oPos.add(new Point(0,-Data.iTILE_HEIGHT))) != null;
         var _bWallDown:* = getTileBlocker(_oPos.add(new Point(0,Data.iTILE_HEIGHT))) != null;
         var _bWallLeft:* = getTileBlocker(_oPos.add(new Point(-Data.iTILE_HEIGHT,0))) != null;
         var _bWallRight:* = getTileBlocker(_oPos.add(new Point(Data.iTILE_HEIGHT,0))) != null;
         _oBlock = new MovingBlock(_mcRef,_oRoom,_oSolvedPos,_bSolved,_bWallLeft,_bWallUp,_bWallRight,_bWallDown);
         trace("Create block : ",_oBlock,"up",_bWallUp,"dn",_bWallDown,"lf",_bWallLeft,"rg",_bWallRight);
         aBlocks.push(_oBlock);
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_CREATE_MOVING_BLOCK,_oBlock));
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function getTileBlocker(_oPoint:Point) : Object
      {
         var _oBlocker:Object = null;
         var _iC:Number = Math.floor(_oPoint.x / Data.iTILE_WIDTH);
         var _iR:Number = Math.floor(_oPoint.y / Data.iTILE_HEIGHT);
         var _oData:Object = getData(AssetData.sTYPE_MISC,_iC,_iR);
         if(_oData != null && _oData.sLinkage != null)
         {
            _oBlocker = new Object();
            _oBlocker.sType = AssetData.getAssetData(_oData.sLinkage).sBlocker;
            _oBlocker.oMatrix = _oData.oMatrix;
         }
         return _oBlocker;
      }
      
      public function enableCameraOnPlayer(_bEnable:Boolean = true) : void
      {
         if(_bEnable && !bTargetPlayer)
         {
            targetCameraAt(Player.Instance.getWorldPositionX(),Player.Instance.getWorldPositionY());
            GameDispatcher.Instance.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove,false,100,true);
            bTargetPlayer = true;
         }
         else if(!_bEnable && bTargetPlayer)
         {
            GameDispatcher.Instance.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
            bTargetPlayer = false;
         }
      }
      
      public function set doorStartPosition(_oPoint:Point) : void
      {
         if(_oPoint != null)
         {
            oDoorStartPoint = _oPoint.clone();
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function set mapData(_oMapData:Object) : void
      {
         oMapData = _oMapData;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function onLeavingRoom(_e:RoomEvent) : void
      {
         trace("......................... LEAVING ROOM");
         onRemoveDoorMask();
         if(_e.worldPosition != null)
         {
            onBuildDoorMask(_e.worldPosition);
         }
      }
      
      private function bumpOnRectangle(_oFrom:Point, _oTo:Point, _oZone:Rectangle) : Object
      {
         if(_oFrom == null || _oTo == null || _oZone == null)
         {
            return null;
         }
         var _oRet:Object = null;
         var _nL:Number = _oZone.left;
         var _nR:Number = _oZone.right;
         var _nT:Number = _oZone.top;
         var _nB:Number = _oZone.bottom;
         if(_oTo.x - _oFrom.x > 0)
         {
            _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nL,_nT),new Point(_nL,_nB));
         }
         else
         {
            _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nR,_nT),new Point(_nR,_nB));
         }
         if(_oRet == null)
         {
            if(_oTo.y - _oFrom.y > 0)
            {
               _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nL,_nT),new Point(_nR,_nT));
            }
            else
            {
               _oRet = bumpOnWall(_oFrom,_oTo,new Point(_nL,_nB),new Point(_nR,_nB));
            }
         }
         return _oRet;
      }
      
      public function createPuzzles(_oPuzzlesData:Object) : void
      {
         var i:* = null;
         for(i in _oPuzzlesData)
         {
            createMovingBlock(_oPuzzlesData[i].linkage,_oPuzzlesData[i].room,_oPuzzlesData[i].matrix,_oPuzzlesData[i].matrixExit,_oPuzzlesData[i].bSolved);
         }
      }
      
      private function getRoom(_uId:uint) : Room
      {
         return oRooms["r" + _uId] as Room;
      }
      
      private function onMovingBlockDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Moving block destroyed");
         var _iIndex:int = aBlocks.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aBlocks.splice(_iIndex,1);
         }
      }
      
      public function createChest(_sLinkage:String, _uID:uint, _uRoom:uint, _oWorldMatrix:Matrix, _sItemLinkage:String, _uItemID:uint, _bOpened:Boolean = false) : void
      {
         var _oChest:Chest = null;
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create chest");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_UNDER);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         switch(_uID)
         {
            case Data.uCHEST_NORMAL:
               _oChest = new Chest(_mcRef,_oRoom,_uItemID,_bOpened,false,false);
               break;
            case Data.uCHEST_KEY:
               _oChest = new Chest(_mcRef,_oRoom,_uItemID,_bOpened,false,true);
               break;
            case Data.uCHEST_KILL:
               _oChest = new Chest(_mcRef,_oRoom,_uItemID,_bOpened,true,false);
         }
         aChests.push(_oChest);
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_CREATE_CHEST,_oChest));
      }
      
      private function onEventTileDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Puzzle tile destroyed");
         var _iIndex:uint = aEvents.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aEvents.splice(_iIndex,1);
         }
      }
      
      public function createWandable(_sLinkage:String, _uRoom:uint, _oWorldMatrix:Matrix) : void
      {
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create wandable");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_UNDER);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         createRoomIfNotCreated(_uRoom);
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
      }
      
      private function onEnteringRoom(_e:RoomEvent) : void
      {
         trace("......................... ENTERING ROOM");
         onRemoveDoorMask();
         if(_e.worldPosition != null)
         {
            onBuildDoorMask(_e.worldPosition);
         }
      }
      
      public function createCharacters(_oCharactersData:Object) : void
      {
         var i:* = null;
         for(i in _oCharactersData)
         {
            if(_oCharactersData[i].id != Data.uCHARACTER_SPONGEBOB)
            {
               createCharacter(_oCharactersData[i].linkage,_oCharactersData[i].id,_oCharactersData[i].room,_oCharactersData[i].matrix);
            }
         }
      }
      
      public function createEnemies(_oEnemiesData:Object) : void
      {
         var i:* = null;
         for(i in _oEnemiesData)
         {
            createEnemy(_oEnemiesData[i].linkage,_oEnemiesData[i].id,_oEnemiesData[i].room,_oEnemiesData[i].matrix,_oEnemiesData[i].itemLinkage,_oEnemiesData[i].itemID);
         }
      }
      
      public function createCharacter(_sLinkage:String, _uID:uint, _uRoom:uint, _oWorldMatrix:Matrix) : void
      {
         var _oCharacter:Object = null;
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create character ",_sLinkage);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         switch(_uID)
         {
            case Data.uCHARACTER_PATRICK:
               _oCharacter = new Patrick(_mcRef,_oRoom);
               _sEventType = MapGenerateEvent.EVENT_CREATE_PATRICK;
               break;
            case Data.uCHARACTER_KRAB:
               _oCharacter = new Krab(_mcRef,_oRoom);
               _sEventType = MapGenerateEvent.EVENT_CREATE_KRAB;
               break;
            case Data.uCHARACTER_SANDY:
               _oCharacter = new Sandy(_mcRef,_oRoom);
               _sEventType = MapGenerateEvent.EVENT_CREATE_SANDY;
               break;
            case Data.uCHARACTER_SQUIDWARD:
               _oCharacter = new Squidward(_mcRef,_oRoom);
               _sEventType = MapGenerateEvent.EVENT_CREATE_SQUIDWARD;
         }
         aCharacters.push(_oCharacter);
         dispatchEvent(new MapGenerateEvent(_sEventType,_oCharacter));
      }
      
      private function onCharacterDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Character destroyed : ",_e.instance);
         if(aCharacters == null)
         {
            return;
         }
         var _iIndex:int = aCharacters.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aCharacters.splice(_iIndex,1);
         }
      }
      
      private function onPlayerMove(_e:MovingBodyEvent) : void
      {
         targetCameraAt(_e.newWorldPosition.x,_e.newWorldPosition.y);
      }
      
      public function set playerStartPosition(_oPoint:Point) : void
      {
         trace("Map : Player start position",_oPoint);
         if(_oPoint != null)
         {
            oPlayerStartPoint = _oPoint.clone();
         }
      }
      
      private function onFoundItem(_e:DropItemEvent) : void
      {
         var _oMatrix:Matrix = new Matrix();
         _oMatrix.translate(_e.worldPositionX,_e.worldPositionY);
         createFloorItem(null,_e.itemId,_e.room.getRoomId(),_oMatrix,false,true,_e.worldSource);
      }
      
      public function linkIndoorDoors() : void
      {
         var _bFound:Boolean = false;
         var _oFrom:DoorIndoor = null;
         var _oTo:DoorIndoor = null;
         var j:Number = NaN;
         for(var i:Number = 0; i < aIndoors.length - 1; i++)
         {
            _bFound = false;
            _oFrom = aIndoors[i];
            if(!_oFrom.isLinked())
            {
               j = i + 1;
               while(!_bFound && j < aIndoors.length)
               {
                  _oTo = aIndoors[j];
                  if(aIndoorsLink[i] == aIndoorsLink[j])
                  {
                     _oFrom.setExitDoor(_oTo);
                     _oTo.setExitDoor(_oFrom);
                  }
                  j++;
               }
            }
         }
         aIndoorsLink.splice(0);
         aIndoorsLink = null;
      }
      
      private function getTileWorldZone(_nWorldX:Number, _nWorldY:Number) : Rectangle
      {
         var _oRet:Rectangle = new Rectangle();
         _oRet.x = Math.floor(_nWorldX / Data.iTILE_WIDTH) * Data.iTILE_WIDTH;
         _oRet.y = Math.floor(_nWorldY / Data.iTILE_HEIGHT) * Data.iTILE_HEIGHT;
         _oRet.width = Data.iTILE_WIDTH;
         _oRet.height = Data.iTILE_HEIGHT;
         return _oRet;
      }
      
      private function onAddingChild(_e:Event) : void
      {
         bNeedZOrdering = true;
      }
      
      public function linkMovingBlocks() : void
      {
         var _oMov:MovingBlock = null;
         for each(_oMov in aBlocks)
         {
            _oMov.setMovingBlocks(aBlocks);
         }
      }
      
      private function onDropItem(_e:DropItemEvent) : void
      {
         var _oMatrix:Matrix = new Matrix();
         _oMatrix.translate(_e.worldPositionX,_e.worldPositionY);
         createFloorItem(null,_e.itemId,_e.room.getRoomId(),_oMatrix,true,false,_e.worldSource);
      }
      
      public function createFloorItem(_sLinkage:String, _uID:uint, _uRoom:uint, _oWorldMatrix:Matrix, _bDropped:Boolean = false, _bFromChest:Boolean = false, _oSource:Point = null) : void
      {
         var _oItem:FloorItem = null;
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         var _oAsset:Object = null;
         trace("Map : Create item ",uId);
         if(!_bFromChest && !Profile.Instance.canPickUpItem(_uID))
         {
            return;
         }
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         if(_sLinkage == null)
         {
            _oAsset = AssetData.getItemAssetDataByID(_uID);
            _sLinkage = _oAsset.sLinkage;
         }
         _cClass = getDefinitionByName(_sLinkage) as Class;
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         _oItem = new FloorItem(_mcRef,_uID,_oRoom,_bDropped,false,_bFromChest,_oSource);
         aFloorItems.push(_oItem);
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_CREATE_FLOOR_ITEM,_oItem));
      }
      
      private function getStandardLinearEquation(_oPointA:Point, _oPointB:Point) : Object
      {
         var _nOffset:Number = NaN;
         var _oU:Point = null;
         var _oV:Point = null;
         var _oRet:Object = new Object();
         _oRet.x = 0;
         if(_oPointA.y == _oPointB.y)
         {
            _oRet.a = 0;
            _oRet.b = _oPointA.y;
         }
         else
         {
            _nOffset = 0;
            if(_oPointA.x == _oPointB.x)
            {
               _oRet.a = 0;
               _oRet.b = 0;
               _oRet.x = _oPointA.x;
            }
            else
            {
               if(_oPointA.x <= _oPointB.x)
               {
                  _oU = _oPointA;
                  _oV = _oPointB;
               }
               else
               {
                  _oU = _oPointB;
                  _oV = _oPointA;
               }
               _oRet.a = (_oV.y - _oU.y) / (_oV.x + _nOffset - _oU.x);
               _oRet.b = _oV.y - _oRet.a * _oV.x;
            }
         }
         return _oRet;
      }
      
      private function onProjectileThrow(_e:ThrowEvent) : void
      {
         createProjectile(_e.projectileType,_e.worldPositionX,_e.worldPositionY,_e.orientation);
      }
      
      public function onBuildDoorMask(param1:Point) : void
      {
         var _loc3_:Class = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Boolean = false;
         var _loc19_:Sprite = null;
         var _loc20_:BitmapData = null;
         var _loc21_:Bitmap = null;
         var _loc22_:Rectangle = null;
         var _loc23_:Rectangle = null;
         trace("Map : onBuildDoorMask ",param1);
         var _loc2_:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_OVER);
         if(oMaskBitmap != null)
         {
            _loc2_.removeChild(oMaskBitmap);
            oMaskBitmapData.dispose();
            oMaskBitmapData = null;
            oMaskBitmap = null;
         }
         oMaskBitmapData = new BitmapData(Data.iMAP_WIDTH,Data.iMAP_HEIGHT,true,0);
         oMaskBitmap = new Bitmap(oMaskBitmapData,"auto",false);
         var _loc8_:Number = Math.floor(param1.x / Data.iTILE_WIDTH);
         var _loc9_:Number = Math.floor(param1.y / Data.iTILE_HEIGHT);
         _loc5_ = oMapData["X" + _loc8_ + "Y" + _loc9_].oObject;
         var _loc10_:Matrix = _loc5_.oMatrix;
         var _loc11_:Number = _loc8_ * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
         var _loc12_:Number = _loc9_ * Data.iTILE_HEIGHT + Data.iTILE_HEIGHT / 2;
         param1 = _loc10_.transformPoint(new Point(0,-Data.iTILE_HEIGHT));
         var _loc13_:Number = Math.floor(param1.x / Data.iTILE_WIDTH);
         var _loc14_:Number = Math.floor(param1.y / Data.iTILE_HEIGHT);
         _loc6_ = oMapData["X" + _loc13_ + "Y" + _loc14_];
         if(_loc6_ != null)
         {
            _loc15_ = _loc13_ * Data.iTILE_WIDTH;
            _loc16_ = _loc14_ * Data.iTILE_HEIGHT;
            _loc17_ = 13;
            _loc7_ = AssetData.getAssetData(_loc5_.sLinkage).sMaskLinkage;
            if(_loc7_ != "null" && _loc7_ != null)
            {
               _loc3_ = getDefinitionByName(_loc7_) as Class;
               _loc18_ = Player.Instance.getMC().visible;
               Player.Instance.getMC().visible = false;
               _loc19_ = new Sprite();
               _loc20_ = new BitmapData(Data.iTILE_WIDTH * 2,Data.iTILE_HEIGHT * 2 + _loc17_,false,0);
               _loc21_ = new Bitmap(_loc20_,"auto",false);
               _loc21_.x -= Data.iTILE_WIDTH;
               _loc21_.y -= Data.iTILE_HEIGHT * 1.5;
               _loc19_.addChild(_loc21_);
               _loc2_.addChild(_loc19_);
               _loc19_.transform.matrix = _loc5_.oMatrix;
               _loc19_.x = _loc13_ * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
               _loc19_.y = _loc14_ * Data.iTILE_WIDTH + Data.iTILE_WIDTH / 2;
               _loc22_ = _loc19_.getBounds(_loc2_);
               _loc23_ = new Rectangle(_loc22_.x,_loc22_.y,_loc22_.width,_loc22_.height);
               _loc2_.removeChild(_loc19_);
               oMaskBitmapData.draw(mcRef,null,null,null,_loc23_);
               oMaskBitmapData.draw(new _loc3_(),_loc5_.oMatrix,null,BlendMode.ERASE,null);
               oMaskBitmapData.draw(new _loc3_(),_loc5_.oMatrix,null,null);
               _loc19_ = null;
               _loc20_.dispose();
               _loc20_ = null;
               _loc21_ = null;
               _loc2_.addChild(oMaskBitmap);
               Player.Instance.getMC().visible = _loc18_;
            }
            else
            {
               oMaskBitmapData.dispose();
               oMaskBitmapData = null;
               oMaskBitmap = null;
            }
         }
         else
         {
            oMaskBitmapData.dispose();
            oMaskBitmapData = null;
            oMaskBitmap = null;
         }
      }
      
      public function createChests(_oChestsData:Object) : void
      {
         var i:* = null;
         for(i in _oChestsData)
         {
            createChest(_oChestsData[i].linkage,_oChestsData[i].id,_oChestsData[i].room,_oChestsData[i].matrix,_oChestsData[i].itemLinkage,_oChestsData[i].itemID,_oChestsData[i].open);
         }
      }
      
      private function onProjectileDestroy(_e:ProjectileEvent) : void
      {
         trace("Map : Projectile destroyed ");
         var _oProj:Projectile = _e.projectile as Projectile;
         var _iIndex:int = aProjectiles.indexOf(_oProj);
         if(_iIndex != -1)
         {
            aProjectiles.slice(_iIndex,1);
            _oProj = null;
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function onCollisionCheck(_e:MovingBodyEvent) : void
      {
         var _aTilePos:Array = null;
         var _nTW:Number = NaN;
         var _nTH:Number = NaN;
         var _oTile:Object = null;
         var _oTilePos:Point = null;
         var t:uint = 0;
         var _oWorldTile:Rectangle = null;
         var _oBottomLeft:Point = null;
         var _oTopRight:Point = null;
         var _oMat:Matrix = null;
         var _oOffset:Point = null;
         var _oContact:Point = null;
         var _oBump:Point = null;
         var _oSlide:Point = null;
         if(!(_e.mover is ILevelCollidable))
         {
            return;
         }
         var _oMover:ILevelCollidable = _e.mover as ILevelCollidable;
         var _oDisp:Point = _e.newWorldPosition.subtract(_e.lastWorldPosition);
         var _oFeetFrom:Rectangle = _e.localFeetZone.clone();
         _oFeetFrom.offsetPoint(_e.lastWorldPosition);
         var _oFeetTo:Rectangle = _e.localFeetZone.clone();
         _oFeetTo.offsetPoint(_e.newWorldPosition);
         var _aFeetFrom:Array = [];
         var _aFeetTo:Array = [];
         var _oColl:Object = null;
         if(Math.abs(_oDisp.x) < 0.001)
         {
            if(Math.abs(_oDisp.y) >= 0.001)
            {
               if(_oDisp.y > 0)
               {
                  _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.bottom),new Point(_oFeetFrom.right,_oFeetFrom.bottom));
                  _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.bottom),new Point(_oFeetTo.right,_oFeetTo.bottom));
               }
               else if(_oDisp.y < 0)
               {
                  _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.top),new Point(_oFeetFrom.right,_oFeetFrom.top));
                  _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top),new Point(_oFeetTo.right,_oFeetTo.top));
               }
            }
         }
         else if(_oDisp.x < 0)
         {
            _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.top),new Point(_oFeetFrom.left,_oFeetFrom.bottom));
            _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top),new Point(_oFeetTo.left,_oFeetTo.bottom));
            if(_oDisp.y > 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.right,_oFeetFrom.bottom));
               _aFeetTo.push(new Point(_oFeetTo.right,_oFeetTo.bottom));
            }
            else if(_oDisp.y < 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.right,_oFeetFrom.top));
               _aFeetTo.push(new Point(_oFeetTo.right,_oFeetTo.top));
            }
         }
         else
         {
            _aFeetFrom.push(new Point(_oFeetFrom.right,_oFeetFrom.top),new Point(_oFeetFrom.right,_oFeetFrom.bottom));
            _aFeetTo.push(new Point(_oFeetTo.right,_oFeetTo.top),new Point(_oFeetTo.right,_oFeetTo.bottom));
            if(_oDisp.y > 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.bottom));
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.bottom));
            }
            else if(_oDisp.y < 0)
            {
               _aFeetFrom.push(new Point(_oFeetFrom.left,_oFeetFrom.top));
               _aFeetTo.push(new Point(_oFeetTo.left,_oFeetTo.top));
            }
         }
         var _oFrom:Point = null;
         var _oTo:Point = null;
         var i:uint = 0;
         while(_oColl == null && i < _aFeetFrom.length)
         {
            _oFrom = _aFeetFrom[i];
            _oTo = _aFeetTo[i];
            _aTilePos = [];
            _nTW = Data.iTILE_WIDTH;
            _nTH = Data.iTILE_HEIGHT;
            if(_oDisp.x > 0)
            {
               _aTilePos.push(_oTo.add(new Point(-_nTW,0)));
            }
            else if(_oDisp.x < 0)
            {
               _aTilePos.push(_oTo.add(new Point(_nTW,0)));
            }
            if(_oDisp.y > 0)
            {
               _aTilePos.push(_oTo.add(new Point(0,-_nTH)));
            }
            else if(_oDisp.x < 0)
            {
               _aTilePos.push(_oTo.add(new Point(0,_nTH)));
            }
            _aTilePos.push(_oTo);
            t = 0;
            for(; _oColl == null && t < _aTilePos.length; t++)
            {
               _oTilePos = _aTilePos[t];
               _oTile = getTileBlocker(_oTilePos);
               if(_oTile == null)
               {
                  continue;
               }
               switch(_oTile.sType)
               {
                  case "blockerFull":
                  case "blockerNotRoom":
                     _oWorldTile = getTileWorldZone(_aTilePos[t].x,_aTilePos[t].y);
                     _oColl = bumpOnRectangle(_oFrom,_oTo,_oWorldTile);
                     break;
                  case "blockerHalf":
                     _oBottomLeft = new Point(-Data.iTILE_WIDTH / 2,Data.iTILE_HEIGHT / 2);
                     _oTopRight = new Point(Data.iTILE_WIDTH / 2,-Data.iTILE_HEIGHT / 2);
                     _oMat = _oTile.oMatrix;
                     _oBottomLeft = _oMat.transformPoint(_oBottomLeft);
                     _oTopRight = _oMat.transformPoint(_oTopRight);
                     _oColl = bumpOnWall(_oFrom,_oTo,_oBottomLeft,_oTopRight);
                     break;
               }
            }
            i++;
         }
         if(_oColl != null)
         {
            _oOffset = new Point();
            if(_oFrom.x == _oFeetFrom.left)
            {
               _oOffset.x = -_e.localFeetZone.left;
            }
            else
            {
               _oOffset.x = -_e.localFeetZone.right;
            }
            if(_oFrom.y == _oFeetFrom.top)
            {
               _oOffset.y = -_e.localFeetZone.top;
            }
            else
            {
               _oOffset.y = -_e.localFeetZone.bottom;
            }
            _oContact = _oColl.oContact as Point;
            _oBump = _oColl.oBumpResult as Point;
            _oSlide = _oColl.oSlideResult as Point;
            _oContact.x += _oOffset.x;
            _oContact.y += _oOffset.y;
            _oBump.x += _oOffset.x;
            _oBump.y += _oOffset.y;
            _oSlide.x += _oOffset.x;
            _oSlide.y += _oOffset.y;
            _e.stopImmediatePropagation();
            _oMover.onWallCollide(_e.lastWorldPosition,_oContact,_oBump,_oSlide,_e.tries + 1);
         }
         else
         {
            bNeedZOrdering = true;
         }
      }
      
      private function onFloorItemDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Floor item destroyed : ",_e.instance);
         var _iIndex:int = aFloorItems.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aFloorItems.splice(_iIndex,1);
         }
      }
      
      public function createWandables(_oWandablesData:Object) : void
      {
         var i:* = null;
         for(i in _oWandablesData)
         {
            createWandable(_oWandablesData[i].linkage,_oWandablesData[i].room,_oWandablesData[i].matrix);
         }
      }
      
      public function snapshot() : BitmapData
      {
         var _oRet:BitmapData = new BitmapData(Data.iSTAGE_WIDTH,Data.iSTAGE_HEIGHT,false);
         _oRet.draw(mcRef,mcRef.transform.matrix,null,null,new Rectangle(0,0,Data.iSTAGE_WIDTH,Data.iSTAGE_HEIGHT));
         return _oRet;
      }
      
      public function createDoor(_sLinkage:String, _uID:uint, _sType:String, _uRoom:uint, _oWorldMatrix:Matrix, _oWorldMatrixExit:Matrix, _sDoorLink:String, _sMap:String, _uLevelKind:uint, _bOpened:Boolean = false) : void
      {
         var _dpLayer:DisplayObjectContainer = null;
         var _sEventType:String = null;
         var _oDr:Object = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         var _oRoom:Room = null;
         trace("Map : Create door, ","room:",_uRoom,"door linkage",_sLinkage,"@",_oWorldMatrix.tx,_oWorldMatrix.ty);
         trace("_uLevelKind : " + _uLevelKind);
         if(_uLevelKind == Data.uLEVEL_WORLD)
         {
            _dpLayer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         }
         else
         {
            _dpLayer = oDepthManager.getDepthLayer(sDEPTH_Z_UNDER);
         }
         _cClass = getDefinitionByName(_sLinkage) as Class;
         _mcRef = new _cClass();
         _oRoom = createRoomIfNotCreated(_uRoom);
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         trace("%%%%%%%%%%%%%%%");
         if(_sType == AssetData.sLINK_INDOOR)
         {
            _sEventType = MapGenerateEvent.EVENT_CREATE_INDOOR_DOOR;
            switch(_uID)
            {
               case Data.uDOOR_NORMAL:
                  trace("a");
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,true,false,false);
                  break;
               case Data.uDOOR_SECRET:
                  trace("1");
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,true);
                  break;
               case Data.uDOOR_KEY:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,true);
                  trace("b");
                  break;
               case Data.uDOOR_KILL:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,true,false);
                  trace("c");
                  break;
               case Data.uDOOR_KEY_KILL:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,true,true);
                  trace("d");
                  break;
               case Data.uDOOR_SECRET:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,true);
                  trace("e");
                  break;
               case Data.uDOOR_LAIR:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,false,true);
                  trace("f");
                  break;
               case Data.uDOOR_BOSS:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,false,false,true);
                  trace("g");
                  break;
               case Data.uDOOR_SANDY:
               case Data.uDOOR_SQUIDWARD:
               case Data.uDOOR_EPISODE:
                  _oDr = new DoorIndoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,false,false,false,true);
                  trace("h");
            }
            aIndoorsLink.push(_sDoorLink);
            aIndoors.push(_oDr);
         }
         else
         {
            _sEventType = MapGenerateEvent.EVENT_CREATE_OUTDOOR_DOOR;
            switch(_uID)
            {
               case Data.uDOOR_NORMAL:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,true,false,false);
                  trace("_mcRef : " + _mcRef);
                  trace("aa");
                  break;
               case Data.uDOOR_SECRET:
                  trace("11");
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,true);
                  break;
               case Data.uDOOR_KEY:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,true);
                  trace("bb:",_mcRef,_mcRef.name);
                  break;
               case Data.uDOOR_KILL:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,true,false);
                  trace("cc");
                  break;
               case Data.uDOOR_KEY_KILL:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,true,true);
                  trace("dd");
                  break;
               case Data.uDOOR_SECRET:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,true);
                  trace("ee");
                  break;
               case Data.uDOOR_LAIR:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,!_bOpened,false,true);
                  trace("ff");
                  break;
               case Data.uDOOR_BOSS:
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,!_bOpened,false,false,true);
                  trace("gg");
                  break;
               case Data.uDOOR_SANDY:
               case Data.uDOOR_SQUIDWARD:
                  trace("_mcRef outdoor : " + _mcRef);
                  _oDr = new DoorOutdoor(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,false,false,false,true);
                  trace("hh");
                  break;
               case Data.uDOOR_EPISODE:
                  _oDr = new DoorEpisode(_mcRef,_oRoom,Profile.Instance.getCurrentEpisode(),_oWorldMatrix,_bOpened);
            }
            aOutdoors.push(_oDr);
         }
         dispatchEvent(new MapGenerateEvent(_sEventType,_oDr));
      }
      
      private function update(_e:Event) : void
      {
         ++uZOrderingSince;
         if(bNeedZOrdering && uZOrderingSince >= uZ_BUFFERING_SORT_RATE)
         {
            bNeedZOrdering = false;
            uZOrderingSince = 0;
            swapDepth();
         }
      }
      
      private function onEnemyDestroy(_e:MapGenerateEvent) : void
      {
         var _oEn:Enemy = null;
         trace("Map : Enemy destroyed : ",_e.instance);
         var _iIndex:int = aEnemies.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            _oEn = aEnemies[_iIndex];
            aEnemies.splice(_iIndex,1);
            _oEn = null;
         }
      }
      
      public function enterRoom(_uId:int = -1) : void
      {
         if(_uId == -1)
         {
            _uId = uPlayerStartRoom;
         }
         var _oRoom:Room = getRoom(_uId);
         trace("MAP >>> ENTER ROOM ",_uId,_oRoom);
         if(_oRoom != null)
         {
            _oRoom.enterRoom();
         }
      }
      
      private function onBreakableDestroy(_e:MapGenerateEvent) : void
      {
         var _oProp:BreakableProp = null;
         trace("Map : Breakable destroyed : ",_e.instance);
         var _iIndex:int = aBreakables.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            _oProp = aBreakables[_iIndex];
            aBreakables.splice(_iIndex,1);
            _oProp = null;
         }
      }
      
      private function onFixedObjectDestroy(_e:MapGenerateEvent) : void
      {
         trace("Map : Fixed object destroyed : ",_e.instance);
         var _iIndex:int = aFixedObjects.indexOf(_e.instance);
         if(_iIndex != -1)
         {
            aFixedObjects.splice(_iIndex,1);
         }
      }
      
      public function createDestructables(_oDestructablesData:Object) : void
      {
         var i:* = null;
         for(i in _oDestructablesData)
         {
            createDestructable(_oDestructablesData[i].linkage,_oDestructablesData[i].id,_oDestructablesData[i].room,_oDestructablesData[i].matrix,_oDestructablesData[i].itemLinkage,_oDestructablesData[i].itemID);
         }
      }
      
      public function targetCameraAt(_nX:Number, _nY:Number) : void
      {
         var _nNextX:Number = Math.round(-(_nX - uLOCAL_EYE_X));
         var _nNextY:Number = Math.round(-(_nY - uLOCAL_EYE_Y));
         if(mcRef != null && mcRef.x == _nNextX && mcRef.y == _nNextY)
         {
            return;
         }
         var _nLastCamX:Number = oCameraZone.x;
         var _nLastCamY:Number = oCameraZone.y;
         oCameraZone.x = -_nNextX;
         oCameraZone.y = -_nNextY;
         if(!oCameraLimits.containsRect(oCameraZone))
         {
            if(oCameraZone.left < oCameraLimits.left)
            {
               oCameraZone.x = oCameraLimits.x;
            }
            else if(oCameraZone.right > oCameraLimits.right)
            {
               oCameraZone.x = oCameraLimits.right - oCameraZone.width;
            }
            if(oCameraZone.top < oCameraLimits.top)
            {
               oCameraZone.y = oCameraLimits.y;
            }
            else if(oCameraZone.bottom > oCameraLimits.bottom)
            {
               oCameraZone.y = oCameraLimits.bottom - oCameraZone.height;
            }
         }
         if(oCameraZone.x == _nLastCamX && oCameraZone.y == _nLastCamY)
         {
            return;
         }
         mcRef.x = -oCameraZone.x;
         mcRef.y = -oCameraZone.y;
         dispatchEvent(new CameraEvent(CameraEvent.EVENT_CAMERA_MOVE,oCameraZone));
      }
      
      public function createEnemy(_sLinkage:String, _uEnemyType:uint, _uRoom:uint, _oWorldMatrix:Matrix, _sItemLinkage:String, _uItemID:uint) : void
      {
         var _oEn:Enemy = null;
         var _sEventType:String = null;
         var _mcRef:MovieClip = null;
         var _cClass:Class = null;
         trace("Map : Create enemy");
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _cClass = getDefinitionByName(_sLinkage) as Class;
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         _mcRef = new _cClass();
         _mcRef.transform.matrix = _oWorldMatrix.clone();
         _dpLayer.addChild(_mcRef);
         trace("_uItemID : " + _uItemID);
         switch(_uEnemyType)
         {
            case Data.uENEMY_JELLYFISH_LIGHT:
               _oEn = new Jellyfish(_mcRef,_oRoom,Jellyfish.uTYPE_LIGHT,_uItemID);
               break;
            case Data.uENEMY_JELLYFISH_MID:
               _oEn = new Jellyfish(_mcRef,_oRoom,Jellyfish.uTYPE_MID,_uItemID);
               break;
            case Data.uENEMY_JELLYFISH_HIGH:
               _oEn = new Jellyfish(_mcRef,_oRoom,Jellyfish.uTYPE_HIGH,_uItemID);
               break;
            case Data.uENEMY_EEL:
               _oEn = new Eel(_mcRef,_oRoom,_uItemID);
               break;
            case Data.uBOSS_GASEOUS_ROCK:
               _oEn = new GaseousRock(_mcRef,_oRoom);
         }
         aEnemies.push(_oEn);
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_CREATE_ENEMY,_oEn));
      }
      
      public function disableCameraOnPlayer() : void
      {
         enableCameraOnPlayer(false);
      }
      
      public function createDoors(_oDoorsData:Object, _uLevelKind:uint) : void
      {
         var i:* = null;
         for(i in _oDoorsData)
         {
            createDoor(_oDoorsData[i].linkage,_oDoorsData[i].id,_oDoorsData[i].type,_oDoorsData[i].room,_oDoorsData[i].matrix,_oDoorsData[i].matrixExit,_oDoorsData[i].doorLink,_oDoorsData[i].map,_uLevelKind,_oDoorsData[i].open);
         }
      }
      
      private function getIntersectionPoint(_oPointA1:Point, _oPointA2:Point, _oPointB1:Point, _oPointB2:Point) : Point
      {
         var _oRet:Point = null;
         var _nYMin:Number = NaN;
         var _nXMin:Number = NaN;
         var _oLine1:Object = getStandardLinearEquation(_oPointA1,_oPointA2);
         var _oLine2:Object = getStandardLinearEquation(_oPointB1,_oPointB2);
         var _bInf:Boolean = false;
         if(_oLine1.x != 0 || _oLine2.x != 0)
         {
            if(_oLine1.x == _oLine2.x)
            {
               _bInf = true;
               _nYMin = Math.min(_oPointA1.y,_oPointA2.y);
               _nYMin = Math.min(_nYMin,_oPointB1.y);
               _nYMin = Math.min(_nYMin,_oPointB2.y);
               if(_nYMin == _oPointA1.y)
               {
                  _oRet = _oPointA2;
                  if(_oRet.y < _oPointB1.y && _oRet.y < _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y))
                  {
                     _oRet = null;
                  }
               }
               else if(_nYMin == _oPointA2.y)
               {
                  _oRet = _oPointA1;
                  if(_oRet.y < _oPointB1.y && _oRet.y < _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y))
                  {
                     _oRet = null;
                  }
               }
               else if(_nYMin == _oPointB1.y)
               {
                  _oRet = _oPointB2;
                  if(_oRet.y < _oPointA1.y && _oRet.y < _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y))
                  {
                     _oRet = null;
                  }
               }
               else
               {
                  _oRet = _oPointB1;
                  if(_oRet.y < _oPointA1.y && _oRet.y < _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y))
                  {
                     _oRet = null;
                  }
               }
            }
            else
            {
               if(_oLine1.x != 0)
               {
                  _oRet = new Point();
                  _oRet.x = _oLine1.x;
                  _oRet.y = _oLine2.a * _oRet.x + _oLine2.b;
                  if(floatEquals(_oRet.y,_oPointB1.y))
                  {
                     _oRet.y = _oPointB1.y;
                  }
                  else if(floatEquals(_oRet.y,_oPointB2.y))
                  {
                     _oRet.y = _oPointB2.y;
                  }
               }
               else
               {
                  _oRet = new Point();
                  _oRet.x = _oLine2.x;
                  _oRet.y = _oLine1.a * _oRet.x + _oLine1.b;
                  if(floatEquals(_oRet.y,_oPointA1.y))
                  {
                     _oRet.y = _oPointA1.y;
                  }
                  else if(floatEquals(_oRet.y,_oPointA2.y))
                  {
                     _oRet.y = _oPointA2.y;
                  }
               }
               if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x > _oPointA1.x && _oRet.x > _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x) || _oRet.x > _oPointB1.x && _oRet.x > _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
               {
                  _oRet = null;
               }
            }
            if(_oRet != null && (_oRet.y < _oPointA1.y && _oRet.y < _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y) || _oRet.y > _oPointA1.y && _oRet.y > _oPointA2.y && !floatEquals(_oRet.y,_oPointA1.y) && !floatEquals(_oRet.y,_oPointA2.y) || _oRet.y < _oPointB1.y && _oRet.y < _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y) || _oRet.y > _oPointB1.y && _oRet.y > _oPointB2.y && !floatEquals(_oRet.y,_oPointB1.y) && !floatEquals(_oRet.y,_oPointB2.y)))
            {
               _oRet = null;
            }
         }
         else if(_oLine1.a == _oLine2.a)
         {
            if(_oLine1.b != _oLine2.b)
            {
               _oRet = null;
            }
            else
            {
               _bInf = true;
               _nXMin = Math.min(_oPointA1.x,_oPointA2.x);
               _nXMin = Math.min(_nXMin,_oPointB1.x);
               _nXMin = Math.min(_nXMin,_oPointB2.x);
               if(_nXMin == _oPointA1.x)
               {
                  _oRet = _oPointA2;
                  if(_oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
                  {
                     _oRet = null;
                  }
               }
               else if(_nXMin == _oPointA2.x)
               {
                  _oRet = _oPointA1;
                  if(_oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
                  {
                     _oRet = null;
                  }
               }
               else if(_nXMin == _oPointB1.x)
               {
                  _oRet = _oPointB2;
                  if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x))
                  {
                     _oRet = null;
                  }
               }
               else
               {
                  _oRet = _oPointB1;
                  if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x))
                  {
                     _oRet = null;
                  }
               }
            }
         }
         else
         {
            _oRet = new Point();
            _oRet.x = (_oLine1.b - _oLine2.b) / (_oLine2.a - _oLine1.a);
            _oRet.y = _oLine1.a * _oRet.x + _oLine1.b;
            if(_oRet.x < _oPointA1.x && _oRet.x < _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x > _oPointA1.x && _oRet.x > _oPointA2.x && !floatEquals(_oRet.x,_oPointA1.x) && !floatEquals(_oRet.x,_oPointA2.x) || _oRet.x < _oPointB1.x && _oRet.x < _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x) || _oRet.x > _oPointB1.x && _oRet.x > _oPointB2.x && !floatEquals(_oRet.x,_oPointB1.x) && !floatEquals(_oRet.x,_oPointB2.x))
            {
               _oRet = null;
            }
         }
         if(_oRet != null && _bInf)
         {
            _oRet = new Point(Number.NaN,Number.NaN);
         }
         return _oRet;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function set playerStartRoom(_uRoom:uint) : void
      {
         uPlayerStartRoom = _uRoom;
         trace("oPlayerStartRoom : " + uPlayerStartRoom);
      }
      
      public function destroy(_e:Event = null) : void
      {
         var v:Object = null;
         var _oRoom:Room = null;
         trace("Map : destroy");
         disableCameraOnPlayer();
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _dpLayer.removeEventListener(Event.ADDED,onAddingChild);
         _dpLayer = null;
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_ENEMY,onEnemyDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_BREAKABLE_PROP,onBreakableDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_FLOOR_ITEM,onFloorItemDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_INDOOR_DOOR,onIndoorDoorDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_OUTDOOR_DOOR,onOutdoorDoorDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_FIXED_OBJECT,onFixedObjectDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_SANDY,onCharacterDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_PATRICK,onCharacterDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_SQUIDWARD,onCharacterDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_KRAB,onCharacterDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_MOVING_BLOCK,onMovingBlockDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_PUZZLE_NODE,onEventTileDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_INTRO_NODE,onEventTileDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_TUTORIAL_NODE,onEventTileDestroy);
         _oGameDisp.removeEventListener(MapGenerateEvent.EVENT_DESTROY_CHEST,onChestDestroy);
         _oGameDisp.removeEventListener(ThrowEvent.EVENT_ENEMY_THROW_PROJECTILE,onProjectileThrow);
         _oGameDisp.removeEventListener(ThrowEvent.EVENT_PLAYER_THROW_PROJECTILE,onProjectileThrow);
         _oGameDisp.removeEventListener(ProjectileEvent.EVENT_DESTROY,onProjectileDestroy);
         _oGameDisp.removeEventListener(GameEvent.EVENT_UPDATE,update);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_ENEMY_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(MovingBodyEvent.EVENT_PLAYER_PROJECTILE_MOVE,onCollisionCheck);
         _oGameDisp.removeEventListener(DropItemEvent.EVENT_DROP_ITEM,onDropItem);
         _oGameDisp.removeEventListener(DropItemEvent.EVENT_FOUND_ITEM_IN_CHEST,onFoundItem);
         for each(v in aEnemies)
         {
            v = null;
         }
         aEnemies.splice(0);
         aEnemies = null;
         for each(v in aProjectiles)
         {
            v = null;
         }
         aProjectiles.splice(0);
         aProjectiles = null;
         for each(v in aBreakables)
         {
            v = null;
         }
         aBreakables.splice(0);
         aBreakables = null;
         for each(v in aFloorItems)
         {
            v = null;
         }
         aFloorItems.splice(0);
         aFloorItems = null;
         for each(v in aIndoors)
         {
            v = null;
         }
         aIndoors.splice(0);
         aIndoors = null;
         for each(v in aOutdoors)
         {
            v = null;
         }
         aOutdoors.splice(0);
         aOutdoors = null;
         aIndoorsLink = null;
         for each(v in aFixedObjects)
         {
            v = null;
         }
         aFixedObjects.splice(0);
         aFixedObjects = null;
         for each(v in aBlocks)
         {
            v = null;
         }
         aBlocks.splice(0);
         aBlocks = null;
         for each(v in aCharacters)
         {
            v = null;
         }
         aCharacters.splice(0);
         aCharacters = null;
         for each(v in aChests)
         {
            v = null;
         }
         aChests.splice(0);
         aChests = null;
         for each(v in aEvents)
         {
            v = null;
         }
         aEvents.splice(0);
         aEvents = null;
         for each(v in oRooms)
         {
            _oRoom = v as Room;
            _oRoom.removeEventListener(RoomEvent.EVENT_ENTER_ROOM,onEnteringRoom);
            _oRoom.removeEventListener(RoomEvent.EVENT_LEAVE_ROOM,onLeavingRoom);
            v = null;
            _oRoom = null;
         }
         oRooms = null;
         oCameraZone = null;
         oCameraLimits = null;
         oDepthManager.destroy();
         oDepthManager = null;
         oPlayerStartPoint = null;
         oDoorStartPoint = null;
         oMapData = null;
         if(oMaskBitmapData != null)
         {
            oMaskBitmapData.dispose();
            oMaskBitmapData = null;
         }
         oMaskBitmap = null;
         oFloorBitmapData.dispose();
         oFloorBitmapData = null;
         oFloorBitmap = null;
         while(mcRef.numChildren > 0)
         {
            mcRef.removeChildAt(0);
         }
         mcRef = null;
         oEventDisp = null;
         trace("Map : END destroy");
      }
      
      public function attachPlayerToMap(_oPlayer:Player) : void
      {
         if(_oPlayer == null || oDepthManager == null)
         {
            return;
         }
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         _dpLayer.addChild(_oPlayer.getMC());
         if(oPlayerStartPoint != null)
         {
            _oPlayer.setPosition(oPlayerStartPoint.x,oPlayerStartPoint.y);
         }
         var _nAngle:Number = Math.atan2(-(oPlayerStartPoint.y - oDoorStartPoint.y),oPlayerStartPoint.x - oDoorStartPoint.x);
         _oPlayer.setOrientation(_nAngle);
         enableCameraOnPlayer();
      }
      
      private function throwItemFromDropTable(_aDropTable:Array) : uint
      {
         if(_aDropTable == null || _aDropTable.length < 5)
         {
            return ItemID.uNULL_ITEM;
         }
         var _uThrow:uint = MoreMath.getRandomRange(1,100);
         var _uRet:uint = ItemID.uNULL_ITEM;
         var _uOffset:uint = 0;
         if(_aDropTable[Data.uDROP_TABLE_INDEX_KEY] > _uThrow)
         {
            _uRet = ItemID.uDOOR_KEY;
         }
         else
         {
            _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_KEY];
            if(_aDropTable[Data.uDROP_TABLE_INDEX_HEALTH] + _uOffset > _uThrow)
            {
               _uRet = ItemID.uHEARTH;
            }
            else
            {
               _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_HEALTH];
               if(_aDropTable[Data.uDROP_TABLE_INDEX_PEEBLE] + _uOffset > _uThrow)
               {
                  _uRet = throwPeeble();
               }
               else
               {
                  _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_PEEBLE];
                  if(_aDropTable[Data.uDROP_TABLE_INDEX_SEA_URCHIN] + _uOffset > _uThrow)
                  {
                     _uRet = ItemID.uSEA_URCHIN;
                  }
                  else
                  {
                     _uOffset += _aDropTable[Data.uDROP_TABLE_INDEX_SEA_URCHIN];
                     if(_aDropTable[Data.uDROP_TABLE_INDEX_VOLC_URCHIN] + _uOffset > _uThrow)
                     {
                        _uRet = ItemID.uVOLCANIC_URCHIN;
                     }
                     else
                     {
                        _uRet = ItemID.uNULL_ITEM;
                     }
                  }
               }
            }
         }
         return _uRet;
      }
      
      private function pause(_e:Event) : void
      {
         bNeedZOrdering;
      }
      
      public function createEvent(_uID:uint, _uRoom:uint, _oWorldMatrix:Matrix) : void
      {
         var _oEvent:Object = null;
         var _sEv:String = null;
         trace("Map : Create event");
         var _oRoom:Room = createRoomIfNotCreated(_uRoom);
         var _oPos:Point = new Point(0,0);
         _oPos = _oWorldMatrix.transformPoint(_oPos);
         switch(_uID)
         {
            case Data.uEVENT_PUZZLE_SOLVED:
               _oEvent = new PuzzleTile(_oPos.x,_oPos.y,_oRoom);
               _sEv = MapGenerateEvent.EVENT_CREATE_PUZZLE_NODE;
               break;
            case Data.uEVENT_INTRO:
               _oEvent = new IntroTile(_oPos.x,_oPos.y,_oRoom);
               _sEv = MapGenerateEvent.EVENT_CREATE_INTRO_NODE;
               break;
            case Data.uEVENT_TUTORIAL:
               _oEvent = new TutorialTile(_oPos.x,_oPos.y,_oRoom);
               _sEv = MapGenerateEvent.EVENT_CREATE_TUTORIAL_NODE;
         }
         aEvents.push(_oEvent);
         dispatchEvent(new MapGenerateEvent(_sEv,_oEvent));
      }
      
      public function swapDepth() : void
      {
         var _nLDepth:Number = NaN;
         var _nRDepth:Number = NaN;
         var _oLChild:DisplayObject = null;
         var _oRChild:DisplayObject = null;
         var _dpLayer:DisplayObjectContainer = oDepthManager.getDepthLayer(sDEPTH_Z_BUFFERING);
         var _nDepthByColumn:Number = 10000;
         var _uNumChild:uint = _dpLayer.numChildren;
         var i:uint = 0;
         var j:uint = 0;
         for(i = 0; i < _uNumChild - 1; i++)
         {
            for(j = i + 1; j < _uNumChild; j++)
            {
               _oLChild = _dpLayer.getChildAt(i);
               _nLDepth = _oLChild.x / Data.iTILE_WIDTH + _oLChild.y / Data.iMAP_HEIGHT * _nDepthByColumn;
               _oRChild = _dpLayer.getChildAt(j);
               _nRDepth = _oRChild.x / Data.iTILE_WIDTH + _oRChild.y / Data.iMAP_HEIGHT * _nDepthByColumn;
               if(_nLDepth > _nRDepth)
               {
                  _dpLayer.swapChildrenAt(i,j);
               }
            }
         }
      }
   }
}
