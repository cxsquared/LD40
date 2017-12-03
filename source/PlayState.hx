package;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var level:Level;
    var guardManager:GuardManager;

	override public function create():Void
	{
        level = new Level("assets/maps/tileTest.tmx");
        guardManager = new GuardManager(level.walls, level.player, level.guardGroup);

        add(level.backgroundGroup);
        add(level.coinGroup);
        add(level.guardGroup);
        add(level.player);

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
        guardManager.update(elapsed);
	}

    override public function draw():Void {
        FlxSpriteUtil.fill(level.darkness, FlxColor.BLACK);
        super.draw();
    }
}
