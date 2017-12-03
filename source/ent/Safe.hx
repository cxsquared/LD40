package ent;
import flixel.math.FlxMath;
import flixel.util.FlxCollision;
import flixel.addons.display.FlxExtendedSprite;
class Safe extends FlxExtendedSprite {

    public var opened = false;
    public var coins = 0;
    public var player:Player;
    public var canOpen = true;

    public function new(X:Float, Y:Float, Coins:Int) {
        super(X, Y);

        coins = Coins;
        
        loadGraphic("assets/images/safe.png", true, 8, 8);

        animation.add("closed", [0], 1, false);
        animation.add("opend", [1], 1, false);

        animation.play("closed");
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (player != null && FlxMath.distanceBetween(this, player) >= 12 && !canOpen)
        {
            canOpen = true;
            player = null;
        }
    }
}
