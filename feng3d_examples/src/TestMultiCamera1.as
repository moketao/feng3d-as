package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Container3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.entities.Mesh;
	import me.feng3d.test.TestBase;

	import model3d.PhotoBox;

	import parser.ObjParser1;

	/**
	 * 测试多视角
	 * @author feng 2014-3-27
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestMultiCamera1 extends TestBase
	{
		private var camera:Camera3D;
		private var scene3D:Scene3D;

		private var angle:Number = 0;
		private var len:int = 100;

		private var cameraObjData:String = "art/camera.obj";
		private var view:View3D;
		private var viewTop:View3D;
		private var viewFront:View3D;

		public function TestMultiCamera1()
		{
			resourceList = [cameraObjData];
			super();
		}

		public function init(e:Event = null):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			view = new View3D(scene3D);
			addChild(view);

			camera = view.camera;
			scene3D = view.scene;

			initMyCamera();

			initSmallMap();

			initObj();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function initMyCamera():void
		{
			//使用一个四棱锥作为摄像机，四边形那面为摄像机方向
			var objParser:ObjParser1 = new ObjParser1(resourceDic[cameraObjData], 1, true, true);
			var terrainGeometry:Geometry = new Geometry();

			var sub:SubGeometry = new SubGeometry();
			terrainGeometry.addSubGeometry(sub);
			sub.updateIndexData(objParser.rawIndexBuffer);
			sub.numVertices = objParser.rawPositionsBuffer.length / 3;
			sub.updateVertexPositionData(objParser.rawPositionsBuffer);
			sub.updateUVData(objParser.rawUvBuffer);

			var obj3d:Mesh = new Mesh();
			obj3d.name = "obj3d";
			obj3d.geometry = terrainGeometry;
			camera.addChild(obj3d);

			scene3D.addChild(camera);
		}

		private function initObj():void
		{
			var photoBox:Container3D = new PhotoBox(rootPath, 40, 4);
			scene3D.addChild(photoBox);
		}

		private function initSmallMap():void
		{
			//俯视图
			var cameraTop:Camera3D = new Camera3D();
			cameraTop.transform3D.y = 200;
			cameraTop.transform3D.lookAt(new Vector3D(), new Vector3D(0, 0, 1));

			viewTop = new View3D(scene3D, cameraTop);
			addChild(viewTop);
			viewTop.width = viewTop.height = 100;
			viewTop.x = stage.stageWidth - viewTop.width;
			viewTop.backgroundColor = 0x666666;

			//前视图
			var cameraFront:Camera3D = new Camera3D();
			cameraFront.transform3D.z = 200;
			cameraFront.transform3D.lookAt(new Vector3D(), new Vector3D(0, 1, 0));

			viewFront = new View3D(scene3D, cameraFront);
			addChild(viewFront);
			viewFront.width = viewFront.height = 100;
			viewFront.backgroundColor = 0x666666;
		}

		protected function onEnterFrame(event:Event):void
		{
			angle++;
			camera.transform3D.z = len * Math.cos(angle / 180 * Math.PI);
			camera.transform3D.x = len * Math.sin(angle / 180 * Math.PI);

			camera.transform3D.lookAt(new Vector3D());

			view.render();
			viewFront.render();
			viewTop.render();
		}
	}
}
