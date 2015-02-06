package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.methods.FagalVertexMethod;


	/**
	 * 天空盒顶点渲染程序
	 * @author warden_feng 2014-11-4
	 */
	public class V_SkyBox extends FagalVertexMethod
	{
		[Register(regName = "position_va_3", regType = "in", description = "顶点坐标数据")]
		public var position:Register;

		[Register(regName = "uv_v", regType = "out", description = "uv变量数据")]
		public var uv_v:Register;

		[Register(regName = "projection_vc_matrix", regType = "uniform", description = "顶点程序投影矩阵静态数据")]
		public var projection:RegisterMatrix;

		[Register(regName = "camerapos_vc_vector", regType = "uniform", description = "照相机位置静态数据")]
		public var camerapos:Register;

		[Register(regName = "scaleSkybox_vc_vector", regType = "uniform", description = "天空盒缩放静态数据")]
		public var scaleSkybox:Register;

		[Register(regName = "op", regType = "out", description = "位置输出寄存器")]
		public var out:Register;

		override public function runFunc():void
		{
			var vt0:Register = getFreeTemp("缩放后的顶点坐标");
			comment("缩放到天空盒应有的大小");
			mul(vt0, position, scaleSkybox);
			comment("把天空盒中心放到照相机位置");
			add(vt0, vt0, camerapos);
			comment("投影天空盒坐标");
			m44(out, vt0, projection)
			comment("占坑用的，猜的");
			mov(uv_v, position);
		}
	}
}
