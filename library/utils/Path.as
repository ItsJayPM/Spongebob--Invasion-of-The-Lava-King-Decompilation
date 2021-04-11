package library.utils
{
   import flash.display.DisplayObject;
   
   public class Path
   {
       
      
      public function Path()
      {
         super();
      }
      
      public static function getPath(_mcRef:DisplayObject) : String
      {
         var lastCar:Number = NaN;
         var urlTemp:String = new String(_mcRef.loaderInfo.url);
         if(urlTemp.lastIndexOf("/") == -1)
         {
            lastCar = urlTemp.lastIndexOf("\\");
         }
         else
         {
            lastCar = urlTemp.lastIndexOf("/");
            if(lastCar <= 10)
            {
               lastCar = urlTemp.lastIndexOf("\\");
            }
         }
         return urlTemp.substring(0,lastCar + 1);
      }
   }
}
