package library.utils
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import library.interfaces.Idestroyable;
   
   public class DepthManager implements Idestroyable
   {
       
      
      private var oLayers:Object;
      
      public function DepthManager()
      {
         super();
         oLayers = new Object();
      }
      
      public function getDepthLayer(_sCategoryName:String) : DisplayObjectContainer
      {
         return oLayers[_sCategoryName];
      }
      
      public function destroy(_e:Event = null) : void
      {
         var _sIndex:* = null;
         trace("Depth Manager Destroyed");
         for(_sIndex in oLayers)
         {
            oLayers[_sIndex].parent.removeChild(oLayers[_sIndex]);
         }
         oLayers = null;
      }
      
      public function addDepthLayer(_sCategoryName:String, _mcContainer:DisplayObjectContainer) : void
      {
         var _sLayer:Sprite = null;
         if(oLayers[_sCategoryName] == null)
         {
            _sLayer = new Sprite();
            oLayers[_sCategoryName] = _sLayer;
            _mcContainer.addChild(_sLayer);
         }
      }
   }
}
