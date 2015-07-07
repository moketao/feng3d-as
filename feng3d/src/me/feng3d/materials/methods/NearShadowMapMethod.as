package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDShadow;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.lights.shadowmaps.NearDirectionalShadowMapper;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2015-5-28
	 */
	public class NearShadowMapMethod extends SimpleShadowMapMethodBase
	{
		protected var secondaryFragmentConstants:Vector.<Number> = new Vector.<Number>(4);

		private var _baseMethod:SimpleShadowMapMethodBase;
		/**
		 * 阴影消退比例值
		 */
		private var _fadeRatio:Number;
		private var _nearShadowMapper:NearDirectionalShadowMapper;

		public function NearShadowMapMethod(baseMethod:SimpleShadowMapMethodBase, fadeRatio:Number = .1)
		{
			super(baseMethod.castingLight);
			_baseMethod = baseMethod;
			_fadeRatio = fadeRatio;
			_nearShadowMapper = _castingLight.shadowMapper as NearDirectionalShadowMapper;
			if (!_nearShadowMapper)
				throw new Error("NearShadowMapMethod requires a light that has a NearDirectionalShadowMapper instance assigned to shadowMapper.");
			_baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeIDShadow.SECONDARY_FC_VECTOR, FCVectorBuffer, updateSecondaryCommonData0Buffer);
		}

		override arcane function initConstants():void
		{
			super.initConstants();

			_baseMethod.initConstants();

			secondaryFragmentConstants[0] = 0;
			secondaryFragmentConstants[1] = 0;
			secondaryFragmentConstants[2] = 0;
			secondaryFragmentConstants[3] = 1;
		}

		protected function updateSecondaryCommonData0Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(secondaryFragmentConstants);
		}

		override arcane function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var near:Number = camera.lens.near;
			var d:Number = camera.lens.far - near;
			var maxDistance:Number = _nearShadowMapper.coverageRatio;
			var minDistance:Number = maxDistance * (1 - _fadeRatio);

			maxDistance = near + maxDistance * d;
			minDistance = near + minDistance * d;

			secondaryFragmentConstants[0] = minDistance;
			secondaryFragmentConstants[1] = 1 / (maxDistance - minDistance);

			super.setRenderState(renderable, camera);
			_baseMethod.setRenderState(renderable, camera);
		}

		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);
			shaderParamsShadowMap.needsProjection = true;

		}

		/**
		 * Called when the base method's shader code is invalidated.
		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			invalidateShaderProgram();
		}
	}
}
