package
{
   import com.nickonline.services.business.ProxyResponder;
   import com.nickonline.services.business.ServiceLocator;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.LocalConnection;
   import flash.system.Security;
   
   public class NickServices extends EventDispatcher
   {
      
      public static const sLOCAL_BASE_URL:String = "www.nick-q.mtvi.com";
      
      public static const sEVENT_USER_LOGGED_OUT:String = "userLoggedOut";
      
      public static const sEVENT_ERROR:String = "error";
      
      public static const nLOGIN_UI_BACKGROUND_ALPHA:Number = 0.7;
      
      public static const nLOGIN_UI_BACKGROUND_COLOR:Number = 0;
      
      public static const sEVENT_LOGIN_UI_RECEIVED:String = "loginReceived";
      
      public static const sSERVICE_MANAGER_CONFIG_URL:String = "/common/flash/services/data/services.xml";
      
      public static const sEVENT_SCORES_RECEIVED:String = "scoresReceived";
      
      public static const sEVENT_NICK_POINTS_AWARDING_COMPLETED:String = "nickPointsAwardingCompleted";
      
      public static const sSERVICE_MANAGER_URL:String = "/common/flash/services/ServiceManager.swf";
      
      public static const sEVENT_USER_STATUS_RECEIVED:String = "userStatusReceived";
      
      public static const sEVENT_SERVICES_READY:String = "servicesReady";
      
      public static const sEVENT_SCORE_SUBMISSION_COMPLETED:String = "scoreSubmissionCompleted";
       
      
      private var mcLoginUIContainer:DisplayObjectContainer;
      
      private var oAuthenticationResponder:ProxyResponder;
      
      private var bLogged:Boolean;
      
      private var oNickPointsResponder:ProxyResponder;
      
      private var bAutoShowLoginUI:Boolean;
      
      private var sNickName:String;
      
      private var aHighScores:Array;
      
      public var bSubmitHS:Boolean;
      
      private var mcLoginUI:Sprite;
      
      private var sSubmitScoreGameID:String;
      
      private var mcLoginUIBackground:Sprite;
      
      private var bSubmitScoreUserValidation:Boolean;
      
      private var bReady:Boolean;
      
      private var sBaseURL:String;
      
      private var oServiceLocator:ServiceLocator;
      
      public var bViewHS:Boolean;
      
      private var uSubmitScoreScore:Number;
      
      private var oHighScoresResponder:ProxyResponder;
      
      private var uNickPoints:uint;
      
      public function NickServices()
      {
         super();
         init();
      }
      
      private function onHighScoresError(_e:Event) : void
      {
         dispatchError("HighScores service error: " + _e.type);
      }
      
      private function loginFadeOut() : void
      {
         mcLoginUIBackground.addEventListener(Event.ENTER_FRAME,onFadeOutEnterFrame);
      }
      
      private function loginFadeIn() : void
      {
         mcLoginUIBackground = new Sprite();
         mcLoginUIBackground.graphics.beginFill(nLOGIN_UI_BACKGROUND_COLOR);
         mcLoginUIBackground.graphics.drawRect(0,0,mcLoginUIContainer.stage.stageWidth,mcLoginUIContainer.stage.stageHeight);
         mcLoginUIBackground.alpha = 0;
         mcLoginUIBackground.addEventListener(Event.ENTER_FRAME,onFadeInEnterFrame);
         mcLoginUIContainer.addChild(mcLoginUIBackground);
      }
      
      public function requestUserStatus() : void
      {
         if(bReady)
         {
            oServiceLocator.execute("Authentication","checkLogin",null,oAuthenticationResponder);
         }
      }
      
      public function requestScores(_sGameID:String) : void
      {
         if(bReady)
         {
            oServiceLocator.execute("HighScores","doLoadHighScores",new Array(_sGameID),oHighScoresResponder);
         }
      }
      
      private function onAuthenticationError(_e:Event) : void
      {
         dispatchError("Authentication service error: " + _e.type);
      }
      
      private function onFadeInEnterFrame(_e:Event) : void
      {
         mcLoginUIBackground.alpha += 0.1;
         if(mcLoginUIBackground.alpha >= nLOGIN_UI_BACKGROUND_ALPHA)
         {
            mcLoginUIBackground.removeEventListener(Event.ENTER_FRAME,onFadeInEnterFrame);
         }
      }
      
      private function init() : void
      {
         if(new LocalConnection().domain == "localhost")
         {
            sBaseURL = "http://" + sLOCAL_BASE_URL;
            Security.allowDomain(sLOCAL_BASE_URL);
         }
         else
         {
            sBaseURL = "";
         }
         oServiceLocator = new ServiceLocator(sSERVICE_MANAGER_URL,sSERVICE_MANAGER_CONFIG_URL);
         oServiceLocator.defaultURI = sBaseURL;
         oServiceLocator.addEventListener("EVENT_SERVICES_LOADED",onServiceReady);
         oServiceLocator.addEventListener("EVENT_SERVICE_INVALID",onServiceInvalid);
         oServiceLocator.addEventListener("EVENT_SERVICES_NOT_FOUND",onServiceNotFound);
         oServiceLocator.load();
         bSubmitHS = false;
         bViewHS = false;
      }
      
      public function get nickName() : String
      {
         return sNickName;
      }
      
      private function onNickPointsError(_e:Event) : void
      {
         dispatchError("Nick Points service error: " + _e.type);
      }
      
      public function get nickPoints() : uint
      {
         return uNickPoints;
      }
      
      public function requestLoginUI(_bAutoShow:Boolean = false, _mcContainer:DisplayObjectContainer = null) : void
      {
         if(bReady)
         {
            if(_bAutoShow)
            {
               if(_mcContainer == null)
               {
                  trace("You must pass a valid sprite container to use the auto-show feature");
               }
               else
               {
                  bAutoShowLoginUI = true;
                  mcLoginUIContainer = _mcContainer;
                  loginFadeIn();
               }
            }
            oServiceLocator.execute("Authentication","getLogin",null,oAuthenticationResponder);
         }
      }
      
      private function onFadeOutEnterFrame(_e:Event) : void
      {
         mcLoginUIBackground.alpha -= 0.1;
         if(mcLoginUIBackground.alpha <= 0)
         {
            mcLoginUIBackground.removeEventListener(Event.ENTER_FRAME,onFadeOutEnterFrame);
            mcLoginUIContainer.removeChild(mcLoginUIBackground);
            mcLoginUIBackground = null;
            dispatchEvent(new Event(sEVENT_USER_STATUS_RECEIVED));
         }
      }
      
      public function get ready() : Boolean
      {
         return bReady;
      }
      
      private function onAuthenticationResult(_e:Object) : void
      {
         switch(_e.type)
         {
            case "LOGIN_CHECK_LOGGED_IN":
               bLogged = true;
               saveUserInfos(_e.data);
               if(bSubmitScoreUserValidation)
               {
                  bSubmitScoreUserValidation = false;
                  oServiceLocator.execute("HighScores","doSubmitHighScore",new Array(sSubmitScoreGameID,uSubmitScoreScore,sNickName),oHighScoresResponder);
               }
               else
               {
                  dispatchEvent(new Event(sEVENT_USER_STATUS_RECEIVED));
               }
               break;
            case "LOGIN_CHECK_LOGGED_OUT":
               bLogged = false;
               saveUserInfos(new Object());
               if(bSubmitScoreUserValidation)
               {
                  bSubmitScoreUserValidation = false;
                  dispatchEvent(new Event(sEVENT_USER_LOGGED_OUT));
               }
               else
               {
                  dispatchEvent(new Event(sEVENT_USER_STATUS_RECEIVED));
               }
               break;
            case "LOGIN_UI_LOADED":
               mcLoginUI = _e.data;
               if(bAutoShowLoginUI)
               {
                  mcLoginUI.x = (mcLoginUIContainer.stage.stageWidth - mcLoginUI.width) / 2;
                  mcLoginUI.y = (mcLoginUIContainer.stage.stageHeight - mcLoginUI.height) / 2;
                  mcLoginUIContainer.addChild(mcLoginUI);
               }
               dispatchEvent(new Event(sEVENT_LOGIN_UI_RECEIVED));
               break;
            case "LOGIN_COMPLETE":
               bLogged = true;
               saveUserInfos(_e.data);
               if(bAutoShowLoginUI)
               {
                  bAutoShowLoginUI = false;
                  mcLoginUIContainer.removeChild(mcLoginUI);
                  mcLoginUI = null;
                  loginFadeOut();
               }
               else
               {
                  dispatchEvent(new Event(sEVENT_USER_STATUS_RECEIVED));
               }
         }
      }
      
      private function dispatchError(_sDescription:String) : void
      {
         trace(_sDescription);
         dispatchEvent(new ErrorEvent(sEVENT_ERROR,false,false,_sDescription));
      }
      
      public function get logged() : Boolean
      {
         return bLogged;
      }
      
      public function get loginUI() : Sprite
      {
         return mcLoginUI;
      }
      
      private function onServiceInvalid(_e:Event) : void
      {
         dispatchError("Services invalid.");
      }
      
      private function onHighScoresResult(_e:Object) : void
      {
         var _oScore:Object = null;
         switch(_e.type)
         {
            case "SUBMIT_SCORES_SUCCESS":
               dispatchEvent(new Event(sEVENT_SCORE_SUBMISSION_COMPLETED));
               break;
            case "LOAD_SCORES_SUCCESS":
               aHighScores = [];
               for each(_oScore in _e.data.scores)
               {
                  aHighScores.push({
                     "nRank":_oScore.rank,
                     "sNickName":_oScore.name,
                     "nScore":_oScore.score
                  });
               }
               dispatchEvent(new Event(sEVENT_SCORES_RECEIVED));
         }
      }
      
      private function onNickPointsResult(_e:Object) : void
      {
         dispatchEvent(new Event(sEVENT_NICK_POINTS_AWARDING_COMPLETED));
      }
      
      public function awardNickPoints(_sCampaignID:String, _sEventID:String) : void
      {
         if(bReady)
         {
            oServiceLocator.execute("NickPointsCampaign","awardNickPoints",new Array(_sCampaignID,_sEventID),oHighScoresResponder);
         }
      }
      
      private function onServiceNotFound(_e:Event) : void
      {
         dispatchError("Services not found.");
      }
      
      public function submitScore(_sGameID:String, _uScore:Number) : void
      {
         if(bReady)
         {
            requestUserStatus();
            bSubmitScoreUserValidation = true;
            sSubmitScoreGameID = _sGameID;
            uSubmitScoreScore = _uScore;
         }
      }
      
      public function get highScores() : Array
      {
         return aHighScores;
      }
      
      private function onServiceReady(_e:Event) : void
      {
         bReady = true;
         oAuthenticationResponder = new ProxyResponder(onAuthenticationResult,onAuthenticationError);
         oHighScoresResponder = new ProxyResponder(onHighScoresResult,onHighScoresError);
         oNickPointsResponder = new ProxyResponder(onNickPointsResult,onNickPointsError);
         dispatchEvent(new Event(sEVENT_SERVICES_READY));
      }
      
      public function destroy() : void
      {
         mcLoginUI = null;
         mcLoginUIContainer = null;
         mcLoginUIBackground = null;
      }
      
      private function saveUserInfos(_oData:Object) : void
      {
         sNickName = _oData.nickName;
         uNickPoints = _oData.points;
      }
   }
}
