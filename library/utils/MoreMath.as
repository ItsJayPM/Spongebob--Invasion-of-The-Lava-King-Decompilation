package library.utils
{
   import flash.geom.Point;
   
   public class MoreMath
   {
       
      
      public function MoreMath()
      {
         super();
      }
      
      public static function getTurnAngle(_nOrigin:Number, _nTarget:Number) : Number
      {
         var _nTurn:Number = _nTarget - _nOrigin;
         if(Math.abs(_nTurn) > 180)
         {
            if(_nTarget > _nOrigin)
            {
               _nTurn -= 360;
            }
            else
            {
               _nTurn = 360 - Math.abs(_nTurn);
            }
         }
         return _nTurn;
      }
      
      public static function adjustAngleRad(_nAngle:Number) : Number
      {
         while(_nAngle > Math.PI)
         {
            _nAngle -= Math.PI * 2;
         }
         while(_nAngle <= -Math.PI)
         {
            _nAngle += Math.PI * 2;
         }
         return _nAngle;
      }
      
      public static function adjustAngle(_nAngle:Number) : Number
      {
         while(_nAngle > 360)
         {
            _nAngle -= 360;
         }
         while(_nAngle < 0)
         {
            _nAngle += 360;
         }
         return _nAngle;
      }
      
      public static function getRandomRangeFloat(__nMin:Number, __nMax:Number) : Number
      {
         return Math.random() * (__nMax - __nMin) + __nMin;
      }
      
      public static function getDistanceSq(__nX1:Number, __nY1:Number, __nX2:Number, __nY2:Number) : Number
      {
         return Math.pow(__nX2 - __nX1,2) + Math.pow(__nY2 - __nY1,2);
      }
      
      public static function getDistance(__nX1:Number, __nY1:Number, __nX2:Number, __nY2:Number) : Number
      {
         return Math.sqrt(Math.pow(__nX2 - __nX1,2) + Math.pow(__nY2 - __nY1,2));
      }
      
      public static function getRandomRange(__nMin:int, __nMax:int) : int
      {
         return Math.floor(Math.random() * (__nMax + 1 - __nMin)) + __nMin;
      }
      
      public static function getRadianFromDegree(__nDegree:Number) : Number
      {
         return Number(__nDegree * (Math.PI / 180));
      }
      
      public static function getAngle(_oPoint1:Point, _oPoint2:Point) : Number
      {
         var _nXdiff:Number = NaN;
         var _nYdiff:Number = NaN;
         var _nRadius:Number = NaN;
         var _nAngle:Number = NaN;
         _nXdiff = _oPoint2.x - _oPoint1.x;
         _nYdiff = _oPoint2.y - _oPoint1.y;
         _nRadius = Math.atan2(_nYdiff,_nXdiff);
         return Number(getDegreeFromRadius(_nRadius));
      }
      
      public static function getDegreeFromRadius(__nRadius:Number) : Number
      {
         return Number(__nRadius / Math.PI * 180);
      }
   }
}
