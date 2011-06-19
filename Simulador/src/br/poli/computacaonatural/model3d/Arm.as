package br.poli.computacaonatural.model3d {
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Sphere;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class Arm extends ObjectContainer3D {
		
		private var ref:Sphere;
		private var subArm1:SubArm;
		private var subArm2:SubArm;
				
		public function Arm() {			
			this.ref = new Sphere ();
			this.ref.material =  new WireColorMaterial (0x3D3D3D);
			this.ref.radius = 25;
			
			this.subArm1 = new SubArm ();
			this.subArm2 = new SubArm ();
			
			//this.subArm1.y = this.base.height;
			this.subArm2.y = this.subArm1.y + this.subArm1.objectHeight - this.subArm1.axisRadius / 2;
			this.ref.y = this.subArm2.objectHeight - this.subArm2.axisRadius;
			
			this.addChild (this.subArm1);
			this.addChild (this.subArm2);
			this.subArm2.addChild (this.ref);
		}
		
		public function get reference ():Sphere {
			return this.ref;
		}
		
		public function get primAxis ():ObjectContainer3D {
			return this;
		}
		
		public function get interAxis ():ObjectContainer3D {
			return this.subArm2;
		}
		
		public function get subArmRotation ():Number {
			return this.subArm2.rotationX;
		}		
		public function set subArmRotation (degree:Number):void {
			this.subArm2.rotationX = degree;
		}
		
		public function get armRotation ():Number {
			return this.subArm1.rotationX;
		}	
		public function set armRotation (degree:Number):void {
			this.rotationX = degree;
		}
		
		public function get baseRotation ():Number {
			return this.rotationY;
		}
		public function set baseRotation (degree:Number):void {
			this.rotationY = degree;
		}
		
		public function rotateSubArm (degree:Number):void {
			this.subArm2.rotationX += degree;
		}
		
		public function rotateArm (degree:Number):void {
			this.rotationX += degree;
		}
		
		public function rotateBase (degree:Number):void {
			this.rotationY += degree;
		}
		
	}

}