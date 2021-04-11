package gameplay.effects
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import library.basic.StateManaged;
   import library.sounds.SoundManager;
   
   public class EffectDie extends StateManaged
   {
      
      private static const sSTATE_OUT:String = "out";
      
      private static const sSTATE_IN:String = "in";
       
      
      private var fOnHiding:Function;
      
      private var bStopped:Boolean;
      
      private var fOnFinish:Function;
      
      private var mcDief:MovieClip;
      
      public function EffectDie(_mcParent:MovieClip, _fOnHiding:Function = null, _fOnFinish:Function = null)
      {
         fOnHiding = _fOnHiding;
         fOnFinish = _fOnFinish;
         bStopped = false;
         mcDief = new mcEffectDie();
         _mcParent.addChild(mcDief);
         super(mcDief);
         addState(sSTATE_OUT,stateOut);
         addState(sSTATE_IN,stateIn);
         setState(sSTATE_IN);
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndDie",1,1,true);
      }
      
      private function stateIn() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_OUT);
            if(fOnHiding != null)
            {
               fOnHiding();
            }
         }
      }
      
      override public function update(_e:Event) : void
      {
         if(!bStopped)
         {
            super.update(_e);
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         mcDief.parent.removeChild(mcDief);
         mcDief = null;
         fOnHiding = null;
         fOnFinish = null;
      }
      
      private function stateOut() : void
      {
         if(stateComplete)
         {
            bStopped = true;
            pause();
            mcDief.stop();
            if(fOnFinish != null)
            {
               fOnFinish();
               fOnFinish = null;
            }
         }
      }
   }
}
