package ent;
import flixel.math.FlxMath;
import flixel.FlxSprite;
class Door extends FlxSprite {

    public var canInteract = true;
    public var player:Player;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        loadGraphic("assets/images/door.png");

        immovable = true;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (player != null && FlxMath.distanceBetween(this, player) >= 12 && !canInteract)
        {
            canInteract = true;
            player = null;
        }
    }
}
