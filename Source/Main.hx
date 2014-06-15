package;

import openfl.Assets;

import openfl.Lib;

import openfl.display.Sprite;

import openfl.events.Event;

import core.MapDefinitionLoader;
import core.MapData;

import interfaces.IVision;
import core.VisionStampFactory;
import core.VisionGridFactory;
import core.Vision;

import head.BitmapFactory;
import head.AssetLoader;

import head.sprites.MapBackground;
import head.sprites.UpdateSprite;
import head.sprites.ViewToggle;
import head.sprites.FogOfWar;

class Main extends UpdateSprite 
{	
    private var previousTime : Int;

    public function new () 
	{
		super ();
		stage.frameRate = 60;

		// configuration
		var fogOfWarGranularity : Int = 12;


		// instanciate core classes
		var mapDefinitionLoader : MapDefinitionLoader = new MapDefinitionLoader();
		var mapData : MapData = new MapData(mapDefinitionLoader);
        var visionGridFactory : VisionGridFactory = new VisionGridFactory(fogOfWarGranularity);
        var visionStampFactory : VisionStampFactory = new VisionStampFactory(fogOfWarGranularity, visionGridFactory);
        var playerVision : IVisionServer = new Vision(fogOfWarGranularity, mapData, visionStampFactory, visionGridFactory);

		// load map data
		mapData.load("hello_world");
		playerVision.init();

		// instanciate head classes
        var bitmapFactory : BitmapFactory = new BitmapFactory();
        var assetLoader : AssetLoader = new AssetLoader();
        var mapBackground : MapBackground = new MapBackground(mapData, bitmapFactory, assetLoader);
        var fogOfWar : FogOfWar = new FogOfWar(mapData, playerVision, mapBackground, bitmapFactory, assetLoader);
        var viewToggle : ViewToggle = new ViewToggle(bitmapFactory, assetLoader, mapBackground);

        // setup scene graph
		addChild(mapBackground);
			mapBackground.addChild(fogOfWar);
		addChild(viewToggle);

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