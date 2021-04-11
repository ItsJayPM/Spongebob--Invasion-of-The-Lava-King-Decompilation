package library.basic
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Popup extends StateManaged
   {
      
      public static const sSTATE_IDLE:String = "idle";
      
      public static const sSTATE_APPEAR:String = "appear";
      
      public static const sSTATE_DISAPPEAR:String = "disappear";
       
      
      public function Popup(_mcRef:MovieClip)
      {
         super(_mcRef);
      }
      
      public function close() : void
      {
         if(state == sSTATE_IDLE)
         {
            setState(sSTATE_DISAPPEAR);
         }
      }
      
      protected function state_idle() : void
      {
      }
      
      protected function state_appear() : void
      {
         if(stateComplete)
         {
            setState(sSTATE_IDLE);
         }
      }
      
      protected function setButton(_btnButton:DisplayObject, _fOnClick:Function, _fOnRollOver:Function, _bDestroy:Boolean = false) : void
      {
         if(_bDestroy == false)
         {
            _btnButton.addEventListener(MouseEvent.CLICK,_fOnClick,false,0,true);
            _btnButton.addEventListener(MouseEvent.ROLL_OVER,_fOnRollOver,false,0,true);
         }
         else
         {
            _btnButton.stage.focus = null;
            _btnButton.removeEventListener(MouseEvent.CLICK,_fOnClick,false);
            _btnButton.removeEventListener(MouseEvent.ROLL_OVER,_fOnRollOver,false);
         }
      }
      
      protected function state_disappear() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         if(stateComplete)
         {
            Main.instance.removePopup(this);
         }
      }
   }
}
