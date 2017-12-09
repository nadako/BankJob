package nadako.bankjob;

import h2d.Tile;

class Obstacle extends h2d.Bitmap {
    var images:Array<Tile>;
    var def:ObstacleDef;
    var currentState:Int;
    var currentFrame:Int;
    var animTimer:Float;
    var stateTimer:Float;

    public var isBlocking(get, never):Bool;
    public var isDeadly(get, never):Bool;

    public function new(def:ObstacleDef, parent:h2d.Sprite) {
        super(null, parent);
        this.def = def;

        images = [];
        for (path in def.images) {
            images.push(hxd.Res.load(path).toTile());
        }

        currentState = 0;
        currentFrame = 0;
        animTimer = 0;
        stateTimer = 0;
    }

    public function update(dt) {
        var currentStateDef = def.states[currentState];

        // cycle states
        stateTimer += dt;

        while (stateTimer > currentStateDef.duration) {
            stateTimer -= currentStateDef.duration;
            currentState++;
            if (currentState == def.states.length)
                currentState = 0;
            currentStateDef = def.states[currentState];
            currentFrame = 0;
        }

        // cycle animations
        animTimer += 2 * dt;

        while (animTimer >= 1) {
            animTimer--;
            currentFrame++;
            if (currentFrame == currentStateDef.frames.length)
                currentFrame = 0;
        }

        // update graphics
        tile = images[currentStateDef.frames[currentFrame]];
    }

    inline function get_isBlocking():Bool {
        return def.states[currentState].blocking;
    }

    inline function get_isDeadly():Bool {
        return def.states[currentState].deadly;
    }
}

typedef ObstacleDef = {
    var name:String;
    var images:Array<String>;
    var states:Array<ObstacleStateDef>;
}

typedef ObstacleStateDef = {
    var duration:Float;
    var frames:Array<Int>;
    var deadly:Bool;
    var blocking:Bool;
}
