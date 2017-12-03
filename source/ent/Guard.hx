package ent;

import flixel.FlxG;
import flixel.util.FlxPath;
import flixel.addons.display.FlxExtendedSprite;

class Guard extends FlxExtendedSprite {

    private var speed:Int = 8;
    public var seesPlayer = false;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        path = new FlxPath();

        loadGraphic("assets/images/guard.png", true, 8, 8);

        animation.add("walking", [1,2], 6);
        animation.add("idle", [0]);
    }


    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (path.active)
        {
            animation.play("walking");
        }
        else
        {
            animation.play("idle");
        }

        FlxG.watch.addQuick("GuardPath", path.nodes);
    }
}
