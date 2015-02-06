package me.feng3d.animators
{

	/**
	 * 动画类型
	 * @author warden_feng 2015-1-27
	 */
	public class AnimationType
	{
		/** 没有动画 */
		public static const NONE:String = "NONE";

		/** 顶点动画由GPU计算 */
		public static const VERTEX_CPU:String = "VERTEX_CPU";

		/** 顶点动画由GPU计算 */
		public static const VERTEX_GPU:String = "VERTEX_GPU";

		/** 骨骼动画由GPU计算 */
		public static const SKELETON_CPU:String = "SKELETON_CPU";

		/** 骨骼动画由GPU计算 */
		public static const SKELETON_GPU:String = "SKELETON_GPU";

		/** 粒子特效 */
		public static const PARTICLE:String = "PARTICLE";
	}
}
