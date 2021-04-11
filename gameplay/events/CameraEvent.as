package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class CameraEvent extends Event
   {
      
      public static const EVENT_CAMERA_MOVE:String = "MapEvent_cameraMove";
       
      
      private var oWorldZone:Rectangle;
      
      public function CameraEvent(_sType:String, _oWorldZone:Rectangle)
      {
         super(_sType);
         oWorldZone = _oWorldZone.clone();
      }
      
      public function get worldZone() : Rectangle
      {
         return oWorldZone.clone();
      }
      
      override public function clone() : Event
      {
         return new CameraEvent(type,oWorldZone);
      }
   }
}
