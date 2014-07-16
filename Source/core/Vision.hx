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
	private var visionChangeDetector : IVisionChangeDetector;

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
		visionUnitStore : IVisionUnitStore,
		visionChangeDetector : IVisionChangeDetector
	)
	{
		this.visionStampFactory = visionStampFactory;
		this.visionGridFactory = visionGridFactory;
		this.visionBroadcaster = visionBroadcaster;
		this.visionUnitStore = visionUnitStore;
		this.visionChangeDetector = visionChangeDetector;
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

	public function endFrame() : Void
	{
		visionChangeDetector.detectChanges();

		//if temporary vision:
		//  for all visible tiles:
		//    visionChangeDetector.touch(tile);
		//    set tile to invisible
		//    visionChangeDetector.touch(tile);
		//make sure track stamps every unit every frame
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
					if(stamp[rx][ry].shape > 0)
					{
						stampTile(x, y, stamp[rx][ry]);
					}
				}
				ry++;
			}
			rx++;
		}
	}

	/*
		stamp a single tile
	*/
	private function stampTile(tx : Int, ty : Int, stampTile : IVisionTile)
	{
		var gridTile = tiles[tx][ty];

		// notify change-detector before stamping
		visionChangeDetector.touch(gridTile);

		//value 
		if(gridTile.value != stampTile.value)
		{
			gridTile.value = stampTile.value;
		}

		//shape
		//if(gridTile.shape > 0) trace("tile: " + gridTile.shape + ", stamp: " + stampTile.shape + ", OR: " + (gridTile.shape | stampTile.shape));
		if(gridTile.shape != (gridTile.shape | stampTile.shape))
		{
			//if(gridTile.shape > 0) trace("shape changed! " + gridTile.shape + " is now " + (gridTile.shape | stampTile.shape));
			gridTile.shape = (gridTile.shape | stampTile.shape);
			if(gridTile.shape == 511 && gridTile.value == IVision.No) gridTile.value = IVision.Yes;
		}

		// notify change-detector after changes
		visionChangeDetector.touch(gridTile);
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