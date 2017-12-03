package ent;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
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
    private var knockOutTimer:FlxTimer;

    private var moveWait:Float = 2.5;
    private var moveWaitOffset:Float = 2;
    private var knockWait:Float = 2;
    private var knockWaitOffset:Float = 3;
    public var knockedOut = false;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        path = new FlxPath();
        moveTimer = new FlxTimer();
        knockOutTimer = new FlxTimer();

        loadGraphic("assets/images/guard.png", true, 8, 8);

        setFacingFlip(FlxObject.UP, false, true);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        setFacingFlip(FlxObject.DOWN, false, false);

        animation.add("walking", [1,2], 6);
        animation.add("idle", [0]);
        animation.add("knocked", [3, 4, 5], 12, true);

        animation.play("idle");
    }

    public function move(nodes:Array<FlxPoint>):Void {
        path.start(nodes, seesPlayer ? runSpeed : moveSpeed);
        canMove = false;
    }

    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        updateFacing();

        if (path.active && animation.curAnim.name != "walking" && !knockedOut)
        {
            animation.play("walking");
        }

        if (path.finished && !moveTimer.active && !knockedOut)
        {
            if (seesPlayer)
            {
                canMove = true;
            }
            else
            {
                moveTimer.start(FlxG.random.float(-moveWaitOffset, moveWaitOffset) + moveWait, resetMove);
            }
        }
        FlxG.watch.addQuick("GuardPath", path.nodes);
    }

    private function updateFacing()
    {
        if (velocity.x > 0)
        {
            facing = FlxObject.RIGHT;
        }
        else if (velocity.x < 0)
        {
            facing = FlxObject.LEFT;
        }

        if (velocity.y > 0)
        {
            facing = FlxObject.DOWN;
        }
        else if (velocity.y < 0)
        {
            facing = FlxObject.UP;
        }

        if (facing == FlxObject.LEFT)
        {
            angle = 90;
        }
        else if (facing == FlxObject.RIGHT)
        {
            angle = 270;
        }
        else
        {
            angle = 0;
        }
    }

    public function knockOut()
    {
        FlxG.log.add("Guard knocked");
        knockedOut = true;
        path.cancel();
        moveTimer.cancel();
        animation.play("knocked");
        knockOutTimer.start(FlxG.random.float(0, knockWaitOffset) + knockWait, finishedKnocked);
        canMove = false;
    }

    private function resetMove(t:FlxTimer):Void {
        if (!knockedOut)
        {
            canMove = true;
        }
    }

    private function finishedKnocked(t:FlxTimer):Void {
        FlxG.log.add("Guard not knocked");
        knockedOut = false;
        animation.play("idle");
        moveTimer.start(FlxG.random.float(-moveWaitOffset, moveWaitOffset) + moveWait, resetMove);
    }
}
