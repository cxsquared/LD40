package ;
import flixel.FlxG;
class SoundManager {

    private var coinSounds = ["Pickup_Coin.wav", "Pickup_Coin2.wav", "Pickup_Coin3.wav"];

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
    }

    public function playCoin()
    {
        FlxG.sound.play("assets/sounds/" + FlxG.random.getObject(coinSounds), 0.5);
    }
}
