package gameplay.projectiles
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import gameplay.GameDispatcher;
   import gameplay.ItemID;
   import gameplay.Projectile;
   import gameplay.events.MovingBodyEvent;
   
   public class Boomerang extends Projectile
   {
      
      public static var Instance:Boomerang = null;
       
      
      private var nAngle:Number;
      
      private var mcReference:MovieClip;
      
      private var ptOrigine:Point;
      
      private var nCounterMiddle:Number;
      
      private var ptDestination:Point;
      
      private var nCounterLimit:Number;
      
      private var nCounter:Number;
      
      private var nAngleStep:Number;
      
      private var ptCenter:Point;
      
      private var nRayon:Number;
      
      public function Boomerang(_mcRef:MovieClip, _nStartingOrientation:Number, _aEnemies:Array, _aItems:Array)
      {
         super(_mcRef,false,Data.nDAMAGE_BOOMERANG,0,Data.nBOOMERANG_BODY_WIDTH,Data.nBOOMERANG_BODY_HEIGHT,ItemID.uBOOMERANG,99999,false);
         trace("CREATE BOOMERANG");
         trace("_mcRef = " + _mcRef);
         trace("_nStartingOrientation = " + _nStartingOrientation);
         trace("_aEnemies = " + _aEnemies);
         trace("_aItems = " + _aItems);
         disableAutoFacing();
         mcReference = _mcRef;
         computeTarget(_nStartingOrientation,_aEnemies,_aItems);
         initvars();
         addListener();
         Instance = this;
      }
      
      override public function move() : void
      {
         var _ptSurCourbe:Point = null;
         var _nFactor:Number = NaN;
         if(nCounter <= 1)
         {
            die();
         }
         else
         {
            nAngle -= nAngleStep;
            --nCounter;
            _ptSurCourbe = new Point(ptCenter.x + nRayon * Math.cos(nAngle),ptCenter.y - nRayon * Math.sin(nAngle));
            if(nCounter > nCounterMiddle)
            {
               _nFactor = (nCounter - nCounterMiddle) / nCounterMiddle;
            }
            else
            {
               _nFactor = (nCounterMiddle - nCounter) / nCounterMiddle;
            }
            _ptSurCourbe = Point.interpolate(ptOrigine,_ptSurCourbe,_nFactor);
            mcReference.x = _ptSurCourbe.x;
            mcReference.y = _ptSurCourbe.y;
         }
      }
      
      private function onPlayerMove(_e:MovingBodyEvent) : void
      {
         var ptDelta:Point = new Point(_e.newWorldPosition.x,_e.newWorldPosition.y);
         ptDelta = ptDelta.subtract(_e.lastWorldPosition);
         ptOrigine = ptOrigine.add(ptDelta);
      }
      
      private function getAngle(_ptSource:Point, _ptVers:Point) : Number
      {
         var _nAngle:Number = NaN;
         if(_ptSource.x == _ptVers.x)
         {
            if(_ptVers.y < _ptSource.y)
            {
               return -Math.PI / 2;
            }
            return Math.PI / 2;
         }
         _nAngle = Math.atan((_ptSource.y - _ptVers.y) / (_ptVers.x - _ptSource.x));
         if(_ptSource.x < _ptVers.x)
         {
            _nAngle += Math.PI;
         }
         return _nAngle;
      }
      
      private function removeListener() : void
      {
         GameDispatcher.Instance.removeEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
      }
      
      private function computeTarget(_nStartingOrientation:Number, _aEnemies:Array, _aItems:Array) : void
      {
         var _uXIndex:uint = 0;
         var _uYIndex:uint = 0;
         var _nAngle:Number = NaN;
         var _nAngleDelta:Number = NaN;
         var _nDistance:Number = NaN;
         var _ptDistance:Point = null;
         var _nDistanceNew:Number = NaN;
         var _pTarget:Point = null;
         ptOrigine = new Point(mcReference.x,mcReference.y);
         ptDestination = null;
         _uXIndex = 0;
         _uYIndex = 1;
         while(_aEnemies.length > _uYIndex)
         {
            _pTarget = new Point(_aEnemies[_uXIndex],_aEnemies[_uYIndex]);
            _nAngle = getAngle(_pTarget,ptOrigine);
            _nAngleDelta = Math.abs(_nStartingOrientation - _nAngle);
            if(_nAngleDelta > Math.PI)
            {
               _nAngleDelta = 2 * Math.PI - _nAngleDelta;
            }
            if(_nAngleDelta <= Data.nBOOMERANG_ANGLE)
            {
               _ptDistance = _pTarget.subtract(ptOrigine);
               _nDistanceNew = _ptDistance.length;
               if(_nDistanceNew <= Data.nBOOMERANG_MAX_DISTANCE)
               {
                  if(ptDestination == null)
                  {
                     ptDestination = _pTarget;
                     _nDistance = _nDistanceNew;
                  }
                  else if(_nDistanceNew < _nDistance)
                  {
                     ptDestination = _pTarget;
                     _nDistance = _nDistanceNew;
                  }
               }
            }
            _uXIndex += 2;
            _uYIndex += 2;
         }
         if(ptDestination == null)
         {
            _uXIndex = 0;
            _uYIndex = 1;
            while(_aItems.length > _uYIndex)
            {
               _pTarget = new Point(_aItems[_uXIndex],_aItems[_uYIndex]);
               _nAngle = getAngle(_pTarget,ptOrigine);
               _nAngleDelta = Math.abs(_nStartingOrientation - _nAngle);
               if(_nAngleDelta > Math.PI)
               {
                  _nAngleDelta = 2 * Math.PI - _nAngleDelta;
               }
               if(_nAngleDelta <= Data.nBOOMERANG_ANGLE)
               {
                  _ptDistance = _pTarget.subtract(ptOrigine);
                  _nDistanceNew = _ptDistance.length;
                  if(_nDistanceNew <= Data.nBOOMERANG_MAX_DISTANCE)
                  {
                     if(ptDestination == null)
                     {
                        ptDestination = _pTarget;
                        _nDistance = _nDistanceNew;
                     }
                     else if(_nDistanceNew < _nDistance)
                     {
                        ptDestination = _pTarget;
                        _nDistance = _nDistanceNew;
                     }
                  }
               }
               _uXIndex += 2;
               _uYIndex += 2;
            }
         }
         if(ptDestination == null)
         {
            ptDestination = new Point(mcReference.x + Data.nBOOMERANG_MAX_DISTANCE * Math.cos(_nStartingOrientation),mcRef.y - Data.nBOOMERANG_MAX_DISTANCE * Math.sin(_nStartingOrientation));
         }
      }
      
      private function addListener() : void
      {
         GameDispatcher.Instance.addEventListener(MovingBodyEvent.EVENT_PLAYER_MOVE,onPlayerMove);
      }
      
      override public function destroy(_e:Event = null) : void
      {
         Instance = null;
         super.destroy(_e);
         removeListener();
         mcReference = null;
         ptOrigine = null;
         ptDestination = null;
         ptCenter = null;
      }
      
      private function initvars() : void
      {
         ptOrigine = new Point(mcReference.x,mcReference.y);
         ptCenter = Point.interpolate(ptOrigine,ptDestination,0.5);
         nAngle = getAngle(ptOrigine,ptDestination);
         nRayon = Math.sqrt(Math.pow(ptDestination.x - ptOrigine.x,2) + Math.pow(ptDestination.y - ptOrigine.y,2)) / 2;
         nAngleStep = Math.asin(Data.nBOOMERANG_SPEED / nRayon);
         nCounter = 2 * Math.PI / nAngleStep;
         nCounterMiddle = Math.PI / nAngleStep;
         nCounterLimit = 0.5 * Math.PI / nAngleStep;
      }
   }
}
