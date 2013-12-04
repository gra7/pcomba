package water.testrock
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	
	import utils.Coordinates;


	public class RockView extends Plane
	{
		[Embed (source = "/assets/pubdlcnt.php.png")] 
		private var myTextureBitmap:Class;
		
		private var myTextureData:Bitmap;
		private var _context:Context3D;
		private var _program:Program3D;
		
		
		public function RockView(context:Context3D)
		{
			//new RockController(this);			
			myTextureData = new myTextureBitmap();	
			super(myTextureData.width/Coordinates.halfWidth,myTextureData.height/Coordinates.halfHeight);
			_context=context;
			
		}
		
		override public function buildGeometry():void{
		super.buildGeometry();
		var myTexture:Texture = _context.createTexture(myTextureData.width, myTextureData.height, Context3DTextureFormat.BGRA, false);
		
		
		}
		
		private function initRockShader():void{
		
			
			
		var fragmentShaderAssembler1:AGALMiniAssembler  = new AGALMiniAssembler();
		fragmentShaderAssembler1.assemble (Context3DProgramType.FRAGMENT,  
			//делаем выборку цвета текстуры из текстуры fs0
			// используя UV-координаты, хранящиеся в v1
			//и полученный результат записываем в ft0
			"tex ft0, v1, fs0 <2d,repeat,miplinear>\n" +  
			// отправляем это значение цвета на вывод
			"mov oc, ft0\n"
		);
		
		var _program:Program3D = _context.createProgram();
		program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler1.agalcode);
		
		}
		
		
	}
}