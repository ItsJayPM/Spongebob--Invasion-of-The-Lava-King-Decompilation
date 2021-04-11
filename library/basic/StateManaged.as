package library.basic
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class StateManaged
   {
       
      
      private var mcAsset:MovieClip;
      
      private var bPaused:Boolean;
      
      private var oStateFunction:Object;
      
      private var sState:String;
      
      public function StateManaged(_mcRef:MovieClip)
      {
         super();
         mcAsset = _mcRef;
         bPaused = false;
         oStateFunction = new Object();
      }
      
      public function get mcState() : MovieClip
      {
         return mcRef.getChildByName("mcState") as MovieClip;
      }
      
      public function set paused(_bPaused:Boolean) : void
      {
         bPaused = _bPaused;
      }
      
      protected function onAdded(_e:Event) : void
      {
         if(_e.target == mcState)
         {
            if(oStateFunction[sState].load != null)
            {
               oStateFunction[sState].load();
            }
            if(bPaused)
            {
               mcState.stop();
            }
            mcRef.removeEventListener(Event.ADDED,onAdded,false);
         }
      }
      
      public function update(_e:Event) : void
      {
         if(!paused)
         {
            if(oStateFunction[state].state != null)
            {
               oStateFunction[state].state();
            }
         }
      }
      
      public function get stateComplete() : Boolean
      {
         var _bComplete:Boolean = false;
         if(mcState != null)
         {
            if(mcState.currentFrame >= mcState.totalFrames)
            {
               _bComplete = true;
            }
         }
         return _bComplete;
      }
      
      public function resume(_e:Event = null) : void
      {
         bPaused = false;
         var _mcState:MovieClip = mcState;
         if(_mcState != null)
         {
            mcState.play();
         }
      }
      
      public function get paused() : Boolean
      {
         return bPaused;
      }
      
      public function setState(_sState:String) : void
      {
         if(state != _sState)
         {
            if(state != null && oStateFunction[state].unload != null)
            {
               oStateFunction[state].unload();
            }
            sState = _sState;
            if(mcRef != null)
            {
               mcRef.gotoAndStop(sState);
            }
            if(mcState == null)
            {
               mcRef.addEventListener(Event.ADDED,onAdded,false,0,true);
            }
            else if(oStateFunction[sState].load != null)
            {
               oStateFunction[sState].load();
            }
         }
      }
      
      public function get state() : String
      {
         return sState;
      }
      
      public function set mcRef(_mcRef:MovieClip) : void
      {
         mcAsset = _mcRef;
      }
      
      public function pause(_e:Event = null) : void
      {
         bPaused = true;
         var _mcState:MovieClip = mcState;
         if(_mcState != null)
         {
            _mcState.stop();
         }
      }
      
      public function addState(_sState:String, _fStateFunction:Function, _fStateInitFunction:Function = null, _fStateEndFunction:Function = null) : void
      {
         oStateFunction[_sState] = {
            "load":_fStateInitFunction,
            "state":_fStateFunction,
            "unload":_fStateEndFunction
         };
      }
      
      public function get mcRef() : MovieClip
      {
         return mcAsset;
      }
   }
}
