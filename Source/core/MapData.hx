package core;

import interfaces.IMapDefinition;

class MapData
{
	// object that loads data for a map from an external source
	private var mapDefinitionLoader : MapDefinitionLoader;

	// currently loaded map
	private var mapDefinition : IMapDefinition;

	// constructor
	public function new(mapDefinitionLoader : MapDefinitionLoader)
	{
		this.mapDefinitionLoader = mapDefinitionLoader;
	}

	// load a map
	public function load(id : String)
	{
		mapDefinition = mapDefinitionLoader.load(id);
	}
	
	//getters

	public function getID() : String
	{
		return mapDefinition.id;
	}

	public function getHeight() : Float
	{
		return mapDefinition.h;
	}

	public function getWidth() : Float
	{
		return mapDefinition.w;
	}

	public function getResources() : Array<Resource>
	{
		return mapDefinition.resources;
	}
}