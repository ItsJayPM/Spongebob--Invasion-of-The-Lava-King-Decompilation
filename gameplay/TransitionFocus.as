package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import gameplay.events.DoorEvent;
   import gameplay.events.GameEvent;
   import gameplay.events.HurtEvent;
   import gameplay.events.LevelEvent;
   import gameplay.events.TransitionFocusEvent;
   import library.basic.StateManaged;
   import library.events.MainEvent;
   
   public class TransitionFocus extends StateManaged implements IEventDispatcher
   {
      
      private static const sSTATE_DISAPPEAR:String = "disappear";
      
      private static const sSTATE_IDLE:String = "idle";
      
      private static const sSTATE_APPEAR:String = "appear";
      
      private static const sSTATE_HIDDEN:String = "hidden";
       
      
      private var oEventDisp:EventDispatcher;
      
      public function TransitionFocus(_mcRef:MovieClip)
      {
         super(_mcRef);
         oEventDisp = new EventDispatcher(this);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_HIDDEN,null,null);
         setState(sSTATE_IDLE);
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(DoorEvent.EVENT_IN_OUTDOOR_DOOR,onOutdoorDoorEntered);
         _oGameDisp.addWeakEventListener(LevelEvent.EVENT_FINISH_MAP_CREATION,onMapCreated);
         _oGameDisp.addWeakEventListener(HurtEvent.EVENT_PLAYER_DIE,onPlayerDie);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
      }
      
      private function onPlayerDie(_e:HurtEvent) : void
      {
         setState(sSTATE_APPEAR);
      }
      
      private function destroy(_e:GameEvent = null) : void
      {
         mcRef = null;
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         var _oGameDisp:GameDispatcher = GameDispatcher.Instance;
         _oGameDisp.addWeakEventListener(DoorEvent.EVENT_IN_OUTDOOR_DOOR,onOutdoorDoorEntered);
         _oGameDisp.addWeakEventListener(LevelEvent.EVENT_FINISH_MAP_CREATION,onMapCreated);
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         oEventDisp = null;
      }
      
      private function state_appear() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_IDLE);
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function focusAt(_nPosX:Number, _nPosY:Number) : void
      {
         mcRef.x = _nPosX;
         mcRef.y = _nPosY;
         trace("000000000000000000000000000000 FOCUS AT ",_nPosX,_nPosY,"000000000000");
      }
      
      private function onOutdoorDoorEntered(_e:DoorEvent) : void
      {
         setState(sSTATE_APPEAR);
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
               break;
            case sSTATE_DISAPPEAR:
               break;
            case sSTATE_IDLE:
               dispatchEvent(new TransitionFocusEvent(TransitionFocusEvent.EVENT_TRANSITION_MIDDLE));
               break;
            case sSTATE_HIDDEN:
         }
      }
      
      private function onMapCreated(_e:LevelEvent) : void
      {
         setState(sSTATE_DISAPPEAR);
      }
      
      private function state_disappear() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         if(stateComplete)
         {
            dispatchEvent(new TransitionFocusEvent(TransitionFocusEvent.EVENT_TRANSITION_COMPLETED));
            setState(sSTATE_HIDDEN);
         }
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority);
      }
   }
}
