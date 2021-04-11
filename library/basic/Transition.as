package library.basic
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import library.events.MainEvent;
   import library.events.TransitionEvent;
   
   public class Transition extends StateManaged implements IEventDispatcher
   {
      
      private static const sSTATE_DISAPPEAR:String = "disappear";
      
      private static const sSTATE_APPEAR:String = "appear";
       
      
      private var oEventDisp:EventDispatcher;
      
      public function Transition(_mcRef:MovieClip)
      {
         super(_mcRef);
         oEventDisp = new EventDispatcher(this);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         setState(sSTATE_APPEAR);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      private function state_appear() : void
      {
         if(stateComplete)
         {
            dispatchEvent(new TransitionEvent(TransitionEvent.EVENT_FULL_SCREEN,false));
            setState(sSTATE_DISAPPEAR);
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
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
               break;
            case sSTATE_DISAPPEAR:
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      private function state_disappear() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         if(stateComplete)
         {
            dispatchEvent(new TransitionEvent(TransitionEvent.EVENT_COMPLETE,false));
         }
      }
      
      public function destroy(_e:Event) : void
      {
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
      }
   }
}
