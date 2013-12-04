package water.testrock
{
	public class RockController
	{
		private var _model:RockModel;
		private var _view:RockView;
		
		public function RockController(view:RockView)
		{
			
		}
		
		private  function update():void
		{
		  _model.update();
		  
		
		} 
	}
}