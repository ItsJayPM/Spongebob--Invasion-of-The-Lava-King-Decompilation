package builder
{
   import flash.utils.ByteArray;
   import library.utils.Base64;
   import mdm.Dialogs;
   import mdm.FileSystem;
   
   public class FileWriter
   {
       
      
      public function FileWriter()
      {
         super();
      }
      
      public function save(_sFileName:String, _sFileContent:String) : void
      {
         var _oBA:ByteArray = new ByteArray();
         _oBA.writeUTFBytes(_sFileContent);
         _oBA.compress();
         var _s:String = _oBA.toString();
         _s = _s.substr(2,_s.length);
         FileSystem.saveFile(Data.sFILE_FOLDER_PATH + _sFileName + Data.sFILE_EXTENSION,Base64.encodeByteArray(_oBA));
         Dialogs.prompt("Saving");
      }
   }
}
