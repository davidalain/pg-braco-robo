package br.poli.computacaonatural.model3d {
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cylinder;
	import away3d.primitives.Sphere;
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class SubArm extends ObjectContainer3D {
		
		private var sphere:Sphere;
		private var cylinder:Cylinder
		
		public function SubArm() {
			var cylMaterial:WireColorMaterial = new WireColorMaterial (0x0000CC);
			cylMaterial.wireColor = 0x000000;
			var sphereMaterial:WireColorMaterial = new WireColorMaterial (0xFFFFFF);
			sphereMaterial.wireColor = 0x000000;
		
			this.sphere = new Sphere ();
			this.sphere.material = sphereMaterial;
			this.sphere.radius = 35;
			
			this.cylinder = new Cylinder ();
			this.cylinder.material = cylMaterial;
			this.cylinder.radius = 20;
			this.cylinder.height = 200;
			this.cylinder.segmentsW = 10;
			this.cylinder.segmentsH = 3;
			this.cylinder.y = this.cylinder.height / 2;
			
			this.addChild (this.sphere);
			this.addChild (this.cylinder);
		}
		
		public function get axisRadius ():Number {
			return this.sphere.radius;
		}
		
		public function get armRadius ():Number {
			return this.cylinder.radius;
		}
		
	}

}