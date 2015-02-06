package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.TextureFlag;
	import me.feng3d.fagal.fragment.F_TerrainDiffusePostLighting;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 地形渲染函数
	 * @author warden_feng 2014-7-16
	 */
	public class TerrainDiffuseMethod extends BasicDiffuseMethod
	{
		private const tileData:Vector.<Number> = new Vector.<Number>(4);
		private var _blendingTexture:Texture2DBase;
		private var _splats:Array;
		private var _numSplattingLayers:uint;

		public function TerrainDiffuseMethod(splatTextures:Array, blendingTexture:Texture2DBase, tileData:Vector.<Number>)
		{
			super();

			splats = splatTextures;

			for (var i:int = 0; i < this.tileData.length && i < tileData.length; i++)
			{
				this.tileData[i] = tileData[i];
			}

			this.blendingTexture = blendingTexture;
			_numSplattingLayers = splats.length;
			if (_numSplattingLayers > 4)
				throw new Error("More than 4 splatting layers is not supported!");
		}

		public function get splats():Array
		{
			return _splats;
		}

		public function set splats(value:Array):void
		{
			_splats = value;
			markBufferDirty(Context3DBufferTypeID.TERRAINTEXTURES_FS);
		}

		public function get blendingTexture():Texture2DBase
		{
			return _blendingTexture;
		}

		public function set blendingTexture(value:Texture2DBase):void
		{
			_blendingTexture = value;
			markBufferDirty(Context3DBufferTypeID.BLENDINGTEXTURE_FS);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.BLENDINGTEXTURE_FS, FSBuffer, updateBlendingTextureBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.TERRAINTEXTURES_FS, FSArrayBuffer, updateTerrainTextureBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.TILE_FC_VECTOR, FCVectorBuffer, updateTileDataBuffer);
		}

		private function updateTerrainTextureBuffer(terrainTextureBufferArr:FSArrayBuffer):void
		{
			terrainTextureBufferArr.update(splats);
		}

		private function updateTileDataBuffer(tileDataBuffer:FCVectorBuffer):void
		{
			tileDataBuffer.update(tileData);
		}

		private function updateBlendingTextureBuffer(nBlendingTextureBuffer:FSBuffer):void
		{
			nBlendingTextureBuffer.update(blendingTexture);
		}

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{
			super.activate(shaderParams, stage3DProxy);

			shaderParams.splatNum = _numSplattingLayers;

			shaderParams.addSampleFlags(Context3DBufferTypeID.TEXTURE_FS, texture, TextureFlag.MODE_WRAP);
			shaderParams.addSampleFlags(Context3DBufferTypeID.TERRAINTEXTURES_FS, splats[0], TextureFlag.MODE_WRAP);
			shaderParams.addSampleFlags(Context3DBufferTypeID.BLENDINGTEXTURE_FS, blendingTexture);

			shaderParams.diffuseMethod = F_TerrainDiffusePostLighting;
		}
	}
}
