package me.feng3d.core.base
{
	import flash.utils.Dictionary;
	
	import me.feng.events.FEventDispatcher;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.buffer.context3d.Context3DBuffer;
	import me.feng3d.debug.assert;

	/**
	 * Context3D缓存拥有者
	 * @author warden_feng 2014-11-26
	 */
	public class Context3DBufferOwner extends FEventDispatcher implements IContext3DBufferOwner
	{
		private var _cacheDic:Dictionary;
		private var _bufferDic:Dictionary;

		private var children:Vector.<IContext3DBufferOwner> = new Vector.<IContext3DBufferOwner>();

		public function Context3DBufferOwner()
		{
			super(this);
			initBuffers();
		}

		/**
		 * 初始化Context3d缓存
		 */
		protected function initBuffers():void
		{

		}

		/**
		 * 添加子项缓存拥有者
		 * @param childBufferOwner
		 */
		public function addChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void
		{
			var index:int = children.indexOf(childBufferOwner);
			assert(index == -1, "不要重复添加子项缓存拥有者");
			children.push(childBufferOwner);

			//从子类中收集父类相关的缓存
			for (var context3dCache:* in cacheDic)
			{
				childBufferOwner.activateContext3DBuffer(context3dCache);
			}
		}

		/**
		 * 移除子项缓存拥有者
		 * @param childBufferOwner
		 */
		public function removeChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void
		{
			var index:int = children.indexOf(childBufferOwner);
			assert(index != -1, "无法移除不存在的子项缓存拥有者");
			children.splice(index, 1);

			//从子类中释放父类相关的缓存
			for (var context3dCache:* in cacheDic)
			{
				childBufferOwner.deActivateContext3DBuffer(context3dCache);
			}
		}

		/**
		 * 与拥有者关联的缓存字典
		 */
		private function get cacheDic():Dictionary
		{
			if (_cacheDic == null)
				_cacheDic = new Dictionary();
			return _cacheDic;
		}

		public function get bufferDic():Dictionary
		{
			if (_bufferDic == null)
				_bufferDic = new Dictionary();
			return _bufferDic;
		}

		/**
		 * 标记Context3d缓存脏了
		 * @param dataTypeId
		 */
		public function markBufferDirty(dataTypeId:String):void
		{
			var context3DBuffer:Context3DBuffer = bufferDic[dataTypeId];
			context3DBuffer.invalid();
		}

		public function mapContext3DBuffer(dataTypeId:String, bufferCls:Class, updateFunc:Function):void
		{
			var context3DBuffer:Context3DBuffer = new bufferCls(dataTypeId, updateFunc);
			bufferDic[dataTypeId] = context3DBuffer;
			addContext3DBuffer(context3DBuffer);
		}

		/**
		 * 添加Context3dBuffer到已关联的所有Context3DCache中
		 * @param context3DBuffer context3D缓存
		 */
		public function addContext3DBuffer(context3DBuffer:Context3DBuffer):void
		{
			for (var context3dCache:* in cacheDic)
			{
				context3dCache.addDataBuffer(context3DBuffer);
			}
		}

		public function activateContext3DBuffer(context3dCache:Context3DCache):void
		{
			var result:uint = cacheDic[context3dCache];
			if (result == 0)
			{
				for each (var context3DBuffer:Context3DBuffer in bufferDic)
				{
					context3dCache.addDataBuffer(context3DBuffer);
				}
			}
			cacheDic[context3dCache] = result + 1;

			//子项继承
			for each (var bufferOwner:Context3DBufferOwner in children)
			{
				bufferOwner.activateContext3DBuffer(context3dCache);
			}
		}

		public function deActivateContext3DBuffer(context3dCache:Context3DCache):void
		{
			var result:uint = cacheDic[context3dCache];
			if (result == 0)
			{
				throw new Error("不存在对应的缓存");
			}
			cacheDic[context3dCache] = result - 1;
			if (result == 1)
			{
				for each (var context3dBuffer:Context3DBuffer in bufferDic)
				{
					context3dCache.removeDataBuffer(context3dBuffer);
				}
				delete cacheDic[context3dCache];
			}

			//子项继承
			for each (var bufferOwner:Context3DBufferOwner in children)
			{
				bufferOwner.deActivateContext3DBuffer(context3dCache);
			}
		}
	}
}
