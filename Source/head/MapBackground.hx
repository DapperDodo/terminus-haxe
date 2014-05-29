package head;

import openfl.display.BitmapData;
import openfl.display.Bitmap;

import motion.Actuate;
import motion.easing.Quad;

import core.MapData;

class MapBackground extends UpdateSprite
{
	private var mapData : MapData;
	private var mapBitmap : Bitmap;
	private var assetLoader : AssetLoader;

	public function new(mapData : MapData, bitmapFactory : BitmapFactory, assetLoader : AssetLoader)
	{
		super();

		this.mapData = mapData;
		this.mapBitmap = bitmapFactory.getInstance();
		this.assetLoader = assetLoader;

		addChild(mapBitmap);
	}

	override private function onPreLoad()
	{
        assetLoader.register("background", "assets/maps/" + mapData.getID() + "/bg.png");
	}

	override private function onPostLoad()
	{
        mapBitmap.bitmapData = assetLoader.get("background");
		showHome();
	}

	public function showHome()
	{
		// show only bottom (home) half of map
		tweenTo(0 - (mapData.getHeight() / 2));
	}

	public function showAway()
	{
		// show only top (away) half of map
		tweenTo(0);
	}

	private function tweenTo(toY : Float)
	{
		Actuate.tween 
		(
			this, 
			0.4, 
			{ 
				y : toY
			}
		).ease (Quad.easeInOut);
	}
	/*
	override private function onUpdate(deltaTime : Int)
	{
		//trace ("was here! dt=" + deltaTime);
		mapBitmap.y += (10 * (deltaTime / 1000));
	}
	*/
}