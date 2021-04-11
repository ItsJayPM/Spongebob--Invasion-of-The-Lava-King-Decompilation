package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class AttackEvent extends Event
   {
      
      public static const EVENT_PLAYER_ATTACK:String = "AttackEvent_player";
      
      public static const EVENT_ENEMY_ATTACK:String = "AttackEvent_enemy";
      
      public static const EVENT_PLAYER_PROJECTILE_ATTACK:String = "AttackEvent_projectilePlayer";
      
      public static const uENEMY_EFFECT_SLIME:uint = 2;
      
      public static const EVENT_ENEMY_PROJECTILE_ATTACK:String = "Attackevent_projectileEnemey";
      
      public static const uENEMY_EFFECT_ELECTRIFY:uint = 1;
      
      public static const uENEMY_EFFECT_MASHED:uint = 3;
       
      
      private var uItemUsed:uint;
      
      private var oAgressor:Object;
      
      private var oWorldFrom:Point;
      
      private var oWorldAttackZone:Rectangle;
      
      private var nDamage:Number;
      
      public function AttackEvent(_sType:String, _oBy:Object, _nDamage:Number, _oWorldAttackZone:Rectangle, _oWorldFrom:Point, _uItemUsed:uint = 0)
      {
         super(_sType);
         nDamage = new Number(_nDamage);
         oWorldAttackZone = _oWorldAttackZone.clone();
         oWorldFrom = _oWorldFrom.clone();
         uItemUsed = _uItemUsed;
         oAgressor = _oBy;
      }
      
      public function get agressor() : Object
      {
         return oAgressor;
      }
      
      override public function clone() : Event
      {
         return new AttackEvent(type,oAgressor,nDamage,oWorldAttackZone,oWorldFrom,uItemUsed);
      }
      
      public function get worldAttackZone() : Rectangle
      {
         return oWorldAttackZone.clone();
      }
      
      public function get damage() : Number
      {
         return nDamage;
      }
      
      public function get itemUsed() : uint
      {
         return uItemUsed;
      }
      
      public function get enemyEffect() : uint
      {
         return uItemUsed;
      }
      
      public function get worldFrom() : Point
      {
         return oWorldFrom.clone();
      }
   }
}
