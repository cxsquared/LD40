package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var level:Level;

	override public function create():Void
	{
        level = new Level("assets/maps/tileTest.tmx");

        add(level.backgroundGroup);
        add(level.characterGroup);

        add(level.collisionGroup);

        FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
        FlxG.worldBounds.copyFrom(level.bounds);

        super.create();
	}

	override public function update(elapsed:Float):Void
	{
        level.update(elapsed);
		super.update(elapsed);
	}
}
