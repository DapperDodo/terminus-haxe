package data;

import interfaces.IMapDefinition;

class MapHelloWorld implements IMapDefinition
{
	public var id : String = "hello_world";

	public var w : Float = 1280;
	public var h : Float = 1600;

	public var resources : Array<Resource> = [{x:640, y:100, amount:1000}, {x:960, y:200, amount:1000}];
}