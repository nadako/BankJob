package nadako.bankjob;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

class HouseTile extends Entity
{
    public var count(default, set_count):Int;

    var images:Array<Image>;

    public function new(paths:Array<String>)
    {
        super();

        images = [];
        for (path in paths)
        {
            images.push(new Image(path));
        }

        set_count(0);
    }

    function set_count(value:Int):Int
    {
        count = value;

        var imageIdx:Int = (value < images.length) ? value : images.length - 1;
        graphic = images[imageIdx];

        return value;
    }
}
