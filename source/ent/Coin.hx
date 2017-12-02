package ent;
import flixel.FlxG;
import flixel.FlxSprite;
class Coin extends FlxSprite {

    public var value:Int;

    public function new(X:Float, Y:Float, Value:Int) {
        super(X, Y);
        value =  Value;
        loadGraphic("assets/images/coins.png", true, 8, 8);
        FlxG.log.add("Coin value = " + value);
        animation.add("1", [0, 1], 3);
        animation.add("2", [2, 3], 3);

        animation.play(Std.string(value));
    }

    public function getNumberOfCoins():Int
    {
        switch(value)
        {
            case 1:
                return 1;
            case 2:
                return 5;
        }

        throw "Invalid coin value";
    }
}
