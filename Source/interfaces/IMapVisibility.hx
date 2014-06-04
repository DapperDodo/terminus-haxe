package interfaces;

import openfl.geom.Rectangle;
import openfl.geom.Point;

/*
	value

	definition

	make the three visibility modes a type
	for type-safety and readability
*/
enum IVisibility
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

	sent from the MapVisibility system to the registered clients
	whenever a visibility change occurred
*/
typedef IMapVisibilityTile =
{
	var tx : Int; 				// tile x index
	var ty : Int; 				// tile y index
	var value : IVisibility; 	// visibility mode
	var rect : Rectangle; 		// tile rectangle
	var point : Point; 			// tile upper left corner coordinates
	// add smooth shape info later
}

/*
	interface

	client

	classes must implement this interface
	when they want to register themselves to the MapVisibility system
*/
interface IMapVisibilityClient
{
	public function onMapVisibilityChange(tile : IMapVisibilityTile) : Void;
}

/*
	interface

	server

	map visibility implementations must implement this interface
*/
interface IMapVisibility
{
	public function init() : Void;
	public function register(client : IMapVisibilityClient) : Void;
	public function unregister(client : IMapVisibilityClient) : Void;
	public function visit(x : Float, y : Float, radius : Float) : Void;
}
