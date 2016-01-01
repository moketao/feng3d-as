/*

SkyBox example in Away3d

Demonstrates:

How to use a CubeTexture to create a SkyBox object.
How to apply a CubeTexture to a material as an environment map.

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

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

package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.cameras.lenses.PerspectiveLens;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.entities.SkyBox;
	import me.feng3d.materials.ColorMaterial;
	import me.feng3d.materials.methods.EnvMapMethod;
	import me.feng3d.primitives.TorusGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.textures.BitmapCubeTexture;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW")]

	public class Basic_SkyBox extends TestBase
	{
		// Environment map.
		private var EnvPosX:String = "embeds/skybox/snow_positive_x.jpg";
		private var EnvPosY:String = "embeds/skybox/snow_positive_y.jpg";
		private var EnvPosZ:String = "embeds/skybox/snow_positive_z.jpg";
		private var EnvNegX:String = "embeds/skybox/snow_negative_x.jpg";
		private var EnvNegY:String = "embeds/skybox/snow_negative_y.jpg";
		private var EnvNegZ:String = "embeds/skybox/snow_negative_z.jpg";


		//engine variables
		private var _view:View3D;

		//scene objects
		private var _skyBox:SkyBox;
		private var _torus:Mesh;

		/**
		 * Constructor
		 */
		public function Basic_SkyBox()
		{
			resourceList = [EnvPosX, EnvPosY, EnvPosZ, EnvNegX, EnvNegY, EnvNegZ]
			super();
		}

		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//setup the view
			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.transform3D.z = -600;
			_view.camera.transform3D.y = 0;
			_view.camera.transform3D.lookAt(new Vector3D());
			_view.camera.lens = new PerspectiveLens(90);

			//setup the cube texture
			var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture( //
				Cast.bitmapData(resourceDic[EnvPosX]), Cast.bitmapData(resourceDic[EnvNegX]), //
				Cast.bitmapData(resourceDic[EnvPosY]), Cast.bitmapData(resourceDic[EnvNegY]), //
				Cast.bitmapData(resourceDic[EnvPosZ]), Cast.bitmapData(resourceDic[EnvNegZ]) //
				);

			//setup the environment map material
			var material:ColorMaterial = new ColorMaterial(0xFFFFFF, 1);
			material.specular = 0.5;
			material.ambient = 0.25;
			material.ambientColor = 0x111199;
			material.ambient = 1;
			material.addMethod(new EnvMapMethod(cubeTexture, 1));

			//setup the scene
			_torus = new Mesh(new TorusGeometry(150, 60, 40, 20), material);
			_view.scene.addChild(_torus);

			_skyBox = new SkyBox(cubeTexture);
			_view.scene.addChild(_skyBox);

			//setup the render loop
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			_torus.transform3D.rotationX += 2;
			_torus.transform3D.rotationY += 1;

			_view.camera.transform3D.position = new Vector3D();
			_view.camera.transform3D.rotationY += 0.5 * (stage.mouseX - stage.stageWidth / 2) / 800;
			_view.camera.transform3D.moveBackward(600);

			_view.render();
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
	}
}
