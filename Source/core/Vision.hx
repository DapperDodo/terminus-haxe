package core;

import openfl.geom.Rectangle;
import openfl.geom.Point;

import interfaces.IVision;

/*
	add Grid typedef just to make this class more readable
	Grid is a two dimensional array of IVisionTiles
*/
typedef Grid = Array<Array<IVisionTile>>;

/*
	structure for storing tracking data about vision-providing units
*/
typedef Unit = 
{
	id : String,
	tx : Int, 
	ty : Int,
	radius : Float
};

/*
	An instance of this class should be attached to each player in the game
*/
class Vision implements IVisionServer
{
	// size of each Vision Tile in pixels
	private var tilesize : Int = 12;

	// map dimensions, map name etc. can be gotten from this
	private var mapData : MapData;

	// the grid of vision tiles
	private var tiles : Grid;

	// number of rows (height in tiles)
	private var rows : Int;

	// number of cols (width in tiles)
	private var cols : Int;

	// array of objects interested in vision changes
	private var clientRegistry : Array<IVisionClient>;

	// cache of vision 'stamps', one for each radius used in the game
	private var radiusGridCache : Map<String, Grid>;

	// here's where we keep record of our tracked units
	private var unitsTracked : Map<String, Unit>;

	public function new(mapData : MapData)
	{
		this.mapData = mapData;
		clientRegistry = new Array<IVisionClient>();
		radiusGridCache = new Map<String, Grid>();
		unitsTracked = new Map<String, Unit>();
	}


	/*
		called when map data is loaded
		initialize the map visibility 
		start fully unexplored
		covers one half of the map (enemy's side)
	*/
	public function init()
	{
		cols = Math.ceil(mapData.getWidth() / tilesize);

		// the division by 2 is because the fog of war only covers HALF of the map
		rows = Math.ceil((mapData.getHeight() / 2) / tilesize); 

		tiles = newGrid(rows, cols);
	}

	/*
		register objects that want to know about vision state changes
	*/
	public function register(client : IVisionClient)
	{
		if(clientRegistry.indexOf(client) == -1)
		{
			clientRegistry.push(client);
		}
	}

	/*
		unregister objects that no longer want to know about vision state changes
	*/
	public function unregister(client : IVisionClient)
	{
		if(clientRegistry.indexOf(client) >= 0)
		{
			clientRegistry.remove(client);
		}
	}

	/*
		friendly units can let the vision system know where they are providing vision for the player
		the vision system will track their current field of vision (Full)
		the vision system will also track the explored parts of the map (Seen)
	*/
	public function track(id : String, x : Float, y : Float, radius : Float) : Void
	{
		var tx = Math.floor(x / tilesize);
		var ty = Math.floor(y / tilesize);

		if(unitsTracked.exists(id))
		{
			var unit : Unit = unitsTracked.get(id);
			if(unit.tx == tx && unit.ty == ty)
			{
				return;
			}
			else
			{
				// TODO: set Full to Seen where unit has moved out of range
				/*
				- take other nearby units into account
				*/

				// now update unit tracking coordinates
				unit.tx = tx;
				unit.ty = ty;
			}
		}
		else
		{
			unitsTracked.set(id, {id : id, tx : tx, ty : ty, radius : radius});
		}

		var radiusGrid : Grid = getRadiusGrid(radius);
		stamp(radiusGrid, tx, ty);
	}

	/*
		return the vision state of any position on the map
	*/
	public function check(x : Float, y : Float) : IVision
	{
		var tx = Math.floor(x / tilesize);
		var ty = Math.floor(y / tilesize);
		if(inBounds(tx, ty))
		{
			return tiles[tx][ty].value;
		}
		else if(y >= (mapData.getHeight() / 2))
		{
			// full vision on own side of the map
			return IVision.Full;
		}
		else
		{
			// no vision on invalid places
			return IVision.None;
		}
	}

	/////////////////////////////////////////////////////////////
	// private parts
	/////////////////////////////////////////////////////////////


	/*
		stamp the grid with given 'stamp'
		the given coordinates mark the stamp center target tile
	*/
	private function stamp(radiusGrid : Grid, tx : Int, ty : Int)
	{
		var tr : Int = Math.round((radiusGrid.length - 1) / 2);

		var rx : Int = 0;
		for(x in tx-tr...tx+tr+1)
		{
			var ry : Int = 0;
			for(y in ty-tr...ty+tr+1)
			{
				if(inBounds(x, y))
				{
					//if(tiles[x][y].value == IVision.None)
					//{
						if(radiusGrid[rx][ry].seenShape > 0)
						{
							setTile(x, y, radiusGrid[rx][ry]);
						}
					//}
				}
				ry++;
			}
			rx++;
		}
	}

	/*
		get a vision 'stamp' for the given radius
	*/
	private function getRadiusGrid(radius : Float)
	{
		var radiusID : String = Std.string(Math.round(radius));

		if(!radiusGridCache.exists(radiusID))
		{
			radiusGridCache.set(radiusID, newRadiusGrid(radius));	
		}

		return radiusGridCache.get(radiusID);
	}

	/*
		instanciate a new vision 'stamp' for the given radius
	*/
	private function newRadiusGrid(radius : Float) : Grid
	{
		var gridCenter : Int = Math.ceil(radius / tilesize);
		var gridSize : Int = (gridCenter * 2) + 1;

		var radiusGrid : Grid = newGrid(gridSize, gridSize);

		var quadraticTileSize : Float = Math.sqrt((Math.pow(tilesize, 2) * 2));
		//trace("radius:"+radius+" tilesize:"+tilesize+" qtilesize:"+quadraticTileSize);
		if(radius < quadraticTileSize) trace("WARNING: radius too small for vision grid granularity (radius = "+radius+"tilesize = "+tilesize+")");

		for(x in 0...gridSize)
		{
			for(y in 0...gridSize)
			{
				var d = distance(x, y, gridCenter, gridCenter);
				if(d <= radius)
				{
					radiusGrid[x][y].value = IVision.Seen;
					if(radius-d <= quadraticTileSize)
					{
						radiusGrid[x][y].seenShape = 1; //edge
					}
					else
					{
						radiusGrid[x][y].seenShape = 3; //in
					}
				}
				else
				{
					if(d-radius <= quadraticTileSize)
					{
						radiusGrid[x][y].seenShape = 1; //edge
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

	/*
		calculate the distance in pixels between two tile centers
	*/
	private function distance(x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Float
	{
		var d : Float = tilesize * Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
		return d;
	}

	/*
		instanciate a new vision tile grid
	*/
	private function newGrid(rows : Int, cols : Int) : Grid
	{
		var grid = new Grid();

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

	/*
		set a vision state to a tile
		if the vision state has altered, broadcast the vision change
	*/
	private function setTile(tx : Int, ty : Int, stampTile : IVisionTile)
	{
		var dirty : Bool = false;
		var gridTile = tiles[tx][ty];
		if(inBounds(tx, ty))
		{
			//value 
			if(gridTile.value != stampTile.value)
			{
				gridTile.value = stampTile.value;
				dirty = true;
			}

			//shape
			//if(gridTile.seenShape > 0) trace("tile: " + gridTile.seenShape + ", stamp: " + stampTile.seenShape + ", OR: " + (gridTile.seenShape | stampTile.seenShape));
			if(gridTile.seenShape != (gridTile.seenShape | stampTile.seenShape))
			{
				//if(gridTile.seenShape > 0) trace("shape changed! " + gridTile.seenShape + " is now " + (gridTile.seenShape | stampTile.seenShape));
				gridTile.seenShape = (gridTile.seenShape | stampTile.seenShape);
				dirty = true;
			}

			if(dirty)
			{
				broadcastChange(tx, ty);
			}
		}
	}

	/*
		check if tile coordinates are within the bounds of our vision tile grid
	*/
	private function inBounds(tx : Int, ty : Int) : Bool
	{
		if(tx < 0 || tx >= cols)
		{
			return false;
		}
		else if(ty < 0 || ty >= rows)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	/*
		let our client objects know something has changed in the players vision
		for example, a 'fog of war' object may want to paint fog where the player can't see
	*/
	private function broadcastChange(tx : Int, ty : Int)
	{
		for(idx in 0...clientRegistry.length)
		{
			clientRegistry[idx].onVisionChange(tiles[tx][ty]);
		}
	}
}