package
{
   import flash.display.MovieClip;
   
   public dynamic class mcGameObjectDoorMapBorder extends MovieClip
   {
       
      
      public var mcHitzone:MovieClip;
      
      public function mcGameObjectDoorMapBorder()
      {
         super();
      }
      
      function frame1() : *
      {
         mcHitzone.alpha = 0;
      }
   }
}
