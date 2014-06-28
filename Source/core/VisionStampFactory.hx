package core;

import interfaces.IVision;

class VisionStampFactory implements IVisionStampFactory
{
	private var visionGridFactory : IVisionGridFactory;
	private var visionStampOutliner : IVisionStampOutliner;
	private var visionStampFiller : IVisionStampFiller;

	private var cache : Map<String, IVisionGrid>;

	public function new
	(
		visionGridFactory : IVisionGridFactory, 
		visionStampOutliner : IVisionStampOutliner, 
		visionStampFiller : IVisionStampFiller
	)
	{
		this.visionGridFactory = visionGridFactory;
		this.visionStampOutliner = visionStampOutliner;
		this.visionStampFiller = visionStampFiller;

		cache = new Map<String, IVisionGrid>();
	}

	public function instance(radius : Float, tilesize : Int) : IVisionGrid
	{
		var id : String = getID(radius);

		if(!cache.exists(id))
		{
			cache.set(id, makeVisionStamp(radius, tilesize));	
		}

		return cache.get(id);
	}

	/////////////////////////////////////////////////////////////
	// private parts
	/////////////////////////////////////////////////////////////

	/*
		make an id (hash) as a key for our cache map
	*/
	private function getID(radius : Float) : String
	{
		return Std.string(Math.round(radius));
	}

	/*
		make a new vision 'stamp' for the given radius
	*/
	private function makeVisionStamp(radius : Float, tilesize : Int) : IVisionGrid
	{	
		var gridCenter : Int = Math.ceil(radius / tilesize);
		var gridSize : Int = (gridCenter * 2) + 1;

		// get a stamp instance from the factory
		var stamp : IVisionGrid = visionGridFactory.instance(gridSize, gridSize, tilesize);

		// draw the outline
		visionStampOutliner.draw(stamp, gridCenter, radius, tilesize);

		// fill the stamp
		visionStampFiller.fill(stamp, gridSize);

		return stamp;
	}
}