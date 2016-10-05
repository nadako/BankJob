package nadako.bankjob;

import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Image;
import com.haxepunk.World;

class DeathWorld extends World
{
    private static inline var DELAY:Float = 0.75;

    private var levelWorld:World;
    private var deathSound:Sfx;
    private var delayTimer:Float;

    public function new(levelWorld:World)
    {
        super();
        this.levelWorld = levelWorld;
        deathSound = new Sfx("audio/death.wav");
        addGraphic(new Image("gfx/dead.png"));
    }

    override public function begin()
    {
        deathSound.play();
        delayTimer = 0;
    }

    override public function update()
    {
        super.update();

        delayTimer += HXP.elapsed;
        if (delayTimer < DELAY)
            return;

        if (Input.mousePressed || Input.pressed(Key.ANY))
            HXP.scene = levelWorld;
    }
}
