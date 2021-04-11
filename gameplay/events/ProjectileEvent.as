package gameplay.events
{
   import flash.events.Event;
   
   public class ProjectileEvent extends Event
   {
      
      public static const EVENT_DESTROY:String = "ProjectileEvent_destroy";
       
      
      private var oProjectile:Object;
      
      public function ProjectileEvent(_sType:String, _oProjectile:Object)
      {
         super(_sType);
         oProjectile = _oProjectile;
      }
      
      public function get projectile() : Object
      {
         return oProjectile;
      }
      
      override public function clone() : Event
      {
         return new ProjectileEvent(type,oProjectile);
      }
   }
}
