package builder
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   import library.interfaces.Idestroyable;
   
   public class LBAsset implements Idestroyable
   {
       
      
      private var mcRef:DisplayObject;
      
      public function LBAsset(_mcRef:DisplayObject)
      {
         super();
         mcRef = _mcRef;
         mcRef.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         Main.instance.builderManager.asset = getQualifiedClassName(_e.currentTarget);
         Main.instance.builderManager.setTool(LevelBuilder.sTOOL_MAP);
      }
      
      public function destroy(_e:Event = null) : void
      {
         mcRef.removeEventListener(MouseEvent.CLICK,onClick,false);
         mcRef = null;
      }
   }
}
