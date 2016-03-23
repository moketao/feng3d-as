package me.feng.objectView
{
	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.utils.ObjectAttributeUtils;
	import me.feng.objectView.base.utils.ObjectViewUtils;
	import me.feng.objectView.block.utils.ObjectAttributeBlockUtils;


	/**
	 * ObjectView配置
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfig
	{
		/**
		 * 设置自定义对象界面类定义
		 * @param object				指定对象类型
		 * @param viewClass				自定义对象界面类定义（该类必须是实现IObjectView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectViewClass(object:Object, viewClass:Object):void
		{
			objectViewUtils.setCustomObjectViewClass(object, viewClass);
		}

		/**
		 * 设置自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @param viewClass				自定义对象属性界面类定义（该类必须是实现IObjectAttributeView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectAttributeViewClass(owner:Object, attributeName:String, viewClass:Object):void
		{
			objectAttributeUtils.setCustomObjectAttributeViewClass(owner, attributeName, viewClass);
		}

		/**
		 * 设置所有特定类型属性的界面类定义
		 * @param attributeClass			特定属性类型
		 * @param viewClass					属性界面类
		 */
		public static function setAttributeViewClassByType(attributeClass:Class, viewClass:Class):void
		{
			objectAttributeUtils.setAttributeViewClassByType(attributeClass, viewClass);
		}

		/**
		 * 设置对象属性所在的属性块名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @param blockName			所在属性块名称
		 */
		public static function setObjectAttributeBlockName(owner:Object, attrName:String, blockName:String):void
		{
			objectAttributeBlockUtils.setObjectAttributeBlockName(owner, attrName, blockName);
		}

		/**
		 * 设置类配置
		 * @param cls
		 * @param config
		 */
		public static function setClassConfig(cls:Object, config:Object):void
		{
			if (config.view != null)
			{
				setCustomObjectViewClass(cls, config.view);
			}

			if (config.attributeDefinitions != null)
			{
				for (var i:int = 0; i < config.attributeDefinitions.length; i++)
				{
					setObjectAttributeBlockName(cls, config.attributeDefinitions[i].name, config.attributeDefinitions[i].block);
					setCustomObjectAttributeViewClass(cls, config.attributeDefinitions[i].name, config.attributeDefinitions[i].view);
				}
			}
		}

		public static function setGlobalConfig(config:Object):void
		{
			if (config.customObjectViews)
			{
				for (var i:int = 0; i < config.customObjectViews.length; i++)
				{

				}
			}
		}

		/**
		 * 对象界面工具
		 */
		private static function get objectViewUtils():ObjectViewUtils
		{
			return ObjectView.objectViewUtils;
		}

		/**
		 * 对象属性工具
		 */
		private static function get objectAttributeUtils():ObjectAttributeUtils
		{
			return ObjectView.objectAttributeUtils;
		}

		/**
		 * 对象属性块工具
		 */
		private static function get objectAttributeBlockUtils():ObjectAttributeBlockUtils
		{
			return ObjectView.objectAttributeBlockUtils;
		}
	}
}
