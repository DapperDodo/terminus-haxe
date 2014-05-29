package head;

import openfl.display.Sprite;

class UpdateSprite extends Sprite
{
	public function preLoad()
	{
		onPreLoad();

		// recurse
		var c : Int = 0;
		while(c < numChildren)
		{
			if(Std.is(getChildAt(c), UpdateSprite))
			{
				cast(getChildAt(c), UpdateSprite).preLoad();
			}

			c++;
		}
	}

	public function postLoad()
	{
		onPostLoad();

		// recurse
		var c : Int = 0;
		while(c < numChildren)
		{
			if(Std.is(getChildAt(c), UpdateSprite))
			{
				cast(getChildAt(c), UpdateSprite).postLoad();
			}

			c++;
		}
	}

	public function start()
	{
		onStart();

		// recurse
		var c : Int = 0;
		while(c < numChildren)
		{
			if(Std.is(getChildAt(c), UpdateSprite))
			{
				cast(getChildAt(c), UpdateSprite).start();
			}

			c++;
		}
	}

	public function update(deltaTime : Int)
	{
		onUpdate(deltaTime);

		// recurse
		var c : Int = 0;
		while(c < numChildren)
		{
			if(Std.is(getChildAt(c), UpdateSprite))
			{
				cast(getChildAt(c), UpdateSprite).update(deltaTime);
			}

			c++;
		}
	}

	public function stop()
	{
		onStop();

		// recurse
		var c : Int = 0;
		while(c < numChildren)
		{
			if(Std.is(getChildAt(c), UpdateSprite))
			{
				cast(getChildAt(c), UpdateSprite).stop();
			}

			c++;
		}
	}

	private function onPreLoad() {}
	private function onPostLoad() {}
	private function onStart() {}
	private function onUpdate(deltaTime : Int) {}
	private function onStop() {}
}