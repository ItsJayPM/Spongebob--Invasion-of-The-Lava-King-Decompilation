package library.utils
{
   public class Tools
   {
       
      
      public function Tools()
      {
         super();
      }
      
      public static function getMatrixParameter(_sMatrix:String, _sParameter:String, _sCharacter:String) : Number
      {
         var _nParameter:Number = 0;
         var _sCurrentString:String = _sMatrix.substr(_sMatrix.indexOf(_sParameter) + 2,_sMatrix.length);
         _sCurrentString = _sCurrentString.substr(0,_sCurrentString.indexOf(_sCharacter));
         return Number(Number(_sCurrentString));
      }
      
      public static function getFormatedNumber(__nNumber:Number, __nMinimumChar:Number = 0) : String
      {
         var i:Number = NaN;
         var _sChar:String = null;
         var _sNewNumber:String = String(__nNumber);
         while(_sNewNumber.length < __nMinimumChar)
         {
            _sNewNumber = "0" + _sNewNumber;
         }
         var _aParts:Array = new Array();
         var _nLoop:Number = _sNewNumber.length - 1;
         for(i = 0; i <= _nLoop; i++)
         {
            _sChar = _sNewNumber.charAt(i);
            _aParts.push(_sChar);
         }
         _sNewNumber = "";
         var j:Number = 0;
         for(i = _aParts.length - 1; i >= 0; i--)
         {
            if(j % 3 == 0 && j != 0)
            {
               _sNewNumber = " " + _sNewNumber;
            }
            _sNewNumber = _aParts[i] + _sNewNumber;
            j++;
         }
         return _sNewNumber;
      }
      
      public static function getFormatedUint(__nNumber:uint, __nMinimumChar:Number = 0) : String
      {
         var i:Number = NaN;
         var _sChar:String = null;
         var _sNewNumber:String = String(__nNumber);
         while(_sNewNumber.length < __nMinimumChar)
         {
            _sNewNumber = "0" + _sNewNumber;
         }
         var _aParts:Array = new Array();
         var _nLoop:Number = _sNewNumber.length - 1;
         for(i = 0; i <= _nLoop; i++)
         {
            _sChar = _sNewNumber.charAt(i);
            _aParts.push(_sChar);
         }
         _sNewNumber = "";
         var j:Number = 0;
         for(i = _aParts.length - 1; i >= 0; i--)
         {
            if(j % 3 == 0 && j != 0)
            {
               _sNewNumber = " " + _sNewNumber;
            }
            _sNewNumber = _aParts[i] + _sNewNumber;
            j++;
         }
         return _sNewNumber;
      }
      
      public static function isItemInArray(__aArray:Array, __oItem:Object) : Boolean
      {
         var _oItem:Object = null;
         var _bFound:Boolean = false;
         for each(_oItem in __aArray)
         {
            if(_oItem == __oItem)
            {
               _bFound = true;
               break;
            }
         }
         return _bFound;
      }
      
      public static function doCopyArray(__aArraySource:Array) : Array
      {
         var _aNewArray:Array = new Array();
         var i:Number = 0;
         for(i = 0; i < __aArraySource.length; i++)
         {
            if(__aArraySource[i] is Array)
            {
               _aNewArray.push(Tools.doCopyArray(__aArraySource[i]));
            }
            else
            {
               _aNewArray.push(__aArraySource[i]);
            }
         }
         return _aNewArray;
      }
      
      public static function removeItemInArray(__aArray:Array, __oItem:Object) : Boolean
      {
         var _bFound:Boolean = false;
         var _nI:Number = __aArray.length - 1;
         while(_nI >= 0)
         {
            if(__aArray[_nI] == __oItem)
            {
               _bFound = true;
               __aArray.splice(_nI,1);
               break;
            }
            _nI--;
         }
         return _bFound;
      }
   }
}
