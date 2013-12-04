package water.testrock
{
	import math.Vec2;
	
	import water.WaterConstants;
	
	public class RockModel
	{
		private var _position:Vec2;
		public var _velocity:Vec2;
		public static const GRAVITY:Vec2 = new Vec2(0, 0.3);
		
	

		
		public function RockModel(position:Vec2,velocity:Vec2):void
		{
			
			_position=position;
			_velocity=velocity;
			
		}
		
		
		public function get position():Vec2
		{
			return _position;
		}

		public function update():void{
			if (_position.y > water.GetHeight(_position.x))
			{
				_velocity.mulSelf(new Vec2(0,WaterConstants.ROCK_VELOCITY));
				
			}
			
			_position.addSelf(_velocity);
			_velocity.addSelf(GRAVITY);
		}
		
	}
}