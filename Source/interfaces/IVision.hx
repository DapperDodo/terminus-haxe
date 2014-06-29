package interfaces;

import openfl.geom.Rectangle;
import openfl.geom.Point;

/*
	value

	definition

	make the three visibility modes a type
	for type-safety and readability
*/
enum IVision
{
	None;
	Seen;
	Full;
}

/*
	value object

	as value:

	used to store information on map visibility state of a single tile

	as message:

	sent from the Vision system to the registered clients
	whenever a visibility change occurred
*/
typedef IVisionTile =
{
	var tx : Int; 			// tile x index
	var ty : Int; 			// tile y index
	var value : IVision; 	// visibility mode
	var rect  : Rectangle; 	// tile rectangle
	var point : Point; 		// tile upper left corner coordinates
	var seenShape  : IVisionTileShape ;	// tile shape (permanent vision)
	var fullShape  : IVisionTileShape ;	// tile shape (current vision)
}

/*
	a VisionGrid is a two dimensional array of IVisionTiles
	this can be used by:
	- Vision (large grid, complete fog of war)
	- Stamps (small grids, vision around a unit)
*/
typedef IVisionGrid = Array<Array<IVisionTile>>;

/*
	a TileShape is an Int representing a two dimensional grid of bools (bits)
	the Int is necessary for fast bitwise operations
*/
typedef IVisionTileShape = Int;

/*
	interface

	client

	classes must implement this interface
	when they want to register themselves to the Vision system
*/
interface IVisionClient
{
	public function onVisionChange(tile : IVisionTile) : Void;
}

/*
	interface

	broadcaster

	a channel through which vision changes can be transmitted to interested parties
*/
interface IVisionBroadcaster
{
	public function visionChange(tile : IVisionTile) : Void;
}

/*
	interface

	server

	map visibility implementations must implement this interface
*/
interface IVisionServer
{
	/*
		initialize the vision system with a granularity/tilesize, width and height in pixels
	*/
	public function init(tilesize : Int, width : Float, height : Float) : Void;
}

/*
	interface

	tracker

	units should be tracked through this interface
*/
interface IVisionTracker
{
	public function track(unitId : String, x : Float, y : Float, radius : Float) : Void;
}

/*
	interface

	registry

	clients can register/unregister through this interface to receive vision change events
*/
interface IVisionRegistry
{
	public function register(client : IVisionClient) : Void;
	public function unregister(client : IVisionClient) : Void;
}

/*
	interface

	gridfactory

	manage instanciation of vision grids
*/
interface IVisionGridFactory
{
	public function instance(rows : Int, cols : Int, tilesize : Int) : IVisionGrid;
}

/*
	interface

	stampfactory

	manage instanciation of radius stamps
*/
interface IVisionStampFactory
{
	public function instance(radius : Float, tilesize : Int) : IVisionGrid;
}

/*
	interface

	vision stamp outliner

	purpose: draw the outline (edge tiles) of a vision stamp
*/
interface IVisionStampOutliner
{
	public function draw(stamp : IVisionGrid, gridCenter : Int, radius : Float, tilesize : Int) : Void;
}

/*
	interface

	vision stamp filler

	purpose: fill the inside of a stamp given an outline is already drawn
*/
interface IVisionStampFiller
{
	public function fill(stamp : IVisionGrid, gridSize : Int) : Void;
}


/*
	interface

	vision stamp edge shaper

	purpose: determine the shape of an edge tile and encode it as an Int

	straightBefore:
		true : the edge tile before this one has the same X coordinate (straight)
		false: the edge tile before this one has a different X coordinate (cross)
	straightAfter:
		true : the edge tile after this one has the same X coordinate (straight)
		false: the edge tile after this one has a different X coordinate (cross)
	octants: one of these
	    6 7
	  5     8
	  4     1
	    3 2
*/
interface IVisionEdgeShaper
{
	public function getShape(straightBefore : Bool, straightAfter : Bool, octant : Int) : IVisionTileShape;
}

/*
	interface

	unit store

	cache unit tracking information
*/
interface IVisionUnitStore
{
	/*
		return true if unit moved to another tile or was not yet tracked
		returns false if unit stays in the same tile
	*/
	public function update(unitId : String, tx : Int, ty : Int, radius : Float) : Bool;
}

