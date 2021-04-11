package popups
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import gameplay.Game;
   import gameplay.events.TextboxEvent;
   import library.TextTools.TextSlice;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   
   public class PopupTextbox extends Popup implements Idestroyable, IEventDispatcher
   {
       
      
      private var sPicture:String;
      
      private var fCallback:Function;
      
      private var oEventDisp:EventDispatcher;
      
      private var aText:Array;
      
      private var nPageNo:int;
      
      public function PopupTextbox(_mcRef:MovieClip)
      {
         super(_mcRef);
         addState(sSTATE_APPEAR,state_appear,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         oEventDisp = new EventDispatcher(this);
         Game.Instance.listenToTextBox(this);
         setState(sSTATE_APPEAR);
      }
      
      public function dispatchEvent(evt:Event) : Boolean
      {
         return oEventDisp.dispatchEvent(evt);
      }
      
      public function updatePictureText() : void
      {
         var _mcTmp:MovieClip = null;
         if(sPicture != null)
         {
            _mcTmp = mcState.mcPopup;
            if(_mcTmp != null)
            {
               if(_mcTmp.mcPicture != null)
               {
                  _mcTmp.mcPicture.gotoAndStop(sPicture);
                  trace("sPicture : " + sPicture);
               }
               if(_mcTmp.txtPicture != null)
               {
                  _mcTmp.txtPicture.text = sPicture;
               }
            }
         }
         if(aText != null)
         {
            _mcTmp = mcState.mcPopup;
            if(_mcTmp != null)
            {
               _mcTmp.txtCaption.text = aText[nPageNo - 1];
            }
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return oEventDisp.willTrigger(type);
      }
      
      private function tryRemovingMouseListenerFrom(_mcRef:DisplayObjectContainer) : void
      {
         if(_mcRef != null)
         {
            _mcRef.removeEventListener(MouseEvent.CLICK,onClick,false);
         }
      }
      
      public function showText(_sPicture:String, _sText:String, _fCallback:Function = null) : void
      {
         trace("PopupTextbox.showText(" + _sPicture + "," + _sText + "," + _fCallback + ")");
         sPicture = _sPicture;
         if(mcState.mcPopup != null)
         {
            aText = TextSlice.textPages(mcState.mcPopup.txtCaption,_sText);
         }
         else
         {
            aText = new Array("");
         }
         nPageNo = 1;
         updatePictureText();
         fCallback = _fCallback;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         oEventDisp.addEventListener(type,listener,useCapture,priority,useWeakReference);
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
         Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp,false);
         tryRemovingMouseListenerFrom(Main.instance.stage);
         switch(state)
         {
            case sSTATE_APPEAR:
               dispatchOpenEvent();
               updatePictureText();
               break;
            case sSTATE_IDLE:
               updatePictureText();
               Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
               tryAddingMouseListenerTo(Main.instance.stage);
               break;
            case sSTATE_DISAPPEAR:
               updatePictureText();
         }
      }
      
      public function dispatchCloseEvent() : void
      {
         var _e:TextboxEvent = new TextboxEvent(TextboxEvent.EVENT_CLOSE_TEXTBOX);
         dispatchEvent(_e);
      }
      
      public function dispatchOpenEvent() : void
      {
         trace("DISPATCH EVENT TEXTBOX OPEN");
         var _e:TextboxEvent = new TextboxEvent(TextboxEvent.EVENT_OPEN_TEXTBOX);
         dispatchEvent(_e);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         skip();
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return oEventDisp.hasEventListener(type);
      }
      
      public function addWeakEventListener(_sType:String, _fListener:Function) : void
      {
         oEventDisp.addEventListener(_sType,_fListener,false,0,true);
      }
      
      private function tryAddingMouseListenerTo(_mcRef:DisplayObjectContainer) : void
      {
         if(_mcRef != null)
         {
            _mcRef.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Game.Instance.stopListenToTextBox(this);
         Main.instance.stage.focus = Main.instance.stage;
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         mcRef = null;
         oEventDisp = null;
      }
      
      private function onKeyUp(_e:KeyboardEvent) : void
      {
         if(_e.keyCode == Keyboard.SPACE)
         {
            skip();
         }
      }
      
      override protected function state_disappear() : void
      {
         if(stateComplete)
         {
            if(Main.instance.popupShop == null)
            {
               dispatchCloseEvent();
            }
            Main.instance.removePopup(this);
         }
      }
      
      public function skip() : void
      {
         if(nPageNo < aText.length)
         {
            ++nPageNo;
            updatePictureText();
         }
         else if(fCallback != null)
         {
            fCallback();
         }
         else
         {
            setState(sSTATE_DISAPPEAR);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndTextboxNextpage",1,1,true);
      }
   }
}
