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
	No;
	Yes;
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
	var tx : Int; 						// tile x index
	var ty : Int; 						// tile y index
	var value : IVision; 				// visibility mode
	var rect  : Rectangle; 				// tile rectangle
	var point : Point; 					// tile upper left corner coordinates
	var shape : IVisionTileShape;		// tile shape
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
	/*
		mark individual tiles as changed (vision status or shape has changed)
		this object should put these in a queue for later broadcasting to the clients
	*/
	public function visionChange(tile : IVisionTile) : Void;

	/*
		broadcast all changed tiles to the clients
		this empties (flushes) the 'changed tile queue'
		let our client objects know one or more tiles have changed in the players vision
		for example, a 'fog of war' object may want to paint fog where the player can't see
	*/
	public function broadcast() : Void;
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
	/*
		send individual unit updates to the vision system
		do this often (every update loop)
	*/
	public function track(unitId : String, x : Float, y : Float, radius : Float) : Void;

	/*
		indicate you have tracked all units for this frame (update loop)
	*/
	public function endFrame() : Void;
}

/*
	interface

	change detector

	objects of this type are responsible for detecting (within a frame / update loop)
	which tiles have changed
*/
interface IVisionChangeDetector
{
	/*
		call this function to indicate a tile might be changed
		it is possible that the same tile is touched multiple times
		and the sum of these touches results in an unchanged tile.
		this object must handle such cases.
		the first touch of a tile is the baseline on which changes are detected
		the change should be detected between the first (baseline) touch and the last one

		touch 1: Yes, shape 234
		=> no change!

		examples:
		touch 1: Yes, shape 234
		touch 2: No, shape 0
		=> change!

		touch 1: Yes, shape 234
		touch 2: No, shape 0
		touch 1: Yes, shape 234
		=> no change!
	*/
	public function touch(gridTile : IVisionTile) : Void;

	/*
		after al tile touches have been registered, call this function to detect changed tiles
		from the situation before the touches to the situation after the touches.
		reset for the next detection frame (update loop)

		pass the changed tiles to the IVisionBroadcaster object
	*/
	public function detectChanges() : Void;
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

