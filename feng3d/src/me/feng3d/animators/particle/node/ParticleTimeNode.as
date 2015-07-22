package me.feng3d.animators.particle.node
{
	import me.feng3d.arcane;
	import me.feng3d.animators.particle.data.ParticleProperties;
	import me.feng3d.animators.particle.data.ParticlePropertiesMode;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 粒子时间节点
	 * @author warden_feng 2014-11-17
	 */
	public class ParticleTimeNode extends ParticleNodeBase
	{
		override public function get vaId():String
		{
			return Context3DBufferTypeID.PARTICLETIME_VA_4;
		}

		override public function get vaLen():uint
		{
			return 4;
		}

		/**
		 * 创建一个粒子时间节点
		 * @param usesDuration	是否持续
		 * @param usesLooping	是否延时
		 * @param usesDelay		是否循环
		 */
		public function ParticleTimeNode()
		{
			super("ParticleTime", ParticlePropertiesMode.LOCAL_STATIC, 4, 0);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function generatePropertyOfOneParticle(param:ParticleProperties):void
		{
			_oneData[0] = param.startTime;
			_oneData[1] = param.duration;
			_oneData[2] = param.delay + param.duration;
			_oneData[3] = 1 / param.duration;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function processAnimationSetting(shaderParam:ShaderParams):void
		{
			shaderParam[animationName] = true;
		}
	}
}
