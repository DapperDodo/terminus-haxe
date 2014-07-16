package core;

import interfaces.IVision;

class VisionRegistryCaster implements IVisionRegistry implements IVisionBroadcaster
{
	private var R : Array<IVisionClient>;
	private var TileQueue : Array<IVisionTile>;

	public function new()
	{
		R = new Array<IVisionClient>();
		TileQueue = new Array<IVisionTile>();
	}

	// implement IVisionRegistry

	/*
		register objects that want to know about vision state changes
	*/
	public function register(client : IVisionClient)
	{
		if(R.indexOf(client) == -1)
		{
			R.push(client);
		}
	}

	/*
		unregister objects that no longer want to know about vision state changes
	*/
	public function unregister(client : IVisionClient)
	{
		if(R.indexOf(client) >= 0)
		{
			R.remove(client);
		}
	}

	// implement IVisionBroadcaster

	public function visionChange(tile : IVisionTile)
	{
		if(TileQueue.indexOf(tile) == -1)
		{
			TileQueue.push(tile);
		}
	}

	public function broadcast() : Void
	{
		//if(TileQueue.length > 0) trace("broadcasting " + TileQueue.length + " changed tiles");

		while(TileQueue.length > 0)
		{
			var tile : IVisionTile = TileQueue.pop();
			for(idx in 0...R.length)
			{
				R[idx].onVisionChange(tile);
			}
		}
	}
}