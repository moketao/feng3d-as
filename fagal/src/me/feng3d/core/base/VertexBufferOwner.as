package me.feng3d.core.base
{
	import flash.utils.Dictionary;
	
	import me.feng.component.Component;
	import me.feng.debug.assert;
	import me.feng3d.core.buffer.context3d.VABuffer;
	import me.feng3d.fagalRE.FagalIdCenter;

	/**
	 * 顶点数据拥有者
	 * @author feng 2015-1-14
	 */
	public class VertexBufferOwner extends Component
	{
		public var context3DBufferOwner:Context3DBufferOwner;

		protected var _numVertices:uint;

		private var _vaIdList:Vector.<String> = new Vector.<String>();
		/** 顶点属性数据缓存字典 */
		private var vaBufferDic:Dictionary = new Dictionary();
		/** 顶点数据长度字典 */
		private var data32PerVertexDic:Dictionary = new Dictionary();
		/** 顶点数据字典 */
		protected var vertexDataDic:Dictionary = new Dictionary();

		/** 数据有效(与脏相反)标记字典 */
		private var dataValidDic:Dictionary = new Dictionary();

		/**
		 * 创建顶点数据拥有者
		 */
		public function VertexBufferOwner()
		{
			super();
			context3DBufferOwner = new Context3DBufferOwner();
		}

		/**
		 * 顶点个数
		 */
		public function get numVertices():uint
		{
			return _numVertices;
		}

		public function set numVertices(value:uint):void
		{
			if (_numVertices != value)
			{
				for each (var vaBuffer:VABuffer in vaBufferDic)
				{
					vaBuffer.invalid();
				}
			}
			_numVertices = value;
		}

		/**
		 * 注册顶点数据
		 * @param dataTypeId
		 * @param data32PerVertex
		 */
		public function mapVABuffer(dataTypeId:String, data32PerVertex:int):void
		{
			data32PerVertexDic[dataTypeId] = data32PerVertex;
			vertexDataDic[dataTypeId] = new Vector.<Number>();
			_vaIdList.push(dataTypeId);
			vaBufferDic[dataTypeId] = context3DBufferOwner.mapContext3DBuffer(dataTypeId, updateVABuffer);
		}

		/**
		 * 更新顶点数据缓冲
		 * @param vaBuffer
		 */
		private function updateVABuffer(vaBuffer:VABuffer):void
		{
			var data32PerVertex:int = getVALen(vaBuffer.dataTypeId);
			var data:Vector.<Number> = getVAData(vaBuffer.dataTypeId);
			vaBuffer.update(data, numVertices, data32PerVertex);
		}

		/**
		 * 使顶点数据失效
		 * @param dataTypeId
		 */
		public function invalidVAData(dataTypeId:String):void
		{
			dataValidDic[dataTypeId] = false;
			context3DBufferOwner.markBufferDirty(dataTypeId);
		}

		/**
		 * 获取顶点属性长度(1-4)
		 * @param dataTypeId 数据类型编号
		 * @return 顶点属性长度
		 */
		public function getVALen(dataTypeId:String):uint
		{
			return data32PerVertexDic[dataTypeId];
		}

		/**
		 * 设置顶点属性数据
		 * @param dataTypeId 数据类型编号
		 * @param data 顶点属性数据
		 */
		public function setVAData(dataTypeId:String, data:Vector.<Number>):void
		{
			var vaLen:uint = getVALen(dataTypeId);
			assert(data.length == numVertices * vaLen, "数据长度不对，更新数据之前需要给SubGeometry.numVertices赋值");
			vertexDataDic[dataTypeId] = data;
			context3DBufferOwner.markBufferDirty(dataTypeId);

			dataValidDic[dataTypeId] = true;

			notifyVADataChanged(dataTypeId);
		}

		/**
		 * 获取顶点属性数据
		 * @param dataTypeId 数据类型编号
		 * @param needUpdate 是否需要更新数据
		 * @return 顶点属性数据
		 */
		public function getVAData(dataTypeId:String):Vector.<Number>
		{
			if (!dataValidDic[dataTypeId])
				updateVAdata(dataTypeId);
			dataValidDic[dataTypeId] = true;

			return vertexDataDic[dataTypeId];
		}

		/**
		 * 通知数据发生变化<br/>
		 * 通常会在setVAData后被调用<br/>
		 * 处理某数据改变后对其他数据造成的影响<br/>
		 * 比如顶点数据发生变化后法线、切线等数据就变得无效了
		 * @param dataTypeId 数据类型编号
		 */
		protected function notifyVADataChanged(dataTypeId:String):void
		{

		}

		/**
		 * 更新顶点数据
		 * @param dataTypeId 数据类型编号
		 */
		protected function updateVAdata(dataTypeId:String):void
		{

		}

		/** 顶点属性编号列表 */
		public function get vaIdList():Vector.<String>
		{
			return _vaIdList;
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
