package;

import openfl.Assets;

import openfl.Lib;

import openfl.display.Sprite;
//import openfl.display.BitmapData;
//import openfl.display.Bitmap;

import openfl.events.Event;

import core.MapDefinitionLoader;
import core.MapData;

import head.BitmapFactory;
import head.MapBackground;
import head.UpdateSprite;
import head.AssetLoader;
import head.ViewToggle;

class Main extends UpdateSprite 
{	
    private var previousTime : Int;

    public function new () 
	{
		super ();
		stage.frameRate = 60;

		// instanciate core classes
		var mapDefinitionLoader : MapDefinitionLoader = new MapDefinitionLoader();
		var mapData : MapData = new MapData(mapDefinitionLoader);

		// instanciate head classes
        var bitmapFactory : BitmapFactory = new BitmapFactory();
        var assetLoader : AssetLoader = new AssetLoader();
        var mapBackground : MapBackground = new MapBackground(mapData, bitmapFactory, assetLoader);
        var viewToggle : ViewToggle = new ViewToggle(bitmapFactory, assetLoader, mapBackground);


        // setup scene graph
		addChild(mapBackground);
		addChild(viewToggle);

        // load map data
		mapData.load("hello_world");

        // load assets
        this.preLoad();

        assetLoader.load(function()
        {
	        this.postLoad();

        	// start game loop
        	previousTime = Lib.getTimer ();
        	addEventListener (Event.ENTER_FRAME, frame);

	        this.start();
        });
    }

	private function frame (event:Event) : Void 
	{
		var currentTime = Lib.getTimer ();
		var deltaTime = currentTime - previousTime;

		previousTime = currentTime;

		this.update(deltaTime);
	}
}