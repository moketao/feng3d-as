package me.feng.objectView
{
	import com.bit101.components.HBox;

	import flash.display.DisplayObjectContainer;

	import me.feng.objectView.configs.ObjectViewClassConfig;
	import me.feng.objectView.data.ObjectA;
	import me.feng.objectView.view.BooleanAttrView;
	import me.feng.objectView.view.CustomAttrView;
	import me.feng.objectView.view.CustomBlockView;

	//
	//
	// @author feng 2016-3-23
	//
	[SWF(width = "800", height = "600")]
	public class ObjectViewWithBlockTest extends TestBase
	{
		public function init():void
		{
//			initBlockConfig()
			initBlockConfig1()

			var box:DisplayObjectContainer = new HBox();

			var a:ObjectA = new ObjectA();
			a.boo = true;
			a.da = 2;
			a.db = "```";
			box.addChild(ObjectView.getObjectView(a));
			addChild(box);
		}

		private function initBlockConfig1():void
		{
			var config:Object = { //
					view: "", //
//					view: Sprite, //
//					view: CustomObjectView, //
					attributeDefinitions: [ //
					{name: "x", block: "坐标"}, //
						{name: "y", block: "坐标"}, //
						{name: "z", block: "坐标"}, //
//						
						{name: "rx", block: "旋转"}, //
						{name: "ry", block: "旋转"}, //
						{name: "rz", block: "旋转"}, //
//						
						{name: "sx", block: "缩放"}, //
						{name: "sy", block: "缩放"}, //
						{name: "sz", block: "缩放"}, //
						//
						{name: "a", block: "自定义块"}, //
						{name: "b", block: "自定义块"}, //

						{name: "custom", block: "缩放", view: CustomAttrView}, //

					], //
					blockDefinitions: [ //
					{name: "自定义块", view: CustomBlockView}, //
					] //
				};
			ObjectViewConfig.setClassConfig(ObjectA, config);

			var globalConfig:Object = { //
					attributeDefaultViews: [ //
//						{attributeType: "", viewType: BooleanAttrView}, //
//					{attributeType: "String", viewType: BooleanAttrView}, //
//					{attributeType: "String", viewType: ""}, //
					{attributeType: "Boolean", viewType: BooleanAttrView}, //
					]};
			ObjectViewConfig.setGlobalConfig(globalConfig);
		}

		private function initBlockConfig():void
		{
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "x", "坐标");
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "y", "坐标");
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "z", "坐标");
//
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "rx", "旋转");
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "ry", "旋转");
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "rz", "旋转");
//
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "sx", "缩放");
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "sy", "缩放");
			ObjectViewConfig.setObjectAttributeBlockName(ObjectA, "sz", "缩放");
		}
	}
}


