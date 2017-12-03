package ent;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxPath;
import flixel.addons.display.FlxExtendedSprite;

class Guard extends FlxExtendedSprite {

    private var moveSpeed:Int = 15;
    private var runSpeed:Int = 35;
    public var seesPlayer = false;
    public var seeDistance:Int = 75;
    public var canMove = true;

    private var moveTimer:FlxTimer;
    private var seePlayerTimer:FlxTimer;

    private var moveWait:Float = 2.5;
    private var moveWaitOffset:Float = 2;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        path = new FlxPath();
        moveTimer = new FlxTimer();
        seePlayerTimer = new FlxTimer();

        loadGraphic("assets/images/guard.png", true, 8, 8);

        animation.add("walking", [1,2], 6);
        animation.add("idle", [0]);
    }

    public function move(nodes:Array<FlxPoint>):Void {
        path.start(nodes, seesPlayer ? runSpeed : moveSpeed);
        canMove = false;
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

        if (path.finished && (canMove = false || !moveTimer.active))
        {
            if (seesPlayer)
            {
                canMove = true;
            }
            else
            {
                moveTimer.start(FlxG.random.float(0, moveWaitOffset) + moveWait, resetMove);
            }
        }
        FlxG.watch.addQuick("GuardPath", path.nodes);
    }

    private function resetMove(t:FlxTimer):Void {
        canMove = true;
    }
}
