package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.fragment.light.F_DiffusePostLighting;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 基础漫反射函数
	 * @author warden_feng 2014-7-1
	 */
	public class BasicDiffuseMethod extends LightingMethodBase
	{
		/** 漫反射纹理 */
		protected var _texture:Texture2DBase;

		private var _diffuseColor:uint = 0xffffff;

		/** 漫反射颜色数据RGBA */
		private const diffuseInputData:Vector.<Number> = new Vector.<Number>(4);

		/** 是否使用环境光材质 */
		private var _useAmbientTexture:Boolean;

		private var _isFirstLight:Boolean;

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.texture_fs, updateTextureBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.diffuseInput_fc_vector, updateDiffuseInputBuffer);
		}

		/** 漫反射颜色 */
		public function get diffuseColor():uint
		{
			return _diffuseColor;
		}

		public function set diffuseColor(diffuseColor:uint):void
		{
			_diffuseColor = diffuseColor;
			updateDiffuse();
		}

		/**
		 * 更新漫反射值
		 */
		private function updateDiffuse():void
		{
			diffuseInputData[0] = ((_diffuseColor >> 16) & 0xff) / 0xff;
			diffuseInputData[1] = ((_diffuseColor >> 8) & 0xff) / 0xff;
			diffuseInputData[2] = (_diffuseColor & 0xff) / 0xff;
		}

		/** 漫反射alpha */
		public function get diffuseAlpha():Number
		{
			return diffuseInputData[3];
		}

		public function set diffuseAlpha(value:Number):void
		{
			diffuseInputData[3] = value;
		}

		/**
		 * 更新纹理缓冲
		 */
		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(texture);
		}

		/**
		 * 更新漫反射输入片段常量缓冲
		 */
		private function updateDiffuseInputBuffer(diffuseInputBuffer:FCVectorBuffer):void
		{
			diffuseInputBuffer.update(diffuseInputData);
		}

		/**
		 * 漫反射纹理
		 */
		public function get texture():Texture2DBase
		{
			return _texture;
		}

		public function set texture(value:Texture2DBase):void
		{
			if (Boolean(value) != Boolean(_texture) || (value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format)))
			{
				invalidateShaderProgram();
			}

			_texture = value;

			markBufferDirty(Context3DBufferTypeID.texture_fs);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			shaderParams.needsUV += texture ? 1 : 0;
			shaderParams.needsNormals += shaderParams.numLights > 0 ? 1 : 0;

			shaderParams.hasDiffuseTexture = _texture != null;
			shaderParams.usingDiffuseMethod += 1;

			shaderParams.diffuseMethod = F_DiffusePostLighting;

			shaderParams.addSampleFlags(Context3DBufferTypeID.texture_fs, _texture);
		}

		/**
		 * @inheritDoc
		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{
			var diff:BasicDiffuseMethod = BasicDiffuseMethod(method);
			texture = diff.texture;
			diffuseAlpha = diff.diffuseAlpha;
			diffuseColor = diff.diffuseColor;
		}
	}
}
