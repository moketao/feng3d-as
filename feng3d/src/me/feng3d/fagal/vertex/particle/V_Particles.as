package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.fagal.methods.FagalVertexMethod;
	import me.feng3d.fagal.params.ParticleShaderParam;

	/**
	 * 粒子顶点渲染程序
	 * @author warden_feng 2014-11-14
	 */
	public class V_Particles extends FagalVertexMethod
	{
		/**
		 * 粒子渲染参数
		 */
		public function get particleShaderParam():ParticleShaderParam
		{
			return shaderParams.particleShaderParam;
		}

		override public function runFunc():void
		{
			//初始化
			if (particleShaderParam.changePosition > 0)
				call(V_ParticlesInit);

			//粒子颜色初始化
			if (particleShaderParam.changeColor > 0)
				call(V_ParticlesInitColor);

			//计算时间
			particleShaderParam.ParticleTimeLocalStatic && call(V_ParticlesTime);

			//粒子速度节点顶点渲染程序
			particleShaderParam.ParticleVelocityGlobal && call(V_ParticleVelocityGlobal);
			//计算速度
			particleShaderParam.ParticleVelocityLocalStatic && call(V_ParticleVelocity);

			//粒子缩放节点顶点渲染程序
			particleShaderParam.ParticleScaleGlobal && call(V_ParticleScaleGlobal);

			//使用广告牌 朝向照相机
			particleShaderParam.ParticleBillboardGlobal && call(V_ParticleBillboard);

			//粒子颜色节点顶点渲染程序
			if (particleShaderParam.changeColor > 0)
				call(V_ParticleColorGlobal);

			//结算坐标偏移
			if (particleShaderParam.changePosition > 0)
				call(V_ParticlePositionEnd);

			//结算颜色
			particleShaderParam.ParticleColorGlobal && call(V_ParticleColorEnd);
		}
	}
}
