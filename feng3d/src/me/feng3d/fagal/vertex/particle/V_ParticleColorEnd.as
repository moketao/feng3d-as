package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;


	/**
	 * 粒子颜色变化结算顶点渲染程序
	 * @author warden_feng 2015-1-20
	 */
	public class V_ParticleColorEnd extends FagalVertexMethod
	{
		[Register(regName = "particleColorMultiplier_vt_4", regType = "in", description = "粒子颜色乘数因子，用于乘以纹理上的颜色值")]
		public var colorMulTarget:Register;

		[Register(regName = "particleColorOffset_vt_4", regType = "in", description = "粒子颜色偏移值，在片段渲染的最终颜色值上偏移")]
		public var colorAddTarget:Register;

		[Register(regName = "particleColorMultiplier_v", regType = "out", description = "粒子颜色乘数因子，用于乘以纹理上的颜色值")]
		public var colorMulVary:Register;

		[Register(regName = "particleColorOffset_v", regType = "out", description = "粒子颜色偏移值，在片段渲染的最终颜色值上偏移")]
		public var colorAddVary:Register;

		override public function runFunc():void
		{
//			if (hasColorMulNode)
			mov(colorMulVary, colorMulTarget);
//			if (hasColorAddNode)
			mov(colorAddVary, colorAddTarget);
		}
	}
}
