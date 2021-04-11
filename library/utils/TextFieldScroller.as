package library.utils
{
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   
   public class TextFieldScroller
   {
       
      
      public var nScrollDirection:int;
      
      private var aTextFields:Array;
      
      private var btUp:SimpleButton;
      
      private var btDown:SimpleButton;
      
      public var nCurrentScrollV:Number;
      
      public function TextFieldScroller(_btUp:SimpleButton, _btDown:SimpleButton, _aTextFields:Array)
      {
         super();
         btUp = _btUp;
         btDown = _btDown;
         aTextFields = _aTextFields;
         nCurrentScrollV = 1;
         init();
         onUpdateScroll();
      }
      
      private function startScrolling(_nDirection:int) : void
      {
         nScrollDirection = _nDirection;
         btUp.addEventListener(Event.ENTER_FRAME,onUpdateScroll,false,0,true);
         onUpdateScroll();
      }
      
      public function resetTextField() : void
      {
         var _txtField:TextField = null;
         nCurrentScrollV = 1;
         for each(_txtField in aTextFields)
         {
            _txtField.scrollV = 1;
         }
         nScrollDirection = 0;
         onUpdateScroll();
      }
      
      private function onBtDown_down(_e:Event) : void
      {
         if(_e.target.enabled)
         {
            startScrolling(1);
         }
      }
      
      private function disableButton(_btn:SimpleButton) : void
      {
         _btn.visible = true;
         _btn.enabled = false;
         _btn.filters = [Data.oDISABLED_FILTER];
      }
      
      private function stopScrolling() : void
      {
         btUp.removeEventListener(Event.ENTER_FRAME,onUpdateScroll);
      }
      
      private function init() : void
      {
         btUp.addEventListener(MouseEvent.MOUSE_DOWN,onBtUp_down,false,0,true);
         btUp.addEventListener(MouseEvent.MOUSE_UP,onBtUp_up,false,0,true);
         btDown.addEventListener(MouseEvent.MOUSE_DOWN,onBtDown_down,false,0,true);
         btDown.addEventListener(MouseEvent.MOUSE_UP,onBtDown_up,false,0,true);
      }
      
      public function onUpdateScroll(_e:Event = null) : void
      {
         var _txtField:TextField = null;
         var _sTest:String = null;
         var _txtLineMetric:TextLineMetrics = null;
         var _iLinePossible:int = 0;
         for each(_txtField in aTextFields)
         {
            _txtField.scrollV += nScrollDirection;
            nCurrentScrollV = _txtField.scrollV;
            _sTest = _txtField.text;
            _txtLineMetric = _txtField.getLineMetrics(0);
            _iLinePossible = Math.floor(_txtField.height / _txtLineMetric.height);
            if(_txtField.numLines <= _iLinePossible)
            {
               disableButton(btUp);
               disableButton(btDown);
            }
            else
            {
               trace("nCurrentScrollV : " + nCurrentScrollV);
               if(nCurrentScrollV == 1)
               {
                  disableButton(btUp);
                  enableButton(btDown);
               }
               else if(nCurrentScrollV >= _txtField.maxScrollV)
               {
                  disableButton(btDown);
                  enableButton(btUp);
               }
               else
               {
                  enableButton(btUp);
                  enableButton(btDown);
               }
            }
         }
      }
      
      private function onBtDown_up(_e:Event) : void
      {
         stopScrolling();
      }
      
      private function enableButton(_btn:SimpleButton) : void
      {
         trace("ENABLE: " + _btn.name);
         _btn.visible = true;
         _btn.enabled = true;
         _btn.filters = [];
      }
      
      public function destroy() : void
      {
         stopScrolling();
         aTextFields = null;
         btUp.removeEventListener(MouseEvent.MOUSE_DOWN,onBtUp_down,false);
         btUp.removeEventListener(MouseEvent.MOUSE_UP,onBtUp_up,false);
         btDown.removeEventListener(MouseEvent.MOUSE_DOWN,onBtDown_down,false);
         btDown.removeEventListener(MouseEvent.MOUSE_UP,onBtDown_up,false);
         btUp = null;
         btDown = null;
      }
      
      private function onBtUp_down(_e:Event) : void
      {
         if(_e.target.enabled)
         {
            startScrolling(-1);
         }
      }
      
      private function onBtUp_up(_e:Event) : void
      {
         stopScrolling();
      }
   }
}
