package ;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSubState;
class GameOver extends FlxState {

    override public function create()
    {
        var gameOver = new FlxText(10, 0, FlxG.width, "Game Over\nYou got too greedy.");
        gameOver.alignment = FlxTextAlign.CENTER;
        add(gameOver);

        var pressStart = new FlxText(0, 0, FlxG.width, "Press space to restart...");
        pressStart.y = FlxG.height - pressStart.height - 10;
        pressStart.alignment = FlxTextAlign.CENTER;
        add(pressStart);
    }

    override public function update(elapsed:Float)
    {
       if (FlxG.keys.justPressed.SPACE)
       {
           FlxG.switchState(new PlayState());
       }
    }
}
