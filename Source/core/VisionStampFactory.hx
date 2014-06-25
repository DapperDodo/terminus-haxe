package core;

import interfaces.IVision;

class VisionStampFactory implements IVisionStampFactory
{
	private var visionGridFactory : IVisionGridFactory;

	private var cache : Map<String, IVisionGrid>;

	public function new(visionGridFactory : IVisionGridFactory)
	{
		this.visionGridFactory = visionGridFactory;

		cache = new Map<String, IVisionGrid>();
	}

	public function instance(radius : Float, tilesize : Int) : IVisionGrid
	{
		var id : String = getID(radius);

		if(!cache.exists(id))
		{
			cache.set(id, newVisionStamp(radius, tilesize));	
		}

		return cache.get(id);
	}

	/////////////////////////////////////////////////////////////
	// private parts
	/////////////////////////////////////////////////////////////

	/*
		make an id (hash) as a key for our cache map
	*/
	private function getID(radius : Float) : String
	{
		return Std.string(Math.round(radius));
	}

	/*
		instanciate a new vision 'stamp' for the given radius
	*/
	private function newVisionStamp(radius : Float, tilesize : Int) : IVisionGrid
	{
		var gridCenter : Int = Math.ceil(radius / tilesize);
		var gridSize : Int = (gridCenter * 2) + 1;

		var radiusGrid : IVisionGrid = visionGridFactory.instance(gridSize, gridSize, tilesize);

		var quadraticTileSize : Float = Math.sqrt((Math.pow(tilesize, 2) * 2));
		//trace("radius:"+radius+" tilesize:"+tilesize+" qtilesize:"+quadraticTileSize);
		if(radius < quadraticTileSize) trace("WARNING: radius too small for vision grid granularity (radius = " + radius + " tilesize = " + tilesize + ")");

		for(x in 0...gridSize)
		{
			for(y in 0...gridSize)
			{
				var d = distance(x, y, gridCenter, gridCenter, tilesize);
				if(d <= radius)
				{
					radiusGrid[x][y].value = IVision.Seen;
					if(radius-d <= quadraticTileSize)
					{
						radiusGrid[x][y].seenShape = shape(); //edge
					}
					else
					{
						radiusGrid[x][y].seenShape = 511; //in
					}
				}
				else
				{
					if(d-radius <= quadraticTileSize)
					{
						radiusGrid[x][y].seenShape = shape(); //edge
					}
					else
					{
						radiusGrid[x][y].seenShape = 0; //out
					}
				}
				//trace("x:"+x+" y:"+y+" d:"+d+" shape:"+radiusGrid[x][y].seenShape);
			}
		}

		return radiusGrid;
	}

	private function shape() : Int
	{
		return Std.random(512);
	}

	/*
		calculate the distance in pixels between two tile centers
	*/
	private function distance(x1 : Int, y1 : Int, x2 : Int, y2 : Int, tilesize : Int) : Float
	{
		var d : Float = tilesize * Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
		return d;
	}
}