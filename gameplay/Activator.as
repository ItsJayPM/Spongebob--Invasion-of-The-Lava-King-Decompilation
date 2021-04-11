package gameplay
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.CameraEvent;
   import gameplay.events.RoomEvent;
   
   public class Activator
   {
       
      
      private var fViewActivate:Function;
      
      private var bActivated:Boolean;
      
      private var mcRef:MovieClip;
      
      private var oLocalGeom:Rectangle;
      
      private var oRoom:Room;
      
      private var oWorldCam:Rectangle;
      
      private var oParent:DisplayObjectContainer;
      
      private var fViewDeactivate:Function;
      
      public function Activator(_mcRef:MovieClip, _oRoom:Room = null)
      {
         super();
         mcRef = _mcRef;
         oParent = _mcRef.parent;
         oRoom = _oRoom;
         snapShotGeometry();
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addEventListener(CameraEvent.EVENT_CAMERA_MOVE,onCameraMove,false,-1,true);
         if(oRoom != null)
         {
            oRoom.addEventListener(RoomEvent.EVENT_ENTER_ROOM,onRoomActivation,false,1,true);
            oRoom.addEventListener(RoomEvent.EVENT_LEAVE_ROOM,onRoomDeactivation,false,-1,true);
            if(oRoom.isActivated())
            {
               activate();
            }
            else if(isInCamera())
            {
               activate();
            }
            else
            {
               deactivate();
            }
         }
         else if(isInCamera())
         {
            activate();
         }
         else
         {
            deactivate();
         }
      }
      
      private function activate() : void
      {
         bActivated = true;
         if(fViewActivate != null)
         {
            fViewActivate();
         }
      }
      
      public function isActivated() : Boolean
      {
         return bActivated;
      }
      
      public function refreshVisibility() : Boolean
      {
         var _bSeen:Boolean = isInCamera(oWorldCam);
         if(isLinkedWithParent())
         {
            if(!_bSeen)
            {
               oParent.removeChild(mcRef);
            }
         }
         else if(_bSeen)
         {
            oParent.addChild(mcRef);
         }
         return _bSeen;
      }
      
      private function onRoomActivation(_e:RoomEvent) : void
      {
         if(!bActivated)
         {
            activate();
         }
      }
      
      private function onRoomDeactivation(_e:RoomEvent) : void
      {
      }
      
      private function isLinkedWithParent() : Boolean
      {
         var _iIndex:int = -1;
         try
         {
            _iIndex = oParent.getChildIndex(mcRef);
         }
         catch(e:ArgumentError)
         {
            _iIndex = -1;
         }
         return _iIndex != -1;
      }
      
      private function onCameraMove(_e:CameraEvent) : void
      {
         oWorldCam = _e.worldZone.clone();
         checkActivation();
      }
      
      public function setOnActivation(_fCallBack:Function) : void
      {
         fViewActivate = _fCallBack;
      }
      
      public function setOnDeactivation(_fCallBack:Function) : void
      {
         fViewDeactivate = _fCallBack;
      }
      
      private function deactivate() : void
      {
         bActivated = false;
         if(fViewDeactivate != null)
         {
            fViewDeactivate();
         }
      }
      
      public function snapShotGeometry() : void
      {
         oLocalGeom = mcRef.getBounds(mcRef).clone();
         if(mcRef is mcGameObjectDoorLv1 || mcRef is mcGameObjectLairDoorLv1)
         {
         }
      }
      
      public function destroy() : void
      {
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.removeEventListener(CameraEvent.EVENT_CAMERA_MOVE,onCameraMove);
         if(oRoom != null)
         {
            oRoom.removeEventListener(RoomEvent.EVENT_ENTER_ROOM,onRoomActivation);
            oRoom.removeEventListener(RoomEvent.EVENT_LEAVE_ROOM,onRoomDeactivation);
         }
         oLocalGeom = null;
         fViewActivate = null;
         fViewDeactivate = null;
      }
      
      private function isInCamera(_oWorldCameraZone:Rectangle = null) : Boolean
      {
         var _oView:Point = null;
         var _oWorldGeom:Rectangle = oLocalGeom.clone();
         if(_oWorldCameraZone == null)
         {
            _oWorldCameraZone = new Rectangle(0,0,Data.iSTAGE_WIDTH,Data.iSTAGE_HEIGHT);
            _oView = mcRef.localToGlobal(new Point(0,0));
            _oWorldGeom.offset(_oView.x,_oView.y);
            return _oWorldCameraZone.intersects(_oWorldGeom);
         }
         _oWorldGeom.offset(mcRef.x,mcRef.y);
         return _oWorldGeom.intersects(_oWorldCameraZone);
      }
      
      public function checkActivation() : Boolean
      {
         if(oWorldCam == null)
         {
            return isActivated();
         }
         var _bSeen:Boolean = refreshVisibility();
         if(mcRef is mcGameObjectDoorLv1 || mcRef is mcGameObjectLairDoorLv1)
         {
         }
         if(bActivated && !_bSeen)
         {
            deactivate();
         }
         else if(!bActivated && _bSeen)
         {
            activate();
         }
         return isActivated();
      }
   }
}
