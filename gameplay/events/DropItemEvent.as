package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Point;
   import gameplay.Room;
   
   public class DropItemEvent extends Event
   {
      
      public static const EVENT_FOUND_ITEM_IN_CHEST:String = "DropItemEvent_foundInChest";
      
      public static const EVENT_DROP_ITEM:String = "DropItemEvent_dropItem";
       
      
      private var uItem:uint;
      
      private var oSource:Point;
      
      private var oRoom:Room;
      
      private var nPosX:Number;
      
      private var nPosY:Number;
      
      public function DropItemEvent(_sType:String, _uItemToDrop:uint, _nWorldX:Number, _nWorldY:Number, _oAtRoom:Room = null, _oWorldSource:Point = null)
      {
         super(_sType);
         uItem = _uItemToDrop;
         nPosX = _nWorldX;
         nPosY = _nWorldY;
         oRoom = _oAtRoom;
         if(_oWorldSource != null)
         {
            oSource = _oWorldSource.clone();
         }
         else
         {
            oSource = new Point(_nWorldX,_nWorldY);
         }
      }
      
      public function get room() : Room
      {
         return oRoom;
      }
      
      public function get worldPositionX() : Number
      {
         return nPosX;
      }
      
      public function get worldSource() : Point
      {
         return oSource.clone();
      }
      
      public function get itemId() : uint
      {
         return uItem;
      }
      
      override public function clone() : Event
      {
         return new DropItemEvent(type,uItem,nPosX,nPosY,oRoom,oSource);
      }
      
      public function get worldPositionY() : Number
      {
         return nPosY;
      }
   }
}
