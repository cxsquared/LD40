package ;
import ent.Safe;
import ent.Guard;
import flixel.tile.FlxTilemap;
import ent.Coin;
import ent.Coin.Coin;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flash.display.BlendMode;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import ent.Player;
import flixel.util.FlxSort;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.math.FlxRect;
import flixel.FlxObject;
import flixel.addons.tile.FlxTilemapExt;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.editors.tiled.TiledMap;

class Level extends TiledMap {

    public var backgroundGroup:FlxTypedGroup<FlxTilemapExt>;

    public var collisionGroup:FlxTypedGroup<FlxObject>;
    public var guardGroup:FlxTypedGroup<Guard>;
    public var walls:FlxTilemap;
    public var coinGroup:FlxTypedGroup<Coin>;
    public var safeGroup:FlxTypedGroup<Safe>;
    public var player:Player;

    public var darkness:FlxSprite;

    public var bounds:FlxRect;

    public function new(Level:Dynamic) {
        super(Level);

        backgroundGroup = new FlxTypedGroup<FlxTilemapExt>();

        guardGroup = new FlxTypedGroup<Guard>();
        coinGroup = new FlxTypedGroup<Coin>();
        safeGroup = new FlxTypedGroup<Safe>();
        collisionGroup = new FlxTypedGroup<FlxObject>();

        bounds = FlxRect.get(0, 0, fullWidth, fullHeight);

        var tileset:TiledTileSet;
        var tilemap:FlxTilemapExt;

        for (tiledLayer in layers)
        {
            if (tiledLayer.type != TiledLayerType.TILE)
                continue;
            var layer:TiledTileLayer = cast tiledLayer;

            if (layer.properties.contains("tileset"))
                tileset = getTileSet(layer.properties.get("tileset"));
            else
                throw "Each layer needs a tileset property with the tileset name";

            if (tileset == null)
                throw  "Tileset is null";

            tilemap = new FlxTilemapExt();
            tilemap.loadMapFromArray(layer.tileArray, layer.width, layer.height, "assets/maps/" + tileset.imageSource, tileset.tileWidth, tileset.tileHeight, FlxTilemapAutoTiling.OFF, tileset.firstGID);
            tilemap.setTileProperties(1, FlxObject.ANY);
            tilemap.setTileProperties(2, FlxObject.NONE);

            tilemap.alpha = layer.opacity;

            backgroundGroup.add(tilemap);

            walls = tilemap;
        }

        darkness = new FlxSprite(0, 0);
        darkness.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
        darkness.blend = BlendMode.MULTIPLY;

        loadObjects();
    }

    private function loadObjects()
    {
        for (layer in layers)
        {
            if (layer.type != TiledLayerType.OBJECT)
                continue;

            var group:TiledObjectLayer = cast layer;

            for (obj in group.objects)
            {
                loadObject(obj, group);
            }
        }
    }

    private function loadObject(Obj:TiledObject, Group:TiledObjectLayer)
    {
        var x:Int = Obj.x;
        var y:Int = Obj.y;

        switch(Obj.type.toLowerCase())
        {
            case "collision":
                var coll:FlxObject = new FlxObject(x, y, Obj.width, Obj.height);
                coll.immovable = true;
                collisionGroup.add(coll);

            case "player":
                if (player == null)
                {
                    player = new Player(x, y, "assets/images/player.png", darkness);
                    player.setBoundsMap(bounds);
                    FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT, 2);
                }
                else
                    throw "There can't be more than one player";

            case "coin":
                if (!Obj.properties.contains("coinType"))
                    throw "Coin must have a value";

                var type = Obj.properties.get("coinType");
                FlxG.log.add("Parsing coin type " + type);
                var coin:Coin = new Coin(x, y, Std.parseInt(type));
                coinGroup.add(coin);

            case "guard":
                var guard:Guard = new Guard(x, y);
                guardGroup.add(guard);

            case "safe":
                safeGroup.add(new Safe(x, y, Std.parseInt(Obj.properties.get("coins"))));
        }
    }

    public function update(elapsed:Float):Void
    {
        updateCollisions();
        //updateEventsOrder();
    }

    public function updateCollisions():Void
    {
        FlxG.collide(guardGroup, collisionGroup);
        FlxG.collide(player , collisionGroup);
        FlxG.collide(guardGroup, player);

        FlxG.overlap(player, coinGroup, playerCoinsOverlap);
        if (FlxG.state.subState == null)
        {
            FlxG.overlap(player, safeGroup, playerSafeOverlap);
        }
    }

    private function playerCoinsOverlap(Player:FlxObject, Coin:FlxObject):Void {
        player.pickUpCoin(cast Coin);
    }

    private function playerSafeOverlap(HitPlayer:FlxObject, Safe:FlxObject):Void {
        var safe:Safe = cast Safe;
        if (!safe.opened)
        {
            var subState = new SafeMiniGame(safe, FlxColor.fromRGB(0, 0, 0, 200));
            Player.canMove = false;
            FlxG.state.openSubState(subState);
        }
    }

    public function updateEventsOrder()
    {
        guardGroup.sort(FlxSort.byY);
    }
}
