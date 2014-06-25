package;

import openfl.Assets;

import openfl.Lib;

import openfl.display.Sprite;

import openfl.events.Event;

import core.MapDefinitionLoader;
import core.MapData;

import interfaces.IVision;
import core.VisionRegistryCaster;
import core.VisionStampFactory;
import core.VisionGridFactory;
import core.VisionUnitStore;
import core.Vision;

import head.BitmapFactory;
import head.AssetLoader;

import head.sprites.MapBackground;
import head.sprites.UpdateSprite;
import head.sprites.ViewToggle;

import interfaces.IFog;
import head.sprites.FogOfWar;
import head.FogMaskFactory;
import head.FogTileProjector;

class Main extends UpdateSprite 
{	
    private var previousTime : Int;

    public function new () 
	{
		super ();
		stage.frameRate = 60;

		///////////////////////////////////////////////////
		// CORE objects
		///////////////////////////////////////////////////

		// subsystem Map
		var mapDefinitionLoader : MapDefinitionLoader = new MapDefinitionLoader();
		var mapData : MapData = new MapData(mapDefinitionLoader);

		// subsystem Vision (shared)
		var fogOfWarGranularity : Int = 24;
        var visionGridFactory : IVisionGridFactory = new VisionGridFactory();
        var visionStampFactory : IVisionStampFactory = new VisionStampFactory(visionGridFactory);
		// subsystem Vision (player 1) TODO: add objects for player 2
		var visionRegistry : IVisionRegistry = new VisionRegistryCaster();
		var visionBroadcaster : IVisionBroadcaster = cast(visionRegistry, IVisionBroadcaster); //implements registry and broadcast interfaces
        var visionUnitStore : IVisionUnitStore = new VisionUnitStore();
        var visionServer : IVisionServer = new Vision(visionStampFactory, visionGridFactory, visionBroadcaster, visionUnitStore);
        var visionTracker : IVisionTracker = cast(visionServer, IVisionTracker); //implements server and tracker interfaces

		// load map data
		mapData.load("hello_world");
		visionServer.init(fogOfWarGranularity, mapData.getWidth(), mapData.getHeight() / 2);

		///////////////////////////////////////////////////
		// HEAD objects
		///////////////////////////////////////////////////

        var bitmapFactory : BitmapFactory = new BitmapFactory();
        var assetLoader : AssetLoader = new AssetLoader();
        var mapBackground : MapBackground = new MapBackground(mapData, bitmapFactory, assetLoader);
        var fogMaskFactory : IFogMaskFactory = new FogMaskFactory(fogOfWarGranularity);
        var fogTileProjector : IFogTileProjector = new FogTileProjector(fogOfWarGranularity, fogMaskFactory);
        var fogOfWar : FogOfWar = new FogOfWar(mapData, mapBackground, bitmapFactory, assetLoader, visionRegistry, visionTracker, fogTileProjector);
        var viewToggle : ViewToggle = new ViewToggle(bitmapFactory, assetLoader, mapBackground);

        // setup scene graph
		addChild(mapBackground);
			mapBackground.addChild(fogOfWar);
		addChild(viewToggle);

        // load assets
        this.preLoad();

        assetLoader.load(function()
        {
        	var visionUnitStore : VisionUnitStore = new VisionUnitStore();
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