package head;

import openfl.display.BitmapData;

import interfaces.IVision;
import interfaces.IFog;
import interfaces.IBit;

class FogMaskGenerator implements IFogMaskFactory
{
	private var tilesize : Int;
	private var bitHelper : IBitHelper;

	public function new(tilesize : Int, bitHelper : IBitHelper)
	{
		this.tilesize = tilesize;
		this.bitHelper = bitHelper;
	}

	public function instance(shape : IVisionTileShape) : BitmapData
	{
		var mask : BitmapData = new BitmapData(tilesize, tilesize, true, 0xFFFFFFFF);
		mask.lock();
		for (x in 0...tilesize)
		{
			for (y in 0...tilesize)
			{
				if(bitIsSet(x, y, shape))
				{
					mask.setPixel32(x, y, 0);
				}
			}
		}
		mask.unlock();
		return mask;
	}

	//////////////////////////////
	// private parts
	//////////////////////////////

	private function bitIsSet(x : Int, y : Int, shape : IVisionTileShape) : Bool
	{
		var oneThird : Int = Math.round((tilesize / 3));
		var twoThird : Int = Math.round(2 * (tilesize / 3));

		if(y < oneThird)
		{
			// top row
			if(x < oneThird)
			{
				// top left
				return bitHelper.getBitBool(shape, 0);
			}
			else if(x >= oneThird && x < twoThird)
			{
				// top center
				return bitHelper.getBitBool(shape, 1);
			}
			else
			{
				// top right
				return bitHelper.getBitBool(shape, 2);
			}
		}
		else if(y >= oneThird && y < twoThird)
		{
			// mid row
			if(x < oneThird)
			{
				// mid left
				return bitHelper.getBitBool(shape, 3);
			}
			else if(x >= oneThird && x < twoThird)
			{
				// mid center
				return bitHelper.getBitBool(shape, 4);
			}
			else
			{
				// mid right
				return bitHelper.getBitBool(shape, 5);
			}
		}
		else
		{
			// bottom row
			if(x < oneThird)
			{
				// bottom left
				return bitHelper.getBitBool(shape, 6);
			}
			else if(x >= oneThird && x < twoThird)
			{
				// bottom center
				return bitHelper.getBitBool(shape, 7);
			}
			else
			{
				// bottom right
				return bitHelper.getBitBool(shape, 8);
			}
		}
	}
}