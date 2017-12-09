package nadako.bankjob;

import h2d.Tile;
import h2d.Bitmap;

class HouseTile extends Bitmap {
    public var count(default, set):Int;

    var images:Array<Tile>;

    public function new(images:Array<Tile>, parent:h2d.Sprite) {
        super(null, parent);
        this.images = images;
        set_count(0);
    }

    function set_count(value:Int):Int {
        count = value;
        var imageIdx = (value < images.length) ? value : images.length - 1;
        tile = images[imageIdx];
        return value;
    }
}
