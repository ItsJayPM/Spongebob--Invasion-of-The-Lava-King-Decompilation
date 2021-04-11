package popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   import library.utils.TextFieldScroller;
   import library.utils.Tools;
   
   public class PopupHSTitle extends Popup implements Idestroyable
   {
       
      
      private var btnBack:SimpleButton;
      
      private var bScoresReceived:Boolean;
      
      private var btnDown:SimpleButton;
      
      private var oScroller:TextFieldScroller;
      
      private var btnUp:SimpleButton;
      
      private var nCurrentScrollV:Number;
      
      public function PopupHSTitle(_mcRef:MovieClip)
      {
         super(_mcRef);
         bScoresReceived = false;
         nCurrentScrollV = 1;
         addState(sSTATE_APPEAR,state_appear,loadState,unloadState);
         addState(sSTATE_IDLE,null,loadState,unloadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState,unloadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         setState(sSTATE_APPEAR);
      }
      
      private function onScoresReceived(_e:Event) : void
      {
         bScoresReceived = true;
         if(mcState != null)
         {
            if(mcState.mcPopup != null)
            {
               showHighScore();
            }
         }
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SCORES_RECEIVED,onScoresReceived,false);
      }
      
      public function showHighScore() : void
      {
         var i:uint = 0;
         var _sPrefixe:String = null;
         var _bCreateScroller:Boolean = false;
         var _mcBoard:MovieClip = mcState.mcPopup.mcHSBoard;
         trace("======================================================");
         var _aScores:Array = Main.instance.oNickServices.highScores;
         trace("======================================================");
         var _aText:Array = new Array();
         switch(state)
         {
            case sSTATE_IDLE:
               _bCreateScroller = true;
               break;
            case sSTATE_APPEAR:
            case sSTATE_DISAPPEAR:
               _bCreateScroller = false;
         }
         _mcBoard.txtHSError.text = "";
         _mcBoard.txtHSNumber.text = "";
         _mcBoard.txtHSName.text = "";
         _mcBoard.txtHSScore.text = "";
         if(_aScores != null && _aScores.length > 0)
         {
            trace("_aScores : " + _aScores);
            for(i = 0; i < _aScores.length; i++)
            {
               if(i == 0)
               {
                  _sPrefixe = "";
               }
               else
               {
                  _sPrefixe = "\n";
               }
               _mcBoard.txtHSNumber.text += _sPrefixe + _aScores[i].nRank;
               _mcBoard.txtHSName.text += _sPrefixe + _aScores[i].sNickName;
               _mcBoard.txtHSScore.text += _sPrefixe + Tools.getFormatedNumber(_aScores[i].nScore);
            }
            _mcBoard.txtHSNumber.scrollV = nCurrentScrollV;
            _mcBoard.txtHSName.scrollV = nCurrentScrollV;
            _mcBoard.txtHSScore.scrollV = nCurrentScrollV;
            _aText.push(_mcBoard.txtHSNumber);
            _aText.push(_mcBoard.txtHSName);
            _aText.push(_mcBoard.txtHSScore);
            if(_bCreateScroller && oScroller == null)
            {
               oScroller = new TextFieldScroller(btnUp,btnDown,_aText);
            }
         }
         else
         {
            if(bScoresReceived)
            {
               _mcBoard.txtHSError.text = "There\'s no high scores data.";
            }
            else
            {
               _mcBoard.txtHSError.text = "Loading high scores...";
            }
            btnUp.visible = false;
            btnDown.visible = false;
         }
      }
      
      public function destroy(_e:Event = null) : void
      {
         setButton(btnBack,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SCORES_RECEIVED,onScoresReceived,false);
         if(oScroller != null)
         {
            oScroller.destroy();
         }
         oScroller = null;
         btnBack = null;
         btnUp = null;
         btnDown = null;
         mcRef = null;
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnBack:
               close();
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
      }
      
      private function unloadState() : void
      {
         trace("unload");
         switch(state)
         {
            case sSTATE_APPEAR:
               break;
            case sSTATE_IDLE:
               if(oScroller != null)
               {
                  nCurrentScrollV = oScroller.nCurrentScrollV;
                  trace("nCurrentScrollV : " + nCurrentScrollV);
                  oScroller.destroy();
                  oScroller = null;
               }
               break;
            case sSTATE_DISAPPEAR:
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
            case sSTATE_APPEAR:
               btnUp = mcState.mcPopup.mcHSBoard.btnUp;
               btnDown = mcState.mcPopup.mcHSBoard.btnDown;
               Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SCORES_RECEIVED,onScoresReceived,false,0,true);
               Main.instance.oNickServices.requestScores(Data.sGAME_ID);
               showHighScore();
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupIn.wav",1,1,true);
               break;
            case sSTATE_IDLE:
               btnUp = mcState.mcPopup.mcHSBoard.btnUp;
               btnDown = mcState.mcPopup.mcHSBoard.btnDown;
               btnBack = mcState.mcPopup.btnBack;
               setButton(btnBack,onClick,onRollOver);
               showHighScore();
               break;
            case sSTATE_DISAPPEAR:
               trace("load");
               btnUp = mcState.mcPopup.mcHSBoard.btnUp;
               btnDown = mcState.mcPopup.mcHSBoard.btnDown;
               showHighScore();
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupOut.wav",1,1,true);
         }
      }
      
      public function onRollOver(_e:MouseEvent) : void
      {
         var _loc2_:* = _e.target;
         switch(0)
         {
         }
         trace("Over: " + _e.target.name);
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndRollOver",1,1,true);
      }
   }
}
