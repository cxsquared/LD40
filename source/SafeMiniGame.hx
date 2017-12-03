package ;
import flixel.util.FlxColor;
import ent.Safe;
import ent.Player;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;
class SafeMiniGame extends FlxSubState {

    private var safeCombo:Array<Int>;
    private var dial:FlxSprite;
    private var rotationSpeed:Float = 90;
    private var currCombo = 0;
    private var movingRight = false;
    private var tollerance = 2;
    private var rightArrow:FlxSprite;
    private var leftArrow:FlxSprite;

    private var safe:Safe;

    public function new(Safe:Safe, ?color:FlxColor)
    {
        super(color);

        safe = Safe;
    }

    override public function create():Void
    {
        super.create();

        FlxG.log.add("Adding safe sub state");

        _parentState.persistentUpdate = true;

        generateSafeCombo();

        var bg = new FlxSprite(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
        bg.loadGraphic("assets/images/safeDialBackground.png");
        bg.scale.x = bg.scale.y = .5;
        bg.x = FlxG.camera.scroll.x - bg.width/8;
        bg.y = FlxG.camera.scroll.y - bg.height/8;
        add(bg);

        dial = new FlxSprite(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
        dial.loadGraphic("assets/images/safeDialCenter.png");
        dial.scale.x = dial.scale.y = .5;
        dial.x = FlxG.camera.scroll.x - dial.width/8;
        dial.y = FlxG.camera.scroll.y - dial.height/8;
        add(dial);

        rightArrow = new FlxSprite(0, 0);
        rightArrow.loadGraphic("assets/images/rightArrow.png");
        rightArrow.scrollFactor.set(0, 0);
        rightArrow.visible = false;
        add(rightArrow);

        leftArrow = new FlxSprite(0, 0);
        leftArrow.loadGraphic("assets/images/leftArrow.png");
        leftArrow.scrollFactor.set(0, 0);
        leftArrow.visible = false;
        add(leftArrow);
    }

    private function generateSafeCombo()
    {
        safeCombo = [FlxG.random.int(0, 39), FlxG.random.int(0, 39), FlxG.random.int(0, 39)];
    }

    override public function update(elapsed:Float):Void {
        if (FlxG.keys.anyPressed([FlxKey.SPACE])) {
            Player.canMove = true;
            close();
        }

        super.update(elapsed);

        FlxG.watch.addQuick("Dial Combo", safeCombo);
        FlxG.watch.addQuick("Dial Number", getCurrentDialNumber());
        FlxG.watch.addQuick("Current Dial State", currCombo);

        if (FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]))
        {
            SoundManager.getInstance().startSafeLoop();
            rotateDial(rotationSpeed * elapsed);
            movingRight = true;
        }
        else if (FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]))
        {
            SoundManager.getInstance().startSafeLoop();
            rotateDial(-rotationSpeed * elapsed);
            movingRight = false;
        }
        else{
            SoundManager.getInstance().stopSafeLoop();
        }

        switch(currCombo)
        {
            case 0:
                rightArrow.visible = false;
                leftArrow.visible = true;
                if (isWithin(getCurrentDialNumber(), safeCombo[0] - tollerance, safeCombo[0] + tollerance) && movingRight)
                {
                    currCombo++;
                    SoundManager.getInstance().playSafeDrop();
                    FlxG.camera.shake(0.0075, 0.25);
                }

            case 1:
                rightArrow.visible = true;
                leftArrow.visible = false;
                if (movingRight && !isWithin(getCurrentDialNumber(), safeCombo[0] - tollerance, safeCombo[0] + tollerance))
                {
                    SoundManager.getInstance().playSafeFail();
                    currCombo = 0;
                    FlxG.camera.shake(0.1);
                }

                if (!movingRight && isWithin(getCurrentDialNumber(), safeCombo[1] - tollerance, safeCombo[1] + tollerance))
                {
                    SoundManager.getInstance().playSafeDrop();
                    currCombo++;
                    FlxG.camera.shake(0.0075, 0.25);
                }

            case 2:
                rightArrow.visible = false;
                leftArrow.visible = true;
                if (!movingRight && !isWithin(getCurrentDialNumber(), safeCombo[1] - tollerance, safeCombo[1] + tollerance))
                {
                    SoundManager.getInstance().playSafeFail();
                    currCombo = 0;
                    FlxG.camera.shake(0.1);
                }

                if (movingRight && isWithin(getCurrentDialNumber(), safeCombo[2] - tollerance, safeCombo[2] + tollerance))
                {
                    SoundManager.getInstance().stopSafeLoop();
                    SoundManager.getInstance().playSafeSuccess();
                    safe.open();
                    close();
                    Player.coins += safe.coins;
                    Player.canMove = true;
                }
        }
    }

    private function rotateDial(amount:Float)
    {
        dial.angle += amount;
        if (dial.angle > 360)
            dial.angle -= 360;
        if (dial.angle < 0)
            dial.angle += 360;
    }

    private function isWithin(value:Float, min:Float, max:Float):Bool
    {
        return value >= min && value <= max;
    }

    public function getCurrentDialNumber():Int
    {
        return Math.round(scale(dial.angle, 0, 360, 39, 0));
    }

    private function scale(valueIn:Float, baseMin:Float, baseMax:Float, limitMin:Float, limitMax:Float) {
        return ((limitMax - limitMin) * (valueIn - baseMin) / (baseMax - baseMin)) + limitMin;
    }
}
