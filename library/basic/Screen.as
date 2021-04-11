package library.basic
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import library.interfaces.Idestroyable;
   
   public class Screen extends StateManaged implements Idestroyable
   {
       
      
      public function Screen(_mcRef:MovieClip)
      {
         super(_mcRef);
      }
      
      public function destroy(_e:Event = null) : void
      {
      }
      
      protected function initButton() : void
      {
      }
      
      protected function setButton(_btnButton:DisplayObject, _fOnClick:Function, _fOnRollOver:Function, _bDestroy:Boolean = false) : void
      {
         if(_btnButton != null)
         {
            if(_bDestroy == false)
            {
               _btnButton.addEventListener(MouseEvent.CLICK,_fOnClick,false,0,true);
               _btnButton.addEventListener(MouseEvent.ROLL_OVER,_fOnRollOver,false,0,true);
            }
            else
            {
               _btnButton.removeEventListener(MouseEvent.CLICK,_fOnClick,false);
               _btnButton.removeEventListener(MouseEvent.ROLL_OVER,_fOnRollOver,false);
            }
         }
      }
   }
}
