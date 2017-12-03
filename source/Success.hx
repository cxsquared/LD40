package ;
import ent.Player;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
class Success extends FlxState {

    override public function create()
    {
        var gameOver = new FlxText(10, 0, FlxG.width, "Congrats\nYou made out with $" + Player.coins * 25 + ".");
        gameOver.alignment = FlxTextAlign.CENTER;
        add(gameOver);

        var pressStart = new FlxText(0, 0, FlxG.width, "Press space to try again...");
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
