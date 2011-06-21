package br.poli.computacaonatural.model3d {
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cylinder;
	import away3d.primitives.Sphere;
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class ArmModel extends ObjectContainer3D {
		
		private var base:Cylinder;
		private var arm:Arm;
		
		public function ArmModel() {
			this.arm = new Arm ();
			
			this.base = new Cylinder ();
			this.base.material =  new WireColorMaterial (0x3D3D3D);
			this.base.radius = 70;
			this.base.height = 200;
			this.base.y = this.base.height/2;
			
			this.arm.y = this.base.height;
			
			this.addChild (this.base);
			this.addChild (this.arm);
		}
		
		public function get reference ():Sphere {
			return this.arm.reference;
		}
		
		public function get primAxis ():ObjectContainer3D {
			return this.arm.primAxis;
		}
		
		public function get interAxis ():ObjectContainer3D {
			return this.arm.interAxis;
		}
		
		public function get subArmRotation ():Number {
			return this.arm.subArmRotation;
		}
		public function set subArmRotation (degree:Number):void {
			this.arm.subArmRotation += degree;
		}
		
		public function get armRotation ():Number {
			return this.arm.armRotation;
		}
		public function set armRotation (degree:Number):void {
			this.arm.armRotation += degree;
		}
		
		public function get baseRotation ():Number {
			return this.arm.baseRotation;
		}
		public function set baseRotation (degree:Number):void {
			this.arm.baseRotation += degree;
		}
		
		public function rotateSubArm (degree:Number):void {
			this.arm.rotateSubArm (degree);
		}
		
		public function rotateArm (degree:Number):void {
			this.arm.rotateArm (degree);
		}
		
		public function rotateBase (degree:Number):void {
			this.arm.rotateBase (degree);
		}
		
	}

}