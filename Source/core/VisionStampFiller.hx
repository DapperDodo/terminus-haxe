package core;

import interfaces.IVision;

class VisionStampFiller implements IVisionStampFiller
{
	public function new(){}

	public function fill(stamp : IVisionGrid, gridSize : Int) : Void
	{
		// fill up the stamp
		// one row at a time
		for(y in 0...gridSize)
		{
			var lFound : Bool = false;
			var l : Int = 0;
			var r : Int = 0;

			// first find left and right edges
			for(x in 0...gridSize)
			{
				if(stamp[x][y].value == IVision.Yes)
				{
					if(!lFound) 
					{
						lFound = true;
						l = x;
					}
					r = x;
				}
			}

			// now fill her up!
			for(x in l+1...r)
			{
				if(stamp[x][y].value == IVision.No)
				{
					stamp[x][y].value = IVision.Yes;
					stamp[x][y].shape = 511;
				}
			}
		}
	}
}