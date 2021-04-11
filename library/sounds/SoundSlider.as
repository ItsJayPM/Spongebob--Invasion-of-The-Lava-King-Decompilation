package library.sounds
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SoundSlider
   {
       
      
      private var sSoundCategory:String;
      
      private var oEndPoint:Point;
      
      private var oStartPoint:Point;
      
      private var mcRef:MovieClip;
      
      public function SoundSlider(_mcRef:MovieClip, _sSoundCategory:String)
      {
         super();
         mcRef = _mcRef;
         sSoundCategory = _sSoundCategory;
         setPoints();
         setAnchor();
         mcRef.mcAnchor.addEventListener(MouseEvent.MOUSE_DOWN,onClick,false,0,true);
      }
      
      private function setPoints() : void
      {
         var _nRotation:Number = mcRef.mcSlideBar.rotation;
         var _nWidth:Number = mcRef.mcSlideBar.width;
         var _nStartX:Number = mcRef.mcSlideBar.x + _nWidth * Math.cos(_nRotation * Math.PI / 180);
         var _nStartY:Number = mcRef.mcSlideBar.y + _nWidth * Math.sin(_nRotation * Math.PI / 180);
         var _nEndX:Number = mcRef.mcSlideBar.x;
         var _nEndY:Number = mcRef.mcSlideBar.y;
         oStartPoint = new Point(_nStartX,_nStartY);
         oEndPoint = new Point(_nEndX,_nEndY);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         mcRef.mcAnchor.removeEventListener(MouseEvent.MOUSE_DOWN,onClick,false);
         Main.instance.addEventListener(MouseEvent.MOUSE_UP,onRelease,false,0,true);
         Main.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove,false,0,true);
      }
      
      public function manageSoundVolume() : void
      {
         var _oLimbPoint:Point = new Point(mcRef.mcAnchor.x,mcRef.mcAnchor.y);
         var _nDiffMax:Number = Point.distance(oStartPoint,oEndPoint);
         var _nDiff:Number = Point.distance(oEndPoint,_oLimbPoint);
         var _nVolume:Number = _nDiff / _nDiffMax;
         SoundManager.setCategoryVolume(sSoundCategory,_nVolume);
      }
      
      public function onRelease(_e:MouseEvent) : void
      {
         manageSoundVolume();
         Main.instance.removeEventListener(MouseEvent.MOUSE_UP,onRelease,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove,false);
         mcRef.mcAnchor.addEventListener(MouseEvent.MOUSE_DOWN,onClick,false,0,true);
      }
      
      private function onMove(_e:MouseEvent) : void
      {
         var _nDistance:Number = NaN;
         var _oLimbPoint:Point = null;
         var _nDiffMax:Number = NaN;
         var _nDiff:Number = NaN;
         var _nPercent:Number = NaN;
         var _nFactor:Number = NaN;
         var _oPoint:Point = null;
         var _nMouseX:Number = Main.instance.stage.mouseX;
         var _nMouseY:Number = Main.instance.stage.mouseY;
         if(_nMouseX < 0 || _nMouseX > Data.iSTAGE_WIDTH || _nMouseY < 0 || _nMouseY > Data.iSTAGE_HEIGHT)
         {
            onRelease(null);
         }
         else
         {
            _nMouseX = mcRef.mouseX;
            _nDistance = _nMouseX - oEndPoint.x;
            _oLimbPoint = new Point(mcRef.mcAnchor.x,mcRef.mcAnchor.y);
            _nDiffMax = Point.distance(oStartPoint,oEndPoint);
            _nDiff = Point.distance(_oLimbPoint,oStartPoint);
            _nPercent = Math.floor(_nDiff * 100 / _nDiffMax);
            _nFactor = _nDistance / Point.distance(oStartPoint,oEndPoint);
            if(_nFactor < 0)
            {
               _oPoint = oEndPoint;
            }
            else if(_nFactor > 1)
            {
               _oPoint = oStartPoint;
            }
            else
            {
               _oPoint = Point.interpolate(oStartPoint,oEndPoint,_nFactor);
            }
            mcRef.mcAnchor.x = _oPoint.x;
            mcRef.mcAnchor.y = _oPoint.y;
            manageSoundVolume();
         }
      }
      
      private function setAnchor() : void
      {
         var _nDiffMax:Number = Point.distance(oStartPoint,oEndPoint);
         var _nCurrentVolume:Number = SoundManager.getCategoryVolume(sSoundCategory);
         mcRef.mcAnchor.x = oEndPoint.x + _nCurrentVolume * _nDiffMax;
      }
      
      public function destroy(_e:Event = null) : void
      {
         trace("Slider destroyed");
         mcRef.mcAnchor.removeEventListener(MouseEvent.MOUSE_DOWN,onClick,false);
         Main.instance.removeEventListener(MouseEvent.MOUSE_UP,onRelease,false);
         Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove,false);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         mcRef = null;
      }
   }
}
