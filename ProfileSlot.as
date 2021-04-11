package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import library.basic.StateManaged;
   import library.events.MainEvent;
   import library.sounds.SoundManager;
   
   public class ProfileSlot extends StateManaged
   {
      
      public static const sSTATE_EMPTY:String = "empty";
      
      public static const sSTATE_OVER:String = "over";
      
      public static const sSTATE_IDLE:String = "idle";
      
      public static const sSTATE_EMPTY_OVER:String = "overEmpty";
      
      public static const sSTATE_NAME:String = "name";
       
      
      private var btnBack:SimpleButton;
      
      private var btnDelete:SimpleButton;
      
      private var oData:Object;
      
      private var btnPlay:SimpleButton;
      
      private const sINITIAL_NAME:String = "Spongebob";
      
      private var iSlot:int;
      
      public function ProfileSlot(_mcRef:MovieClip, _iSlot:int)
      {
         super(_mcRef);
         addState(sSTATE_EMPTY,null,loadState);
         addState(sSTATE_EMPTY_OVER,null,loadState);
         addState(sSTATE_NAME,null,loadState);
         addState(sSTATE_IDLE,null,loadState);
         addState(sSTATE_OVER,null,loadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         iSlot = _iSlot;
         oData = Profile.loadHeader(iSlot);
         if(oData != null)
         {
            setState(sSTATE_IDLE);
         }
         else
         {
            setState(sSTATE_EMPTY);
         }
      }
      
      private function unloadState() : void
      {
         switch(state)
         {
            case sSTATE_EMPTY:
               mcState.mcHitzone.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
               break;
            case sSTATE_EMPTY_OVER:
               mcState.mcHitzone.removeEventListener(MouseEvent.ROLL_OUT,onRollOut,false);
               mcState.mcHitzone.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false);
               break;
            case sSTATE_NAME:
               setButton(btnBack,onClick,onRollOver,false);
               setButton(btnPlay,onClick,onRollOver,false);
               break;
            case sSTATE_IDLE:
               setButton(btnDelete,onClick,onRollOver,false);
               mcState.mcHitzone.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
               break;
            case sSTATE_OVER:
               setButton(btnDelete,onClick,onRollOver,false);
               mcState.mcHitzone.removeEventListener(MouseEvent.ROLL_OUT,onRollOut,false);
               mcState.mcHitzone.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false);
         }
      }
      
      private function showStats() : void
      {
         mcState.txtName.text = oData.sPlayerName;
         for(var i:int = 0; i < Data.nLIVES_MAXIMUM; i++)
         {
            if(i < oData.nHearts)
            {
               mcState.mcHealthBar["mcHealth" + i].gotoAndStop("full");
            }
            else
            {
               mcState.mcHealthBar["mcHealth" + i].gotoAndStop("empty");
               mcState.mcHealthBar["mcHealth" + i].visible = false;
            }
         }
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         var _bValid:Boolean = false;
         switch(_e.target)
         {
            case btnBack:
               setState(sSTATE_EMPTY);
               btnBack = null;
               break;
            case btnPlay:
               _bValid = false;
               _bValid = validName(mcState.txtName.text);
               if(!_bValid)
               {
                  mcState.txtName.text = sINITIAL_NAME;
               }
               else
               {
                  Profile.initNewProfile(iSlot,mcState.txtName.text);
                  new Profile(iSlot);
                  Main.instance.transitTo(Main.sSTATE_GAME);
                  btnPlay = null;
               }
               break;
            case btnDelete:
               Main.instance.addPopup(Main.sPOPUP_DELETE);
               Main.instance.popupDelete.profileID = iSlot;
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      public function onRollOut(_e:MouseEvent) : void
      {
         switch(state)
         {
            case sSTATE_EMPTY_OVER:
               setState(sSTATE_EMPTY);
               break;
            case sSTATE_OVER:
               setState(sSTATE_IDLE);
         }
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         switch(state)
         {
            case sSTATE_EMPTY:
               mcState.mcHitzone.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
               break;
            case sSTATE_EMPTY_OVER:
               mcState.mcHitzone.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
               mcState.mcHitzone.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
               break;
            case sSTATE_NAME:
               mcState.mcBlocker.useHandCursor = false;
               mcState.txtName.restrict = "0-1a-zA-Z. \\-";
               btnBack = mcState.btnBack;
               btnPlay = mcState.btnPlay;
               setButton(btnBack,onClick,onRollOver);
               setButton(btnPlay,onClick,onRollOver);
               break;
            case sSTATE_IDLE:
               showStats();
               btnDelete = mcState.btnDelete;
               setButton(btnDelete,onClick,onRollOver);
               mcState.mcHitzone.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
               break;
            case sSTATE_OVER:
               showStats();
               btnDelete = mcState.btnDelete;
               setButton(btnDelete,onClick,onRollOver);
               mcState.mcHitzone.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
               mcState.mcHitzone.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
         }
      }
      
      public function onMouseDown(_e:MouseEvent) : void
      {
         switch(state)
         {
            case sSTATE_EMPTY_OVER:
               setState(sSTATE_NAME);
               break;
            case sSTATE_OVER:
               new Profile(iSlot);
               Main.instance.transitTo(Main.sSTATE_GAME);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
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
            _btnButton.removeEventListener(MouseEvent.CLICK,_fOnClick,false);
            _btnButton.removeEventListener(MouseEvent.ROLL_OVER,_fOnRollOver,false);
         }
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         switch(state)
         {
            case sSTATE_EMPTY:
               setState(sSTATE_EMPTY_OVER);
               break;
            case sSTATE_IDLE:
               setState(sSTATE_OVER);
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
      
      public function destroy(_e:Event = null) : void
      {
         mcState.mcHitzone.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,false);
         mcState.mcHitzone.removeEventListener(MouseEvent.ROLL_OUT,onRollOut,false);
         mcState.mcHitzone.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false);
         if(btnDelete != null)
         {
            setButton(btnDelete,onClick,onRollOver,false);
         }
         btnBack = null;
         btnPlay = null;
         btnDelete = null;
         mcRef = null;
      }
      
      private function validName(_sName:String) : Boolean
      {
         var _aTextSplit:Array = null;
         var _bOnlySpace:Boolean = false;
         var i:* = null;
         var _bValid:Boolean = false;
         if(_sName != null && _sName != "")
         {
            _aTextSplit = _sName.split(" ",100);
            _bOnlySpace = true;
            for(i in _aTextSplit)
            {
               if(_aTextSplit[i] != "")
               {
                  _bOnlySpace = false;
                  break;
               }
            }
            if(_bOnlySpace == false)
            {
               _bValid = true;
            }
         }
         else
         {
            _bValid = false;
         }
         return _bValid;
      }
   }
}
