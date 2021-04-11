package gameplay.projectiles
{
   import flash.display.MovieClip;
   import gameplay.ItemID;
   import gameplay.Projectile;
   import gameplay.interfaces.ILevelCollidable;
   
   public class SeaUrchin extends Projectile implements ILevelCollidable
   {
       
      
      public function SeaUrchin(_mcRef:MovieClip, _nStartingOrientation:Number)
      {
         super(_mcRef,false,Data.nDAMAGE_SEA_URCHIN,_nStartingOrientation,Data.nSEA_URCHIN_BODY_WIDTH,Data.nSEA_URCHIN_BODY_HEIGHT,ItemID.uSEA_URCHIN,Data.nSEA_URCHIN_MAX_DISTANCE,true,Data.nSEA_URCHIN_SPEED);
      }
   }
}
