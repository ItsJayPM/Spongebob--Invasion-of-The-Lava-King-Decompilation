package builder
{
   import builder.events.BuilderEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import library.basic.StateManaged;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   
   public class AssetManager extends StateManaged implements Idestroyable
   {
      
      public static const sSTATE_KEYITEMS:String = "keyItems";
      
      public static const sSTATE_PUZZLE:String = "puzzle";
      
      public static const sSTATE_TILES_LAIR_LV1:String = "tilesLairLv1";
      
      public static const sSTATE_TILES_LAIR_LV3:String = "tilesLairLv3";
      
      public static const sSTATE_ENEMIES:String = "enemies";
      
      public static const sSTATE_TILES_LAIR_LV2:String = "tilesLairLv2";
      
      public static const sSTATE_TILES_MAP_LV2:String = "tilesMapLv2";
      
      public static const sSTATE_TILES_MAP_LV3:String = "tilesMapLv3";
      
      public static const sSTATE_DOORS_LV1:String = "doorsLv1";
      
      public static const sSTATE_DOORS_LV2:String = "doorsLv2";
      
      public static const sSTATE_DOORS_LV3:String = "doorsLv3";
      
      public static const sSTATE_TILES_MAP_LV1:String = "tilesMapLv1";
      
      public static const sSTATE_CHARACTERS:String = "characters";
      
      public static const sSTATE_MISC:String = "misc";
      
      public static const sSTATE_OBJECTS_LV1:String = "objectsLv1";
      
      public static const sSTATE_OBJECTS_LV2:String = "objectsLv2";
      
      public static const sSTATE_OBJECTS_LV3:String = "objectsLv3";
      
      public static const sSTATE_ITEMS:String = "items";
       
      
      private var oLimitAsset:Object;
      
      private var oLimitScroller:Object;
      
      private var aAssetList:Array;
      
      private const nASSET_VIEWER_HEIGHT:Number = 254;
      
      public function AssetManager(_mcRef:MovieClip)
      {
         super(_mcRef);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(BuilderEvent.EVENT_DESTROY,destroy,false,0,true);
         addState(sSTATE_TILES_MAP_LV1,null,loadState,unloadState);
         addState(sSTATE_TILES_MAP_LV2,null,loadState,unloadState);
         addState(sSTATE_TILES_MAP_LV3,null,loadState,unloadState);
         addState(sSTATE_TILES_LAIR_LV1,null,loadState,unloadState);
         addState(sSTATE_TILES_LAIR_LV2,null,loadState,unloadState);
         addState(sSTATE_TILES_LAIR_LV3,null,loadState,unloadState);
         addState(sSTATE_OBJECTS_LV1,null,loadState,unloadState);
         addState(sSTATE_OBJECTS_LV2,null,loadState,unloadState);
         addState(sSTATE_OBJECTS_LV3,null,loadState,unloadState);
         addState(sSTATE_DOORS_LV1,null,loadState,unloadState);
         addState(sSTATE_DOORS_LV2,null,loadState,unloadState);
         addState(sSTATE_DOORS_LV3,null,loadState,unloadState);
         addState(sSTATE_CHARACTERS,null,loadState,unloadState);
         addState(sSTATE_ITEMS,null,loadState,unloadState);
         addState(sSTATE_KEYITEMS,null,loadState,unloadState);
         addState(sSTATE_PUZZLE,null,loadState,unloadState);
         addState(sSTATE_ENEMIES,null,loadState,unloadState);
         addState(sSTATE_MISC,null,loadState,unloadState);
         setState(sSTATE_TILES_MAP_LV1);
      }
      
      public function destroy(_e:Event = null) : void
      {
         var i:* = null;
         trace("AssetManager Destroyed");
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(BuilderEvent.EVENT_DESTROY,destroy,false);
         if(aAssetList != null)
         {
            for(i in aAssetList)
            {
               aAssetList[i].destroy();
               aAssetList[i] = null;
            }
         }
         oLimitScroller = null;
         oLimitAsset = null;
         mcRef = null;
      }
      
      private function setAssets() : void
      {
         var _nNumChildren:Number = mcState.numChildren;
         for(var i:Number = 0; i < _nNumChildren; i++)
         {
            aAssetList.push(new LBAsset(mcState.getChildAt(i)));
         }
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         trace("CLICK");
         mcRef.mcSlider.removeEventListener(MouseEvent.MOUSE_DOWN,onClick,false);
         mcRef.mcSlider.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
         Main.instance.addEventListener(MouseEvent.MOUSE_UP,onRelease,false,0,true);
         Main.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove,false,0,true);
         oLimitScroller.nDecal = mcRef.mouseY - mcRef.mcSlider.y;
      }
      
      private function loadState() : void
      {
         trace("LOADSTATE");
         mcRef.mcSlider.addEventListener(MouseEvent.MOUSE_DOWN,onClick,false,0,true);
         mcRef.mcSlider.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         mcRef.mcSlider.y = mcRef.mcSliderBar.y;
         oLimitScroller = new Object();
         oLimitScroller.nMinY = mcRef.mcSliderBar.y;
         oLimitScroller.nMaxY = mcRef.mcSliderBar.y + mcRef.mcSliderBar.height;
         oLimitScroller.nDistance = oLimitScroller.nMaxY - oLimitScroller.nMinY;
         oLimitScroller.nDecal = 0;
         oLimitAsset = new Object();
         oLimitAsset.nMinY = mcState.y;
         oLimitAsset.nMaxY = mcState.y + mcState.height;
         oLimitAsset.nDistance = oLimitAsset.nMaxY - oLimitAsset.nMinY;
         oLimitAsset.nExtend = oLimitAsset.nMaxY - nASSET_VIEWER_HEIGHT;
         aAssetList = new Array();
         setAssets();
      }
      
      public function onRelease(_e:MouseEvent) : void
      {
         trace("RELEASE");
         Main.instance.removeEventListener(MouseEvent.MOUSE_UP,onRelease,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove,false);
         mcRef.mcSlider.addEventListener(MouseEvent.MOUSE_DOWN,onClick,false,0,true);
         mcRef.mcSlider.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
      }
      
      public function onMove(_e:MouseEvent) : void
      {
         var _nMouseX:Number = Main.instance.stage.mouseX;
         var _nMouseY:Number = Main.instance.stage.mouseY;
         if(_nMouseX < 0 || _nMouseX > Data.iSTAGE_WIDTH || _nMouseY < 0 || _nMouseY > Data.iSTAGE_HEIGHT)
         {
            onRelease(null);
         }
         else
         {
            _nMouseY = mcRef.mouseY - oLimitScroller.nDecal;
            if(_nMouseY < oLimitScroller.nMinY)
            {
               mcRef.mcSlider.y = oLimitScroller.nMinY;
            }
            else if(_nMouseY > oLimitScroller.nMaxY)
            {
               mcRef.mcSlider.y = oLimitScroller.nMaxY;
            }
            else
            {
               mcRef.mcSlider.y = _nMouseY;
            }
         }
         var _nNewPosition:Number = _nMouseY * 100 / oLimitScroller.nDistance;
         if(_nNewPosition < 0)
         {
            _nNewPosition = 0;
         }
         if(_nNewPosition > 100)
         {
            _nNewPosition = 100;
         }
         if(oLimitAsset.nDistance > nASSET_VIEWER_HEIGHT)
         {
            mcState.y = oLimitAsset.nMinY - _nNewPosition * (oLimitAsset.nExtend / 100);
         }
      }
      
      private function unloadState() : void
      {
         var i:* = null;
         if(aAssetList != null)
         {
            for(i in aAssetList)
            {
               aAssetList[i].destroy(null);
               aAssetList[i] = null;
            }
         }
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
      }
   }
}
