package me.feng3d.passes
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;

	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.BlendFactorsBuffer;
	import me.feng3d.core.buffer.context3d.CullingBuffer;
	import me.feng3d.core.buffer.context3d.DepthTestBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.debug.Debug;
	import me.feng3d.errors.AbstractMethodError;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.fragment.F_Main;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.vertex.V_Main;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.materials.methods.ShaderMethodSetup;

	use namespace arcane;

	/**
	 * 生成与管理渲染程序
	 * （实现MaterialPassBase类的功能，说实话我并没有理解MaterialPassBase中Pass的意思）
	 * @author warden_feng 2014-4-15
	 */
	public class MaterialPassBase extends Context3DBufferOwner
	{
		protected var _animationSet:AnimationSetBase;

		protected var _methodSetup:ShaderMethodSetup;

		protected var _blendFactorSource:String = Context3DBlendFactor.ONE;
		protected var _blendFactorDest:String = Context3DBlendFactor.ZERO;

		protected var _depthCompareMode:String = Context3DCompareMode.LESS_EQUAL;
		protected var _enableBlending:Boolean;

		private var _bothSides:Boolean;

		protected var _lightPicker:LightPickerBase;

		protected var _defaultCulling:String = Context3DTriangleFace.BACK;

		protected var _writeDepth:Boolean = true;

		public var useVertex:Boolean = true;

		protected var _smooth:Boolean = true;
		protected var _repeat:Boolean = false;
		protected var _mipmap:Boolean = true;

		protected var _numDirectionalLights:uint;

		protected var _numPointLights:uint;

		public function MaterialPassBase()
		{
		}

		/**
		 *
		 * Defines whether smoothing should be applied to any used textures.
		 */
		public function get smooth():Boolean
		{
			return _smooth;
		}

		public function set smooth(value:Boolean):void
		{
			if (_smooth == value)
				return;
			_smooth = value;
			invalidateShaderProgram();
		}

		/**
		 * Defines whether textures should be tiled.
		 */
		public function get repeat():Boolean
		{
			return _repeat;
		}

		public function set repeat(value:Boolean):void
		{
			if (_repeat == value)
				return;
			_repeat = value;
			invalidateShaderProgram();
		}

		/**
		 * Defines whether any used textures should use mipmapping.
		 */
		public function get mipmap():Boolean
		{
			return _mipmap;
		}

		public function set mipmap(value:Boolean):void
		{
			if (_mipmap == value)
				return;
			_mipmap = value;
			invalidateShaderProgram();
		}

		public function get enableBlending():Boolean
		{
			return _enableBlending;
		}

		public function set enableBlending(value:Boolean):void
		{
			_enableBlending = value;
			markBufferDirty(Context3DBufferTypeID.BLEND_FACTORS);
			markBufferDirty(Context3DBufferTypeID.DEPTH_TEST);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.CULLING, CullingBuffer, updateCullingBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.BLEND_FACTORS, BlendFactorsBuffer, updateBlendFactorsBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.DEPTH_TEST, DepthTestBuffer, updateDepthTestBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.PROGRAM, ProgramBuffer, updateProgramBuffer);
		}

		/**
		 * 动画数据集合
		 */
		public function get animationSet():AnimationSetBase
		{
			return _animationSet;
		}

		public function set animationSet(value:AnimationSetBase):void
		{
			if (_animationSet == value)
				return;

			_animationSet = value;

			invalidateShaderProgram();
		}

		arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			shaderParams.useMipmapping = _mipmap;
			shaderParams.useSmoothTextures = _smooth;
			shaderParams.repeatTextures = _repeat;

			shaderParams.animationType = AnimationType.NONE;

			if (_animationSet)
				_animationSet.activate(shaderParams, stage3DProxy, this);
		}

		/**
		 * 更新动画状态
		 * @param renderable
		 * @param stage3DProxy
		 * @param camera
		 */
		arcane function updateAnimationState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			renderable.animator.setRenderState(renderable, stage3DProxy, camera);
		}

		/**
		 * 渲染
		 * @param renderable
		 * @param stage3DProxy
		 * @param camera
		 */
		arcane function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 标记渲染程序失效
		 * @param updateMaterial
		 */
		arcane function invalidateShaderProgram():void
		{
			markBufferDirty(Context3DBufferTypeID.PROGRAM);
		}

		protected function updateDepthTestBuffer(depthTestBuffer:DepthTestBuffer):void
		{
			depthTestBuffer.update(_writeDepth && !enableBlending, _depthCompareMode);
		}

		protected function updateBlendFactorsBuffer(blendFactorsBuffer:BlendFactorsBuffer):void
		{
			blendFactorsBuffer.update(_blendFactorSource, _blendFactorDest);
		}

		protected function updateCullingBuffer(cullingBuffer:CullingBuffer):void
		{
			cullingBuffer.update(_bothSides ? Context3DTriangleFace.NONE : _defaultCulling);
		}

		/**
		 * 更新（编译）渲染程序
		 */
		arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			//运行顶点渲染函数
			var vertexCode:String = runFagalMethod(V_Main);
			//运行片段渲染函数
			var fragmentCode:String = runFagalMethod(F_Main);

			if (Debug.agalDebug)
			{
				trace("Compiling AGAL Code:");
				trace("--------------------");
				trace(vertexCode);
				trace("--------------------");
				trace(fragmentCode);
			}

			//上传程序
			programBuffer.update(vertexCode, fragmentCode);
		}

		/**
		 * 灯光采集器
		 */
		arcane function get lightPicker():LightPickerBase
		{
			return _lightPicker;
		}

		arcane function set lightPicker(value:LightPickerBase):void
		{
			if (_lightPicker)
				_lightPicker.removeEventListener(Event.CHANGE, onLightsChange);
			_lightPicker = value;
			if (_lightPicker)
				_lightPicker.addEventListener(Event.CHANGE, onLightsChange);
			updateLights();
		}

		/**
		 * 灯光发生变化
		 */
		private function onLightsChange(event:Event):void
		{
			updateLights();
		}

		/**
		 * 更新灯光渲染
		 */
		protected function updateLights():void
		{
			if (_lightPicker)
			{
				_numPointLights = _lightPicker.numPointLights;
				_numDirectionalLights = _lightPicker.numDirectionalLights;
			}
			invalidateShaderProgram();
		}

		public function setBlendMode(value:String):void
		{
			switch (value)
			{
				case BlendMode.NORMAL:
					_blendFactorSource = Context3DBlendFactor.ONE;
					_blendFactorDest = Context3DBlendFactor.ZERO;
					enableBlending = false;
					break;
				case BlendMode.LAYER:
					_blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
					_blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					enableBlending = true;
					break;
				case BlendMode.MULTIPLY:
					_blendFactorSource = Context3DBlendFactor.ZERO;
					_blendFactorDest = Context3DBlendFactor.SOURCE_COLOR;
					enableBlending = true;
					break;
				case BlendMode.ADD:
					_blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
					_blendFactorDest = Context3DBlendFactor.ONE;
					enableBlending = true;
					break;
				case BlendMode.ALPHA:
					_blendFactorSource = Context3DBlendFactor.ZERO;
					_blendFactorDest = Context3DBlendFactor.SOURCE_ALPHA;
					enableBlending = true;
					break;
				case BlendMode.SCREEN:
					_blendFactorSource = Context3DBlendFactor.ONE;
					_blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					enableBlending = true;
					break;
				default:
					throw new ArgumentError("Unsupported blend mode!");
			}
		}

		/**
		 * 是否写入到深度缓存
		 */
		public function get writeDepth():Boolean
		{
			return _writeDepth;
		}

		public function set writeDepth(value:Boolean):void
		{
			_writeDepth = value;
			markBufferDirty(Context3DBufferTypeID.DEPTH_TEST);
		}

		/**
		 * 深度比较模式
		 */
		public function get depthCompareMode():String
		{
			return _depthCompareMode;
		}

		public function set depthCompareMode(value:String):void
		{
			_depthCompareMode = value;
			markBufferDirty(Context3DBufferTypeID.DEPTH_TEST);
		}

		/**
		 * 是否双面渲染
		 */
		public function get bothSides():Boolean
		{
			return _bothSides;
		}

		public function set bothSides(value:Boolean):void
		{
			_bothSides = value;
			markBufferDirty(Context3DBufferTypeID.CULLING);
		}

		/**
		 * Indicates whether the shader uses any lights.
		 */
		protected function usesLights():Boolean
		{
			return (_numPointLights > 0 || _numDirectionalLights > 0);
		}
	}
}
