package
{
	import utils.Coordinates;


	public class Plane
	{
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _doubleSided:Boolean;
		
	
	
	
		
		private var _vertexData:Vector.<Number>
		private var _indices:Vector.<uint>
	
		private var _numVertices:uint;
		private var _numIndices:uint;
		
		
		public function Plane(width:Number = 100, height:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, yUp:Boolean = false, doubleSided:Boolean = false)
		{
			
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
			_width = width;
			_height = height;
			_doubleSided = doubleSided;
			
			 
		}
		
		public function get numIndices():uint
		{
			return _numIndices;
		}

		public function get numVertices():uint
		{
			return _numVertices;
		}

		public function get indices():Vector.<uint>
		{
			return _indices;
		}

		public function get vertexData():Vector.<Number>
		{
			return _vertexData;
		}

		public function buildGeometry():void
		{
			
		
			var x:Number, y:Number;
			
			var base:uint;
			var tw:uint = _segmentsW + 1;
			_numVertices = (_segmentsH + 1)*tw;
			var stride:uint =6; //target.vertexStride;
			var skip:uint =4;//stride-// stride - 9;
			if (_doubleSided)
				_numIndices *= 2;
			
			_numIndices = _segmentsH*_segmentsW*6;
			if (_doubleSided)
				_numIndices <<= 1;
			
			//if (_numIndices == target._numIndices) {
				//data = target.vertexData;
				//indices = target.indexData || new Vector.<uint>(_numIndices, true);
			//} else {
			
			var InfoNUM:uint=9;//information about vertex 1-x 2-y 3-z 4-normal etc
			_vertexData = new Vector.<Number>(_numVertices*InfoNUM, true);
			_indices = new Vector.<uint>(_numIndices, true);
				//invalidateUVs();
			//}
			
			_numIndices = 0;
			var index:uint = 0;//target.vertexOffset;
			for (var yi:uint = 0; yi <= _segmentsH; ++yi) {
				for (var xi:uint = 0; xi <= _segmentsW; ++xi) {
					
					
					x =   (xi/_segmentsW - .5)*_width;
					y = (yi/_segmentsH - .5)*_height;
					
				
					// vertex X
					_vertexData[index++] = x;
					// vertex Y
					if (_yUp) {
						_vertexData[index++] = 0;
						_vertexData[index++] = y;
					} else {
						_vertexData[index++] = y;
						_vertexData[index++] = 0;
					}
					
		////////////////////Color
					//vertex Color red
					_vertexData[index++] = Math.random();
					//vertex Color green
					_vertexData[index++] = Math.random();
					//vertex Color blue
					_vertexData[index++] = Math.random();
					
					// vertex Z
					_vertexData[index++] = 0;
					
					//vertex Direction
					if (_yUp) {
						_vertexData[index++] = 1;
						_vertexData[index++] = 0;
					} else {
						_vertexData[index++] = 0;
						_vertexData[index++] = -1;
					}
					
				
					
					//index += skip;
					
					// add vertex with same position, but with inverted normal & tangent
					if (_doubleSided) {
						for (var i:int = 0; i < 3; ++i) {
							_vertexData[index] = _vertexData[index - stride];
							++index;
						}
						for (i = 0; i < 3; ++i) {
							_vertexData[index] = -_vertexData[index - stride];
							++index;
						}
						for (i = 0; i < 3; ++i) {
							_vertexData[index] = -_vertexData[index - stride];
							++index;
						}
						index += skip;
					}
					
					
					
					
					
					if (xi != _segmentsW && yi != _segmentsH) {
						base = xi + yi*tw;
						var mult:int = _doubleSided? 2 : 1;
						
						_indices[_numIndices++] = base*mult;
						_indices[_numIndices++] = (base + tw)*mult;
						_indices[_numIndices++] = (base + tw + 1)*mult;
						_indices[_numIndices++] = base*mult;
						_indices[_numIndices++] = (base + tw + 1)*mult;
						_indices[_numIndices++] = (base + 1)*mult;
						
						if (_doubleSided) {
							_indices[_numIndices++] = (base + tw + 1)*mult + 1;
							_indices[_numIndices++] = (base + tw)*mult + 1;
							_indices[_numIndices++] = base*mult + 1;
							_indices[_numIndices++] = (base + 1)*mult + 1;
							_indices[_numIndices++] = (base + tw + 1)*mult + 1;
							_indices[_numIndices++] = base*mult + 1;
						}
					}
				}
			}
			
			
		}
		
		
		
		private function updateIndexData(indices:Vector.<uint>):void
		{
			_indices = indices;
			_numIndices = indices.length;
			
			var numTriangles:int = _numIndices/3;
		//	if (_numTriangles != numTriangles)
			//	disposeIndexBuffers(_indexBuffer);
			//_numTriangles = numTriangles;
			//invalidateBuffers(_indicesInvalid);
			//_faceNormalsDirty = true;
			
			//if (_autoDeriveVertexNormals)
				//_vertexNormalsDirty = true;
			//if (_autoDeriveVertexTangents)
				//_vertexTangentsDirty = true;
		}
		
		/*protected function disposeIndexBuffers(buffers:Vector.<IndexBuffer3D>):void
		{
		for (var i:int = 0; i < 8; ++i) {
		if (buffers[i]) {
		buffers[i].dispose();
		buffers[i] = null;
		}
		}
		}*/
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
}