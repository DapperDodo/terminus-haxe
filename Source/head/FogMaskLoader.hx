package head;

import openfl.display.BitmapData;

import openfl.utils.ByteArray;

//import sys.io.FileOutput;

import interfaces.IVision;
import interfaces.IFog;

class FogMaskLoader implements IFogMaskFactory
{
	private var tilesize : Int;
	private var fogMaskFactory : IFogMaskFactory;
	private var assetLoader : AssetLoader;

	public function new(tilesize : Int, fogMaskFactory : IFogMaskFactory, assetLoader : AssetLoader)
	{
		this.tilesize = tilesize;
		this.fogMaskFactory = fogMaskFactory;
		this.assetLoader = assetLoader;

        assetLoader.register("30-11" , "assets/fogmasks/30-11-new.png" );
        assetLoader.register("30-192", "assets/fogmasks/30-192-new.png");
        assetLoader.register("30-200", "assets/fogmasks/30-200-new.png");
        assetLoader.register("30-219", "assets/fogmasks/30-219-new.png");
        assetLoader.register("30-288", "assets/fogmasks/30-288-new.png");
        assetLoader.register("30-3"  , "assets/fogmasks/30-3-new.png"  );
        assetLoader.register("30-36" , "assets/fogmasks/30-36-new.png" );
        assetLoader.register("30-38" , "assets/fogmasks/30-38-new.png" );
        assetLoader.register("30-384", "assets/fogmasks/30-384-new.png");
        assetLoader.register("30-416", "assets/fogmasks/30-416-new.png");
        assetLoader.register("30-438", "assets/fogmasks/30-438-new.png");
        assetLoader.register("30-504", "assets/fogmasks/30-504-new.png");
        assetLoader.register("30-6"  , "assets/fogmasks/30-6-new.png"  );
        assetLoader.register("30-63" , "assets/fogmasks/30-63-new.png" );
        assetLoader.register("30-72" , "assets/fogmasks/30-72-new.png" );
        assetLoader.register("30-9"  , "assets/fogmasks/30-9-new.png"  );
	}

	public function instance(shape : IVisionTileShape) : BitmapData
	{
		var maskAsset : String = tilesize+"-"+shape;
		//trace("Trying to load fog mask asset ["+maskAsset+"]");
		var mask : BitmapData = assetLoader.get(maskAsset);
		if(mask == null)
		{
			mask = fogMaskFactory.instance(shape);
			// var b:ByteArray = mask.encode("png", 1);
			// var fo:FileOutput = sys.io.File.write(maskAsset+".png", true);
			// fo.writeString(b.toString());
			// fo.close();
		}
		return mask;
	}

	//////////////////////////////
	// private parts
	//////////////////////////////

}