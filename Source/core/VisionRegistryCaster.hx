package core;

import interfaces.IVision;

class VisionRegistryCaster implements IVisionRegistry implements IVisionBroadcaster
{
	private var R : Array<IVisionClient>;

	public function new()
	{
		R = new Array<IVisionClient>();
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

	/*
		let our client objects know something has changed in the players vision
		for example, a 'fog of war' object may want to paint fog where the player can't see
	*/
	public function visionChange(tile : IVisionTile)
	{
		for(idx in 0...R.length)
		{
			R[idx].onVisionChange(tile);
		}
	}
}