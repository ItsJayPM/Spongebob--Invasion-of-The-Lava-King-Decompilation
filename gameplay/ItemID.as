package gameplay
{
   public class ItemID
   {
      
      private static var i:uint = 1;
      
      public static const uPEBBLES:uint = i++;
      
      public static const uPEBBLE_1:uint = i++;
      
      public static const uPEEBLES_5:uint = i++;
      
      public static const uMINI_MAP:uint = i++;
      
      public static const uSHIELD_LV_2:uint = i++;
      
      public static const uSHIELD_LV_1:uint = i++;
      
      public static const uSANDY_TOOLS:uint = i++;
      
      public static const uHEALTH_BOTTLE:uint = i++;
      
      public static const uBOSS_CHAMBER_KEY:uint = i++;
      
      public static const uFORK:uint = i++;
      
      public static const uBOSS_DUNGEON_KEY_2:uint = i++;
      
      public static const uBOSS_DUNGEON_KEY_1:uint = i++;
      
      public static const uSANDY_ITEM_3:uint = i++;
      
      public static const uSEA_URCHIN:uint = i++;
      
      public static const uSANDY_ITEM_2:uint = i++;
      
      public static const uSANDY_ITEM_1:uint = i++;
      
      public static const uDOOR_KEY:uint = i++;
      
      public static const uVOLCANIC_URCHIN:uint = i++;
      
      public static const uHEARTH:uint = i++;
      
      public static const uSWORD_LV_2:uint = i++;
      
      public static const uSWORD_LV_1:uint = i++;
      
      public static const uBOOMERANG:uint = i++;
      
      public static const uPEEBLES_10:uint = i++;
      
      public static const uHEART_CONTAINER:uint = i++;
      
      public static const uWAND:uint = i++;
      
      public static const uNULL_ITEM:uint = 0;
       
      
      public function ItemID()
      {
         super();
      }
      
      public static function isAnItem(_uItem:uint, _bIncludesNull:Boolean = false) : Boolean
      {
         if(_bIncludesNull)
         {
            return _uItem >= 0 && _uItem < i;
         }
         return _uItem > 0 && _uItem < i;
      }
   }
}
