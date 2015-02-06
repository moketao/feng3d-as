package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 世界坐标输出函数
	 * @author warden_feng 2014-11-7
	 */
	public class V_WorldPositionOut extends FagalVertexMethod
	{
		[Register(regName = "globalPosition_vt_4", regType = "in", description = "顶点世界坐标")]
		public var positionSceneReg:Register;

		[Register(regName = "globalPos_v", regType = "out", description = "世界坐标变量")]
		public var globalPosVaryReg:Register;

		override public function runFunc():void
		{
			mov(globalPosVaryReg, positionSceneReg);
		}
	}
}
