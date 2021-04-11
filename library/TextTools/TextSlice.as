package library.TextTools
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class TextSlice
   {
       
      
      public function TextSlice()
      {
         super();
      }
      
      public static function textPages(_txtField:TextField, _sTextInput:String) : Array
      {
         var _txtFormat:TextFormat = null;
         var _txtLineMetric:TextLineMetrics = null;
         var _sOldText:String = null;
         var _iLinePossible:int = 0;
         var _aPages:Array = null;
         _sOldText = _txtField.text;
         _txtLineMetric = _txtField.getLineMetrics(0);
         _txtFormat = _txtField.getTextFormat();
         _aPages = new Array();
         _txtField.text = _sTextInput;
         _iLinePossible = Math.floor(_txtField.height / _txtLineMetric.height);
         var _sPage:String = "";
         for(var i:int = 0; i < _txtField.numLines; i++)
         {
            if(i % _iLinePossible == 0 && i != 0)
            {
               _aPages.push(_sPage);
               _sPage = "";
            }
            _sPage += _txtField.getLineText(i);
         }
         if(_sPage != "")
         {
            _aPages.push(_sPage);
         }
         _txtField.text = _sOldText;
         return _aPages;
      }
   }
}
