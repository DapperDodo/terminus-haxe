package head;

import openfl.display.BitmapData;
import openfl.display.Bitmap;

import core.MapData;

class MapBackground extends UpdateSprite
{
	private var mapData : MapData;
	private var mapBitmap : Bitmap;

	public function new(mapData : MapData, bitmapFactory : BitmapFactory)
	{
		super();

		this.mapData = mapData;
		this.mapBitmap = bitmapFactory.getInstance();

		addChild(mapBitmap);
	}

	public function load(bitmapData : BitmapData)
	{
        mapBitmap.bitmapData = bitmapData;

        // show only bottom (home) half of map
		mapBitmap.x = 0;
		mapBitmap.y = 0 - (mapData.getHeight() / 2);
	}

	/*
	override private function onUpdate(deltaTime : Int)
	{
		//trace ("was here! dt=" + deltaTime);
		mapBitmap.y += (10 * (deltaTime / 1000));
	}
	*/
}