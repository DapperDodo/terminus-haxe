package core;

import interfaces.IVision;

typedef IVisionBaseline = 
{
	var value : IVision;
	var shape : IVisionTileShape;
}

class VisionChangeDetector implements IVisionChangeDetector
{
	private var visionBroadcaster : IVisionBroadcaster;
	private var touched : Map<IVisionTile, IVisionBaseline>;

	public function new(visionBroadcaster : IVisionBroadcaster)
	{
		this.visionBroadcaster = visionBroadcaster;

		touched = new Map<IVisionTile, IVisionBaseline>();
	}

	public function touch(gridTile : IVisionTile) : Void
	{
		if(!touched.exists(gridTile))
		{
			// first touch of this tile! set baseline!
			touched.set(gridTile, { value : gridTile.value, shape : gridTile.shape });
		}
	}

	public function detectChanges() : Void
	{
		// detect changed tiles
		var i = touched.keys();
		while(i.hasNext())
		{
			var tile = i.next();
			var base = touched.get(tile);

			if(tile.value != base.value || tile.shape != base.shape)
			{
				// change found! communicate this to the broadcaster
				visionBroadcaster.visionChange(tile);
			}
		}

		// reset map
		touched = new Map<IVisionTile, IVisionBaseline>();

		// tell the broadcaster to do their thing
		visionBroadcaster.broadcast();
	}
}