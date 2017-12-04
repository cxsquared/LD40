package ent;
import flixel.FlxG;
import flixel.math.FlxMath;
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
        animation.add("opened", [1], 1, false);
        animation.add("door", [2], 1, false);

        if (coins > 0)
        {
            animation.play("closed");
        }
        else
        {
            immovable = true;
            animation.play("door");
        }
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

    public function open()
    {
        if (coins > 0)
        {
            animation.play("opened");
            opened = true;
        }
        else {
            immovable = false;
            player.canLeave = true;
            FlxG.state.openSubState(new UiPopUp("Now just to grab the cash and leave."));
            kill();
        }
    }
}
