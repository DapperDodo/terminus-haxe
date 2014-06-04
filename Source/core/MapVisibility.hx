package core;

import openfl.geom.Rectangle;
import openfl.geom.Point;

import interfaces.IMapVisibility;

class MapVisibility implements IMapVisibility
{
	private var tilesize : Int = 16;
	private var mapData : MapData;

	private var tiles : Array<Array<IMapVisibilityTile>>;
	private var rows : Int;
	private var cols : Int;

	private var clientRegistry : Array<IMapVisibilityClient>;

	public function new(mapData : MapData)
	{
		this.mapData = mapData;
		clientRegistry = new Array<IMapVisibilityClient>();
	}

	public function init()
	{
		// called when map data is loaded
		// initialize the map visibility 
		// start fully unexplored
		// covers one half of the map (enemy's side)

		cols = Math.ceil(mapData.getWidth() / tilesize);
		rows = Math.ceil((mapData.getHeight() / 2) / tilesize);

		//trace("MapVisibility.init : cols, rows = (" + cols + ", " + rows + ")");

		tiles = new Array<Array<IMapVisibilityTile>>();

		for(x in 0...cols)
		{
			tiles[x] = new Array<IMapVisibilityTile>();
			for(y in 0...rows)
			{
				tiles[x][y] = 
				{
					tx : x, 
					ty : y, 
					value : IVisibility.None, 
					rect : new Rectangle(x*tilesize, y*tilesize, tilesize, tilesize),
					point : new Point(x*tilesize, y*tilesize)
					//add smoothing information later
				};
			}
		}
	}

	public function register(client : IMapVisibilityClient)
	{
		if(clientRegistry.indexOf(client) == -1)
		{
			clientRegistry.push(client);
		}
	}

	public function unregister(client : IMapVisibilityClient)
	{
		if(clientRegistry.indexOf(client) >= 0)
		{
			clientRegistry.remove(client);
		}
	}

	public function visit(x : Float, y : Float, radius : Float) : Void
	{
		var tx = Math.floor(x / tilesize);
		var ty = Math.floor(y / tilesize);
		//trace("MapVisibility.visit : x=" + x + ", y=" + y + ", tx=" + tx + ", ty=" + ty);

		setTile(tx, ty, IVisibility.Full);
	}

	private function setTile(tx : Int, ty : Int, v : IVisibility)
	{
		if(tx < 0 || tx >= cols)
		{
			//trace("MapVisibility.visit : Error : tx out of range");
		}
		else if(ty < 0 || ty >= rows)
		{
			//trace("MapVisibility.visit : Error : ty out of range");
		}
		else if(tiles[tx][ty].value == v)
		{
			// do nothing. Already seen.
		}
		else
		{
			tiles[tx][ty].value = v;
			broadcastChange(tx, ty);

			if(v == IVisibility.Full)
			{
				setTile(tx-1, ty-1, IVisibility.Seen);
				setTile(tx-1, ty  , IVisibility.Seen);
				setTile(tx-1, ty+1, IVisibility.Seen);
				setTile(tx  , ty-1, IVisibility.Seen);
				setTile(tx  , ty+1, IVisibility.Seen);
				setTile(tx+1, ty-1, IVisibility.Seen);
				setTile(tx+1, ty  , IVisibility.Seen);
				setTile(tx+1, ty+1, IVisibility.Seen);
			}
		}
	}

	private function broadcastChange(tx : Int, ty : Int)
	{
		for(idx in 0...clientRegistry.length)
		{
			clientRegistry[idx].onMapVisibilityChange(tiles[tx][ty]);
		}
	}
}