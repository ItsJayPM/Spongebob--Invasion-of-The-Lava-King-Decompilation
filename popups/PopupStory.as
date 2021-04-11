package popups
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import gameplay.Game;
   import gameplay.Storyline;
   import gameplay.events.StoryPopupEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   
   public class PopupStory extends Popup implements Idestroyable, IEventDispatcher
   {
       
      
      private var uEpisode:uint;
      
      private var oEventDisp:EventDispatcher;
      
      public function PopupStory(_mcRef:MovieClip)
      {
         super(_mcRef);
         oEventDisp = new EventDispatcher(this);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         Game.Instance.listenToStory(this);
         uEpisode = Profile.Instance.getCurrentEpisode();
         setState(sSTATE_APPEAR);
         Main.instance.switchToBossMusic();
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function dispatchCloseEvent() : void
      {
         var _e:StoryPopupEvent = new StoryPopupEvent(StoryPopupEvent.EVENT_CLOSE_POPUP_STORY);
         dispatchEvent(_e);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         switch(state)
         {
            case sSTATE_APPEAR:
               setStory(true);
               dispatchOpenEvent();
               break;
            case sSTATE_IDLE:
               setStory(false);
               Storyline.play("Intro",onEndStory);
               break;
            case sSTATE_DISAPPEAR:
               setStory(true);
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function destroy(_e:Event = null) : void
      {
         Game.Instance.stopListenToStory(this);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
      }
      
      private function setStory(_bPaused:Boolean) : void
      {
         mcState.mcPopup.gotoAndStop(uEpisode);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function dispatchOpenEvent() : void
      {
         trace("DISPATCH PAUSE EVENT ");
         var _e:StoryPopupEvent = new StoryPopupEvent(StoryPopupEvent.EVENT_OPEN_POPUP_STORY);
         dispatchEvent(_e);
      }
      
      private function onEndStory() : void
      {
         Main.instance.switchToGameMusic();
         setState(sSTATE_DISAPPEAR);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
   }
}
