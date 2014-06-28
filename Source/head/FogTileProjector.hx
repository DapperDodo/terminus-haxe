package head;

import openfl.display.BitmapData;

import interfaces.IVision;
import interfaces.IFog;

class FogTileProjector implements IFogTileProjector
{
	private var tilesize : Int;
	private var fogMaskFactory : IFogMaskFactory;

	public function new(tilesize : Int, fogMaskFactory : IFogMaskFactory)
	{
		this.tilesize = tilesize;
		this.fogMaskFactory = fogMaskFactory;
	}

	public function bake(tile : IVisionTile, dest : BitmapData, base : BitmapData) : Void
	{
		dest.copyPixels(base, tile.rect, tile.point);
	}

	public function bakeEdge(tile : IVisionTile, dest : BitmapData, base : BitmapData, layer : BitmapData) : Void
	{
		// get a mask for this tile's shape
		var mask : BitmapData = fogMaskFactory.instance(tile.seenShape);

		// and apply it
		// TODO: optimize the fuck out of this
		for(x in 0...tilesize)
		{
			for(y in 0...tilesize)
			{
				var scrX : Int = Math.round(x+tile.point.x);
				var scrY : Int = Math.round(y+tile.point.y);
				var colorBase : UInt = base.getPixel32(scrX, scrY);
				var colorLayer : UInt = layer.getPixel32(scrX, scrY);
				var colorMask : UInt = mask.getPixel32(x,y);
				var color : UInt = mergePixel(colorBase, colorLayer, colorMask);
				dest.setPixel32(scrX, scrY, color);
			}
		}
	}

	/////////////////////////
	// private parts
	/////////////////////////

	private function mergePixel(basePixel : UInt, overlayPixel : UInt, maskPixel : UInt) : UInt
	{
		var bR : UInt = (basePixel >> 16) & 255;
		var bG : UInt = (basePixel >>  8) & 255;
		var bB : UInt =  basePixel        & 255;

		var oR : UInt = (overlayPixel >> 16) & 255;
		var oG : UInt = (overlayPixel >>  8) & 255;
		var oB : UInt =  overlayPixel        & 255;

		var mA : UInt = (maskPixel >> 24) & 255;

		var rR : UInt = mergeChannel(bR, oR, mA);
		var rG : UInt = mergeChannel(bG, oG, mA);
		var rB : UInt = mergeChannel(bB, oB, mA);

		return ((255 << 24) | (rR << 16) | (rG << 8) | rB);
	}

	private function mergeChannel(base : UInt, over : UInt, mask : UInt) : UInt
	{
		var fBase : Float = base / 255;
		var fOver : Float = over / 255;
		var fMask : Float = mask / 255;

		var fMerg : Float = (fBase * (1 - fMask)) + (fOver * fMask);

		return Math.round(fMerg * 255);
	}
}