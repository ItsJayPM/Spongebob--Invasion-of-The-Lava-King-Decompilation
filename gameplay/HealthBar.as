package gameplay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import library.interfaces.Idestroyable;
   
   public class HealthBar extends EventDispatcher implements Idestroyable
   {
      
      private static var nMAX_HEALTH:Number;
       
      
      private var aHealthItems:Array;
      
      private var mcAsset:MovieClip;
      
      public function HealthBar(_mcRef:MovieClip)
      {
         super();
         if(Data.nLIVES_DEFAULT_MAXIMUM)
         {
            nMAX_HEALTH = Data.nLIVES_MAXIMUM;
         }
         else
         {
            nMAX_HEALTH = 9;
         }
         mcAsset = _mcRef;
         setHealthItems();
      }
      
      public function set mcRef(_mcRef:MovieClip) : void
      {
         mcAsset = _mcRef;
         setHealthItems();
      }
      
      private function setHealthItems() : void
      {
         var _mc:MovieClip = null;
         var oHealthItem:HealthItem = null;
         if(aHealthItems != null)
         {
            unsetHealthItems();
         }
         aHealthItems = new Array();
         for(var _i:int = 0; _i < Data.nLIVES_MAXIMUM; _i++)
         {
            _mc = mcRef["mcHealth" + _i];
            if(_mc)
            {
               oHealthItem = new HealthItem(mcAsset["mcHealth" + _i],_i);
               aHealthItems.push(oHealthItem);
            }
         }
      }
      
      public function show(_nValue:Number = -1, _nMax:Number = -1) : void
      {
         var item:* = null;
         for(item in aHealthItems)
         {
            aHealthItems[item].show(_nValue,_nMax);
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         mcAsset = null;
      }
      
      private function unsetHealthItems() : void
      {
         var _i:* = null;
         if(aHealthItems != null)
         {
            aHealthItems = new Array();
            for(_i in aHealthItems)
            {
               aHealthItems[_i].destroy();
            }
         }
      }
      
      public function get mcRef() : MovieClip
      {
         return mcAsset;
      }
   }
}
