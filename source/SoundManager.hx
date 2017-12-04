package ;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.FlxG;
class SoundManager {

    private var coinSounds = ["Pickup_Coin.wav", "Pickup_Coin2.wav", "Pickup_Coin3.wav"];
    private var tumblerSounds =["tumblr01.wav", "tumblr02.wav", "tumblr03.wav"];
    private var fightSounds = ["fight01.wav", "fight02.wav", "fight03.wav"];
    private var shoutSounds = ["shout01.wav", "shout02.wav", "shout03.wav"];
    private var safeLoop:FlxSound;

    private static var intance:SoundManager;
    public static function getInstance():SoundManager
    {
        if (intance == null)
        {
            intance = new SoundManager();
        }

        return intance;
    }

    private function new() {
        safeLoop = FlxG.sound.load("assets/sounds/safeLoop.wav", 0.25, true);
    }

    public function playCoin()
    {
        FlxG.sound.play("assets/sounds/" + FlxG.random.getObject(coinSounds), 0.35);
    }

    public function playSafeDrop()
    {
        FlxG.sound.play("assets/sounds/" + FlxG.random.getObject(tumblerSounds), 0.5);
    }

    public function playSafeFail()
    {
        FlxG.sound.play("assets/sounds/tumblerFail.wav", 0.5);
    }

    public function playSafeSuccess()
    {
        FlxG.sound.play("assets/sounds/safeSuccess.wav", .75);
    }

    public function startSafeLoop()
    {
        if (safeLoop.playing != true)
        {
            safeLoop.play(false);
        }
        else {
            safeLoop.resume();
        }
    }

    public function stopSafeLoop()
    {
        safeLoop.pause();
    }

    public function playFight()
    {
        FlxG.sound.play("assets/sounds/" + FlxG.random.getObject(fightSounds), 1.5);
    }

    public function playShout()
    {
        FlxG.sound.play("assets/sounds/" + FlxG.random.getObject(shoutSounds), 1.5);
    }

    public function playMusic()
    {
        if (FlxG.sound.music == null || !FlxG.sound.music.playing)
        {
            #if desktop
            FlxG.sound.playMusic("assets/music/music.ogg", .35);
            #else
            FlxG.sound.playMusic("assets/music/music.mp3", .35);
            #end
        }
    }

    public function getTextSounds():Array<FlxSound>
    {
        var returnArray = new Array<FlxSound>();

        for (i in 1...6)
        {
            var sound = new FlxSound();
            sound.loadEmbedded("assets/sounds/text0" + i + ".wav");
            sound.volume = 0.25;
            returnArray[i] = sound;
        }

        return returnArray;
    }
}
