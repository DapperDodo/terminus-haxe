package interfaces;

/*
	definition of a resource patch

	x: x-coordinate of the resource
	y: y-coordinate of the resource (within the upper half of the map)

	y should be less then the map's height (IMapDefinition.h / 2) 
	because resources are symmetric on the upper and lower half of the map. (Mirrored on the map center). 
	Only define the map's resources on the upper half of the map as the resources on the lower half will be auto-generated.

	For example: given this map:
	{w:1280, h:1600, ...}
	and given this resource definition:
	{x:640, y:100, ...}
	the game should automatically generate a 'mirrored' resource:
	{x:1280-640, y:1600-100, ...}

	amount: the amount of resources on this resource patch
*/
typedef Resource = 
{
	var x : Float;
	var y : Float;
	var amount: Float;
};

/*
	definition of a map

	id: internal identifier of the map
	w: width of the map (pixels)
	h: height of the map (pixels), this should be (map window height * 2)
	resources: array of resource patches for the upper half of the map
*/
interface IMapDefinition
{
	public var id : String;
	public var w : Float;
	public var h : Float;
	public var resources : Array<Resource>;
}