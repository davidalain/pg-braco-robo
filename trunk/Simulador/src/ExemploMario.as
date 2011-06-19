/*

Collada bones example in Away3d

Demonstrates:

How to import an animated collada file that uses bones.
How to posiiton a mouse cursor that hovers over a plane.
how to duplicate animated geometry with the minimum processing overhead.

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

Models by Peter Kapelyan
flashnine@gmail.com
http://www.flashten.com/

This code is distributed under the MIT License

Copyright (c)  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

import away3d.animators.*;
import away3d.cameras.*;
import away3d.containers.*;
import away3d.core.base.Mesh;
import away3d.core.utils.*;
import away3d.events.*;
import away3d.loaders.*;
import away3d.materials.*;
import away3d.primitives.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;

//engine variables
var camera:Camera3D;
var view:View3D;
var scene:Scene3D;

//material variables
var material:BitmapMaterial;
var shadeMaterial:BitmapMaterial;
var positionMaterial:BitmapMaterial;
var floorMaterial:TransformBitmapMaterial;

//signature variables
var Signature:Sprite;
var SignatureBitmap:Bitmap;

//objectvariables
var collada:Collada;
var loader:Loader3D;
var model1:ObjectContainer3D;
var mesh:Mesh;
var model2:ObjectContainer3D;
var model3:ObjectContainer3D;
var model4:ObjectContainer3D;
var model5:ObjectContainer3D;
var position:Plane;
var shade1:Plane;
var shade2:Plane;
var shade3:Plane;
var shade4:Plane;
var shade5:Plane;
var floor:Plane;

//animation varibles
var bonesAnimator:BonesAnimator;

//navigation variables
var rotate:Number;
var scrollX:Number;
var scrollY:Number;
var loaded:Boolean;

init();

/**
 * Global initialise function
 */
function init():void
{
	//Debug.active = true;
	initEngine();
	initMaterials();
	initObjects();
	initListeners();
}

/**
 * Initialise the engine
 */
function initEngine():void
{
	scene = new Scene3D();
	camera = new Camera3D();
	
	//view = new View3D({camera:camera, scene:scene});
	view = new View3D();
	view.camera = camera;
	view.scene = scene;
	
	view.addSourceURL("srcview/index.html");
	view.mouseZeroMove = true;
	addChild(view);
	
	//add signature
	Signature = Sprite(new SignatureSwf());
	SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
	stage.quality = StageQuality.HIGH;
	SignatureBitmap.bitmapData.draw(Signature);
	stage.quality = StageQuality.LOW;
	addChild(SignatureBitmap);
}

/**
 * Initialise the materials
 */
function initMaterials():void
{
	material = new BitmapMaterial(Cast.bitmap(Charmap));
	
	//floorMaterial = new TransformBitmapMaterial(Cast.bitmap(Floor), {repeat:true,scaleX:3,scaleY:3, precision:2});
	floorMaterial = new TransformBitmapMaterial(Cast.bitmap(Floor));
	floorMaterial.repeat = true;
	floorMaterial.scaleX = 3;
	floorMaterial.scaleY = 3;
	
	shadeMaterial = new BitmapMaterial(Cast.bitmap(Shade));
	
	positionMaterial = new BitmapMaterial(Cast.bitmap(Position));
}

/**
 * Initialise the scene objects
 */
function initObjects():void
{
	//loader = Collada.load("assets/mario_testrun.dae", {scaling:10, material:material, mouseEnabled:false}) as Loader3D;
	collada = new Collada();
	collada.scaling = 10;
	collada.material = material;
	loader = new Loader3D();
	loader.mouseEnabled = false;
	loader.loadGeometry("assets/mario_testrun.dae", collada);
	
	//loader.addOnSuccess(onSuccess);
	loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
	
	scene.addChild(loader);
		
	//position = new Plane({width:50, height:50, material:positionMaterial, pushfront:true});
	position = new Plane();
	position.width = 50;
	position.height = 50;
	position.material = positionMaterial;
	position.pushfront = true;
	
	scene.addChild(position);
	
	//shade1 = new Plane({material:shadeMaterial, pushback:true, mouseEnabled:false});
	shade1 = new Plane();
	shade1.material = shadeMaterial;
	shade1.pushback = true;
	shade1.mouseEnabled = false;
	
	scene.addChild(shade1);
	
	//shade2 = new Plane({x:150, material:shadeMaterial, pushback:true, mouseEnabled:false});
	shade2 = new Plane();
	shade2.x = 150;
	shade2.material = shadeMaterial;
	shade2.pushback = true;
	shade2.mouseEnabled = false;
	
	scene.addChild(shade2);
	
	//shade3 = new Plane({x:-150, material:shadeMaterial, pushback:true, mouseEnabled:false});
	shade3 = new Plane();
	shade3.x = -150;
	shade3.material = shadeMaterial;
	shade3.pushback = true;
	shade3.mouseEnabled = false;
	
	scene.addChild(shade3);
	
	//shade4 = new Plane({z:150, material:shadeMaterial, pushback:true, mouseEnabled:false});
	shade4 = new Plane();
	shade4.z = 150;
	shade4.material = shadeMaterial;
	shade4.pushback = true;
	shade4.mouseEnabled = false;
	
	scene.addChild(shade4);
	
	//shade5 = new Plane({z:-150, material:shadeMaterial, pushback:true, mouseEnabled:false});
	shade5 = new Plane();
	shade5.z = -150;
	shade5.material = shadeMaterial;
	shade5.pushback = true;
	shade5.mouseEnabled = false;
	
	scene.addChild(shade5);
	
	//floor = new Plane({yUp:true, width:600, height:600, material:floorMaterial, ownCanvas:true, pushback:true});
	floor = new Plane();
	floor.width = 600;
	floor.height = 600;
	floor.material = floorMaterial;
	floor.ownCanvas = true;
	floor.pushback = true;
	scene.addChild(floor);
}

/**
 * Initialise the listeners
 */
function initListeners():void
{
	scene.addOnMouseMove(onMouseMove);
	addEventListener(Event.ENTER_FRAME, onEnterFrame);
	stage.addEventListener(Event.RESIZE, onResize);
	onResize();
}

/**
 * Navigation and render loop
 */
function onEnterFrame(event:Event):void
{
	//calculate the polar coordinate rotation for the cursor position on the floor plane
	rotate = (Math.floor(Math.atan2(-position.x, -position.z)*(180/Math.PI)) + 180);
	
	//calculate scroll values for the floor material
	scrollY = Math.sin((rotate + 90)/180*Math.PI)*5;
	scrollX = Math.cos((rotate + 90)/180*Math.PI)*5;
	
	//apply scroll values to the floor material
	floorMaterial.offsetX += scrollX;
	floorMaterial.offsetY += scrollY;
	
	if (loaded) {
		//update the rotation of each mario model
		model1.rotationY = rotate;
		model2.rotationY = rotate;
		model3.rotationY = rotate;
		model4.rotationY = rotate;
		model5.rotationY = rotate;
		
		//update the collada animation
		bonesAnimator.update(getTimer()*2/1000);
	}
	
	//update the camera position
	camera.moveTo(0, 70, -10);
	camera.rotationX = -mouseY/20;			
	camera.moveBackward(700 - mouseY/2);
	
	//render scene
	view.render();
}

/**
 * Listener function for loading complete event
 */
function onSuccess(event:Loader3DEvent):void
{
	loaded = true;
	
	model1 = loader.handle as ObjectContainer3D;
	
	mesh = model1.getChildByName("polySurface1") as Mesh;
	
	//model2 = new ObjectContainer3D(mesh.clone(), {x:150, mouseEnabled:false});
	model2 = new ObjectContainer3D(mesh.clone());
	model2.x = 150;
	model2.mouseEnabled = false;
	
	scene.addChild(model2);
	
	//model3 = new ObjectContainer3D(mesh.clone(), {x:-150, mouseEnabled:false});
	model3 = new ObjectContainer3D(mesh.clone());
	model3.x = -150;
	model3.mouseEnabled = false;
	
	scene.addChild(model3);
	
	//model4 = new ObjectContainer3D(mesh.clone(), {z:150, mouseEnabled:false});
	model4 = new ObjectContainer3D(mesh.clone());
	model4.z = 150;
	model4.mouseEnabled = false;
	
	scene.addChild(model4);
	
	//model5 = new ObjectContainer3D(mesh.clone(), {z:-150, mouseEnabled:false});
	model5 = new ObjectContainer3D(mesh.clone());
	model5.z = -150;
	model5.mouseEnabled = false;
	
	scene.addChild(model5);
		
	//grabs an instance of the skin animation from the animationLibrary
	bonesAnimator = model1.animationLibrary.getAnimation("default").animator as BonesAnimator;
}

/**
 * scene listener for crosshairs plane
 */
function onMouseMove(e:MouseEvent3D):void {
	position.x = e.sceneX;
	position.z = e.sceneZ;
}

/**
 * stage listener for resize events
 */
function onResize(event:Event = null):void
{
	view.x = stage.stageWidth / 2;
	view.y = stage.stageHeight / 2;
	SignatureBitmap.y = stage.stageHeight - Signature.height;
}