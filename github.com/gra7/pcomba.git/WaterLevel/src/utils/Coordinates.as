package utils
{
	public class Coordinates
	{
		private static var _width:int;
		private static var _height:int
		
		private static var _halfWidth:int;
		private static var _halfHeight:int;
		
		
		private static var _miterInPixel:Number;
		
		
		private static var _sceneHeight:Number
		
		public static function get miterInPixel():Number
		{
			return _miterInPixel;
		}
		
		public static function set sceneHeight(value:Number):void
		{
			_sceneHeight = value;
			_miterInPixel=value/_height;
		}
		
		public static function get sceneHeight():Number
		{
			return _sceneHeight;
		}
		
		public static function get halfHeight():int
		{
			return _halfHeight;
		}
		
		public static function get halfWidth():int
		{
			return _halfWidth;
		}
		
		public static function get height():int
		{
			return _height;
		}
		
		public static function set height(value:int):void
		{
			
			_height = value;
			_halfHeight=_height*0.5
		}
		
		public static function get width():int
		{
			
			return _width;
			
		}
		
		public static function set width(value:int):void
		{
			_width = value;
			_halfWidth=_width*0.5;
		}
		
		public static function	getCoordinateBy3DCoordinate(x:Number,y:Number):SimplePoint
		{
			return new SimplePoint(width*x,height*y);
		}
		
		public static function	getCoordinateBy2D(x:Number,y:Number):SimplePoint
		{
			
			if(x<_halfWidth){
				x=-(_halfWidth-x)/_halfWidth;
			}else if(x>_halfWidth){
				x=(x-_halfWidth)/_halfWidth;
			}else{
				x=0
			}
			
			if(y<_halfHeight){
				y=(_halfHeight-y)/_halfHeight;
			}else if(y>_halfHeight){
				y=-(y-_halfHeight)/_halfHeight;			
			}else{
				y=0;
			}
			
			return new SimplePoint(x,y);
		}
	}
}