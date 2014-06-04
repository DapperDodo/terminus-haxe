package head.sprites;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

import interfaces.IMapVisibility;

import core.MapData;

class FogOfWar extends UpdateSprite implements IMapVisibilityClient
{
	private var mapData : MapData;
	private var mapVisibility : IMapVisibility;
	private var mapBackground : MapBackground;
	private var bitmapFactory : BitmapFactory;
	private var assetLoader : AssetLoader;

	private var fogBitmaps : Map<IVisibility, Bitmap>;

	private var dirtyTiles : Array<IMapVisibilityTile>;

	public function new(mapData : MapData, mapVisibility : IMapVisibility, mapBackground : MapBackground, bitmapFactory : BitmapFactory, assetLoader : AssetLoader)
	{
		super();

		this.mapData = mapData;
		this.mapVisibility = mapVisibility;
		this.mapBackground = mapBackground;
		this.assetLoader = assetLoader;

		fogBitmaps = new Map<IVisibility, Bitmap>();
		fogBitmaps.set(IVisibility.None, bitmapFactory.getInstance());
		fogBitmaps.set(IVisibility.Seen, bitmapFactory.getInstance());
		fogBitmaps.set(IVisibility.Full, bitmapFactory.getInstance());

		dirtyTiles = new Array<IMapVisibilityTile>();
	}

	override public function onPreLoad()
	{
        assetLoader.register("visibility-none", "assets/maps/" + mapData.getID() + "/bg-1280x1600-invisible.jpg");
        assetLoader.register("visibility-seen", "assets/maps/" + mapData.getID() + "/bg-1280x1600-explored.jpg");
        assetLoader.register("visibility-full", "assets/maps/" + mapData.getID() + "/bg-1280x1600.jpg");
	}

	override public function onPostLoad()
	{
		fogBitmaps.get(IVisibility.None).bitmapData = assetLoader.get("visibility-none");
		fogBitmaps.get(IVisibility.Seen).bitmapData = assetLoader.get("visibility-seen");
		fogBitmaps.get(IVisibility.Full).bitmapData = assetLoader.get("visibility-full");
	}

	override public function onStart()
	{
		mapVisibility.register(this);
	}

	override public function onStop()
	{
		mapVisibility.unregister(this);
	}

	/* needed for IMapVisibilityClient interface */

	public function onMapVisibilityChange(tile : IMapVisibilityTile) : Void
	{
		//trace("FogOfWar.onChange tx=" + tile.tx + ", ty=" + tile.ty + ", value=" + tile.value + ", rect=" + tile.rect + ", point=" + tile.point);

		dirtyTiles.push(tile);
	}


    private var testX : Float = 600;
    private var testY : Float = 900;
    private var testDX : Float = 50;
    private var testDY : Float = -50;

	override private function onUpdate(deltaTime : Int)
	{
		if(dirtyTiles.length > 0)
		{	
			var tile : IMapVisibilityTile = dirtyTiles.shift();
			mapBackground.bitmap().bitmapData.copyPixels(fogBitmaps.get(tile.value).bitmapData, tile.rect, tile.point);
		}

        mapVisibility.visit(testX, testY, 100);

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