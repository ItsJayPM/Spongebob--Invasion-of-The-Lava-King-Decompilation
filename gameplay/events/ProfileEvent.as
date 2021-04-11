package gameplay.events
{
   import flash.events.Event;
   
   public class ProfileEvent extends Event
   {
      
      public static const EVENT_UPDATE_SCORE:String = "ProfileEvent_updateScore";
      
      public static const EVENT_UPDATE_PEEBLE:String = "ProfileEvent_updatePeebleScore";
      
      public static const EVENT_GET_NEW_ITEM:String = "ProfileEvent_getNewItem";
      
      public static const EVENT_GET_ITEM:String = "ProfileEvent_getItem";
      
      public static const EVENT_UPDATE_BOTTLE_NUM:String = "ProfileEvent_updateBottle";
      
      public static const EVENT_UPDATE_VOLCANIC_URCHIN_NUM:String = "ProfileEvent_updateVolcanicUrchin";
      
      public static const EVENT_UPDATE_PRIMARYWEAPON:String = "ProfileEvent_updatePrimaryWeapon";
      
      public static const EVENT_UPDATE_KEY:String = "ProfileEvent_updateKey";
      
      public static const EVENT_UPDATE_HEALTH_CONTAINER:String = "ProfileEvent_updateHealthContainer";
      
      public static const EVENT_UPDATE_HEALTH:String = "ProfileEvent_updateHealth";
      
      public static const EVENT_UPDATE_SEA_URCHIN_NUM:String = "ProfileEvent_updateSeaUrchin";
      
      public static const EVENT_UPDATE_SECONDARYWEAPON:String = "ProfileEvent_updateSecondaryWeapon";
       
      
      private var uItemId:uint;
      
      public function ProfileEvent(_sType:String, _uItemId:uint = 0)
      {
         super(_sType);
         uItemId = _uItemId;
      }
      
      public function get itemId() : uint
      {
         return uItemId;
      }
      
      override public function clone() : Event
      {
         return new ProfileEvent(type,uItemId);
      }
   }
}
