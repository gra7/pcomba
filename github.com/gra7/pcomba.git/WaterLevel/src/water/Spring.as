package water
{
	public class Spring
	{
		private var _position:Number=0;
		private var _velocity:Number=0;
		public const k:Number=0.025;
		// public var x:Number=0;
		public var height:Number=20; 
		public var targetHeight:Number=0;
		public var speed:Number=0.6;
		
		
		public function Spring(position:Number=10,velocity:Number=1):void
		{
			_position=position;
			_velocity=velocity;
			
			
		}
		
		public function get velocity():Number
		{
			return _velocity;
		}

		public function get position():Number
		{
			return _position;
		}

		public function update():void
		{
			//const float k = 0.025f; // adjust this value to your liking
			var x:Number = height-targetHeight;//Height - TargetHeight;
			var acceleration:Number = -k * x;			
			_position += velocity;
			_velocity += acceleration;
		}
	}
}