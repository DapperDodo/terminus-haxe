package;

import openfl.Assets;

import openfl.Lib;

import openfl.display.Sprite;

import openfl.events.Event;

import core.MapDefinitionLoader;
import core.MapData;

import interfaces.IBit;
import core.BitHelper;

import interfaces.IVision;
import core.VisionRegistryCaster;
import core.VisionStampFactory;
import core.VisionGridFactory;
import core.VisionUnitStore;
import core.VisionStampOutliner;
import core.VisionStampFiller;
import core.VisionEdgeShaper;
import core.Vision;

import head.BitmapFactory;
import head.AssetLoader;

import head.sprites.MapBackground;
import head.sprites.UpdateSprite;
import head.sprites.ViewToggle;

import interfaces.IFog;
import head.sprites.FogOfWar;
import head.FogMaskLoader;
import head.FogMaskGenerator;
import head.FogMaskCache;
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

		// helpers
        var bitHelper : IBitHelper = new BitHelper();

		// subsystem Map
		var mapDefinitionLoader : MapDefinitionLoader = new MapDefinitionLoader();
		var mapData : MapData = new MapData(mapDefinitionLoader);

		// subsystem Vision (shared)
		var fogOfWarGranularity : Int = 30;
        var visionGridFactory : IVisionGridFactory = new VisionGridFactory();
        var visionEdgeShaper : IVisionEdgeShaper = new VisionEdgeShaper(bitHelper);
        var visionStampOutliner : IVisionStampOutliner = new VisionStampOutliner(visionEdgeShaper);
        var visionStampFiller : IVisionStampFiller = new VisionStampFiller();
        var visionStampFactory : IVisionStampFactory = new VisionStampFactory(visionGridFactory, visionStampOutliner, visionStampFiller);
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
        var fogMaskGenerator : IFogMaskFactory = new FogMaskGenerator(fogOfWarGranularity, bitHelper);
        var fogMaskLoader : IFogMaskFactory = new FogMaskLoader(fogOfWarGranularity, fogMaskGenerator, assetLoader);
        var fogMaskCache : IFogMaskFactory = new FogMaskCache(fogOfWarGranularity, fogMaskLoader);
        var fogTileProjector : IFogTileProjector = new FogTileProjector(fogOfWarGranularity, fogMaskCache);
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