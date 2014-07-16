package core;

import openfl.geom.Rectangle;
import openfl.geom.Point;

import interfaces.IVision;

class VisionGridFactory implements IVisionGridFactory
{
	public function new(){}

	public function instance(rows : Int, cols : Int, tilesize : Int) : IVisionGrid
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
					value : IVision.No, 
					rect : new Rectangle(x*tilesize, y*tilesize, tilesize, tilesize),
					point : new Point(x*tilesize, y*tilesize),
					shape : 0,
				};
			}
		}

		return grid;
	}	
}