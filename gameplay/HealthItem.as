package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import library.basic.StateManaged;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   
   public class HealthItem extends StateManaged implements Idestroyable
   {
      
      private static var sSTATE_FULL:String = "full";
      
      private static var sSTATE_HALF:String = "half";
      
      private static var sSTATE_EMPTY:String = "empty";
       
      
      private var nValueID:Number;
      
      public function HealthItem(_mcRef:MovieClip, _nValue:Number)
      {
         super(_mcRef);
         nValueID = _nValue;
         addState(sSTATE_EMPTY,null,loadState);
         addState(sSTATE_HALF,null,loadState);
         addState(sSTATE_FULL,null,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_EMPTY);
         mcRef.visible = false;
      }
      
      public function destroy(_e:Event = null) : void
      {
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
      }
      
      private function loadState() : void
      {
         switch(state)
         {
            case sSTATE_EMPTY:
            case sSTATE_HALF:
            case sSTATE_FULL:
         }
      }
      
      public function show(_nValue:Number = -1, _nMax:Number = -1) : void
      {
         if(_nValue == -1)
         {
            _nValue = Profile.Instance.getHearts();
         }
         if(_nMax == -1)
         {
            _nMax = Profile.Instance.getHearthsCapacity();
         }
         var _nDiff:Number = 0;
         if(_nMax <= nValueID)
         {
            mcRef.visible = false;
         }
         else
         {
            mcRef.visible = true;
            _nDiff = _nValue - nValueID;
            if(_nDiff >= 0.75)
            {
               setState(sSTATE_FULL);
            }
            else if(_nDiff < 0.25)
            {
               setState(sSTATE_EMPTY);
            }
            else
            {
               setState(sSTATE_HALF);
            }
         }
      }
   }
}
