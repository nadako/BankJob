package nadako.bankjob;

import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.World;

class SimpleImageWorld extends World
{
    var nextWorld:World;

    public function new(path:String, nextWorld:World = null)
    {
        super();
        this.nextWorld = nextWorld;
        addGraphic(new Image(path));
    }

    override public function update():Void
    {
        super.update();
        if (nextWorld != null && (Input.mousePressed || Input.pressed(Key.ANY)))
            HXP.scene = nextWorld;
    }
}
