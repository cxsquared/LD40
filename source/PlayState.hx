package;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var level:Level;

	override public function create():Void
	{
        level = new Level("assets/maps/tileTest.tmx");

        add(level.backgroundGroup);
        add(level.coinGroup);
        add(level.characterGroup);

        add(level.collisionGroup);

        add(level.player.light);
        add(level.darkness);

        FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
        FlxG.worldBounds.copyFrom(level.bounds);

        super.create();
	}

	override public function update(elapsed:Float):Void
	{
        level.update(elapsed);
		super.update(elapsed);
	}

    override public function draw():Void {
        FlxSpriteUtil.fill(level.darkness, FlxColor.BLACK);
        super.draw();
    }
}
