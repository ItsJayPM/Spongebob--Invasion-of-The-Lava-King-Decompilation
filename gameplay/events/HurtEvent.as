package gameplay.events
{
   import flash.events.Event;
   
   public class HurtEvent extends Event
   {
      
      public static const EVENT_ENEMY_DIE:String = "HurtEvent_enemyDie";
      
      public static const EVENT_PLAYER_DIE:String = "HurtEvent_playerDie";
      
      public static const EVENT_PLAYER_HITTED:String = "HurtEvent_playerHitted";
      
      public static const EVENT_ENEMY_HITTED:String = "HurtEvent_enemyHitted";
       
      
      private var oVictim:Object;
      
      private var oAgressor:Object;
      
      private var nDamage:Number;
      
      public function HurtEvent(_sType:String, _nDamage:Number = 0, _oAgressor:Object = null, _oVictim:Object = null)
      {
         super(_sType);
         nDamage = new Number(_nDamage);
         oAgressor = _oAgressor;
         oVictim = _oVictim;
      }
      
      override public function clone() : Event
      {
         return new HurtEvent(type,nDamage,oAgressor,oVictim);
      }
      
      public function get victim() : Object
      {
         return oVictim;
      }
      
      public function get agressor() : Object
      {
         return oAgressor;
      }
      
      public function get damage() : Number
      {
         return nDamage;
      }
   }
}
