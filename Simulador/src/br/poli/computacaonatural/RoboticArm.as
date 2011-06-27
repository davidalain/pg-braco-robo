package br.poli.computacaonatural {
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Mesh;
	import away3d.core.base.Object3D;
	import away3d.core.draw.ScreenVertex;
	import away3d.core.filter.FogFilter;
	import away3d.core.filter.ZDepthFilter;
	import away3d.core.render.BasicRenderer;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight3D;
	import away3d.lights.PointLight3D;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	import away3d.primitives.Torus;
	
	import br.poli.computacaonatural.events.RoboticArmEvent;
	import br.poli.computacaonatural.model3d.ArmModel;
	import br.poli.computacaonatural.model3d.ElementModel;
	import br.poli.computacaonatural.model3d.SubArm;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Ricardo Teixeira
	 */
	public class RoboticArm extends Sprite {
		
		private var objects:Vector.<ElementModel>;
		
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
		
		private var mao:Mesh;
		private var pGeral:Mesh;
		private var pJuncao1:Mesh;
		private var pJuncao2:Mesh;
		
		private var loaderConfig:URLLoader;
		private var urlConfig:String;
		private var xmlConfig:XML;
		private var light:DirectionalLight3D;
		private var urlCollada:String;
		private var pegou:Boolean;
		private var bracoConteiner:ObjectContainer3D;
		private var armModel:ArmModel;
		private var reference:Sphere;
		
		private var draggedItem:ElementModel;
		
		//[Event (type="RoboticArmEvent.END_ROTATE")] 
		
		public function RoboticArm(config:String = "data/config.xml") {
			this.objects = new Vector.<ElementModel>();
			this.pegou = false;
			this.urlConfig = config;
			this.urlCollada = "models/Arm02.DAE";
			this.addEventListener (Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			this.loaderConfig = new URLLoader ();
			this.loaderConfig.load (new URLRequest (this.urlConfig));
			this.loaderConfig.addEventListener (Event.COMPLETE, onLoadConfig);
			
		}
		
		private function init3D ():void {
			this.initEngine();
			this.initObjects();
			this.initListeners ();
		}
		
		private function onLoadConfig(e:Event):void {
			this.xmlConfig = new XML (this.loaderConfig.data);
			this.init3D ();
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
			
			
			//var a:* =this.camera.viewProjection
			
						
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
		
			/*var collada:Collada = new Collada (initObject);
			
			this.braco = new Loader3D ();
			this.braco.mouseEnabled = false;
			this.braco.loadGeometry (this.urlCollada, collada);
			this.braco.addEventListener (Loader3DEvent.LOAD_SUCCESS, onLoadCollada);
			
			this.scene.addChild(this.braco);*/

						
			//plane = new Plane({y:-20, width:1000, height:1000, pushback:true, segmentsW:20, segmentsH:20});
			this.plane = new Plane();
			this.plane.material = new WireColorMaterial (0xDDDDDD);
			this.plane.x = 0;
			this.plane.y = 0;
			this.plane.z = 0;
			this.plane.width = 1000;
			this.plane.height = 1000;
			this.plane.pushback = true;
			this.plane.segmentsW = 5;
			this.plane.segmentsH = 5;
			
			this.scene.addChild(this.plane);
			
			//sphere = new Sphere({x:300, y:160, z:300, radius:150, segmentsW:12, segmentsH:10});
			/*this.sphere = new Sphere();
			this.sphere.radius = 50;
			this.sphere.segmentsW = 12;
			this.sphere.segmentsH = 10;		
			this.sphere.x = 300;
			this.sphere.y = this.sphere.objectHeight / 2;
			this.sphere.z = 0;*/
			
			this.armModel = new ArmModel ();
			this.scene.addChild(this.armModel);
			
			//this.scene.addChild(this.cube);			
			//this.scene.addChild(this.sphere);
						
			this.armModel.primAxis.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "arm").@initAng);
			this.armModel.interAxis.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@initAng);	
						
			this.addObject ();
			
			//cube = new Cube({x:300, y:160, z:-80, width:200, height:200, depth:200});
			/*this.cube = new Cube();
			this.cube.name = "geral";
			this.cube.height = 100;
			this.cube.width = 100;
			this.cube.depth = 100;
			this.cube.x = 150;
			this.cube.y = 25;
			this.cube.z = -80;*/
			//this.cube.centerPivot ();
					
		}
		
		public function reset ():void {		
			if(this.armModel){
				this.armModel.primAxis.rotationX = 0;
				this.armModel.interAxis.rotationX = 0;
				this.armModel.rotationY = 0;
				if (this.draggedItem != null) {
					this.armModel.interAxis.removeChild (this.draggedItem);
				}
				this.draggedItem = null;
				this.addObject ();
			}
			
		}
		
		private function addObject ():void {
		
			for each (var obj:XML in this.xmlConfig.config.objects.object) {
				var element:ElementModel = new ElementModel();	
				element.elementID = Number (obj.@id);
				element.x = Number (obj.@x);
				element.y = element.objectHeight / 2;
				element.z = Number (obj.@z);
				this.objects.push (element);
				this.scene.addChild(element);
			}
			
			//this.armModel.primAxis.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "arm").@initAng);
			//this.armModel.interAxis.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@initAng);	
			
		}
		
		private function onLoadCollada(e:Loader3DEvent):void {
			
			//new BitmapMaterial(new BitmapData(50,50),null );//
			var shadeMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(Shade));
			
			this.bracoConteiner = this.braco.handle as ObjectContainer3D;
			this.bracoConteiner.material = shadeMaterial;
						
			this.mao = bracoConteiner.getChildByName ("node-mao") as Mesh;
			this.pGeral = bracoConteiner.getChildByName ("node-antebraco1") as Mesh;
			this.pJuncao1 = bracoConteiner.getChildByName ("node-pJuncao2") as Mesh;
			this.pJuncao2 = bracoConteiner.getChildByName ("node-pJuncao3") as Mesh;
			
			this.pGeral.collider = true;
			this.pJuncao1.collider = true;
			this.pJuncao2.collider = true;
			
			this.pGeral.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "arm").@initAng);
			this.pJuncao1.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@initAng);
			this.pJuncao2.rotationX = Number (this.xmlConfig.config.pivots.pivot.(@id == "juncao2").@initAng);
		}		
		
		public function distances():Number {
//		public function distances ():Vector.<Number> {
			var dists:Number;
//			var dists:Vector.<Number> = new Vector.<Number>();
			//this.view.render();
			if( this.armModel ){
				this.reference = this.armModel.reference;
				
				//for (var i:int = 0; i < this.objects.length; i++) {
					var item:ElementModel = this.objects[0];
					dists = this.reference.distanceTo (item);
			//		dists.push ( this.reference.distanceTo (item) );				
//					dists.push ( this.reference.distanceTo (item) - 75);				
				//}
			}
						
			return dists;
			
		}
		
		private function degreeToRadian (degree:Number):Number {
			return Math.PI / 180 * degree;
		}
		
		public function rotateBase (ang:Number):int {
			//this.pGeral.rotationY += ang;
			//trace ("this.reference", this.reference.position);
			var isValid:int = 0;
			if (isNaN (ang)) ang = 0;
			
			this.armModel.rotationY += ang;
			
			var max:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "base").@maxLimitAng);
			var min:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "base").@minLimitAng);
			
		//	var event:RoboticArmEvent;
			if (this.armModel.rotationY > max) {
				this.armModel.rotationY -= ang;
				isValid = 0;
			//	event = new RoboticArmEvent (RoboticArmEvent.INVALID_ROTATION);
			} else {
				isValid = 1;
			//	event = new RoboticArmEvent (RoboticArmEvent.VALID_ROTATION);
			}
			if (this.armModel.rotationY < min) {
				this.armModel.rotationY -= ang;
				isValid = 0;
			//	event = new RoboticArmEvent (RoboticArmEvent.INVALID_ROTATION);
			} else {
				isValid= 1;
			//	event = new RoboticArmEvent (RoboticArmEvent.VALID_ROTATION);
			}
			//this.dispatchEvent (event);
			
		//	this.view.render();
			return isValid;
			// TODO Pegar Caixa
			/*if (this.distances ()[0] < 40 || this.pegou) {
				this.pegou = true;
				this.cube.x = Math.cos (this.degreeToRadian (this.pJuncao1.rotationX)) * 200;
				this.cube.y = Math.sin (this.degreeToRadian (this.pJuncao2.rotationY)) * 200;
				this.cube.z = this.cube.x + this.cube.y ;
			}
			*/
			
			//this.testCollision ();
			
		}
		
		private function testCollision():void {		
			
			var dists:Number = this.distances ();
//			var dists:Vector.<Number> = this.distances ();
			
		//	var event:RoboticArmEvent = new RoboticArmEvent (RoboticArmEvent .END_ROTATE, dists);
		//	this.dispatchEvent ( event );
			
			//this.draggedItem = null;
			
			for (var i:int = 0; i < this.objects.length; i++) {
				var item:ElementModel = this.objects[i];
				var dist:Number = this.reference.distanceTo (item) - 75;
				
				if (dist <= 0.01) {
			//		event = new RoboticArmEvent (RoboticArmEvent.COLLISION , dists, item);
			//		this.dispatchEvent ( event );	
					
					if (this.draggedItem == null) {
						this.draggedItem = item;
						trace (this.draggedItem);
					}
					
			//		item.x = this.reference.x;
			//		item.y = this.reference.y;
			//		item.z = this.reference.z;
					
			//		this.armModel.interAxis.addChild (item);
				}
				
				
			}
		}
		
		public function release (vector:Vector3D = null):void {
			if (this.draggedItem != null) {
				var rad:Number = this.degreeToRadian (this.armModel.rotationY);
								
				
								
				// TODO Calcular raio correto para soltar na posição correta
				var radius:Number = 300;
				
				var px:Number = -Math.sin (rad) * radius;
				var pz:Number = -Math.cos (rad) * radius;
				
				this.draggedItem.x = px; // Number (this.xmlConfig.config.objects.object.(@id == this.draggedItem.elementID.toString()).@x);
				this.draggedItem.y = 0; // Number (this.xmlConfig.config.objects.object.(@id == this.draggedItem.elementID.toString()).@y);
				this.draggedItem.z = pz; // Number (this.xmlConfig.config.objects.object.(@id == this.draggedItem.elementID.toString()).@z);
				this.scene.addChild(this.draggedItem);
				this.draggedItem = null;
			}
			
		}
		
		public function rotateArm (ang:Number):int {
			
			if (isNaN (ang)) ang = 0;
			
			this.armModel.primAxis.rotationX += ang;
			var isValid:int = 0;
			/*this.pGeral.rotationX += ang;
			*/
			var max:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "arm").@maxLimitAng);
			var min:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "arm").@minLimitAng);
			
		//	var event:RoboticArmEvent;
			if (this.armModel.primAxis.rotationX > max) {
				this.armModel.primAxis.rotationX -= ang;
		//		event = new RoboticArmEvent (RoboticArmEvent.INVALID_ROTATION);
			} else {
				isValid =1 
		//		event = new RoboticArmEvent (RoboticArmEvent.VALID_ROTATION);
			}			
			if (this.armModel.primAxis.rotationX < min) {
				this.armModel.primAxis.rotationX -= ang;
		//		event = new RoboticArmEvent (RoboticArmEvent.INVALID_ROTATION);
			} else {
				
				isValid = 1;
		//		event = new RoboticArmEvent (RoboticArmEvent.VALID_ROTATION);
			}
			//.dispatchEvent (event);
			//this.view.render();
			return  isValid ;			
			//this.testCollision ();
		}
		
		public function rotateSubArm (ang:Number):int {
			
			if (isNaN (ang)) ang = 0;
			
			this.armModel.interAxis.rotationX += ang;
			var isValid:int = 0;
			var max:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@maxLimitAng);
			var min:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@minLimitAng);
			
			
		//	var event:RoboticArmEvent;
			if (this.armModel.interAxis.rotationX > max) {
				this.armModel.interAxis.rotationX -= ang;
				//event = new RoboticArmEvent (RoboticArmEvent.INVALID_ROTATION);
			} else {
				isValid =1
			//	event = new RoboticArmEvent (RoboticArmEvent.VALID_ROTATION);
			}			
			if (this.armModel.interAxis.rotationX < min) {
				this.armModel.interAxis.rotationX -= ang;
				isValid =0 
			//	event = new RoboticArmEvent (RoboticArmEvent.INVALID_ROTATION);
			} else {
				isValid =1
			//	event = new RoboticArmEvent (RoboticArmEvent.VALID_ROTATION);
			}
			//this.dispatchEvent (event);
		//	this.view.render();
			return isValid;
			//this.testCollision ();
		}
		
		public function rotateJuncao1 (ang:Number):void {
			this.pJuncao1.rotationX += ang;
			
			var max:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@maxLimitAng);
			var min:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "subarm").@minLimitAng);
			
			if (this.pJuncao1.rotationX > max) {
				this.pJuncao1.rotationX = max;
			}
			
			if (this.pJuncao1.rotationX < min) {
				this.pJuncao1.rotationX = min;
			}
			//var event:RoboticArmEvent = new RoboticArmEvent (RoboticArmEvent .END_ROTATE, this.distances ());
			//this.dispatchEvent ( event );
		}
		
		public function rotateJuncao2 (ang:Number):void {
			this.pJuncao2.rotationX += ang;
			
			var max:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "juncao2").@maxLimitAng);
			var min:Number = Number (this.xmlConfig.config.pivots.pivot.(@id == "juncao2").@minLimitAng);
			
			if (this.pJuncao2.rotationX > max) {
				this.pJuncao2.rotationX = max;
			}
			
			if (this.pJuncao2.rotationX < min) {
				this.pJuncao2.rotationX = min;
			}
			//var event:RoboticArmEvent = new RoboticArmEvent (RoboticArmEvent .END_ROTATE, this.distances ());
			//this.dispatchEvent ( event );
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
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			this.onResize();
		}
		
		private function onWheel(e:MouseEvent):void {
			this.camera.distance += 100 * e.delta
		}

		/**
		 * Mouse up listener for the 3d scene
		 */
		private function onSceneMouseUp(e:MouseEvent3D):void {
			/*var obj:Mesh = e.object as Mesh;
			if (e.object is Mesh) {
				switch (obj.name) {
					case "geral": this.rotateGeral (10); break;
					case "geral2": this.pGeral.rotationY += 10; break;
					case "juncao1": this.rotateJuncao1 (10); break;
					case "juncao2": this.rotateJuncao2 (10); break;
				}
			}
			
			trace ("Geral X",  this.pGeral.rotationX);
			trace ("Juncao1 X",  this.pJuncao1.rotationX);
			trace ("Juncao2 X",  this.pJuncao2.rotationX);
			*/
			/*if (e.object is Mesh) {
				var mesh:Mesh = e.object as Mesh;
				mesh.material = new WireColorMaterial();
			}*/
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void {
			if (move) {
				this.camera.panAngle = 0.3 * (this.stage.mouseX - lastMouseX) + lastPanAngle;
				this.camera.tiltAngle = 0.3 * (this.stage.mouseY - lastMouseY) + lastTiltAngle;
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
		
		override public function toString ():String {
			var saida:String = "";
			if (this.armModel) { 
				saida = "Base: " + this.armModel.rotationY;
				saida += "\nEixo 0: " + this.armModel.primAxis.rotationX;
				saida += "\nEixo 1: " + this.armModel.interAxis.rotationX;
			}
			return saida;
		}
	}

}