package utils
{
	public class Color
	{
		public static const RGB:uint=0;
		public static const RGBA:uint=1;
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var a:Number;
		
		public function Color(r:Number=.0,g:Number=.0,b:Number=.0,a:Number=.0):void
		{
			this.r=r;
			this.g=g;
			this.b=b;
			this.a=a;
		}
		
		
		
		
	}
}