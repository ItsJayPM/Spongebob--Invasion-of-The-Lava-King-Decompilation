package gameplay.projectiles
{
   import flash.display.MovieClip;
   import gameplay.ItemID;
   import gameplay.Projectile;
   import gameplay.interfaces.ILevelCollidable;
   
   public class GasCloud extends Projectile implements ILevelCollidable
   {
       
      
      public function GasCloud(_mcRef:MovieClip, _nStartingOrientation:Number)
      {
         super(_mcRef,true,Data.nGASEOUS_ROCK_GAS_CLOUD_DAMAGE,_nStartingOrientation,25,25,ItemID.uNULL_ITEM,9999,true,Data.nGASEOUS_ROCK_GAS_CLOUD_SPEED,true);
      }
      
      override protected function stateIdle() : void
      {
         if(stateComplete)
         {
            super.die();
         }
         else
         {
            super.stateIdle();
         }
      }
   }
}
