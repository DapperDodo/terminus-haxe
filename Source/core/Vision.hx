package core;

import interfaces.IVision;

/*
	An instance of this class should be attached to each player in the game
*/
class Vision implements IVisionServer implements IVisionTracker
{
	private var visionStampFactory : IVisionStampFactory;
	private var visionGridFactory : IVisionGridFactory;
	private var visionBroadcaster : IVisionBroadcaster;
	private var visionUnitStore : IVisionUnitStore;

	// size of each Vision Tile in pixels
	private var tilesize : Int;

	// map width (pixels)
	private var width : Float;

	// map height (pixels)
	private var height : Float;

	// number of rows (height in tiles)
	private var rows : Int;

	// number of cols (width in tiles)
	private var cols : Int;

	// the grid of vision tiles
	private var tiles : IVisionGrid;

	public function new
	(
		visionStampFactory : IVisionStampFactory, 
		visionGridFactory : IVisionGridFactory, 
		visionBroadcaster : IVisionBroadcaster,
		visionUnitStore : IVisionUnitStore
	)
	{
		this.visionStampFactory = visionStampFactory;
		this.visionGridFactory = visionGridFactory;
		this.visionBroadcaster = visionBroadcaster;
		this.visionUnitStore = visionUnitStore;
	}


	// implement IVisionServer

	public function init(tilesize : Int, width : Float, height : Float)
	{
		this.tilesize = tilesize;

		this.width = width;
		this.height = height;

		cols = Math.ceil(width / tilesize);
		rows = Math.ceil(height / tilesize); 

		tiles = visionGridFactory.instance(rows, cols, tilesize);
	}

	// implement IVisionTracker

	public function track(unitId : String, x : Float, y : Float, radius : Float) : Void
	{
		var tx = Math.floor(x / tilesize);
		var ty = Math.floor(y / tilesize);
		if(inBounds(tx, ty))
		{	
			if(visionUnitStore.update(unitId, tx, ty, radius))
			{
				// moved to another tile
				stamp(radius, tx, ty);
			}
			else
			{
				// same tile
				return;
			}
		}
	}

	/////////////////////////////////////////////////////////////
	// private parts
	/////////////////////////////////////////////////////////////

	/*
		stamp the grid
		the given coordinates mark the stamp center target tile
	*/
	private function stamp(radius : Float, tx : Int, ty : Int)
	{
		var stamp : IVisionGrid = visionStampFactory.instance(radius, tilesize);
		var tr : Int = Math.round((stamp.length - 1) / 2);

		var rx : Int = 0;
		for(x in tx-tr...tx+tr+1)
		{
			var ry : Int = 0;
			for(y in ty-tr...ty+tr+1)
			{
				if(inBounds(x, y))
				{
					if(stamp[rx][ry].seenShape > 0)
					{
						setTile(x, y, stamp[rx][ry]);
					}
				}
				ry++;
			}
			rx++;
		}
	}

	/*
		set a vision state to a tile
		if the vision state has altered, broadcast the vision change
	*/
	private function setTile(tx : Int, ty : Int, stampTile : IVisionTile)
	{
		var dirty : Bool = false;
		var gridTile = tiles[tx][ty];

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
			if(gridTile.seenShape == 511 && gridTile.value == IVision.None) gridTile.value = IVision.Seen;
			dirty = true;
		}

		if(dirty)
		{
			visionBroadcaster.visionChange(gridTile);
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
}