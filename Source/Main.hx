package;

import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

import flash.events.Event;
import flash.Lib;

import core.MapDefinitionLoader;
import core.MapData;

import head.BitmapFactory;
import head.MapBackground;
import head.UpdateSprite;

class Main extends Sprite 
{	
    private var previousTime : Int;
    private var updateroot : UpdateSprite;

    public function new () 
	{
		super ();
		stage.frameRate = 60;

		// instanciate core classes
		var mapDefinitionLoader : MapDefinitionLoader = new MapDefinitionLoader();
		var mapData : MapData = new MapData(mapDefinitionLoader);


		// instanciate head classes
        var bitmapFactory : BitmapFactory = new BitmapFactory();
        var mapBackground : MapBackground = new MapBackground(mapData, bitmapFactory);

        // setup scene graph
        updateroot = cast(mapBackground, UpdateSprite);
		addChild(mapBackground);

        // load map data
		mapData.load("hello_world");

        // load assets
        Assets.loadBitmapData ("assets/maps/" + mapData.getID() + "/bg.png", function(bitmapData:BitmapData)
        {
        	mapBackground.load(bitmapData);

        	// start game loop
        	previousTime = Lib.getTimer ();
        	addEventListener (Event.ENTER_FRAME, frame);
        });
    }

	private function frame (event:Event) : Void 
	{
		var currentTime = Lib.getTimer ();
		var deltaTime = currentTime - previousTime;

		previousTime = currentTime;

		updateroot.update(deltaTime);
	}
}