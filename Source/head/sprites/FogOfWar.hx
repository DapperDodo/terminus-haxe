package head.sprites;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.geom.Point;

import interfaces.IVision;
import interfaces.IFog;

import core.MapData;

class FogOfWar extends UpdateSprite implements IVisionClient
{
	private var mapData : MapData;
	private var mapBackground : MapBackground;
	private var bitmapFactory : BitmapFactory;
	private var assetLoader : AssetLoader;
	private var visionRegistry : IVisionRegistry;
	private var visionTracker : IVisionTracker;
	private var fogTileProjector : IFogTileProjector;

	private var fogBitmaps : Map<IVision, Bitmap>;

	private var dirtyTiles : Array<IVisionTile>;

	public function new
	(
		mapData : MapData, 
		mapBackground : MapBackground, 
		bitmapFactory : BitmapFactory, 
		assetLoader : AssetLoader, 
		visionRegistry : IVisionRegistry, 
		visionTracker : IVisionTracker, 
		fogTileProjector : IFogTileProjector
	)
	{
		super();

		this.mapData = mapData;
		this.mapBackground = mapBackground;
		this.assetLoader = assetLoader;
		this.visionRegistry = visionRegistry;
		this.visionTracker = visionTracker;
		this.fogTileProjector = fogTileProjector;

		fogBitmaps = new Map<IVision, Bitmap>();
		fogBitmaps.set(IVision.None, bitmapFactory.getInstance());
		fogBitmaps.set(IVision.Seen, bitmapFactory.getInstance());
		fogBitmaps.set(IVision.Full, bitmapFactory.getInstance());

		dirtyTiles = new Array<IVisionTile>();
	}

	override public function onPreLoad()
	{
        assetLoader.register("visibility-none", "assets/maps/" + mapData.getID() + "/bg-1280x1600-invisible.jpg");
        assetLoader.register("visibility-seen", "assets/maps/" + mapData.getID() + "/bg-1280x1600-explored.jpg");
        assetLoader.register("visibility-full", "assets/maps/" + mapData.getID() + "/bg-1280x1600.jpg");
	}

	override public function onPostLoad()
	{
		fogBitmaps.get(IVision.None).bitmapData = assetLoader.get("visibility-none");
		fogBitmaps.get(IVision.Seen).bitmapData = assetLoader.get("visibility-seen");
		fogBitmaps.get(IVision.Full).bitmapData = assetLoader.get("visibility-full");
	}

	override public function onStart()
	{
		visionRegistry.register(this);
	}

	override public function onStop()
	{
		visionRegistry.unregister(this);
	}

	/* needed for IVisionClient interface */
	public function onVisionChange(tile : IVisionTile) : Void
	{
		if(tile.seenShape == 0)
		{
			// no vision
			fogTileProjector.bake(tile, mapBackground.bitmap().bitmapData, fogBitmaps.get(IVision.None).bitmapData);
		}
		else if(tile.seenShape >= 511)
		{
			// seen
			fogTileProjector.bake(tile, mapBackground.bitmap().bitmapData, fogBitmaps.get(IVision.Full).bitmapData);
		}
		else
		{
			// edge
			fogTileProjector.bakeEdge(tile, mapBackground.bitmap().bitmapData, fogBitmaps.get(IVision.None).bitmapData, fogBitmaps.get(IVision.Seen).bitmapData);
		}
		//dirtyTiles.push(tile);
	}

    private var testR : Float = 100;
    private var testX : Float = 640;
    private var testY : Float = 800;
    private var testDX : Float = 50;
    private var testDY : Float = -50;

    private var oneshot : Bool = true;

	override private function onUpdate(deltaTime : Int)
	{
		/*
		if(dirtyTiles.length > 0)
		{	
			var tile : IVisionTile = dirtyTiles.shift();
			mapBackground.bitmap().bitmapData.copyPixels(fogBitmaps.get(tile.value).bitmapData, tile.rect, tile.point);
		}
		*/

		if(oneshot)
		{
	        visionTracker.track("UUID-foo", testX, testY, testR);
	        visionTracker.track("UUID-bar", testX-200, testY-200, testR-50);

	        /*
	        for(i in 0...10)
	        {
	        	var fx : Float = Math.random() * mapData.getWidth();
	        	var fy : Float = Math.random() * (mapData.getHeight() / 2);
	        	var r : Float = Math.random() * testR;
	        	var ix : Int = Std.int(fx);
	        	var iy : Int = Std.int(fy);
		        visionTracker.track("UUID-"+ix+"-"+iy, fx, fy, r);
	        }
	        */
	        //oneshot = false;
		}

		testX += (testDX * (deltaTime / 1000));
		if(testX >= 1280)
		{
			testX = 1280-1;
			testDX = -testDX;
		}
		if(testX < 0)
		{
			testX = 0;
			testDX = -testDX;
		}

		testY += (testDY * (deltaTime / 1000));
		if(testY >= 800)
		{
			testY = 800-1;
			testDY = -testDY;
		}
		if(testY < 0)
		{
			testY = 0;
			testDY = -testDY;
		}
	}
}