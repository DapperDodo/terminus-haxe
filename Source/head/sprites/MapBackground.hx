package head.sprites;

import openfl.display.BitmapData;
import openfl.display.Bitmap;

import motion.Actuate;
import motion.easing.Sine;

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

	public function showHome()
	{
		// show only bottom (home) half of map
		tweenTo(0 - (mapData.getHeight() / 2) + 250);
	}

	public function showAway()
	{
		// show only top (away) half of map
		tweenTo(0);
	}

	public function bitmap() : Bitmap
	{
		return mapBitmap;
	}

	private function tweenTo(toY : Float)
	{
		Actuate.tween 
		(
			this, 
			0.5, 
			{ 
				y : toY
			}
		).ease (Sine.easeInOut);
	}

	override private function onPreLoad()
	{
        assetLoader.register("background", "assets/maps/" + mapData.getID() + "/bg-1280x1600-invisible.jpg");
	}

	override private function onPostLoad()
	{
        mapBitmap.bitmapData = assetLoader.get("background");
	}

	override private function onStart()
	{
		//showHome();
	}

	/*
	override private function onUpdate(deltaTime : Int)
	{
		//trace ("was here! dt=" + deltaTime);
		mapBitmap.y += (10 * (deltaTime / 1000));
	}
	*/
}