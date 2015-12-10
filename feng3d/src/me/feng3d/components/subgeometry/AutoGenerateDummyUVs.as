package me.feng3d.components.subgeometry
{
	import me.feng.component.event.ComponentEvent;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.events.GeometryComponentEvent;
	import me.feng3d.fagalRE.FagalIdCenter;

	/**
	 * 自动生成虚拟UV
	 * @author feng 2015-12-8
	 */
	public class AutoGenerateDummyUVs extends SubGeometryComponent
	{
		private var dataTypeId:String;
		private var target:Vector.<Number>;
		private var needGenerate:Boolean;

		public function AutoGenerateDummyUVs()
		{
			dataTypeId = _.uv_va_2;

			super();
		}

		override protected function set subGeometry(value:SubGeometry):void
		{
			if (_subGeometry != null)
			{
				_subGeometry.removeEventListener(GeometryComponentEvent.GET_VA_DATA, onGetVAData);
				_subGeometry.removeEventListener(GeometryComponentEvent.CHANGED_VA_DATA, onChangedVAData);
			}
			_subGeometry = value;
			if (_subGeometry != null)
			{
				_subGeometry.addEventListener(GeometryComponentEvent.GET_VA_DATA, onGetVAData);
				_subGeometry.addEventListener(GeometryComponentEvent.CHANGED_VA_DATA, onChangedVAData);
			}
		}

		/**
		 * 处理被添加事件
		 * @param event
		 */
		override protected function onBeAddedComponet(event:ComponentEvent):void
		{
			super.onBeAddedComponet(event);

			needGenerate = true;
			subGeometry.invalidVAData(dataTypeId);
		}

		protected function onGetVAData(event:GeometryComponentEvent):void
		{
			if (event.data != dataTypeId)
				return;
			if (!needGenerate)
				return;
			target = updateDummyUVs(target);
			subGeometry.setVAData(dataTypeId, target);

			needGenerate = false;
		}

		/**
		 * 更新虚拟uv
		 * @param target 虚拟uv(输出)
		 * @return 虚拟uv
		 */
		private function updateDummyUVs(target:Vector.<Number>):Vector.<Number>
		{
			var idx:uint, uvIdx:uint;
			var stride:int = 2;
			var len:uint = subGeometry.numVertices * stride;

			if (!target)
				target = new Vector.<Number>();
			target.fixed = false;
			target.length = len;
			target.fixed = true;

			idx = 0;
			uvIdx = 0;
			while (idx < len)
			{
				target[idx++] = uvIdx * .5;
				target[idx++] = 1.0 - (uvIdx & 1);

				if (++uvIdx == 3)
					uvIdx = 0;
			}

			return target;
		}

		protected function onChangedVAData(event:GeometryComponentEvent):void
		{
			if (event.data == _.position_va_3)
			{
				needGenerate = true;
			}
		}

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}
	}
}
