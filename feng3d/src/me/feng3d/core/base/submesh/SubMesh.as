package me.feng3d.core.base.submesh
{
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.data.AnimationSubGeometry;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.entities.Entity;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 子网格，可渲染对象
	 */
	public class SubMesh extends Context3DBufferOwner implements IRenderable
	{
		protected var _material:MaterialBase;
		protected var _parentMaterial:MaterialBase;
		protected var _parentMesh:Mesh;
		protected var _subGeometry:SubGeometry;
		arcane var _index:uint;

		private var _materialUsed:MaterialBase;

		private var _animator:IAnimator;

		private var _animationSubGeometry:AnimationSubGeometry;

		private var _context3dCache:Context3DCache;

		/**
		 * 创建一个子网格
		 * @param subGeometry 子几何体
		 * @param parentMesh 父网格
		 * @param material 材质
		 */
		public function SubMesh(subGeometry:SubGeometry, parentMesh:Mesh, material:MaterialBase = null)
		{
			this.parentMesh = parentMesh;
			this.subGeometry = subGeometry;
			this.material = material;

			_context3dCache = new Context3DCache()
			activateContext3DBuffer(_context3dCache);
		}

		public function get context3dCache():Context3DCache
		{
			return _context3dCache;
		}

		/**
		 * 使用中的材质
		 */
		public function get materialUsed():MaterialBase
		{
			return _materialUsed;
		}

		public function set materialUsed(value:MaterialBase):void
		{
			if (_materialUsed)
			{
				removeChildBufferOwner(_materialUsed);
			}
			_materialUsed = value;
			if (_materialUsed)
			{
				addChildBufferOwner(_materialUsed);
			}
		}

		/**
		 * 父材质
		 */
		arcane function get parentMaterial():MaterialBase
		{
			return _parentMaterial;
		}

		arcane function set parentMaterial(value:MaterialBase):void
		{
			if (_parentMaterial != value)
			{
				_parentMaterial = value;
				updateMaterial();
			}
		}

		/**
		 * 网格材质
		 */
		public function get material():MaterialBase
		{
			return _material;
		}

		public function set material(value:MaterialBase):void
		{
			if (_material != value)
			{
				_material = value;
				updateMaterial();
			}
		}

		/**
		 * 更新材质
		 */
		private function updateMaterial():void
		{
			materialUsed = _material ? _material : _parentMaterial;
		}

		/**
		 * 所属实体
		 */
		public function get sourceEntity():Entity
		{
			return _parentMesh;
		}

		/**
		 * 子网格
		 */
		public function get subGeometry():SubGeometry
		{
			return _subGeometry;
		}

		public function set subGeometry(value:SubGeometry):void
		{
			if (_subGeometry)
			{
				removeChildBufferOwner(_subGeometry);
			}
			_subGeometry = value;
			if (_subGeometry)
			{
				addChildBufferOwner(_subGeometry);
			}
		}

		/**
		 * 动画顶点数据(例如粒子特效的时间、位置偏移、速度等等)
		 */
		public function get animationSubGeometry():AnimationSubGeometry
		{
			return _animationSubGeometry;
		}

		public function set animationSubGeometry(value:AnimationSubGeometry):void
		{
			if (_animationSubGeometry)
			{
				removeChildBufferOwner(_animationSubGeometry);
			}
			_animationSubGeometry = value;
			if (_animationSubGeometry)
			{
				addChildBufferOwner(_animationSubGeometry);
			}
		}

		public function get animator():IAnimator
		{
			return _animator;
		}

		public function set animator(value:IAnimator):void
		{
			if (_animator)
			{
				removeChildBufferOwner(_animator);
				materialUsed.animationSet = null;
			}
			_animator = value;
			if (_animator)
			{
				addChildBufferOwner(_animator);
				materialUsed.animationSet = _animator.animationSet;
			}
		}

		/**
		 * 父网格
		 */
		arcane function get parentMesh():Mesh
		{
			return _parentMesh;
		}

		arcane function set parentMesh(value:Mesh):void
		{
			_parentMesh = value;
			parentMaterial = _parentMesh.material;
		}

		/**
		 * 渲染子网格
		 * @param stage3DProxy 
		 * @param camera			摄像机
		 */		
		public function render(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			if (!_parentMesh.visible)
				return;

			//初始化渲染参数
			context3dCache.shaderParams.init();

			materialUsed.activatePass(context3dCache.shaderParams, stage3DProxy, camera);
			//准备渲染时所需数据 与 设置渲染参数
			materialUsed.renderPass(this, stage3DProxy, camera);

			//绘制图形
			context3dCache.render(stage3DProxy.context3D);
		}

		public function dispose():void
		{
			material = null;
		}
	}
}
