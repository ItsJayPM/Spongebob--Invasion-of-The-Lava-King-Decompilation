package gameplay
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gameplay.events.GameEvent;
   import gameplay.events.MapGenerateEvent;
   import gameplay.events.MovingBodyEvent;
   import gameplay.events.RoomEvent;
   
   public class IntroTile implements IEventDispatcher
   {
       
      
      private var oRoom:Room;
      
      private var oWorldZone:Rectangle;
      
      private var oWorldPos:Point;
      
      private var oEventDisp:EventDispatcher;
      
      public function IntroTile(_nWorldX:Number, _nWorldY:Number, _oRoom:Room)
      {
         super();
         oRoom = _oRoom;
         oEventDisp = new EventDispatcher(this);
         oWorldPos = new Point(_nWorldX,_nWorldY);
         oWorldZone = new Rectangle(-Data.iTILE_WIDTH / 2,-Data.iTILE_HEIGHT / 2,Data.iTILE_WIDTH,Data.iTILE_HEIGHT);
         oWorldZone.offsetPoint(oWorldPos);
         GameDispatcher.Instance.addWeakEventListener(GameEvent.EVENT_START,onGameStart,-1);
         trace("############### INTRO TILE !!! AHHH !!!",oWorldZone);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function destroy(_e:Event = null) : void
      {
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_INTRO_NODE,this));
         GameDispatcher.Instance.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
         oWorldZone = null;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function onGameStart(_e:GameEvent) : void
      {
         dispatchEvent(new RoomEvent(RoomEvent.EVENT_ROOM_INTRO_TILE,oRoom.getRoomId(),oWorldPos));
         Main.instance.addPopup(Main.sPOPUP_STORY);
         destroy();
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function onPlayerMove(_e:MovingBodyEvent) : void
      {
         var _oFeet:Rectangle = _e.localFeetZone;
         _oFeet.offsetPoint(_e.newWorldPosition);
         if(oWorldZone.intersects(_oFeet))
         {
            dispatchEvent(new RoomEvent(RoomEvent.EVENT_ROOM_INTRO_TILE,oRoom.getRoomId(),oWorldPos));
            Main.instance.addPopup(Main.sPOPUP_STORY);
            destroy();
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
   }
}
