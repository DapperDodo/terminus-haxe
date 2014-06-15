package core;

import openfl.geom.Rectangle;
import openfl.geom.Point;

import interfaces.IVision;

class VisionGridFactory
{
	private var tilesize : Int;

	public function new(tilesize : Int)
	{
		this.tilesize = tilesize;
	}

	public function instance(rows : Int, cols : Int) : IVisionGrid
	{
		var grid = new IVisionGrid();

		for(x in 0...cols)
		{
			grid[x] = new Array<IVisionTile>();
			for(y in 0...rows)
			{
				grid[x][y] = 
				{
					tx : x, 
					ty : y, 
					value : IVision.None, 
					rect : new Rectangle(x*tilesize, y*tilesize, tilesize, tilesize),
					point : new Point(x*tilesize, y*tilesize),
					seenShape : 0,
					fullShape : 0
				};
			}
		}

		return grid;
	}	
}