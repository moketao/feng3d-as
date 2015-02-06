package me.feng3d.fagal.fragment
{
	import me.feng3d.fagal.fragment.light.F_Ambient;
	import me.feng3d.fagal.fragment.light.F_DirectionalLight;
	import me.feng3d.fagal.fragment.light.F_PointLight;
	import me.feng3d.fagal.fragment.light.F_SpecularPostLighting;
	import me.feng3d.fagal.fragment.particle.F_Particles;
	import me.feng3d.fagal.methods.FagalFragmentMethod;

	/**
	 * 片段渲染程序主入口
	 * @author warden_feng 2014-10-30
	 */
	public class F_Main extends FagalFragmentMethod
	{
		override public function runFunc():void
		{
			if (shaderParams.needsNormals)
				if (shaderParams.hasNormalTexture)
					call(F_TangentNormalMap);
				else
					call(F_TangentNormalNoMap);

			if (shaderParams.hasSpecularTexture)
				call(F_SpecularSample);

			if (shaderParams.needsViewDir)
				call(F_ViewDir);

			if (shaderParams.numDirectionalLights)
				call(F_DirectionalLight);
			if (shaderParams.numPointLights)
				call(F_PointLight);

			if (shaderParams.usingDiffuseMethod)
				call(shaderParams.diffuseMethod);

			if (shaderParams.numLights > 0)
			{
				if (shaderParams.usingSpecularMethod)
					call(F_SpecularPostLighting);
				call(F_Ambient);
			}
			
			//调用粒子相关片段渲染程序
			if(shaderParams.particleShaderParam != null)
			{
				call(F_Particles);
			}

			call(F_FinalOut);
		}
	}
}
