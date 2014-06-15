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
	var seenShape  : Int ;	// 3x3 shape matrix encoded as int
	var fullShape  : Int ;	// 3x3 shape matrix encoded as int
}

/*
	a VisionGrid is a two dimensional array of IVisionTiles
	this can be used by:
	- Vision (large grid, complete fog of war)
	- Stamps (small grids, vision around a unit)
*/
typedef IVisionGrid = Array<Array<IVisionTile>>;


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

	server

	map visibility implementations must implement this interface
*/
interface IVisionServer
{
	public function init() : Void;
	public function register(client : IVisionClient) : Void;
	public function unregister(client : IVisionClient) : Void;
	public function track(id : String, x : Float, y : Float, radius : Float) : Void;
	public function check(x : Float, y : Float) : IVision;
}
