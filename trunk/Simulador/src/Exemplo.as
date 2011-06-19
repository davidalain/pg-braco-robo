package  {
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Element;
	import away3d.core.base.Mesh;
	import away3d.core.base.Object3D;
	import away3d.core.filter.FogFilter;
	import away3d.core.filter.ZDepthFilter;
	import away3d.core.render.BasicRenderer;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.events.MouseEvent3D;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	import away3d.primitives.Torus;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class Exemplo extends Sprite {
		
		private var scene:Scene3D;
		private var camera:HoverCamera3D;
		private var fogfilter:FogFilter;
		private var renderer:BasicRenderer;
		private var view:View3D;
		private var plane:Plane;
		private var cube:Cube;
		private var sphere:Sphere;
		private var torus:Torus;
		
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var braco:Loader3D;
		
		private var pGeral:Mesh;
		private var pJuncao1:Mesh;
		private var pJuncao2:Mesh;
		
		public function Exemplo () {
			this.addEventListener (Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			this.initEngine();
			this.initObjects();
			this.initListeners ();
		}
		
		public function initEngine():void {
			this.scene = new Scene3D();
			
			//camera = new HoverCamera3D({focus:50, distance:1000, mintiltangle:0, maxtiltangle:90});
			this.camera = new HoverCamera3D();
			this.camera.focus = 50;
			this.camera.distance = 1000;
			this.camera.minTiltAngle = 0;
			this.camera.maxTiltAngle = 90;
			
			this.camera.panAngle = 45;
			this.camera.tiltAngle = 20;
			this.camera.hover(true);
			
			//fogfilter = new FogFilter({material:new ColorMaterial(0x000000), minZ:500, maxZ:2000});
			this.fogfilter = new FogFilter();
			this.fogfilter.material = new ColorMaterial(0x000000);
			this.fogfilter.minZ = 500;
			this.fogfilter.maxZ = 2000;
			//fogfilter
			this.renderer = new BasicRenderer ();
			
			//view = new View3D({scene:scene, camera:camera, renderer:renderer});
			this.view = new View3D();
			this.view.scene = scene;
			this.view.camera = camera;
			this.view.renderer = renderer;
			
			//this.view.addSourceURL("srcview/index.html");
			this.addChild(view);
		
		}
		
		private function initObjects():void {
			var initObject:Object = {
				scaling: 5,
				shading: false,
				centerMeshes: false
			};
		
			var collada:Collada = new Collada (initObject);
			
			this.braco = new Loader3D ();
			this.braco.mouseEnabled = false;
			this.braco.loadGeometry ("models/SimpleArm.dae", collada);
			this.braco.addEventListener (Loader3DEvent.LOAD_SUCCESS, onLoadCollada);
			
			this.scene.addChild(this.braco);
			
						
			//plane = new Plane({y:-20, width:1000, height:1000, pushback:true, segmentsW:20, segmentsH:20});
			this.plane = new Plane();
			this.plane.y = -20;
			this.plane.width = 1000;
			this.plane.height = 1000;
			this.plane.pushback = true;
			this.plane.segmentsW = 2;
			this.plane.segmentsH = 2;
			
			this.scene.addChild(this.plane);
			/*
			//sphere = new Sphere({x:300, y:160, z:300, radius:150, segmentsW:12, segmentsH:10});
			this.sphere = new Sphere();
			this.sphere.x = 300;
			this.sphere.y = 160;
			this.sphere.z = 300;
			this.sphere.radius = 150;
			this.sphere.segmentsW = 12;
			this.sphere.segmentsH = 10;
			
			this.scene.addChild(this.sphere);
			
			//cube = new Cube({x:300, y:160, z:-80, width:200, height:200, depth:200});
			this.cube = new Cube();
			this.cube.x = 300;
			this.cube.y = 160;
			this.cube.z = -80;
			this.cube.width = 200;
			this.cube.height = 200;
			this.cube.depth = 200;
			
			this.scene.addChild(this.cube);
			
			//torus = new Torus({x:-250, y:160, z:-250, radius:150, tube:60, segmentsR:12, segmentsT:10});
			this.torus = new Torus();
			this.torus.x = -250;
			this.torus.y = 160;
			this.torus.z = -250;
			this.torus.radius = 150;
			this.torus.tube = 60;
			this.torus.segmentsR = 12;
			this.torus.segmentsT = 10;
			
			this.scene.addChild(this.torus);*/
			
		}
		
		private function onLoadCollada(e:Loader3DEvent):void {
			trace ("onLoadCollada", this.braco.handle);
			var shadeMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(Shade));
			var bracoConteiner:ObjectContainer3D = this.braco.handle as ObjectContainer3D;
			bracoConteiner.material = shadeMaterial;
			
			this.pGeral = bracoConteiner.getChildByName ("node-antebraco1") as Mesh;
			this.pJuncao1 = bracoConteiner.getChildByName ("node-antebraco2") as Mesh;
			this.pJuncao2 = bracoConteiner.getChildByName ("node-pJuncao3") as Mesh;
			
									
			this.pJuncao1.rotationX += Math.round (Math.random () * 20) - 20;
			this.pJuncao2.rotationX += Math.round (Math.random () * 20) - 20;
			this.pGeral.rotationX += Math.round (Math.random () * 20) - 20;
			
			/*
			for (var i:int = 0; i < bracoConteiner.children.length; i++) {
				var item:Mesh = bracoConteiner.children[i] as Mesh;
				trace (item.name);				
			}*/
		}
		
		private function onJuncaoMove(e:Event):void {
			this.pJuncao1.rotationX += 5;
		}
		
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void {
			//scene.addOnMouseUp(onSceneMouseUp);
			this.scene.addEventListener(MouseEvent3D.MOUSE_UP, onSceneMouseUp);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.addEventListener(Event.RESIZE, onResize);
			this.onResize();
		}

		/**
		 * Mouse up listener for the 3d scene
		 */
		private function onSceneMouseUp(e:MouseEvent3D):void {
			if (e.object is Mesh) {
				var mesh:Mesh = e.object as Mesh;
				mesh.material = new WireColorMaterial();
			}
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void {
			if (move) {
				//this.camera.panAngle = 0.3 * (this.stage.mouseX - lastMouseX) + lastPanAngle;
				//this.camera.tiltAngle = 0.3 * (this.stage.mouseY - lastMouseY) + lastTiltAngle;
				
				this.pGeral.rotationY += 20;
			}
			
			this.camera.hover();  
			this.view.render();
		}

		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void {
			this.lastPanAngle = camera.panAngle;
			this.lastTiltAngle = camera.tiltAngle;
			this.lastMouseX = stage.mouseX;
			this.lastMouseY = stage.mouseY;
			this.move = true;
			this.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void {
			this.move = false;
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}

		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void {
			this.move = false;
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}

		/**
		 * Stage listener for resize events
		 */
		private function onResize(event:Event = null):void {
			this.view.x = this.stage.stageWidth / 2;
			this.view.y = this.stage.stageHeight / 2;
		}
	}

}