package ent;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
class Dust extends FlxSprite {

    private var timer:FlxTimer;
    private var aliveTime = 1;
    private var player:Player;

    public function new(X:Float, Y:Float, ?Player:Player) {
        super(X, Y);

        player = Player;

        loadGraphic("assets/images/dust.png", true, 8, 8);

        animation.add("dust", [0, 1, 2, 3], 12, true);
        animation.play("dust");

        timer = new FlxTimer();
        timer.start(aliveTime, endTimer);
    }

    private function endTimer(t:FlxTimer):Void {
        if (player != null)
        {
            Player.canMove = true;
            player.knockedOut = false;
        }
        destroy();
    }
}
