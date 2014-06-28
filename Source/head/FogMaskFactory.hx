package head;

import openfl.display.BitmapData;

import interfaces.IFog;

class FogMaskFactory implements IFogMaskFactory
{
	private var cache : Map<Int, BitmapData>;
	private var cachesize : Int;
	private var tilesize : Int;

	public function new(tilesize : Int)
	{
		this.tilesize = tilesize;
		cache = new Map<Int, BitmapData>();
		cachesize = 0;
	}

	public function instance(shape : Int) : BitmapData
	{
		if(!cache.exists(shape))
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
			cache.set(shape, mask);
			cachesize++;
			//trace("new fogmask (#" + cachesize + ") for shape " + shape);
		}
		return cache.get(shape);
	}

	//////////////////////////////
	// private parts
	//////////////////////////////
	
	private function bitIsSet(x : Int, y : Int, shape : Int) : Bool
	{
		var oneThird : Int = Math.round((tilesize / 3));
		var twoThird : Int = Math.round(2 * (tilesize / 3));

		if(y < oneThird)
		{
			// top row
			if(x < oneThird)
			{
				// top left
				return getBit(0, shape);
			}
			else if(x >= oneThird && x < twoThird)
			{
				// top center
				return getBit(1, shape);
			}
			else
			{
				// top right
				return getBit(2, shape);
			}
		}
		else if(y >= oneThird && y < twoThird)
		{
			// mid row
			if(x < oneThird)
			{
				// mid left
				return getBit(3, shape);
			}
			else if(x >= oneThird && x < twoThird)
			{
				// mid center
				return getBit(4, shape);
			}
			else
			{
				// mid right
				return getBit(5, shape);
			}
		}
		else
		{
			// bottom row
			if(x < oneThird)
			{
				// bottom left
				return getBit(6, shape);
			}
			else if(x >= oneThird && x < twoThird)
			{
				// bottom center
				return getBit(7, shape);
			}
			else
			{
				// bottom right
				return getBit(8, shape);
			}
		}
	}

	private function getBit(idx : Int, shape : Int) : Bool
	{
		if(((shape >> idx) & 1) == 1)
		{
			// trace("getBit [" + idx + "] from shape [" + shape + "] is TRUE");
			return true;
		}
		else
		{
			// trace("getBit [" + idx + "] from shape [" + shape + "] is FALSE");
			return false;
		}
	}
}