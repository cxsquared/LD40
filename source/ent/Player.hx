package ent;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.addons.display.FlxExtendedSprite;

class Player extends FlxExtendedSprite {

    private var collisionMap:FlxRect;
    private var maxBounds:FlxRect;
    public var light:Light;

    public function new(X:Float, Y:Float, Graphics:Dynamic, Darkness:FlxSprite) {
        super(X, Y);

        loadGraphic(Graphics, true, 8, 8);

        collisionMap = new FlxRect(0, 0, 8, 8);

        facing = FlxObject.DOWN;

        maxVelocity = FlxPoint.get(100, 100);

        drag.x = maxVelocity.x * 4;
        drag.y = maxVelocity.y * 4;

        light = new Light(X, Y, Darkness);
        light.scale = FlxPoint.get(4, 4);
    }

    override public function update(elapsed:Float):Void {
        acceleration.set(0, 0);

        if (FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]))
        {
            acceleration.x = drag.x;
            facing = FlxObject.RIGHT;
        }
        else if (FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]))
        {
            acceleration.x = -drag.x;
            facing = FlxObject.LEFT;
        }

        if (FlxG.keys.anyPressed([FlxKey.UP, FlxKey.W]))
        {
            acceleration.y = -drag.y;
            facing = FlxObject.UP;
        }
        else if (FlxG.keys.anyPressed([FlxKey.DOWN, FlxKey.S]))
        {
            acceleration.y = drag.y;
            facing = FlxObject.DOWN;
        }
        checkBoundsMap();

        light.x = this.x;
        light.y = this.y;

        super.update(elapsed);
    }

    public function setBoundsMap(boundsMap:FlxRect) {
        maxBounds = boundsMap;
    }

    private function checkBoundsMap():Void {
        if (maxBounds == null)
            return;

        if (x + collisionMap.x < maxBounds.x)
        {
            x = maxBounds.x - collisionMap.x;
            acceleration.x = 0;
        }
        else if ((x + collisionMap.x + collisionMap.width) > (maxBounds.x + maxBounds.width))
        {
            x = (maxBounds.x + maxBounds.width) - collisionMap.width - collisionMap.x;
            acceleration.x = 0;
        }

        if (y + collisionMap.y < maxBounds.y)
        {
            y = maxBounds.y - collisionMap.y;
            acceleration.y = 0;
        }
        else if ((y + collisionMap.y + collisionMap.height) > (maxBounds.y + maxBounds.height))
        {
            y = (maxBounds.y + maxBounds.height) - collisionMap.height - collisionMap.y;
            acceleration.y = 0;
        }
    }
}
