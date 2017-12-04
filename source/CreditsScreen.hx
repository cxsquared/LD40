package ;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
class CreditsScreen extends FlxState {

    private var me:FlxText;

    override public function create():Void {
        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString("#ff4343a3"));
        add(bg);

        var titleText = new FlxText(0, 10, FlxG.width, "Credits");
        titleText.setFormat("assets/Bullio.ttf", 14, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.GREEN);
        add(titleText);

        var startText = new FlxText(0, 0, FlxG.width/2, "Press space to return");
        startText.setFormat("assets/Bullio.ttf", 10, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        startText.y = FlxG.height - titleText.height * 1.5;
        add(startText);

        me = new FlxText(0, 0, FlxG.width, "Font by Jupiter_Hadley");
        me.setFormat("assets/Bullio.ttf", 12, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        me.y = FlxG.height/2 - me.height;
        add(me);
    }

    override public function update(elapsed:Float):Void {
        if (FlxG.keys.justPressed.SPACE)
        {
            FlxG.switchState(new MenuScreen());
        }

        if (FlxG.mouse.justPressed && FlxMath.pointInFlxRect(FlxG.mouse.x, FlxG.mouse.y, me.getHitbox()))
        {
            var url = "https://twitter.com/Jupiter_Hadley";
            openfl.Lib.getURL(new openfl.net.URLRequest(url));
        }
    }
}
