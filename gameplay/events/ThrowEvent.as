package gameplay.events
{
   import flash.events.Event;
   
   public class ThrowEvent extends Event
   {
      
      private static var uId:uint = 1;
      
      public static const uPROJECTILE_VOLCANIC_URCHIN:uint = uId++;
      
      public static const uPROJECTILE_GAS_SPOUT:uint = uId++;
      
      public static const uPROJECTILE_BOOMERANG:uint = uId++;
      
      public static const uPROJECTILE_GAS_CLOUD:uint = uId++;
      
      public static const uPROJECTILE_SEA_URCHIN:uint = uId++;
      
      public static const EVENT_PLAYER_THROW_PROJECTILE:String = "ThrowEvent_enemyProjectile";
      
      public static const EVENT_ENEMY_THROW_PROJECTILE:String = "ThrowEvent_enemyProjectile";
       
      
      private var uType:uint;
      
      private var nPosX:Number;
      
      private var nPosY:Number;
      
      private var nOrient:Number;
      
      public function ThrowEvent(_sType:String, _uProjectileType:uint, _nWorldSrcX:Number, _nWorldSrcY:Number, _nOrientation:Number = 0)
      {
         super(_sType);
         nPosX = _nWorldSrcX;
         nPosY = _nWorldSrcY;
         uType = _uProjectileType;
         nOrient = _nOrientation;
      }
      
      public function get projectileType() : uint
      {
         return uType;
      }
      
      override public function clone() : Event
      {
         return new ThrowEvent(type,uType,nPosX,nPosY,nOrient);
      }
      
      public function get orientation() : Number
      {
         return nOrient;
      }
      
      public function get worldPositionX() : Number
      {
         return nPosX;
      }
      
      public function get worldPositionY() : Number
      {
         return nPosY;
      }
   }
}
