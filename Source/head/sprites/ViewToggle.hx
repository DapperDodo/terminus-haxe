package head.sprites;

import openfl.display.SimpleButton;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.events.MouseEvent;

import motion.Actuate;
import motion.easing.Sine;

class ViewToggle extends UpdateSprite
{
	private var button : SimpleButton;

	private var up : Bitmap;
	private var over : Bitmap;
	private var down : Bitmap;
	private var hittest : Bitmap;

	private var assetLoader : AssetLoader;
	private var mapBackground : MapBackground;

	private var home : Bool;

	public function new(bitmapFactory : BitmapFactory, assetLoader : AssetLoader, mapBackground : MapBackground)
	{
		super();

		up = bitmapFactory.getInstance();
		over = bitmapFactory.getInstance();
		down = bitmapFactory.getInstance();
		hittest = bitmapFactory.getInstance();

		this.assetLoader = assetLoader;
		this.mapBackground = mapBackground;

		button = new SimpleButton(up, over, down, hittest);
		addChild(button);

		home = true; // by default show home half of the map
	}

	override private function onPreLoad()
	{
        assetLoader.register("up-up", "assets/gui/up-up.png");
        assetLoader.register("up-over", "assets/gui/up-over.png");
        assetLoader.register("up-down", "assets/gui/up-down.png");
        assetLoader.register("up-hittest", "assets/gui/up-hittest.png");
	}

	override private function onPostLoad()
	{
		up.bitmapData = assetLoader.get("up-up");
		over.bitmapData = assetLoader.get("up-over");
		down.bitmapData = assetLoader.get("up-down");
		hittest.bitmapData = assetLoader.get("up-hittest");
	}

	override private function onStart()
	{
		x = (mapBackground.width - width) / 2;
		enable();
	}

	override private function onStop()
	{
		disable();
	}

	private function onMouseDown(event:MouseEvent)
	{
		disable();
		if(home)
		{
			home = false;
			mapBackground.showAway();
			tweenTo(180, ((mapBackground.width - width) / 2) + width, 800 - width + width);
		}
		else
		{	
			home = true;
			mapBackground.showHome();
			tweenTo(0, (mapBackground.width - width) / 2, 0);
		}
	}

	private function tweenTo(toRotation : Float, toX : Float, toY : Float)
	{
		Actuate.tween 
		(
			this, 
			0.75, 
			{ 
				rotation : toRotation,  
				x : toX, 
				y : toY
			}
		).onComplete
		(
			function ()
			{
				enable();
			}
		).ease (Sine.easeInOut);
	}

	private function enable()
	{
		button.mouseEnabled = true;
		button.enabled = true;
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}

	private function disable()
	{
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		button.enabled = false;
		button.mouseEnabled = false;
	}

	/*
	override private function onUpdate(deltaTime : Int)
	{
		//trace ("was here! dt=" + deltaTime);
		x += (10 * (deltaTime / 1000));
	}
	*/
}