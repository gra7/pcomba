package water.testrock
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import math.Vec2;
	
	import utils.Coordinates;
	
	
	public class RockView extends Plane
	{
		[Embed (source = "/assets/pubdlcnt.php.png")] 
		private var myTextureBitmap:Class;
		
		private var _myTextureData:Bitmap;
		private var _myTexture:Texture;
		private var _context:Context3D;
		private var _program:Program3D;
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D
		private var _t:Number=0;
		private var _modelMatrix:Matrix3D=new Matrix3D();
		private var _modelViewProjection:Matrix3D=new Matrix3D()
		private var _projectionMatrix:PerspectiveMatrix3D;
		private var _viewMatrix:Matrix3D;
		
		
		private var _isAlive:Boolean=false;		
		private var _position:Vec2;
		private var _velocity:Vec2;
		private var _gravity:Vec2 ;
		
		
		
		
		
		
		
		public function RockView(position:Vec2,
								 mass:Number,
								 context:Context3D,
								 projectionMatrix:PerspectiveMatrix3D,
								 viewMatrix:Matrix3D)
		{
			_position=position;
			_velocity=new Vec2(0,0);			
			_gravity=new Vec2(0,-(9.8*mass*Coordinates.miterInPixel)/Coordinates.height);
			_projectionMatrix=projectionMatrix;
			_viewMatrix=viewMatrix;
			_myTextureData = new myTextureBitmap();	
			 super(0.1*(_myTextureData.width/Coordinates.halfWidth),0.1*(_myTextureData.height/Coordinates.halfHeight),200,1);		
			_context=context;
			
		}
		
		public function get isAlive():Boolean
		{
			return _isAlive;
		}
		
		public function set position(value:Vec2):void
		{
			//if(!_isAlive){
				_position = value;
				_isAlive=true;
				_velocity=new Vec2(0,0)
			//}
		}
		
		
		
		
		override public function buildGeometry():void{
			super.buildGeometry();	
			_myTexture = _context.createTexture(128, 128, Context3DTextureFormat.BGRA, false);
			
			// var ws:int = _myTextureData.bitmapData.width;
			//var hs:int = _myTextureData.bitmapData.height;
			//var level:int = 0; var tmp:BitmapData;
			//var transform:Matrix = new Matrix();
			_myTexture.uploadFromBitmapData(_myTextureData.bitmapData);
			
			/* var tmp:BitmapData = new BitmapData(ws, hs, true, 0x00000000);
			
			while ( ws >= 1 && hs >= 1 ) { 
			tmp.draw(_myTextureData.bitmapData, transform, null, null, null, true); 
			_myTexture.uploadFromBitmapData(tmp, level);
			transform.scale(0.5, 0.5); 
			level++; 
			ws >>= 1; 
			hs >>= 1;
			if (hs && ws) {
			tmp.dispose();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			}
			}
			tmp.dispose();
			
			// _myTextureData.bitmapData.dispose();*/
			
			
			
			_vertexBuffer=_context.createVertexBuffer(numVertices,9);
			_vertexBuffer.uploadFromVector(vertexData,0,numVertices);
			_indexBuffer=_context.createIndexBuffer(numIndices);
			_indexBuffer.uploadFromVector(indices,0,numIndices);		
			_modelMatrix=new Matrix3D();		
			initShader();
			
		}
		
		private function initShader():void{
			
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble (Context3DProgramType.VERTEX,
				// умножаем 4x4 матрицу трансформации на полученный ракурс камеры  
				"m44 op, va0, vc0\n" +
				// рассказываем фрагментному шейдеру о XYZ
				"mov v0, va0\n" +
				// рассказываем фрагментному шейдеру о UV
				"mov v1, va1\n" +
				// рассказываем фрагментному шейдеру о RGBA
				"mov v2, va2\n"
			);
			
			
			
			
			var fragmentShaderAssembler1:AGALMiniAssembler  = new AGALMiniAssembler();
			fragmentShaderAssembler1.assemble (Context3DProgramType.FRAGMENT,  
				//делаем выборку цвета текстуры из текстуры fs0
				// используя UV-координаты, хранящиеся в v1
				//и полученный результат записываем в ft0
				"tex ft0, v1, fs0 <2d,linear>\n" +  
				// отправляем это значение цвета на вывод
				"mov oc, ft0\n"
			);
			
			
			//без текстуры, RGBA цвет получаем из вершинного буфера
			var fragmentShaderAssembler2:AGALMiniAssembler  = new AGALMiniAssembler();
			fragmentShaderAssembler2.assemble (Context3DProgramType.FRAGMENT,  
				// берем цвет из регистра v2 
				// переданного из вершинной программы, и отправляем это значение цвета на вывод
				"mov oc, v2\n"
			);
			
			_program = _context.createProgram();
			_program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler1.agalcode);
			
			
			
		}
		
		
		public function update():void
		{
			
			
			_position.addSelf(_velocity);
			trace(_position)
			_velocity.addSelf(_gravity);			//trace(_position.x)
			//trace(_position);
			
			
			_modelMatrix.identity();
			_context.setTextureAt(0,_myTexture);
			
			
			//_context.setTextureAt(0,_myTexture);
			_context.setProgram ( _program);
			////_modelMatrix.appendRotation(_t*-0.2, Vector3D.Y_AXIS);
			//_modelMatrix.appendRotation(_t*0.4, Vector3D.X_AXIS);
			//_modelMatrix.appendRotation(_t*0.7, Vector3D.Y_AXIS);
			_modelMatrix.appendTranslation(_position.x, _position.y, 0);	
			
			if(_position.y<-1){
				trace('die')
				_isAlive=false;
				_velocity=new Vec2(0,0);
				_position=new Vec2(0,0);
			}
			_modelViewProjection.identity();
			_modelViewProjection.append(_modelMatrix);
			_modelViewProjection.append(_viewMatrix);
			_modelViewProjection.append(_projectionMatrix)
			
		
			
			// отправляем данные матрицы в шейдерную программу
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _modelViewProjection, true );
			
			//Выше, мы записываем в регистр vc0 AGAL нашу матрицу modelViewProjection:
			
			// связываем данные вершин с текущей шейдерной программой
			// позиция
			
			_context.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			// текстурные координаты
			_context.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			
			// цвет вершин rgba
			_context.setVertexBufferAt(2, _vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4);
			
			// наконец отрисовываем треугольники
			
			_context.drawTriangles(_indexBuffer, 0, indices.length/3);			
			
			
			
			
			
			
			
			
		}
		
	}
}