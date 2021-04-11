package library.basic
{
   import flash.events.Event;
   import library.basic.InactivityElements.InactivityStruct;
   
   public class InactivityPromp
   {
       
      
      private var aLstOfInactivityStruct:Array;
      
      private var nFPS:Number;
      
      public function InactivityPromp()
      {
         nFPS = Main.instance.stage.frameRate;
         super();
         aLstOfInactivityStruct = new Array();
      }
      
      public function resetAllCue() : void
      {
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            aLstOfInactivityStruct[i].nCurrentTime = 0;
            aLstOfInactivityStruct[i].nTargetTime = aLstOfInactivityStruct[i].nPermanentTargetTime;
            aLstOfInactivityStruct[i].bPause = false;
         }
      }
      
      private function fDummy() : void
      {
      }
      
      public function resetCue(_sName:String) : Boolean
      {
         if(alreadyExist(_sName) == false)
         {
            return false;
         }
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            if(_sName == aLstOfInactivityStruct[i].sName)
            {
               aLstOfInactivityStruct[i].nCurrentTime = 0;
               aLstOfInactivityStruct[i].nTargetTime = aLstOfInactivityStruct[i].nPermanentTargetTime;
               aLstOfInactivityStruct[i].bPause = false;
            }
         }
         return true;
      }
      
      public function pause() : void
      {
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            InactivityStruct(aLstOfInactivityStruct[i]).bPause = true;
         }
      }
      
      private function alreadyExist(_sName:String) : Boolean
      {
         var _bRet:Boolean = false;
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            if(_sName == InactivityStruct(aLstOfInactivityStruct[i]).sName)
            {
               _bRet = true;
            }
         }
         return _bRet;
      }
      
      public function deleteCue(_sName:String) : Boolean
      {
         var _oInactivity:Array = null;
         if(alreadyExist(_sName) == false)
         {
            return false;
         }
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            if(_sName == aLstOfInactivityStruct[i].sName)
            {
               _oInactivity = aLstOfInactivityStruct.splice(i,1);
               _oInactivity = null;
            }
         }
         return true;
      }
      
      public function update(_e:Event = null) : void
      {
         var _oTempInactivity:InactivityStruct = null;
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            _oTempInactivity = InactivityStruct(aLstOfInactivityStruct[i]);
            if(_oTempInactivity.bPause == false)
            {
               if(_oTempInactivity.nTargetTime != Number.POSITIVE_INFINITY)
               {
                  _oTempInactivity.nCurrentTime += 1 / nFPS;
                  if(_oTempInactivity.nCurrentTime >= _oTempInactivity.nTargetTime)
                  {
                     _oTempInactivity.fCallBack();
                     if(_oTempInactivity.bLoop == false)
                     {
                        _oTempInactivity.nTargetTime = Number.POSITIVE_INFINITY;
                     }
                     else
                     {
                        _oTempInactivity.nCurrentTime = 0;
                     }
                  }
               }
            }
         }
      }
      
      public function addCue(_sName:String, _fCallBack:Function = undefined, _nTargetTime:Number = 1, _bLoop:Boolean = false) : Boolean
      {
         if(alreadyExist(_sName) == true)
         {
            return false;
         }
         if(_sName == null)
         {
            return false;
         }
         var _oNewStruct:InactivityStruct = new InactivityStruct();
         _oNewStruct.sName = _sName;
         _oNewStruct.fCallBack = _fCallBack;
         _oNewStruct.nCurrentTime = 0;
         _oNewStruct.nTargetTime = _nTargetTime;
         _oNewStruct.nPermanentTargetTime = _nTargetTime;
         _oNewStruct.bLoop = _bLoop;
         _oNewStruct.bPause = false;
         aLstOfInactivityStruct.push(_oNewStruct);
         return true;
      }
      
      public function pauseCue(_sName:String) : Boolean
      {
         if(alreadyExist(_sName) == false)
         {
            return false;
         }
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            if(_sName == aLstOfInactivityStruct[i].sName)
            {
               InactivityStruct(aLstOfInactivityStruct[i]).bPause = true;
            }
         }
         return true;
      }
      
      public function unpauseCue(_sName:String) : Boolean
      {
         if(alreadyExist(_sName) == false)
         {
            return false;
         }
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            if(_sName == aLstOfInactivityStruct[i].sName)
            {
               InactivityStruct(aLstOfInactivityStruct[i]).bPause = false;
            }
         }
         return true;
      }
      
      public function clearData() : void
      {
         var _oTmp:Object = null;
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            _oTmp = aLstOfInactivityStruct.pop();
            _oTmp = null;
         }
         aLstOfInactivityStruct = null;
      }
      
      public function unpause() : void
      {
         for(var i:Number = 0; i < aLstOfInactivityStruct.length; i++)
         {
            InactivityStruct(aLstOfInactivityStruct[i]).bPause = false;
         }
      }
   }
}
