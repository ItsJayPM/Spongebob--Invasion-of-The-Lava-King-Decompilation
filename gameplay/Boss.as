package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Boss extends Enemy
   {
      
      public static const sSTATE_DIE:String = "die";
       
      
      private var oRoom:Room;
      
      public function Boss(_mcRef:MovieClip, _oRoom:Room, _nInitialHealth:Number, _nTouchDamage:Number)
      {
         super(_mcRef,_oRoom,_nInitialHealth,_nTouchDamage,false);
         oRoom = _oRoom;
         oRoom.addBoss();
      }
      
      override protected function die() : void
      {
         setState(sSTATE_DIE);
      }
      
      override public function destroy(_e:Event = null) : void
      {
         oRoom.removeBoss();
         oRoom.removeAnEnemy();
         super.destroy(_e);
      }
   }
}
