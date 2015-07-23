package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 顶点动画渲染程序(CPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationCPU():void
	{
		var animatedPosition:Register = requestRegister(Context3DBufferTypeID.animatedPosition_vt_4);
		var position:Register = requestRegister(Context3DBufferTypeID.position_va_3);

		mov(animatedPosition, position);
	}
}
