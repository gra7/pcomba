package utils
{
	public class SimplePoint
	{
		public var x:Number;
		public var y:Number;
		public function SimplePoint(x:Number,y:Number)
		{
			this.x=x;
			this.y=y;
		}
		
		
		public function toString():String{
			return "x:"+x+"; y:"+y;
		}
	}
}