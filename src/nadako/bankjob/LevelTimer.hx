package nadako.bankjob;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;

class LevelTimer extends Entity
{
    var duration:Float;
    var timer:Float;
    var barImage:Image;
    var carImage:Spritemap;

    public function new(duration:Float)
    {
        super();
        this.duration = duration;
        barImage = cast addGraphic(new Image("gfx/car_bar.png"));
        carImage = cast addGraphic(new Spritemap("gfx/car.png", 52));
        carImage.add("main", [0, 1], 2);
        carImage.y = (barImage.height - carImage.height) / 2 - 3;
    }

    override public function added():Void
    {
        timer = 0;
        carImage.play("main", true);
    }

    override public function update():Void
    {
        timer += HXP.elapsed;
        if (!isFinished)
        {
            var percent:Float = timer / duration;
            var width:Int = barImage.width - carImage.width;
            carImage.x = width * percent;
        }
    }

    public var isFinished(get, never):Bool;

    inline function get_isFinished():Bool
    {
        return timer > duration;
    }

    public var timeLeft(get, never):Int;

    inline function get_timeLeft():Int
    {
        return Math.ceil(duration - timer);
    }
}
