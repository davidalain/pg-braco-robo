package teoria {
	import away3d.core.*;
	import away3d.core.mesh.*;
	import away3d.core.material.*;
	import away3d.core.utils.*;

	public class Cube extends Mesh {
		private var ve:Array;
		private var fa:Array;

		public function Cube(init:Object = null) {
			super( init );
			init = Init.parse(init);
			ve = [];
			
			v(1.000,1.000,-1.000);
			v(1.000,-1.000,-1.000);
			v(-1.000,-1.000,-1.000);
			v(-1.000,1.000,-1.000);
			v(1.000,1.000,1.000);
			v(1.000,-1.000,1.000);
			v(-1.000,-1.000,1.000);
			v(-1.000,1.000,1.000);

			f2(0,1,2);
			f2(4,7,6);
			f2(0,4,5);
			f2(1,5,6);
			f2(2,6,7);
			f2(4,0,3);


			x = 0.000; y = 0.000; z = 0.000;

			rotationX = 0.000; rotationY = -0.000; rotationZ = 0.000;

			this.scaleXYZ(1.000, 1.000, 1.000);

		}
		public function v(x:Number, y:Number, z:Number):void {
			ve.push(new Vertex(x, y, z));
		}

		public function f(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {
			var face:Face = new Face( ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3], null, new UV(uv00, uv01), new UV(uv10, uv11), new UV(uv20, uv21) );
			addFace(face);
		}

		public function f2(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int):void {
			addFace( new Face(ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]) );
		}
	}
}