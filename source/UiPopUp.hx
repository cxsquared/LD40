package ;

import flixel.system.FlxSound;
import ent.Player;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class UiPopUp extends FlxSubState {

    private var textBackground:FlxSprite;
    private var textSprite:FlxTypeText;
    private var textFinishedSprite:FlxText;
    private var isTextFinished:Bool = false;
    private var text:String = "";

    public function new(Text:String)
    {
        super();
        text = Text;

        Player.canMove = false;
    }

    override public function create()
    {
        super.create();
        textBackground = new FlxSprite();
        textBackground.scrollFactor.set(0, 0);
        textBackground.makeGraphic(FlxG.width, Std.int(FlxG.height / 4), FlxColor.fromRGB(0, 0, 0, 126));
        add(textBackground);

        textSprite = new FlxTypeText(0, 0, FlxG.width - 20, text);
        textSprite.setFormat("assets/Bullio.ttf", 10);
        textSprite.sounds = [new FlxSound().loadEmbedded("assets/sounds/text01.wav"),
                            new FlxSound().loadEmbedded("assets/sounds/text02.wav"),
                            new FlxSound().loadEmbedded("assets/sounds/text03.wav"),
                            new FlxSound().loadEmbedded("assets/sounds/text04.wav"),
                            new FlxSound().loadEmbedded("assets/sounds/text05.wav")];
        textSprite.alignment = FlxTextAlign.LEFT;
        textSprite.color = FlxColor.WHITE;
        textSprite.scrollFactor.set(0, 0);
        add(textSprite);

        textFinishedSprite = new FlxText(10, 0, FlxG.width - 20, "Press space...");
        textFinishedSprite.setFormat("assets/Bullio.ttf");
        textFinishedSprite.visible = false;
        textFinishedSprite.y = textBackground.height - textFinishedSprite.height;
        textFinishedSprite.scrollFactor.set(0, 0);
        add(textFinishedSprite);

        textSprite.start(textSprite.delay, false, false, [FlxKey.SPACE], textFinished);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (isTextFinished && FlxG.keys.justPressed.SPACE)
        {
            close();
            Player.canMove = true;
        }
    }

    public function textFinished():Void {
        var timer = new FlxTimer();
        timer.start(0.25, textSkippabled);
        textFinishedSprite.visible = true;
    }

    private function textSkippabled(t:FlxTimer)
    {
        isTextFinished = true;
    }
}
