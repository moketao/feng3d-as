package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;
	
	/**
	 * 粒子广告牌节点顶点渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public class V_ParticleBillboard extends FagalVertexMethod
	{
		[Register(regName = "particleBillboard_vc_matrix", regType = "uniform", description = "广告牌旋转矩阵(3个长度向量形式)")]
		public var particleBillboardMtx:Register;
		
		[Register(regName = "animatedPosition_vt_4", regType = "out", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;
		
		override public function runFunc():void
		{
			//使用广告牌 朝向照相机
			m33(animatedPosition.xyz, animatedPosition.xyz, particleBillboardMtx); //计算旋转
		}
	}
}