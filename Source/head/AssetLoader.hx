package head;

import openfl.Assets;

import openfl.display.BitmapData;

class AssetLoader
{
	private var paths : Map<String, String>;
	private var bdata : Map<String, BitmapData>;
	private var loading : Bool;
	private var loadcnt : Int;
	private var callbck : Dynamic;

	public function new () 
	{
		paths = new Map<String, String>();
		bdata = new Map<String, BitmapData>();
		loading = false;
		loadcnt = 0;
		callbck = null;
	}

	public function register(id : String, path : String) : Bool
	{
		if(!loading)
		{
			if(paths.exists(id))
			{
				// if an entry is overridden, force a reload
				if(bdata.exists(id)) bdata.remove(id);
				paths.remove(id);
			}

			paths.set(id, path);
			return true;
		}

		return false; //can't register while loading in progress
	}

	public function load(callback : Dynamic)
	{
		loading = true;
		loadcnt = 0;
		callbck = callback;

		// first count how many assets we have to load
		for(id in paths.keys())
		{
			if(!bdata.exists(id))
			{
				loadcnt++;
			}
		}

		// then fire asynchronous loading of each asset one by one
		for(id in paths.keys())
		{
			if(!bdata.exists(id))
			{
				Assets.loadBitmapData (paths.get(id), function(bitmapData:BitmapData)
				{
					bdata.set(id, bitmapData);
					check();
				});
			}
		}
	}

	public function get(id) : BitmapData
	{
		if(bdata.exists(id))
		{
			return bdata.get(id);
		}
		else
		{
			return null;
		}
	}

	private function check()
	{
		if(loading)
		{
			loadcnt--;
			if(loadcnt <= 0)
			{
				loading = false;
				loadcnt = 0;
				callbck();
				callbck = null;
			}
		}
	}
}