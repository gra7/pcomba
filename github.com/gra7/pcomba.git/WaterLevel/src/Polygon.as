package
{
	
	
	import flash.geom.Rectangle;
	
	import utils.Color;
	import utils.Coordinates;
	import utils.SimplePoint;
	
	public class Polygon
	{  
		public static const VERTEX_COLOR:Vector.<Number>=Vector.<Number>([.0, .0, .0,
		                                                                 .0, .0, .0,
		                                                                 .0, .0, .0,
																		 .0, .0, .0]  );
		
		public var v0:SimplePoint;
		public var v1:SimplePoint;
		public var v2:SimplePoint;
		public var v3:SimplePoint;
	  
		
		
		
		public function Polygon():void
		{
					
			
		
					
		
			
		}
		
	public function	fromRectangle(rect:Rectangle, 
								  vertexColor:Vector.<Number>=null,
								  colorType:uint=Color.RGB):Vector.<Number>
	{
		v0=Coordinates.getCoordinateBy2D(rect.left,rect.top);	
		v1=Coordinates.getCoordinateBy2D(rect.right,rect.top);		
		v2=Coordinates.getCoordinateBy2D(rect.right,rect.bottom);		
		v3=Coordinates.getCoordinateBy2D(rect.left,rect.bottom);
		
		
		
		vertexColor=vertexColor?vertexColor:Polygon.VERTEX_COLOR;
		
	
			
	
		return Vector.<Number>([
			v0.x ,v0.y, 0, vertexColor[0], vertexColor[1], vertexColor[2], 	
			v1.x ,v1.y, 0, vertexColor[3], vertexColor[4], vertexColor[5], 		 
			v2.x ,v2.y, 0, vertexColor[6], vertexColor[7], vertexColor[8],			
			v3.x ,v3.y, 0, vertexColor[9], vertexColor[10], vertexColor[11]		
		])
	
			
	
	
	
	}
	
	
	
		
		
		
	}
}