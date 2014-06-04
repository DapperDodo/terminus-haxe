package head.sprites;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

import interfaces.IVision;

import core.MapData;

class FogOfWar extends UpdateSprite implements IVisionClient
{
	private var mapData : MapData;
	private var playerVision : IVisionServer;
	private var mapBackground : MapBackground;
	private var bitmapFactory : BitmapFactory;
	private var assetLoader : AssetLoader;

	private var fogBitmaps : Map<IVision, Bitmap>;

	private var dirtyTiles : Array<IVisionTile>;

	public function new(mapData : MapData, playerVision : IVisionServer, mapBackground : MapBackground, bitmapFactory : BitmapFactory, assetLoader : AssetLoader)
	{
		super();

		this.mapData = mapData;
		this.playerVision = playerVision;
		this.mapBackground = mapBackground;
		this.assetLoader = assetLoader;

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
		playerVision.register(this);
	}

	override public function onStop()
	{
		playerVision.unregister(this);
	}

	/* needed for IVisionClient interface */
	public function onVisionChange(tile : IVisionTile) : Void
	{
		//trace("FogOfWar.onChange tx=" + tile.tx + ", ty=" + tile.ty + ", value=" + tile.value + ", rect=" + tile.rect + ", point=" + tile.point);
		mapBackground.bitmap().bitmapData.copyPixels(fogBitmaps.get(tile.value).bitmapData, tile.rect, tile.point);

		//dirtyTiles.push(tile);
	}

    private var testR : Float = 100;
    private var testX : Float = 640;
    private var testY : Float = 800;
    private var testDX : Float = 25;
    private var testDY : Float = -25;

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
	        playerVision.visit(testX, testY, testR);
	        playerVision.visit(testX-200, testY-200, testR-50);
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