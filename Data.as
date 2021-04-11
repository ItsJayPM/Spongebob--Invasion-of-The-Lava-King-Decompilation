package
{
   import flash.filters.ColorMatrixFilter;
   import gameplay.ItemID;
   
   public class Data
   {
      
      public static const aSEAWEED_DROP_TABLE:Array = [10,20,20,10,0];
      
      public static const uDEFAULT_SHOP1_BOTTLES:uint = 10;
      
      public static const nBOTTLE_AMOUNT_OF_HEART_GIVEN:Number = 3;
      
      public static const nLIVES_DEFAULT_START:Number = 3;
      
      public static const nENEMY_JELLYFISH_SPEED_MID:Number = 80;
      
      public static const uINVENTORY_MAXIMUM_BOTTLES:uint = 3;
      
      public static const nENEMY_JELLYFISH_INIT_HEALTH_LIGHT:Number = 1;
      
      public static const sFILE_EXTENSION:String = ".sbz";
      
      public static const nENEMY_LANTERN_INIT_HEALTH_CALM:Number = 2;
      
      public static const uSCORE_LAVA_GOLEM:uint = 70;
      
      public static const uSCORE_EP2_SQUIDWARD_QUEST:uint = 1500;
      
      public static const nPROJECTILE_DEFAULT_MAX_DISTANCE:Number = 600;
      
      public static const nENEMY_JELLYFISH_PHASE_CHANGE_MIN_LIGHT:Number = 3;
      
      private static var uId:Number = 1;
      
      public static const uCHEST_KILL:uint = uId++;
      
      public static const uCHARACTER_SPONGEBOB:uint = uId++;
      
      public static const aJELLYFISH_LIGHT_DROP_TABLE:Array = [0,8,8,3,0];
      
      public static const nENEMY_LANTERN_INIT_HEALTH_AGGRESSIVE:Number = 3;
      
      public static const nENEMY_JELLYFISH_SPEED_LIGHT:Number = 20;
      
      public static const uDOOR_KILL:uint = uId++;
      
      public static const uDOOR_KEY_KILL:uint = uId++;
      
      public static const uDROP_TABLE_INDEX_KEY:uint = 0;
      
      public static const uDOOR_BOSS:uint = uId++;
      
      public static const iSTAGE_HEIGHT:Number = 300;
      
      public static const nENEMY_LANTERN_SPEED_CALM:Number = 40;
      
      public static const uHIGHEST_EPISODE_UNLOCKED:uint = 1;
      
      public static const uSCORE_SEAWEED_PUPPET:uint = 55;
      
      public static const sSTATE_WEAPONS0:String = "empty";
      
      public static const sSTATE_WEAPONS1:String = "sword_lvl1";
      
      public static const sSTATE_WEAPONS2:String = "sword_lvl2";
      
      public static const sSTATE_WEAPONS3:String = "shield_lvl1";
      
      public static const sSTATE_WEAPONS5:String = "sea_urchin";
      
      public static const sSTATE_WEAPONS7:String = "fork";
      
      public static const sSTATE_WEAPONS9:String = "wand";
      
      public static const nENEMY_LANTERN_PHASE_CHANGE_MIN_HUNGRY:Number = 1;
      
      public static const sSTATE_WEAPONS8:String = "boomerang";
      
      public static const uINVENTORY_MAXIMUM_KEYBOSSPART2:uint = 1;
      
      public static const uSCORE_LANTERN_AGGR:uint = 45;
      
      public static const sSTATE_WEAPONS4:String = "shield_lvl2";
      
      public static const sSTATE_WEAPONS6:String = "volcanic_sea_urchin";
      
      public static const aJELLYFISH_HIGH_DROP_TABLE:Array = [2,18,10,3,0];
      
      public static const nBOOMERANG_BODY_WIDTH:Number = 50;
      
      public static const sGAME_ID:String = "sb_lavahsb";
      
      public static const bPLAYER_DEBUG:Boolean = false;
      
      public static const nGASEOUS_ROCK_GAS_SPOUT_DAMAGE:Number = 2;
      
      public static const uEVENT_INTRO:uint = uId++;
      
      public static const uDESTRUCTABLE_SOLID:uint = uId++;
      
      public static const uINVENTORY_MAXIMUM_KEYBOSSPART1:uint = 1;
      
      public static const uDOOR_SECRET:uint = uId++;
      
      public static const sMUSIC_DUNGEON:String = "dungeon.wav";
      
      public static const uSCORE_EP2_DUNGEON_1:uint = 2000;
      
      public static const uSCORE_EP2_DUNGEON_2:uint = 2000;
      
      public static const sMUSIC_PACKAGING:String = "packaging.wav";
      
      public static const uCHARACTER_PATRICK:uint = uId++;
      
      public static const uSCORE_EP2_DUNGEON_3:uint = 3500;
      
      public static const nSEA_URCHIN_SPEED:Number = 150;
      
      public static const uDROP_TABLE_INDEX_VOLC_URCHIN:uint = 4;
      
      public static const nENEMY_EEL_MIN_TIME_TO_ATTACK:Number = 2;
      
      public static const nENEMY_JELLYFISH_DAMAGE_LIGHT:Number = 0.5;
      
      public static const uINVENTORY_MAXIMUM_TOOLS:uint = 3;
      
      public static const nENEMY_JELLYFISH_INIT_HEALTH_MID:Number = 1;
      
      public static const aROCK_DROP_TABLE:Array = [5,30,30,10,5];
      
      public static const iSTAGE_WIDTH:Number = 600;
      
      public static const uCHEST_NORMAL:uint = uId++;
      
      public static const nENEMY_LANTERN_SPEED_HUNGRY:Number = 80;
      
      public static const sPROFILE_SO_NAME:String = "soNICK_SpongeBob_LavaInvader";
      
      public static const nENEMY_EEL_DAMAGE:Number = 2;
      
      public static const nLIVES_MAXIMUM:Number = 9;
      
      public static const nENEMY_LANTERN_PHASE_CHANGE_MAX_AGGRESSIVE:Number = 0.8;
      
      public static const uEVENT_GAP1:uint = uId++;
      
      public static const uEVENT_GAP2:uint = uId++;
      
      public static const uEVENT_GAP3:uint = uId++;
      
      public static const sCATEGORY_MUSIC_LINKAGE:String = "music";
      
      public static const nPLAYER_FORGIVENESS:Number = 1.5;
      
      public static const uPRICE_TOOL:uint = 30;
      
      public static const nSEA_URCHIN_MAX_DISTANCE:Number = 150;
      
      public static const aGASEOUS_ROCK_AI_AFTER_GAS_SPOUT:Array = [{
         "luck":50,
         "cool":2
      },{
         "luck":40,
         "cool":2
      },{
         "luck":10,
         "cool":3
      }];
      
      public static const nENEMY_JELLYFISH_PHASE_CHANGE_MAX_MID:Number = 2;
      
      public static const nENEMY_LANTERN_DAMAGE_HUNGRY:Number = 2;
      
      public static const nENEMY_LANTERN_PHASE_CHANGE_MIN_CALM:Number = 3;
      
      public static const iCATEGORY_SOUND_VOLUME:Number = 1;
      
      public static const nMOVING_BLOCK_TIME:Number = 0.7;
      
      public static const nENEMY_LANTERN_PHASE_CHANGE_MAX_HUNGRY:Number = 2;
      
      public static const aGASEOUS_ROCK_AI_INITIAL_MOVE:Array = [{
         "luck":40,
         "cool":1.5
      },{
         "luck":40,
         "cool":2
      },{
         "luck":20,
         "cool":3
      }];
      
      public static const nBOOMERANG_SPEED:Number = 15;
      
      public static const uSCORE_EP1_SANDY_QUEST:uint = 1000;
      
      public static const uPRICE_KEY:uint = 20;
      
      public static const nENEMY_LANTERN_PHASE_CHANGE_MAX_CALM:Number = 4;
      
      public static const aITEMS_WITHOUT_EFFECT:Array = [ItemID.uPEBBLE_1,ItemID.uPEEBLES_5,ItemID.uPEEBLES_10,ItemID.uHEARTH,ItemID.uHEART_CONTAINER];
      
      public static const nGASEOUS_ROCK_HIT_DAMAGE:Number = 1;
      
      public static const uSCORE_JELLYFISH_LIGHT:uint = 20;
      
      public static const aLANTERN_AGGR_DROP_TABLE:Array = [5,18,12,10,0];
      
      public static const uDEFAULT_SHOP1_TOOL:uint = 1;
      
      public static const nDAMAGE_BOOMERANG:Number = 1;
      
      public static const sFILE_FOLDER_PATH:String = "data/";
      
      public static const uENEMY_EEL:uint = uId++;
      
      public static const nENEMY_JELLYFISH_DAMAGE_MID:Number = 1;
      
      public static const aGASEOUS_ROCK_AI_AFTER_ARM_SWING:Array = [{
         "luck":20,
         "cool":2
      },{
         "luck":60,
         "cool":2
      },{
         "luck":20,
         "cool":3
      }];
      
      public static const uBOSS_GASEOUS_ROCK:uint = uId++;
      
      public static const uDOOR_KEY:uint = uId++;
      
      public static const nPEEBLE_DROP_1:Number = 30;
      
      public static const nPEEBLE_DROP_5:Number = 60;
      
      public static const aCORAL_DROP_TABLE:Array = [10,25,25,10,0];
      
      public static const uINVENTORY_MAXIMUM_KEYS:uint = 5;
      
      public static const aLANTERN_HUNGRY_DROP_TABLE:Array = [4,12,10,7,0];
      
      public static const nBOOMERANG_MAX_DISTANCE:Number = 300;
      
      public static const nENEMY_LANTERN_INIT_HEALTH_HUNGRY:Number = 3;
      
      public static const nENEMY_LANTERN_SPEED_AGGRESSIVE:Number = 100;
      
      public static const uSCORE_CORALS:uint = 10;
      
      public static const uSWORD_LV1_ATTACK_AT_FRAME:uint = 3;
      
      public static const uDEFAULT_SHOP1_KEYS:uint = 10;
      
      public static const nGASEOUS_ROCK_GAS_CLOUD_DAMAGE:Number = 1;
      
      public static const uINVENTORY_MAXIMUM_PEBBLES:uint = 9999;
      
      public static const nENEMY_EEL_INIT_HEALTH:Number = 3;
      
      public static const uSCORE_SPONGE_SPITTING:uint = 50;
      
      public static const aLANTERN_CALM_DROP_TABLE:Array = [2,8,10,5,0];
      
      public static const nBOOMERANG_ANGLE:Number = Math.PI / 4;
      
      public static const uSCORE_ROCKS:uint = 15;
      
      public static const uSCORE_SPONGE_WALL:uint = 60;
      
      public static const nENEMY_JELLYFISH_PHASE_CHANGE_MAX_LIGHT:Number = 5;
      
      public static const nENEMY_JELLYFISH_DAMAGE_HIGH:Number = 1;
      
      public static const iTILE_WIDTH:Number = 50;
      
      public static const sCATEGORY_SOUND_LINKAGE:String = "sound";
      
      public static const nGASEOUS_ROCK_GAS_CLOUD_SPEED:Number = 150;
      
      public static const uSCORE_EP1_DUNGEON_1:uint = 1500;
      
      public static const uSCORE_EP1_DUNGEON_2:uint = 1500;
      
      public static const uSCORE_EP1_DUNGEON_3:uint = 2500;
      
      public static const uDEFAULT_SHOP2_TOOL:uint = 0;
      
      public static const sMUSIC_BOSS:String = "boss.wav";
      
      public static const nDAMAGE_SWORD_LV1:Number = 1;
      
      public static const nDAMAGE_SWORD_LV2:Number = 2;
      
      public static const uDEFAULT_SHOP3_BOTTLES:uint = 10;
      
      public static const aSPONGE_WALL_DROP_TABLE:Array = [5,10,18,2,10];
      
      public static const nGASEOUS_ROCK_INITIAL_COOLDOWN_LENGTH:Number = 0.5;
      
      public static const uPRICE_WEAPON5:uint = 5;
      
      public static const aLAVA_GOLEM_DROP_TABLE:Array = [2,15,20,2,8];
      
      public static const uPRICE_WEAPON6:uint = 15;
      
      public static const nGASEOUS_ROCK_ARM_SWING_DAMAGE:Number = 1;
      
      public static const uCHARACTER_SQUIDWARD:uint = uId++;
      
      public static const oINVENTORY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,0,1,0.2,0,0,0,0,1,0,0,0,0,0,1,0]);
      
      public static const oDISABLED_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.6,0,0,0,0,-0.4,1,0,0,0,-0.4,0,1,0,0,0,0,0,1,0]);
      
      public static const uDROP_TABLE_INDEX_SEA_URCHIN:uint = 3;
      
      public static const uENEMY_JELLYFISH_MID:uint = uId++;
      
      public static const uSCORE_EP1_SQUIDWARD_QUEST:uint = 1000;
      
      public static const uSCORE_EP3_SQUIDWARD_QUEST:uint = 2000;
      
      public static const nSHIELD_TIMEOUT:Number = 3;
      
      public static const uSCORE_EP3_SANDY_QUEST:uint = 2000;
      
      public static const uENEMY_JELLYFISH_LIGHT:uint = uId++;
      
      public static const uLEVEL_DUNGEON:uint = 2;
      
      public static const uDEFAULT_SHOP2_KEYS:uint = 10;
      
      public static const uDOOR_LAIR:uint = uId++;
      
      public static const nGASEOUS_ROCK_INIT_HEALTH:Number = 12;
      
      public static const aJELLYFISH_MID_DROP_TABLE:Array = [0,12,8,3,0];
      
      public static const uINVENTORY_MAXIMUM_WEAPON3:uint = 1;
      
      public static const uINVENTORY_MAXIMUM_WEAPON4:uint = 1;
      
      public static const uINVENTORY_MAXIMUM_WEAPON5:uint = 10;
      
      public static const uINVENTORY_MAXIMUM_WEAPON6:uint = 10;
      
      public static const nSEA_URCHIN_BODY_HEIGHT:Number = 10;
      
      public static const uINVENTORY_MAXIMUM_WEAPON8:uint = 1;
      
      public static const uSCORE_JELLYFISH_HIGH:uint = 30;
      
      public static const uINVENTORY_MAXIMUM_WEAPON2:uint = 1;
      
      public static const nMOVING_BLOCK_PUSH_TIMEOUT:Number = 0.4;
      
      public static const uINVENTORY_MAXIMUM_WEAPON9:uint = 1;
      
      public static const uINVENTORY_MAXIMUM_WEAPON1:uint = 1;
      
      public static const uPRICE_BOTTLE:uint = 20;
      
      public static const nDAMAGE_SEA_URCHIN:Number = 2;
      
      public static const iMAP_WIDTH:int = 1800;
      
      public static const uINVENTORY_MAXIMUM_WEAPON7:uint = 1;
      
      public static const sMUSIC_GAME:String = "inGame.wav";
      
      public static const uCHARACTER_SANDY:uint = uId++;
      
      public static const uDROP_TABLE_INDEX_PEEBLE:uint = 2;
      
      public static const nGASEOUS_ROCK_GAS_SPOUT_SPEED:Number = 300;
      
      public static const uSCORE_LANTERN_HUNGRY:uint = 40;
      
      public static const nENEMY_JELLYFISH_INIT_HEALTH_HIGH:Number = 2;
      
      public static const uINVENTORY_MAXIMUM_MAP:uint = 1;
      
      public static const uDEFAULT_SHOP3_TOOL:uint = 0;
      
      public static const iMAP_HEIGHT:int = 1800;
      
      public static const uDROP_TABLE_INDEX_HEALTH:uint = 1;
      
      public static const uDOOR_SANDY:uint = uId++;
      
      public static const aSPONGE_DOUBLE_DROP_TABLE:Array = [5,18,13,10,5];
      
      public static const uINVENTORY_MAXIMUM_KEYBOSSCHAMBER:uint = 1;
      
      public static const nDAMAGE_VOLCANIC_URCHIN:Number = 3;
      
      public static const uENEMY_JELLYFISH_HIGH:uint = uId++;
      
      public static const nLIVES_DEFAULT_MAXIMUM:Number = 3;
      
      public static const nENEMY_JELLYFISH_SPEED_HIGH:Number = 110;
      
      public static const nITEM_DROP_TIMEOUT:Number = 180;
      
      public static const uDOOR_SQUIDWARD:uint = uId++;
      
      public static const uCHARACTER_KRAB:uint = uId++;
      
      public static const uDESTRUCTABLE_EXPLOSIVE:uint = uId++;
      
      public static const uDOOR_NORMAL:uint = uId++;
      
      public static const nITEM_DROP_FLASH_TIMEOUT:Number = 5;
      
      public static const uDEFAULT_SHOP3_KEYS:uint = 10;
      
      public static const uDEFAULT_SHOP2_BOTTLES:uint = 10;
      
      public static const uCHEST_KEY:uint = uId++;
      
      public static const nENEMY_JELLYFISH_PHASE_CHANGE_MIN_MID:Number = 1.5;
      
      public static const nPROJECTILE_DEFAULT_SPEED:Number = 80;
      
      public static const aSEAWEED_PUPPET_DROP_TABLE:Array = [7,25,8,15,0];
      
      public static const nENEMY_EEL_HURT_DURATION:Number = 1;
      
      public static const uSCORE_SPONGE_DOUBLE:uint = 55;
      
      public static const nGASEOUS_ROCK_FIELD_OF_VIEW:Number = 350;
      
      public static const uDOOR_EPISODE:uint = uId++;
      
      public static const uLEVEL_WORLD:uint = 1;
      
      public static const aSPONGE_SPITTING_DROP_TABLE:Array = [5,15,13,10,2];
      
      public static const uEVENT_TUTORIAL:uint = uId++;
      
      public static const nENEMY_EEL_HIT_DAMAGE:Number = 1;
      
      public static const uSCORE_SEA_WEEDS:uint = 5;
      
      public static const nENEMY_LANTERN_PHASE_CHANGE_MIN_AGGRESSIVE:Number = 0.4;
      
      public static const nPEEBLE_DROP_10:Number = 10;
      
      public static const iCATEGORY_MUSIC_VOLUME:Number = 0.8;
      
      public static const uDESTRUCTABLE_ORGANIC:uint = uId++;
      
      public static const aEEL_DROP_TABLE:Array = [5,12,10,5,0];
      
      public static const uSCORE_LANTERN_CALM:uint = 35;
      
      public static const nENEMY_JELLYFISH_PHASE_CHANGE_MIN_HIGH:Number = 0.5;
      
      public static const uSCORE_ALL_DUNGEONS_AND_QUESTS:uint = 6000;
      
      public static const uSCORE_EEL:uint = 40;
      
      public static const uEVENT_PUZZLE_SOLVED:uint = uId++;
      
      public static const uSEA_URCHIN_THROW_AT_FRAME:uint = 7;
      
      public static const aGASEOUS_ROCK_AI_AFTER_GAS_CLOUD:Array = [{
         "luck":60,
         "cool":2.25
      },{
         "luck":40,
         "cool":2.25
      },{
         "luck":0,
         "cool":0
      }];
      
      public static const uSCORE_EP3_DUNGEON_1:uint = 3000;
      
      public static const uSCORE_EP3_DUNGEON_3:uint = 5500;
      
      public static const nENEMY_JELLYFISH_PHASE_CHANGE_MAX_HIGH:Number = 1;
      
      public static const uSCORE_EP3_DUNGEON_2:uint = 3000;
      
      public static const nENEMY_EEL_MAX_TIME_TO_ATTACK:Number = 5;
      
      public static const nPLAYER_WALK_SPEED:Number = 180;
      
      public static const sFILE_WORLD:String = "patrick01a";
      
      public static const nGASEOUS_ROCK_FORGIVENESS_TIMEOUT:Number = 4;
      
      public static const nDAMAGE_WAND:Number = 3;
      
      public static const uSWORD_LV2_ATTACK_AT_FRAME:uint = 2;
      
      public static const iTILE_HEIGHT:Number = 50;
      
      public static const nENEMY_LANTERN_DAMAGE_CALM:Number = 2;
      
      public static const nBOOMERANG_BODY_HEIGHT:Number = 50;
      
      public static const uSCORE_JELLYFISH_MID:uint = 25;
      
      public static const uSCORE_EP2_SANDY_QUEST:uint = 1500;
      
      public static const nSEA_URCHIN_BODY_WIDTH:Number = 10;
      
      public static const nENEMY_LANTERN_DAMAGE_AGGRESSIVE:Number = 2.5;
       
      
      public function Data()
      {
         super();
      }
   }
}
