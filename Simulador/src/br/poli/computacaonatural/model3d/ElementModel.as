package br.poli.computacaonatural.model3d {
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.Sphere;
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class ElementModel extends ObjectContainer3D {
		
		private var _elementID:Number = -1;
		
		public function ElementModel() {
			var sphere:Sphere = new Sphere();
			sphere.radius = 50;
			sphere.segmentsW = 12;
			sphere.segmentsH = 10;		
			
			this.addChild (sphere);
		}
		
		public function get elementID():Number {
			return _elementID;
		}
		
		public function set elementID(value:Number):void {
			_elementID = value;
		}
		
	}

}