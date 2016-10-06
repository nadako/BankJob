package nadako.bankjob;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

class Obstacle extends Entity
{
    var images:Array<Image>;
    var def:ObstacleDef;
    var currentState:Int;
    var currentFrame:Int;
    var animTimer:Float;
    var stateTimer:Float;

    public var isBlocking(get_isBlocking, never):Bool;
    public var isDeadly(get_isDeadly, never):Bool;

    public function new(def:ObstacleDef)
    {
        super();

        this.def = def;

        images = [];
        for (path in def.images)
        {
            images.push(new Image(path));
        }

        currentState = 0;
        currentFrame = 0;
        animTimer = 0;
        stateTimer = 0;
    }

    override public function update():Void
    {
        var currentStateDef:ObstacleStateDef = def.states[currentState];

        // cycle states
        stateTimer += HXP.elapsed;

        while (stateTimer > currentStateDef.duration)
        {
            stateTimer -= currentStateDef.duration;
            currentState++;
            if (currentState == def.states.length)
                currentState = 0;
            currentStateDef = def.states[currentState];
        }

        // cycle animations
        animTimer += 2 * HXP.elapsed;

        while (animTimer >= 1)
        {
            animTimer--;
            currentFrame++;
            if (currentFrame == currentStateDef.frames.length)
                currentFrame = 0;
        }

        // update graphics
        graphic = images[currentStateDef.frames[currentFrame]];
    }

    inline function get_isBlocking():Bool
    {
        return def.states[currentState].blocking;
    }

    inline function get_isDeadly():Bool
    {
        return def.states[currentState].deadly;
    }
}

typedef ObstacleDef =
{
    var name:String;
    var images:Array<String>;
    var states:Array<ObstacleStateDef>;
}

typedef ObstacleStateDef =
{
    var duration:Float;
    var frames:Array<Int>;
    var deadly:Bool;
    var blocking:Bool;
}
