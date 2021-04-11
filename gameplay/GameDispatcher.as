package gameplay
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import gameplay.events.GameEvent;
   
   public class GameDispatcher extends EventDispatcher
   {
      
      public static var Instance:GameDispatcher = null;
       
      
      private var bPaused:Boolean;
      
      private var bPlayerPaused:Boolean;
      
      public function GameDispatcher()
      {
         super();
         Instance = this;
         bPaused = false;
         bPlayerPaused = false;
      }
      
      public function dispatchUpdate() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_UPDATE));
      }
      
      public function dispatchPlayerUpdate() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_PLAYER_UPDATE));
      }
      
      public function dispatchStart() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_START));
      }
      
      override public function toString() : String
      {
         return "GameDispatcher";
      }
      
      public function dispatchDestroy() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_DESTROY));
      }
      
      public function dispatchResume() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_RESUME));
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         if(event is GameEvent)
         {
            switch(event.type)
            {
               case GameEvent.EVENT_PAUSE:
                  bPaused = true;
                  break;
               case GameEvent.EVENT_PLAYER_PAUSE:
                  bPlayerPaused = true;
                  break;
               case GameEvent.EVENT_RESUME:
                  bPaused = false;
                  break;
               case GameEvent.EVENT_PLAYER_RESUME:
                  bPlayerPaused = false;
            }
         }
         return super.dispatchEvent(event);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function, _iPriority:int = 0) : void
      {
         super.addEventListener(_sType,_fListener,false,_iPriority,true);
      }
      
      public function dispatchPlayerResume() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_PLAYER_RESUME));
      }
      
      public function isPaused() : Boolean
      {
         return bPaused;
      }
      
      public function isPlayerPaused() : Boolean
      {
         return bPlayerPaused;
      }
      
      public function destroy(_e:Event = null) : void
      {
      }
      
      public function dispatchPlayerPause() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_PLAYER_PAUSE));
      }
      
      public function dispatchPause() : Boolean
      {
         return dispatchEvent(new GameEvent(GameEvent.EVENT_PAUSE));
      }
   }
}
