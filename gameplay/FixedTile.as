package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import gameplay.events.GameEvent;
   import gameplay.events.MapGenerateEvent;
   
   public class FixedTile implements IEventDispatcher
   {
       
      
      private var oActivator:Activator;
      
      private var oEventDisp:EventDispatcher;
      
      public function FixedTile(mcRef:MovieClip)
      {
         super();
         oEventDisp = new EventDispatcher(this);
         oActivator = new Activator(mcRef);
         GameDispatcher.Instance.addWeakEventListener(GameEvent.EVENT_DESTROY,destroy);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function destroy(_e:Event = null) : void
      {
         dispatchEvent(new MapGenerateEvent(MapGenerateEvent.EVENT_DESTROY_FIXED_OBJECT,this));
         oEventDisp = null;
         GameDispatcher.Instance.removeEventListener(GameEvent.EVENT_DESTROY,destroy);
         oActivator.destroy();
         oActivator = null;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         oEventDisp.removeEventListener(type,listener,useCapture);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
   }
}
