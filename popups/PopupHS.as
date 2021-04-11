package popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import library.basic.Popup;
   import library.events.MainEvent;
   import library.interfaces.Idestroyable;
   import library.sounds.SoundManager;
   import library.utils.TextFieldScroller;
   import library.utils.Tools;
   
   public class PopupHS extends Popup implements Idestroyable
   {
       
      
      private var oScroller:TextFieldScroller;
      
      private var btnPlayAgain:SimpleButton;
      
      private var btnUp:SimpleButton;
      
      private var btnDown:SimpleButton;
      
      private var btnSubmitHS:SimpleButton;
      
      private var bScoresReceived:Boolean;
      
      private var nCurrentScrollV:Number;
      
      public function PopupHS(_mcRef:MovieClip)
      {
         super(_mcRef);
         bScoresReceived = false;
         nCurrentScrollV = 1;
         addState(sSTATE_APPEAR,state_appear,loadState,unloadState);
         addState(sSTATE_IDLE,null,loadState,unloadState);
         addState(sSTATE_DISAPPEAR,state_disappear,loadState,unloadState);
         Main.instance.addEventListener(MainEvent.EVENT_UPDATE,update,false,0,true);
         Main.instance.addEventListener(MainEvent.EVENT_DESTROY,destroy,false,0,true);
         if(Main.instance.oNickServices.bViewHS)
         {
            Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SCORES_RECEIVED,onScoresReceived,false,0,true);
            Main.instance.oNickServices.requestScores(Data.sGAME_ID);
         }
         else
         {
            submitScore();
         }
         setState(sSTATE_APPEAR);
      }
      
      public function onUserLoggedOut(_e:Event) : void
      {
         Main.instance.oNickServices.addEventListener(NickServices.sEVENT_USER_STATUS_RECEIVED,onLogin,false,0,true);
         Main.instance.oNickServices.requestLoginUI(true,Main.instance.oDepthManager.getDepthLayer(Main.sDEPTH_LOGIN));
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SCORE_SUBMISSION_COMPLETED,submitScore,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_USER_LOGGED_OUT,onUserLoggedOut,false);
      }
      
      public function onLogin(_e:Event) : void
      {
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_USER_STATUS_RECEIVED,onLogin,false);
         submitScore();
      }
      
      private function loadState() : void
      {
         if(mcRef.mcBlocker != null)
         {
            mcRef.mcBlocker.useHandCursor = false;
         }
         mcState.mcPopup.txtScore.text = Tools.getFormatedUint(Profile.Instance.getCurrentScore());
         switch(state)
         {
            case sSTATE_APPEAR:
               btnUp = mcState.mcPopup.mcHSBoard.btnUp;
               btnDown = mcState.mcPopup.mcHSBoard.btnDown;
               showHighScore();
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupIn.wav",1,1,true);
               break;
            case sSTATE_IDLE:
               btnUp = mcState.mcPopup.mcHSBoard.btnUp;
               btnDown = mcState.mcPopup.mcHSBoard.btnDown;
               showHighScore();
               btnPlayAgain = mcState.mcPopup.btnPlayAgain;
               btnSubmitHS = mcState.mcPopup.btnSubmitHS;
               if(Main.instance.oNickServices.bSubmitHS)
               {
                  btnSubmitHS.filters = [Data.oDISABLED_FILTER];
                  btnSubmitHS.enabled = false;
               }
               setButton(btnPlayAgain,onClick,onRollOver);
               setButton(btnSubmitHS,onClick,onRollOver);
               break;
            case sSTATE_DISAPPEAR:
               SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndPopupOut.wav",1,1,true);
               btnUp = mcState.mcPopup.mcHSBoard.btnUp;
               btnDown = mcState.mcPopup.mcHSBoard.btnDown;
               showHighScore();
         }
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
                  oScroller.destroy();
                  oScroller = null;
               }
               break;
            case sSTATE_DISAPPEAR:
         }
      }
      
      public function submitScore() : void
      {
         Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SCORE_SUBMISSION_COMPLETED,onSubmitScore,false,0,true);
         Main.instance.oNickServices.addEventListener(NickServices.sEVENT_USER_LOGGED_OUT,onUserLoggedOut,false,0,true);
         Main.instance.oNickServices.submitScore(Data.sGAME_ID,Profile.Instance.getCurrentScore());
      }
      
      private function onScoresReceived(_e:Event) : void
      {
         bScoresReceived = true;
         if(mcState != null)
         {
            if(mcState.mcPopup != null)
            {
               if(oScroller != null)
               {
                  oScroller.resetTextField();
               }
               showHighScore();
            }
         }
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SCORES_RECEIVED,onScoresReceived,false);
      }
      
      public function onClick(_e:MouseEvent) : void
      {
         switch(_e.target)
         {
            case btnPlayAgain:
               if(Main.instance.state == Main.sSTATE_GAME)
               {
                  if(Main.instance.popupLose != null)
                  {
                     trace("Report on High score Play Again button pressed");
                     ExternalInterface.call("trackKidsGamePlay","sb_lava");
                     close();
                     Main.instance.removePopup(Main.instance.popupLose);
                     Main.instance.startGame();
                  }
                  else
                  {
                     close();
                  }
               }
               else
               {
                  Main.instance.setState(Main.sSTATE_TITLE);
               }
               break;
            case btnSubmitHS:
               btnSubmitHS.filters = [Data.oDISABLED_FILTER];
               btnSubmitHS.enabled = false;
               submitScore();
         }
         SoundManager.playSoundInCat(Data.sCATEGORY_SOUND_LINKAGE,"sndClick",1,1,true);
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
      
      public function destroy(_e:Event = null) : void
      {
         Main.instance.oNickServices.bSubmitHS = false;
         Main.instance.oNickServices.bViewHS = false;
         setButton(btnPlayAgain,onClick,onRollOver,true);
         setButton(btnSubmitHS,onClick,onRollOver,true);
         if(mcRef != null)
         {
            mcRef.parent.removeChild(mcRef);
         }
         Main.instance.removeEventListener(MainEvent.EVENT_UPDATE,update,false);
         Main.instance.removeEventListener(MainEvent.EVENT_DESTROY,destroy,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SCORE_SUBMISSION_COMPLETED,onSubmitScore,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_USER_LOGGED_OUT,onUserLoggedOut,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_LOGIN_UI_RECEIVED,onLogin,false);
         if(oScroller != null)
         {
            oScroller.destroy();
         }
         oScroller = null;
         btnDown = null;
         btnUp = null;
         btnPlayAgain = null;
         btnSubmitHS = null;
         mcRef = null;
      }
      
      public function onSubmitScore(_e:Event) : void
      {
         Main.instance.oNickServices.addEventListener(NickServices.sEVENT_SCORES_RECEIVED,onScoresReceived,false,0,true);
         Main.instance.oNickServices.requestScores(Data.sGAME_ID);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_SCORE_SUBMISSION_COMPLETED,onSubmitScore,false);
         Main.instance.oNickServices.removeEventListener(NickServices.sEVENT_USER_LOGGED_OUT,onUserLoggedOut,false);
      }
   }
}
