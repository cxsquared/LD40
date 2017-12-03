package ;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.tile.FlxBaseTilemap.FlxTilemapDiagonalPolicy;
import ent.Guard;
import flixel.group.FlxGroup.FlxTypedGroup;
import ent.Player;
import flixel.tile.FlxTilemap;

class GuardManager {

    public var tilemap:FlxTilemap;
    public var distances:Array<Int>;
    public var player:Player;

    public var guards:FlxTypedGroup<Guard>;

    public function new(Tilemap:FlxTilemap, Player:Player, Guards:FlxTypedGroup<Guard>) {
        tilemap = Tilemap;
        player = Player;
        guards =  Guards;
    }

    public function update(elapsed:Float):Void {
        var playerPoint = FlxPoint.get(player.x + player.width/2, player.y + player.height/2);
        for (guard in guards.members)
        {
            var curGuard:Guard = cast guard;
            var guardPoint = FlxPoint.get(curGuard.x + curGuard.width/2, curGuard.y + curGuard.height/2);

            var hitPoint = new FlxPoint();
            if (tilemap.ray(guardPoint, playerPoint, hitPoint))
            {
                FlxG.log.add("Player Seen!!!!");
            }
            else {
                FlxG.log.add("Can't see player");
            }

            if (curGuard.path.finished || !curGuard.path.active)
            {
                var path = tilemap.findPath(guardPoint, playerPoint);
                if (path == null)
                {
                    FlxG.log.add("path failed");
                }
                else {
                    FlxG.log.add("Startign path");
                    curGuard.path.start(path, 50);
                }
            }
        }
    }
}
