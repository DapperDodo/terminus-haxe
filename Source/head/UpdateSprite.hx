package head;

import openfl.display.Sprite;

class UpdateSprite extends Sprite
{
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

	private function onUpdate(deltaTime : Int) {}
}