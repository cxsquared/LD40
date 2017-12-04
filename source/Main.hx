package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(240, 180, MenuScreen, 2, 60, 60, false));
	}
}
