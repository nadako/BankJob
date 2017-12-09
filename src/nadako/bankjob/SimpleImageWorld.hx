package nadako.bankjob;

import hxd.Key;

class SimpleImageWorld extends Scene {
    var nextWorld:Scene;

    public function new(tile:h2d.Tile, nextWorld:Scene = null) {
        super();
        this.nextWorld = nextWorld;
        new h2d.Bitmap(tile, this);
    }

    override function update(dt) {
        if (nextWorld != null && (Key.isPressed(Key.MOUSE_LEFT) || Key.isPressed(Key.SPACE)))
            Main.scene = nextWorld;
    }
}
