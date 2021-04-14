package gameplay
{
   import flash.display.*;
   import flash.events.*;
   import popups.PopupTextbox;
   
   public class Storyline extends Sprite
   {
      
      private static var ScenarioSpeechIndex:int;
      
      private static var oPopupTextbox:PopupTextbox;
	  
      public static var oStorylineData:Object;
      
      public static const sSCENARIO_ID_TUTORIAL:String = "Tutorial";
      
      private static var StorylineXML:XML;
      
      private static var ScenarioPlayingID:String;
      
      private static var bServiceEnabled:Boolean;
      
      public static const sSCENARIO_ID_NEW:String = "New";
      
      public static const sSCENARIO_ID_INTRO:String = "Intro";
      
      public static const sSCENARIO_ID_SQUIDWARD:String = "Squidward";
	  
	  [Embed(source="../xml/story.xml", mimeType="application/octet-stream")]
      
      private static const StorylineXMLFile:Class;
      
      private static var fCallBack:Function;
      
      public static const sSCENARIO_ID_SANDY:String = "Sandy";
      
      private static var ScenarioSpeech:XMLList;
      
      public static const sSCENARIO_ID_PATRICK:String = "Patrick";
       
      
      public function Storyline()
      {
         super();
      }
      
      public static function enable() : void
      {
         bServiceEnabled = true;
      }
      
      public static function goto(_sScenarioID:String, _sMarkerID:String) : void
      {
         var _xmlScenario:XMLList = null;
         var _nIndex:int = 0;
         var _sIndex:Object = null;
         trace("Storyline : goto",_sScenarioID,_sMarkerID);
         _xmlScenario = getCurrentScenario(_sScenarioID);
         if(_xmlScenario != null)
         {
            _sIndex = _xmlScenario.marker.(@id == String(_sMarkerID));
            if(_sIndex != null && _sIndex != "" && _sIndex != " ")
            {
               _nIndex = int(_sIndex);
               setMarker(_sScenarioID,_nIndex);
            }
         }
      }
      
      public static function getCurrentScenario(_sScenarioID:String) : XMLList
      {
         var _xmlLevelPackage:XMLList = null;
         var _xmlScenario:XMLList = null;
         if(StorylineXML == null)
         {
            init();
         }
         _xmlLevelPackage = StorylineXML.episode.(@no == String(Profile.Instance.getCurrentEpisode()));
         _xmlScenario = _xmlLevelPackage.scenario.(@id == _sScenarioID);
         return _xmlScenario;
      }
      
      public static function doNextText() : void
      {
         var _xmlText:XML = ScenarioSpeech.text[ScenarioSpeechIndex];
         trace(_xmlText == null);
         trace(ScenarioSpeech);
         if(_xmlText != null)
         {
            Main.instance.popupTextbox.showText(_xmlText.attribute("talker"),_xmlText,doNextText);
            ++ScenarioSpeechIndex;
         }
         else
         {
            Main.instance.popupTextbox.close();
            setMarker(ScenarioPlayingID,int(ScenarioSpeech.attribute("next_id")));
            ScenarioSpeechIndex = 0;
            enable();
            if(fCallBack != null)
            {
               fCallBack();
               fCallBack = null;
            }
         }
      }
      
      public static function init() : void
      {
         trace("Storyline : init");
         oStorylineData = new Object();
         oStorylineData.Episode1 = new Object();
         oStorylineData.Episode1.aScenarioIDs = new Array();
         oStorylineData.Episode1.aScenarioSpeechID = new Array();
         oStorylineData.Episode2 = new Object();
         oStorylineData.Episode2.aScenarioIDs = new Array();
         oStorylineData.Episode2.aScenarioSpeechID = new Array();
         oStorylineData.Episode3 = new Object();
         oStorylineData.Episode3.aScenarioIDs = new Array();
         oStorylineData.Episode3.aScenarioSpeechID = new Array();
         enable();
         StorylineXML = new XML(new StorylineXMLFile());
      }
      
      private static function openTextbox() : void
      {
         if(Main.instance.popupTextbox == null)
         {
            Main.instance.addPopup(Main.sPOPUP_TEXTBOX);
         }
      }
      
      public static function getSpeech(_sScenarioID:String) : XMLList
      {
         var _xmlScenario:XMLList = null;
         var _nIndex:int = 0;
         var _nSpeechID:int = 0;
         _xmlScenario = getCurrentScenario(_sScenarioID);
         _nIndex = getCurrentScenarioIDs().indexOf(_sScenarioID);
         if(_nIndex < 0)
         {
            getCurrentScenarioIDs().push(_sScenarioID);
            _nIndex = getCurrentScenarioIDs().indexOf(_sScenarioID);
            getCurrentScenarioSpeechIDs()[_nIndex] = 1;
         }
         _nSpeechID = getCurrentScenarioSpeechIDs()[_nIndex];
         return _xmlScenario.speech.(@id == String(_nSpeechID));
      }
      
      public static function play(_sScenarioID:String, _fCallBack:Function = null) : void
      {
         var _xmlSpeechList:XMLList = null;
         if(bServiceEnabled)
         {
            fCallBack = _fCallBack;
            _xmlSpeechList = getSpeech(_sScenarioID);
            if(_xmlSpeechList != null)
            {
               ScenarioPlayingID = _sScenarioID;
               ScenarioSpeech = _xmlSpeechList;
               ScenarioSpeechIndex = 0;
               openTextbox();
               doNextText();
            }
         }
      }
      
      public static function getCurrentScenarioIDs() : Array
      {
         var _anArray:Array = null;
         switch(Profile.Instance.getCurrentEpisode())
         {
            case 1:
               _anArray = oStorylineData.Episode1.aScenarioIDs;
               break;
            case 2:
               _anArray = oStorylineData.Episode2.aScenarioIDs;
               break;
            case 3:
               _anArray = oStorylineData.Episode3.aScenarioIDs;
         }
         return _anArray;
      }
      
      public static function disable() : void
      {
         bServiceEnabled = false;
      }
      
      public static function getIntMarkerID(_sScenarioID:String, _sMarkerID:String) : int
      {
         var _xmlScenario:XMLList = null;
         _xmlScenario = getCurrentScenario(_sScenarioID);
         return int(_xmlScenario.marker.(@id == String(_sMarkerID)));
      }
      
      public static function getIntMarker(_sScenarioID:String) : int
      {
         var _xmlScenario:XMLList = null;
         var _nIndex:int = 0;
         _xmlScenario = getCurrentScenario(_sScenarioID);
         _nIndex = getCurrentScenarioIDs().indexOf(_sScenarioID);
         if(_nIndex < 0)
         {
            getCurrentScenarioIDs().push(_sScenarioID);
            _nIndex = getCurrentScenarioIDs().indexOf(_sScenarioID);
         }
         return getCurrentScenarioSpeechIDs()[_nIndex];
      }
      
      public static function getCurrentScenarioSpeechIDs() : Array
      {
         var _anArray:Array = null;
         switch(Profile.Instance.getCurrentEpisode())
         {
            case 1:
               _anArray = oStorylineData.Episode1.aScenarioSpeechID;
               break;
            case 2:
               _anArray = oStorylineData.Episode2.aScenarioSpeechID;
               break;
            case 3:
               _anArray = oStorylineData.Episode3.aScenarioSpeechID;
         }
         return _anArray;
      }
      
      public static function setMarker(_sScenarioID:String, _nValue:int) : void
      {
         var _xmlScenario:XMLList = null;
         var _nIndex:int = 0;
         _xmlScenario = getCurrentScenario(_sScenarioID);
         _nIndex = getCurrentScenarioIDs().indexOf(_sScenarioID);
         if(_nIndex < 0)
         {
            getCurrentScenarioIDs().push(_sScenarioID);
            _nIndex = getCurrentScenarioIDs().indexOf(_sScenarioID);
         }
         getCurrentScenarioSpeechIDs()[_nIndex] = _nValue;
      }
   }
}
