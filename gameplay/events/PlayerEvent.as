package gameplay.events
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      
      public static const EVENT_TRIGGER_FINISH_DIE_ANIM:String = "PlayerEvent_finishDieAnim";
      
      public static const EVENT_TRIGGER_ACTION_BUTTON:String = "PlayerEvent_triggerActionButton";
       
      
      private var nPosX:Number;
      
      private var nPosY:Number;
      
      private var nDir:Number;
      
      public function PlayerEvent(_sType:String, _nWorldPosX:Number, _nWorldPosY:Number, _nDirection:Number)
      {
         super(_sType);
         nPosX = _nWorldPosX;
         nPosY = _nWorldPosY;
         nDir = _nDirection;
      }
      
      public function get worldPositionY() : Number
      {
         return nPosY;
      }
      
      public function get direction() : Number
      {
         return nDir;
      }
      
      public function get worldPositionX() : Number
      {
         return nPosX;
      }
      
      override public function clone() : Event
      {
         return new PlayerEvent(type,nPosX,nPosY,nDir);
      }
   }
}
