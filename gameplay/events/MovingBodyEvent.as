package gameplay.events
{
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MovingBodyEvent extends Event
   {
      
      public static const EVENT_ENEMY_HIT_MOVING_PLAYER:String = "MovingBodyEvent_collidesWithPlayer";
      
      public static const EVENT_PLAYER_MOVE:String = "MovingBodyEvent_playerMove";
      
      public static const EVENT_ENEMY_PROJECTILE_MOVE:String = "MovingBodyEvent_enemyProjectileMove";
      
      public static const EVENT_ENEMY_MOVE:String = "MovingBodyEvent_enemyMove";
      
      public static const EVENT_PLAYER_PROJECTILE_MOVE:String = "MovingBodyEvent_playerProjectileMove";
       
      
      private var oLastWorldPos:Point;
      
      private var oLocalBodyZone:Rectangle;
      
      private var uCollideTries:uint;
      
      private var oMover:Object;
      
      private var oNewWorldPos:Point;
      
      private var nHitDamage:Number;
      
      private var oLocalFeetZone:Rectangle;
      
      public function MovingBodyEvent(_sType:String, _oMover:Object, _oLastWorldPos:Point, _oNewWorldPos:Point, _oLocalFeetZone:Rectangle = null, _oLocalBodyZone:Rectangle = null, _nHitDamage:Number = 0, _uCollisionTries:uint = 0)
      {
         super(_sType);
         nHitDamage = _nHitDamage;
         oLastWorldPos = _oLastWorldPos.clone();
         oNewWorldPos = _oNewWorldPos.clone();
         oMover = _oMover;
         uCollideTries = _uCollisionTries;
         if(_oLocalFeetZone != null)
         {
            oLocalFeetZone = _oLocalFeetZone.clone();
         }
         else
         {
            oLocalFeetZone = null;
         }
         if(_oLocalBodyZone != null)
         {
            oLocalBodyZone = _oLocalBodyZone.clone();
         }
         else
         {
            oLocalBodyZone = null;
         }
      }
      
      public function get mover() : Object
      {
         return oMover;
      }
      
      public function get newWorldPosition() : Point
      {
         return oNewWorldPos.clone();
      }
      
      public function get lastWorldPosition() : Point
      {
         return oLastWorldPos.clone();
      }
      
      public function get hitDamage() : Number
      {
         return nHitDamage;
      }
      
      public function get tries() : uint
      {
         return uCollideTries;
      }
      
      public function get localBodyZone() : Rectangle
      {
         return oLocalBodyZone.clone();
      }
      
      override public function clone() : Event
      {
         return new MovingBodyEvent(type,oMover,oLastWorldPos,oNewWorldPos,oLocalFeetZone,oLocalBodyZone,nHitDamage,uCollideTries);
      }
      
      public function get localFeetZone() : Rectangle
      {
         return oLocalFeetZone.clone();
      }
   }
}
