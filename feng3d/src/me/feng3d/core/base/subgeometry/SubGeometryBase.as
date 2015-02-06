package me.feng3d.core.base.subgeometry
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.VertexBufferOwner;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.IndexBuffer;

	use namespace arcane;

	/**
	 * 子网格基类
	 * @author warden_feng 2015-1-14
	 */
	public class SubGeometryBase extends VertexBufferOwner
	{
		protected var _indices:Vector.<uint>;

		protected var _numIndices:uint;
		protected var _numTriangles:uint;

		public function SubGeometryBase()
		{
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.INDEX, IndexBuffer, updateIndexBuffer);
			mapVABuffer(Context3DBufferTypeID.POSITION_VA_3, 3);
		}

		/**
		 * 更新索引数据
		 * @param indexBuffer 索引缓存
		 */
		protected function updateIndexBuffer(indexBuffer:IndexBuffer):void
		{
			indexBuffer.update(indices, numIndices, numIndices);
		}

		/**
		 * 可绘制三角形的个数
		 */
		public function get numTriangles():uint
		{
			return _numTriangles;
		}

		public function dispose():void
		{
			_indices = null;
		}

		/**
		 * 顶点索引数据
		 */
		public function get indexData():Vector.<uint>
		{
			if (_indices == null)
				_indices = new Vector.<uint>();
			return _indices;
		}

		/**
		 * 索引数量
		 */
		public function get numIndices():uint
		{
			return _numIndices;
		}

		/**
		 * 索引数据
		 */
		public function get indices():Vector.<uint>
		{
			return _indices;
		}

		/**
		 * 更新顶点索引数据
		 */
		public function updateIndexData(indices:Vector.<uint>):void
		{
			_indices = indices;
			_numIndices = indices.length;

			var numTriangles:int = _numIndices / 3;
			_numTriangles = numTriangles;

			markBufferDirty(Context3DBufferTypeID.INDEX);
		}

		/**
		 * 缩放网格尺寸
		 */
		public function scale(scale:Number):void
		{
			var vertices:Vector.<Number> = getVAData(Context3DBufferTypeID.POSITION_VA_3);
			var len:uint = vertices.length;
			var stride:int = getVALen(Context3DBufferTypeID.POSITION_VA_3);

			for (var i:uint = 0; i < len; i += stride)
			{
				vertices[i] *= scale;
				vertices[i + 1] *= scale;
				vertices[i + 2] *= scale;
			}
			markBufferDirty(Context3DBufferTypeID.POSITION_VA_3);
		}

	}
}
