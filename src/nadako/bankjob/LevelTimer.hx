package nadako.bankjob;

import h2d.Bitmap;
import h2d.Anim;

class LevelTimer extends h2d.Sprite {
    var duration:Float;
    var timer:Float;
    var barImage:Bitmap;
    var carImage:Anim;

    public function new(duration:Float, parent) {
        super(parent);
        this.duration = duration;
        barImage = new Bitmap(hxd.Res.gfx.car_bar.toTile(), this);

        var carTiles = hxd.Res.gfx.car.toTile();
        carImage = new Anim([
            carTiles.sub(0, 0, 52, carTiles.height),
            carTiles.sub(52, 0, 52, carTiles.height),
        ], this);
        carImage.y = (barImage.tile.height - carTiles.height) / 2 - 3;
        timer = 0;
        carImage.pause = false;
    }

    public function update(dt) {
        timer += dt;
        if (!isFinished) {
            var percent = timer / duration;
            var width = barImage.tile.width - carImage.frames[0].width;
            carImage.x = width * percent;
        }
    }

    public var isFinished(get, never):Bool;

    inline function get_isFinished():Bool {
        return timer > duration;
    }

    public var timeLeft(get, never):Int;

    inline function get_timeLeft():Int {
        return Math.ceil(duration - timer);
    }
}
