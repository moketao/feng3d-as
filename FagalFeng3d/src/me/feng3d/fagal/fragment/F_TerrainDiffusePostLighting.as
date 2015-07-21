package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterVector;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsTerrain;

	/**
	 * 地形渲染函数
	 * @author warden_feng 2014-11-6
	 */
	public function F_TerrainDiffusePostLighting():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsTerrain:ShaderParamsTerrain = shaderParams.getComponent(ShaderParamsTerrain.NAME);
		var numSplattingLayers:int = shaderParamsTerrain.splatNum;

		//土壤纹理列表
		var splatFsarr:RegisterVector = requestRegisterVector(Context3DBufferTypeID.TERRAINTEXTURES_FS_ARRAY, numSplattingLayers);
		//片段程序的纹理
		var defaultFsReg:Register = requestRegister(Context3DBufferTypeID.TEXTURE_FS);
		//uv变量数据
		var uvVarying:Register = requestRegister(Context3DBufferTypeID.UV_V);
		//混合纹理
		var blendingFsReg:Register = requestRegister(Context3DBufferTypeID.BLENDINGTEXTURE_FS);
		//地形常量
		var scaleRegister:Register = requestRegister(Context3DBufferTypeID.TILE_FC_VECTOR);
		//最终颜色寄存器（输出到oc寄存器的颜色）
		var finalColorReg:Register = requestRegister(Context3DBufferTypeID.FINALCOLOR_FT_4);

		//缩放后的uv坐标、uv计算后的颜色值
		var uvTemp:Register = getFreeTemp("缩放后的uv坐标");
		//混合比例（4个分量表示4个纹理所占比重）
		var blendTemp:Register = getFreeTemp("混合比例");

		mul(uvTemp, uvVarying, scaleRegister.c(0)); // 缩放uv （表示将重复x*x遍） x=scaleRegister.c(0)

		tex(finalColorReg, uvTemp, defaultFsReg); // 使用默认贴图 得到默认颜色值
		tex(blendTemp, uvVarying, blendingFsReg); // 计算混合纹理

		for (var i:int = 0; i < numSplattingLayers; ++i)
		{
			mul(uvTemp, uvVarying, scaleRegister.c(i + 1)); //  缩放uv （表示将重复x*x遍） x=scaleRegister.c(i + 1)
			tex(uvTemp, uvTemp, splatFsarr.getReg(i)); // 使用地面纹理 得到该纹理颜色值

			sub(uvTemp, uvTemp, finalColorReg); // uvtemp = uvtemp - targetreg; --------------1
			mul(uvTemp, uvTemp, blendTemp.c(i)); // uvtemp = uvtemp * blendtemp; ----------2  (0 <= blendtemp <= 1)
			add(finalColorReg, finalColorReg, uvTemp); // 添加到默认颜色值上  targetreg = targetreg + uvtemp; ------------3
				//由 1代入2得		uvtemp = (uvtemp - targetreg) * blendtemp; ----------------4
				//由 4代入3得		targetreg = targetreg + (uvtemp - targetreg) * blendtemp; -------------------5
				//整理5得			targetreg = targetreg * (1 - blendtemp) + uvtemp * blendtemp; (0 <= blendtemp <= 1) -----------------6 
				//公式6很容易看出是平分公式，由此得 引用1、2、3的渲染代码是为了节约变量与计算次数的平分运算。(至少节约1个变量与一次运算)
		}
	}
}
