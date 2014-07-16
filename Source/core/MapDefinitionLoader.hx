package core;

import interfaces.IMapDefinition;

import data.MapHelloWorld;

class MapDefinitionLoader
{
	var mapDefs : Map<String, IMapDefinition>;

	public function new()
	{
		mapDefs = new Map<String, IMapDefinition>();

		// instanciate all available map definition classes here:
		mapDefs.set("hello_world", new MapHelloWorld());
	}

	public function load(id : String) : IMapDefinition
	{
		return mapDefs.get(id);
	}
}