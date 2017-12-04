package ;
import flixel.math.FlxMath;
import flixel.util.FlxCollision;
import flixel.ui.FlxButton;
import flixel.system.FlxLinkedList;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
class MenuScreen extends FlxState {

    private var me:FlxText;
    private var credits:FlxText;

    override public function create():Void {
        var bg = new FlxSprite(0, 0, "assets/images/title.png");
        add(bg);

        var titleText = new FlxText(0, 10, FlxG.width, "More Money\nMore Problems");
        titleText.setFormat("assets/Bullio.ttf", 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.GREEN);
        add(titleText);

        var startText = new FlxText(0, 0, FlxG.width, "Press space to start");
        startText.setFormat("assets/Bullio.ttf", 12, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        startText.y = FlxG.height - titleText.height * 1.5;
        add(startText);

        me = new FlxText(0, 0, FlxG.width/2, "@Cxsquared");
        me.setFormat("assets/Bullio.ttf", 12, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        me.y = FlxG.height - me.height - 5;
        add(me);

        credits = new FlxText(FlxG.width/2, 0, FlxG.width/2, "More Credits");
        credits.setFormat("assets/Bullio.ttf", 12, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        credits.y = FlxG.height - credits.height - 5;
        add(credits);

        SoundManager.getInstance().playMusic();
    }

    override public function update(elapsed:Float):Void {
        if (FlxG.keys.justPressed.SPACE)
        {
            FlxG.switchState(new PlayState());
        }

        if (FlxG.mouse.justPressed && FlxMath.pointInFlxRect(FlxG.mouse.x, FlxG.mouse.y, me.getHitbox()))
        {
            var url = "https://twitter.com/cxsquared";
            openfl.Lib.getURL(new openfl.net.URLRequest(url));
        }

        if (FlxG.mouse.justPressed && FlxMath.pointInFlxRect(FlxG.mouse.x, FlxG.mouse.y, credits.getHitbox()))
        {
            FlxG.switchState(new CreditsScreen());
        }
    }
}
