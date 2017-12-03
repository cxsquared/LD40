package ent;
import flixel.math.FlxVector;
import flixel.util.FlxPath;
import flixel.math.FlxVelocity;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxMath;
import ent.Coin.Coin;
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
    private var coinMultiplyer = 5;
    public static var coins:Int = 0;
    public var light:Light;
    private var lightFollow = 5;
    private var minLightScale = 1;
    private var maxLightScale = 6;
    public static var canMove = true;
    public var knockedOut = false;
    public var bag:FlxSprite;
    private var bagFollow = 15;
    private var maxCoins = 350;
    private var maxBagScale = 6;
    private var minSpeed = 25;
    private var maxSpeed = 100;

    public var canLeave = false;

    public function new(X:Float, Y:Float, Graphics:Dynamic, Darkness:FlxSprite) {
        super(X, Y);

        loadGraphic(Graphics, true, 8, 8);
        animation.add("walking", [1, 2], 6);
        animation.add("idle", [0]);

        setFacingFlip(FlxObject.UP, false, true);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        setFacingFlip(FlxObject.DOWN, false, false);

        collisionMap = new FlxRect(0, 0, 6, 6);

        facing = FlxObject.DOWN;

        maxVelocity = FlxPoint.get(100, 100);

        drag.x = maxVelocity.x * 4;
        drag.y = maxVelocity.y * 4;

        light = new Light(X, Y, Darkness);
        light.scale = FlxPoint.get(maxLightScale, maxLightScale);

        bag = new FlxSprite(X, Y);
        bag.loadGraphic("assets/images/bag.png");

        setSize(6, 6);
    }

    override public function update(elapsed:Float):Void {
        FlxG.watch.addQuick("Coins", Player.coins);

        acceleration.set(0, 0);

        maxVelocity.x = maxVelocity.y = FlxMath.remapToRange(coins, 0, maxCoins, maxSpeed, minSpeed);
        drag.x = maxVelocity.x * 4;
        drag.y = maxVelocity.y * 4;

        if (canMove)
        {
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
        }
        checkBoundsMap();

        if (acceleration.x == 0 && acceleration.y == 0)
        {
            animation.play("idle");
        }
        else
        {
            animation.play("walking");
        }

        light.x = FlxMath.lerp(light.x, x, lightFollow * elapsed);
        light.y = FlxMath.lerp(light.y, y, lightFollow * elapsed);

        light.scale.x = light.scale.y = FlxMath.lerp(light.scale.x, FlxMath.remapToRange(coins, 0, 350, maxLightScale, minLightScale), elapsed);

        if (facing == FlxObject.RIGHT || facing == FlxObject.LEFT)
        {
            bag.angle = angle - 180;
        }
        else
        {
            bag.angle = facing == FlxObject.DOWN ? 180 : 0;
        }

        if (FlxMath.distanceBetween(bag, this) >= 6)
        {
            bag.x = FlxMath.lerp(bag.x, x, bagFollow * elapsed);
            bag.y = FlxMath.lerp(bag.y, y, bagFollow * elapsed);
        }
        bag.scale.x = bag.scale.y = FlxMath.remapToRange(coins, 0, maxCoins, 1, maxBagScale);

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

    public function pickUpCoin(coin:Coin): Void
    {
        coins += coin.getNumberOfCoins();
        coin.destroy();
    }
}
