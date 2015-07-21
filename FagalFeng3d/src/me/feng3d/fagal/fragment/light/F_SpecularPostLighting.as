package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;

	/**
	 * 结算镜面反射光
	 * @author warden_feng 2014-11-7
	 */
	public function F_SpecularPostLighting():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);
		var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);

		//最终颜色寄存器（输出到oc寄存器的颜色）
		var finalColorReg:Register = requestRegister(Context3DBufferTypeID.FINALCOLOR_FT_4);
		//总漫反射颜色寄存器
		var totalSpecularColorReg:Register = requestRegister(Context3DBufferTypeID.TOTALSPECULARLIGHTCOLOR_FT_4);
		//材质镜面反射光数据 
		var _specularDataRegister:Register = requestRegister(Context3DBufferTypeID.SPECULARDATA_FC_VECTOR);
		//光泽纹理数据片段临时寄存器
		var specularTexData:Register = requestRegister(Context3DBufferTypeID.SPECULARTEXDATA_FT_4);


		//把阴影值使用到镜面反射上
		if (shaderParamsShadowMap.needsShadowRegister)
		{
			var shadowValueReg:Register = requestRegister(Context3DBufferTypeID.SHADOWVALUE_FT_4);
			mul(totalSpecularColorReg.xyz, totalSpecularColorReg, shadowValueReg.w);
		}

		if (shaderParamsLight.hasSpecularTexture)
		{
			mul(totalSpecularColorReg.xyz, totalSpecularColorReg, specularTexData.x);
		}

		//混合镜面反射光 = 镜面反射光颜色 mul 材质镜面反射颜色
		mul(totalSpecularColorReg.xyz, totalSpecularColorReg, _specularDataRegister);
		//添加到最终颜色中
		add(finalColorReg.xyz, finalColorReg, totalSpecularColorReg);

		removeTemp(totalSpecularColorReg);
	}
}
