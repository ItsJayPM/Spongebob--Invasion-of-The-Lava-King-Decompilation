package builder
{
   import builder.events.BuilderEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.ui.Mouse;
   import flash.utils.getDefinitionByName;
   import library.basic.StateManaged;
   import library.interfaces.Idestroyable;
   
   public class LBCursor extends StateManaged implements Idestroyable
   {
      
      public static const sSTATE_SCALE_Y:String = "scalingY";
      
      public static const sSTATE_SCALE_X:String = "scalingX";
      
      public static const sSTATE_MAP:String = "mapping";
      
      public static const sSTATE_ERASER:String = "erasing";
      
      public static const sSTATE_LINK:String = "linking";
      
      public static const sSTATE_ROTATE:String = "rotating";
      
      public static const sSTATE_SELECT:String = "selecting";
       
      
      private var mcAssetObject:MovieClip;
      
      private var oBounds:Object;
      
      private var mcLevel:MovieClip;
      
      public function LBCursor(_mcRef:MovieClip, _mcLevel:MovieClip, _oBounds:Object)
      {
         super(_mcRef);
         mcLevel = _mcLevel;
         oBounds = _oBounds;
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_PAUSE,pause,false,0,true);
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_RESUME,resume,false,0,true);
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_DESTROY,destroy,false,0,true);
         addState(sSTATE_MAP,state_map,null);
         addState(sSTATE_SELECT,state_select,null);
         addState(sSTATE_ERASER,state_eraser,null);
         addState(sSTATE_ROTATE,state_rotate,null);
         addState(sSTATE_LINK,state_link,null);
         addState(sSTATE_SCALE_X,state_scale,null);
         addState(sSTATE_SCALE_Y,state_scale,null);
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Cursor destroyed");
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         if(mcAssetObject != null)
         {
            Main.instance.builderManager.mappingLayer.removeChild(mcAssetObject);
         }
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_UPDATE,update,false);
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_PAUSE,pause,false);
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_RESUME,resume,false);
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
         mcLevel = null;
         mcAssetObject = null;
      }
      
      private function state_scale() : void
      {
         manageCursor(null);
      }
      
      private function state_rotate() : void
      {
         manageCursor(null);
      }
      
      private function state_select() : void
      {
         manageCursor(Main.instance.builderManager.assetSelection);
         moveAsset();
      }
      
      private function loadState() : void
      {
      }
      
      public function removeAsset() : void
      {
         if(mcAssetObject != null)
         {
            Main.instance.builderManager.mappingLayer.removeChild(mcAssetObject);
            mcAssetObject = null;
         }
      }
      
      private function state_map() : void
      {
         manageCursor(Main.instance.builderManager.asset);
         moveAsset();
      }
      
      private function state_link() : void
      {
         manageCursor(null);
      }
      
      private function unloadState() : void
      {
      }
      
      override public function pause(_e:Event = null) : void
      {
         super.pause();
         Mouse.show();
         mcRef.visible = false;
      }
      
      private function state_eraser() : void
      {
         manageCursor(null);
      }
      
      private function manageCursor(_sAsset:String) : void
      {
         var _cClass:Class = null;
         mcRef.x = mcRef.parent.mouseX;
         mcRef.y = mcRef.parent.mouseY;
         if(mcRef.x < oBounds.xMin || mcRef.x > oBounds.xMax || mcRef.y < oBounds.yMin || mcRef.y > oBounds.yMax || Main.instance.builderManager.zoom != Main.instance.builderManager.zoomIn)
         {
            Mouse.show();
            mcRef.visible = false;
            if(mcAssetObject != null && (state == sSTATE_MAP || state == sSTATE_SELECT))
            {
               Main.instance.builderManager.mappingLayer.removeChild(mcAssetObject);
               mcAssetObject = null;
            }
         }
         else
         {
            Mouse.hide();
            mcRef.visible = true;
            if(mcAssetObject == null && _sAsset != null && (state == sSTATE_MAP || state == sSTATE_SELECT))
            {
               _cClass = getDefinitionByName(_sAsset) as Class;
               mcAssetObject = new _cClass();
               Main.instance.builderManager.mappingLayer.addChild(mcAssetObject);
            }
         }
      }
      
      private function moveAsset() : void
      {
         var _nTileWidth:Number = NaN;
         var _nTileHeight:Number = NaN;
         var _nNextColumn:Number = NaN;
         var _nCurrentColumn:Number = NaN;
         var _nNextRow:Number = NaN;
         var _nCurrentRow:Number = NaN;
         if(Main.instance.builderManager.zoom == Main.instance.builderManager.zoomIn)
         {
            if(mcAssetObject != null)
            {
               _nTileWidth = Data.iTILE_WIDTH;
               _nTileHeight = Data.iTILE_HEIGHT;
               _nNextColumn = Math.floor(mcLevel.mouseX / _nTileWidth);
               _nCurrentColumn = Math.floor(mcAssetObject.x / _nTileWidth);
               _nNextRow = Math.floor(mcLevel.mouseY / _nTileHeight);
               _nCurrentRow = Math.floor(mcAssetObject.y / _nTileHeight);
               if(state == sSTATE_SELECT)
               {
                  if(mcAssetObject.txtIndex != null)
                  {
                     mcAssetObject.txtIndex.text = Main.instance.builderManager.selectionLink;
                  }
                  mcAssetObject.transform.matrix = Main.instance.builderManager.selectionMatrix;
               }
               mcAssetObject.x = _nNextColumn * _nTileWidth + _nTileWidth / 2;
               mcAssetObject.y = _nNextRow * _nTileHeight + _nTileHeight / 2;
            }
         }
      }
   }
}
