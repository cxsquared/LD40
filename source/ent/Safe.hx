package ent;
import flixel.addons.display.FlxExtendedSprite;
class Safe extends FlxExtendedSprite {

    public var opened = false;
    public var coins = 0;

    public function new(X:Float, Y:Float, Coins:Int) {
        super(X, Y);

        coins = Coins;
        
        loadGraphic("assets/images/safe.png", true, 8, 8);

        animation.add("closed", [0], 1, false);
        animation.add("opend", [1], 1, false);

        animation.play("closed");
    }
}
