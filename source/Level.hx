package ;
import flixel.addons.editors.tiled.TiledTile;
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
    public var characterGroup:FlxTypedGroup<Player>;

    public var bounds:FlxRect;

    public function new(Level:Dynamic) {
        super(Level);

        backgroundGroup = new FlxTypedGroup<FlxTilemapExt>();

        characterGroup = new FlxTypedGroup<Player>();
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

            tilemap.alpha = layer.opacity;

            backgroundGroup.add(tilemap);
        }

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
        }
    }

    public function update(elapsed:Float):Void
    {
        updateCollisions();
        updateEventsOrder();
    }

    public function updateCollisions():Void
    {
        FlxG.collide(characterGroup, collisionGroup);
        FlxG.collide(characterGroup, characterGroup);
    }

    public function updateEventsOrder()
    {
        characterGroup.sort(FlxSort.byY);
    }
}
