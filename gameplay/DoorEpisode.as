package gameplay
{
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import gameplay.events.PlayerEvent;
   
   public class DoorEpisode extends DoorOutdoor
   {
       
      
      private var uEpisode:uint;
      
      private var bOpen:Boolean;
      
      public function DoorEpisode(_mcRef:MovieClip, _oRoom:Room, _uEpisode:uint, _oWorldMatrix:Matrix, _bOpened:Boolean)
      {
         uEpisode = _uEpisode;
         super(_mcRef,_oRoom,_oWorldMatrix,_bOpened,false,false,false,false,false,!_bOpened);
         if(!_bOpened)
         {
            GameDispatcher.Instance.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggeredForDoor);
         }
      }
      
      private function onActionTriggeredForDoor(_e:PlayerEvent) : void
      {
         var nDirX:Number = NaN;
         var nDirY:Number = NaN;
         if(bOpen)
         {
            return;
         }
         if(oWorldActiveZone.contains(_e.worldPositionX,_e.worldPositionY))
         {
            nDirX = Math.cos(_e.direction);
            if(Math.abs(nDirX) < 0.001)
            {
               nDirX = 0;
            }
            nDirY = -Math.sin(_e.direction);
            if(Math.abs(nDirY) < 0.001)
            {
               nDirY = 0;
            }
            if(nDirX > 0 && oNormal.x < 0 || nDirX < 0 && oNormal.x > 0 || nDirY > 0 && oNormal.y < 0 || nDirY < 0 && oNormal.y > 0)
            {
               _e.stopImmediatePropagation();
               if(Profile.Instance.getNbrKillBoss() >= uEpisode)
               {
                  Storyline.play("EpisodeDoor" + uEpisode + "Beaten");
               }
               else
               {
                  Storyline.play("EpisodeDoor" + uEpisode);
               }
            }
         }
      }
      
      override protected function onActivation() : void
      {
         if(!bOpen)
         {
            GameDispatcher.Instance.addWeakEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggeredForDoor);
         }
         super.onActivation();
      }
      
      override protected function onDeactivation() : void
      {
         GameDispatcher.Instance.removeEventListener(PlayerEvent.EVENT_TRIGGER_ACTION_BUTTON,onActionTriggeredForDoor);
         super.onDeactivation();
      }
   }
}
