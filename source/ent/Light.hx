package ent;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

class Light extends FlxSprite {

    private var darkness:FlxSprite;

    public function new(X:Float, Y:Float, Darkness:FlxSprite) {
        super(X, Y);

        loadGraphic("assets/images/light.png");

        darkness = Darkness;
    }

    override public function update(elapsed:Float):Void {
        /*
        if (FlxG.game.ticks % 60 == 0) {
            this.alpha = FlxG.random.float(0.5, 1.0);
        }
        */

        super.update(elapsed);
    }

    override public function draw():Void {
        var screenXY:FlxPoint = getScreenPosition();

        darkness.stamp(this, Std.int(screenXY.x - this.width /2), Std.int(screenXY.y - this.height / 2));
    }
}
