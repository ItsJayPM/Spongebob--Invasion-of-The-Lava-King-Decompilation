package gameplay.interfaces
{
   import flash.geom.Point;
   
   public interface ILevelCollidable
   {
       
      
      function onWallCollide(param1:Point, param2:Point, param3:Point, param4:Point, param5:uint) : void;
   }
}
