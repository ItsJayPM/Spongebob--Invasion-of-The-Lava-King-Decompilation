package builder
{
   import builder.events.BuilderEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import library.interfaces.Idestroyable;
   import library.utils.MoreMath;
   
   public class LBLevel implements Idestroyable
   {
       
      
      private var oKeys:Object;
      
      private var oBounds:Object;
      
      private var mcRef:MovieClip;
      
      public function LBLevel(_mcRef:MovieClip, _oBounds:Object)
      {
         super();
         mcRef = _mcRef;
         oBounds = _oBounds;
         oKeys = new Object();
         oKeys[Keyboard.SPACE] = false;
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.builderManager.addEventListener(BuilderEvent.EVENT_DESTROY,destroy,false,0,true);
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
         Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         mcRef.addEventListener(MouseEvent.MOUSE_DOWN,onClick,false,0,true);
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("LB Level destroyed");
         mcRef.removeEventListener(MouseEvent.MOUSE_DOWN,onClick,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onRelease,false);
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_UPDATE,update,false);
         Main.instance.builderManager.removeEventListener(BuilderEvent.EVENT_DESTROY,destroy,false);
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false);
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp,false);
         oKeys = null;
         mcRef = null;
         oBounds = null;
      }
      
      private function moveLevel() : void
      {
         var _oMousePoint:Point = null;
         var _oCenterPoint:Point = null;
         var _iCurrentAngle:Number = NaN;
         var _nSpeed:Number = NaN;
         if(oKeys[Keyboard.SPACE] && Main.instance.builderManager.zoom == Main.instance.builderManager.zoomIn)
         {
            _oMousePoint = new Point(mcRef.parent.mouseX,mcRef.parent.mouseY);
            _oCenterPoint = new Point((oBounds.xMin + oBounds.xMax) / 2,(oBounds.yMin + oBounds.yMax) / 2);
            _iCurrentAngle = MoreMath.getAngle(_oCenterPoint,_oMousePoint);
            _nSpeed = Point.distance(_oMousePoint,_oCenterPoint) / 25;
            mcRef.x -= _nSpeed * Math.cos(Math.PI / 180 * _iCurrentAngle);
            mcRef.y -= _nSpeed * Math.sin(Math.PI / 180 * _iCurrentAngle);
            if(mcRef.x > oBounds.xMin)
            {
               mcRef.x = oBounds.xMin;
            }
            if(mcRef.y > oBounds.yMin)
            {
               mcRef.y = oBounds.yMin;
            }
            if(mcRef.x + Data.iMAP_WIDTH < oBounds.xMax)
            {
               mcRef.x = oBounds.xMax - Data.iMAP_WIDTH;
            }
            if(mcRef.y + Data.iMAP_HEIGHT < oBounds.yMax)
            {
               mcRef.y = oBounds.yMax - Data.iMAP_HEIGHT;
            }
         }
      }
      
      private function onClick(_e:MouseEvent) : void
      {
         var _nMouseX:Number = mcRef.mouseX;
         var _nMouseY:Number = mcRef.mouseY;
         if(Main.instance.builderManager.zoom == Main.instance.builderManager.zoomOut)
         {
            Main.instance.builderManager.setZoom(Main.instance.builderManager.zoomIn);
            mcRef.x -= _nMouseX;
            mcRef.y -= _nMouseY;
            mcRef.x += (oBounds.xMax - oBounds.xMin) / 2;
            mcRef.y += (oBounds.yMax - oBounds.yMin) / 2;
            if(mcRef.x > oBounds.xMin)
            {
               mcRef.x = oBounds.xMin;
            }
            if(mcRef.y > oBounds.yMin)
            {
               mcRef.y = oBounds.yMin;
            }
            if(mcRef.x + Data.iMAP_WIDTH < oBounds.xMax)
            {
               mcRef.x = oBounds.xMax - Data.iMAP_WIDTH;
            }
            if(mcRef.y + Data.iMAP_HEIGHT < oBounds.yMax)
            {
               mcRef.y = oBounds.yMax - Data.iMAP_HEIGHT;
            }
         }
         else
         {
            if(Main.instance.builderManager.tool == LevelBuilder.sTOOL_LINK)
            {
               Main.instance.builderManager.getLinkData(_nMouseX,_nMouseY);
            }
            else if(Main.instance.builderManager.tool == LevelBuilder.sTOOL_SELECT)
            {
               Main.instance.builderManager.getSelectData(_nMouseX,_nMouseY);
            }
            else
            {
               Main.instance.builderManager.setMapData(_nMouseX,_nMouseY);
            }
            Main.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false,0,true);
            Main.instance.stage.addEventListener(MouseEvent.MOUSE_UP,onRelease,false,0,true);
         }
      }
      
      private function onKeyUp(_e:KeyboardEvent) : void
      {
         if(_e.keyCode == Keyboard.SPACE)
         {
            oKeys[Keyboard.SPACE] = false;
         }
      }
      
      public function onRelease(_e:MouseEvent) : void
      {
         var _nMouseX:Number = NaN;
         var _nMouseY:Number = NaN;
         trace("RELEASE");
         if(Main.instance.builderManager.tool == LevelBuilder.sTOOL_SELECT)
         {
            _nMouseX = mcRef.mouseX;
            _nMouseY = mcRef.mouseY;
            Main.instance.builderManager.setMapData(_nMouseX,_nMouseY);
         }
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onRelease,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false);
      }
      
      private function update(_e:Event) : void
      {
         moveLevel();
      }
      
      public function onMouseLeave() : void
      {
         trace("MOUSE LEAVE");
         if(Main.instance.builderManager.tool == LevelBuilder.sTOOL_SELECT)
         {
            Main.instance.builderManager.resetSelection();
         }
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onRelease,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false);
      }
      
      private function onMouseMove(_e:MouseEvent) : void
      {
         var _nMouseX:Number = Main.instance.stage.mouseX;
         var _nMouseY:Number = Main.instance.stage.mouseY;
         if(_nMouseX < 0 || _nMouseX > Data.iSTAGE_WIDTH || _nMouseY < 0 || _nMouseY > Data.iSTAGE_HEIGHT)
         {
            onMouseLeave();
         }
         else
         {
            _nMouseX = mcRef.mouseX;
            _nMouseY = mcRef.mouseY;
            if(Main.instance.builderManager.tool == LevelBuilder.sTOOL_MAP)
            {
               Main.instance.builderManager.setMapData(_nMouseX,_nMouseY);
            }
         }
      }
      
      private function onKeyDown(_e:KeyboardEvent) : void
      {
         if(_e.keyCode == Keyboard.SPACE)
         {
            oKeys[Keyboard.SPACE] = true;
         }
      }
   }
}
