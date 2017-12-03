package ;

import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.FlxG;
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

            if (Math.abs(FlxMath.distanceBetween(curGuard, player)) <= curGuard.seeDistance)
            {
                var hitPoint = new FlxPoint();
                if (tilemap.ray(guardPoint, playerPoint, hitPoint))
                {
                    curGuard.seesPlayer = true;
                }
                else {
                    curGuard.seesPlayer = false;
                }
            }
            else {
                curGuard.seesPlayer = false;
            }

            if (curGuard.canMove || curGuard.seesPlayer)
            {
                var path:Array<FlxPoint> = null;
                if (curGuard.seesPlayer)
                {
                    path = tilemap.findPath(guardPoint, playerPoint);
                }
                else
                {
                    var tryPoint = FlxAngle.getCartesianCoords(curGuard.seeDistance, FlxG.random.float(0, 360));
                    tryPoint.addPoint(guardPoint);
                    if (tilemap.ray(guardPoint, tryPoint))
                    {
                        path = tilemap.findPath(guardPoint, tryPoint);
                    }
                }

                if (path == null)
                {
                    FlxG.log.add("path failed");
                }
                else {
                    FlxG.log.add("Startign path");
                    curGuard.move(path);
                }
            }
        }
    }
}
