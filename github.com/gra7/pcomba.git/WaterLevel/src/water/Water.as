package water
{
	
	
	public class Water
	{
		//model springs
		private var _springs:Vector.<Spring>
		private var _spread:Number;
		private var _tension:Number;
		private var _dampening:Number;
		
		//view vertex shader
		
		
		
		public function Water(spread:Number=0.25,
							  tension:Number=0.025,
							  dampening:Number=0.025,
							  deltaX:Number=0.05)
		{
			
			_spread=spread;
			_tension=tension;
			_dampening=dampening;
			_springs=new Vector.<Spring>(Math.round(1/deltaX));	
			var n:int=_springs.length;
			for(var i:int=0;i<n;i++){
				
				_springs[i]=new Spring();
			}		
		}
		
		
		
		
		
		
		public function splash(index:int, speed:Number):void
		{
			var n:int=_springs.length;
			var i:int
			if (index >= 0 && index <i ){
				_springs[i].speed = speed;
			}
		}
		
		
		
		public function update():void{
			var n:int=_springs.length;
			for (var i:int = 0; i < n; i++){
				_springs[i].update();
			}
			
			//	float[] leftDeltas = new float[springs.Length];
			//float[] rightDeltas = new float[springs.Length];
			var leftDeltas:Vector.<Number>=new Vector.<Number>(n);
			var rightDeltas:Vector.<Number>=new Vector.<Number>(n);
			
			var wave:String=""
			// do some passes where springs pull on their neighbours
			for (var j:int = 0; j < 8; j++)
			{
				for (var j2:int = 0; j2 < n; j2++)
				{
					if (j2 > 0)
					{
						leftDeltas[j2] =_spread * (_springs[j2].height - _springs [j2 - 1].height);
						_springs[j2 - 1].speed += leftDeltas[j2];
						trace(leftDeltas[j2])
						wave+=_springs[j2 - 1].speed+","
						
					}
					if (j2 < n - 1)
					{
						rightDeltas[j2] = _spread * (_springs[j2].height - _springs [j2 + 1].height);
						_springs[j2 + 1].speed += rightDeltas[j2];
						wave+=_springs[j2 + 1].speed+"|"+rightDeltas[j2]+",";
					}
				}
				
				for (var j3:int = 0; j3 < n; j3++)
				{
					if (j3 > 0){
						
						_springs[j3 - 1].height += leftDeltas[j3];
						wave+=_springs[j3 - 1].speed+","
					}
					if (j3 < n - 1){
						_springs[j3 + 1].height += rightDeltas[j3];
						wave+=_springs[j3 + 1].speed+","
					}
				}
				
				
				
			}
			trace(wave)
		}
		
		
		
	}
}