package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsParticle;

	/**
	 * 粒子片段渲染程序
	 * @author warden_feng 2015-1-21
	 */
	public function F_Particles():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		/** 粒子渲染参数 */
		var particleShaderParam:ShaderParamsParticle = shaderParams.getComponent(ShaderParamsParticle.NAME);
		if (particleShaderParam.ParticleColorGlobal)
		{
			F_ParticleColorCombination();
		}

	}
}