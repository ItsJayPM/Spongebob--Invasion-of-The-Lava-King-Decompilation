package builder
{
   import mdm.Application;
   import mdm.Dialogs;
   
   public class FileReader
   {
       
      
      public function FileReader()
      {
         super();
         Dialogs.BrowseFile.defaultDirectory = Application.path;
         Dialogs.BrowseFile.filterList = "Text Files(*.sbz, *.txt, *.as, *.xml)|*.sbz;*.xml;*.as;*.txt|ALL Files|*.*";
      }
      
      public function loadFile() : String
      {
         var _sFileName:String = null;
         _sFileName = Dialogs.BrowseFile.show();
         _sFileName = _sFileName.substr(_sFileName.lastIndexOf("\\") + 1,_sFileName.length);
         return _sFileName.substr(0,_sFileName.lastIndexOf("."));
      }
   }
}
