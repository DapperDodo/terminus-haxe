package core;

import interfaces.IVision;

class VisionStampOutliner implements IVisionStampOutliner
{
	var visionEdgeShaper : IVisionEdgeShaper;

	public function new(visionEdgeShaper : IVisionEdgeShaper)
	{
		this.visionEdgeShaper = visionEdgeShaper;
	}

	public function draw(radiusGrid : IVisionGrid, gridCenter : Int, radius : Float, tilesize : Int) : Void
	{
		// find the circle's edge
		var radiusInt = Math.round(radius / tilesize);

		var x : Int = radiusInt;
		var y : Int = 0;

		var radiusError : Int = 1-x;
		
		var straightPrev : Bool = true;

		while(x >= y)
		{
			var straightNext : Bool = radiusError<0;

			octants(radiusGrid, x, y, gridCenter, straightPrev, straightNext);

			y++;
			if (radiusError<0)
			{
				straightPrev = true;
				radiusError += 2 * y + 1;
			} 
			else 
			{
				x--;
				straightPrev = false;
				radiusError+= 2 * (y - x + 1);
			}
		}
	}

	////////////////////////////////
	// private parts
	////////////////////////////////

	private function octants(radiusGrid : IVisionGrid, x : Int, y : Int, gridCenter : Int, straightPrev : Bool, straightNext : Bool)
	{
		//     6 7
		//   5     8
		//   4     1
		//     3 2
		// mark edge tiles for all 8 octants
		octant(radiusGrid,  x + gridCenter,  y + gridCenter, straightPrev, straightNext, 1);
		octant(radiusGrid,  y + gridCenter,  x + gridCenter, straightPrev, straightNext, 2);
		octant(radiusGrid, -y + gridCenter,  x + gridCenter, straightPrev, straightNext, 3);
		octant(radiusGrid, -x + gridCenter,  y + gridCenter, straightPrev, straightNext, 4);
		octant(radiusGrid, -x + gridCenter, -y + gridCenter, straightPrev, straightNext, 5);
		octant(radiusGrid, -y + gridCenter, -x + gridCenter, straightPrev, straightNext, 6);
		octant(radiusGrid,  y + gridCenter, -x + gridCenter, straightPrev, straightNext, 7);
		octant(radiusGrid,  x + gridCenter, -y + gridCenter, straightPrev, straightNext, 8);
	}

	private function octant(radiusGrid : IVisionGrid, x : Int, y : Int, straightPrev : Bool, straightNext : Bool, octant : Int)
	{
		radiusGrid[x][y].value = IVision.Yes;
		radiusGrid[x][y].shape = visionEdgeShaper.getShape(straightPrev, straightNext, octant);
	}
}