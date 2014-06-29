package head;

import openfl.display.BitmapData;

import interfaces.IVision;
import interfaces.IFog;

class FogMaskCache implements IFogMaskFactory
{
	private var tilesize : Int;
	private var fogMaskFactory : IFogMaskFactory;

	private var cache : Map<IVisionTileShape, BitmapData>;
	private var cachesize : Int;

	public function new(tilesize : Int, fogMaskFactory : IFogMaskFactory)
	{
		this.tilesize = tilesize;
		this.fogMaskFactory = fogMaskFactory;

		cache = new Map<IVisionTileShape, BitmapData>();
		cachesize = 0;
	}

	public function instance(shape : IVisionTileShape) : BitmapData
	{
		if(!cache.exists(shape))
		{
			cache.set(shape, loadMask(shape));
			cachesize++;
			//trace("new fogmask (#" + cachesize + ") for shape " + shape);
		}
		return cache.get(shape);
	}

	//////////////////////////////
	// private parts
	//////////////////////////////

	private function loadMask(shape : IVisionTileShape)
	{
		return fogMaskFactory.instance(shape);
	}
}