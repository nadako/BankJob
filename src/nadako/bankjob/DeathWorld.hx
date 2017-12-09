package nadako.bankjob;

import hxd.Key;
import hxd.res.Sound;

class DeathWorld extends Scene {
    static inline var DELAY = 0.75;

    var levelWorld:Scene;
    var deathSound:Sound;
    var delayTimer:Float;

    public function new(levelWorld:Scene) {
        super();
        this.levelWorld = levelWorld;
        deathSound = hxd.Res.audio.death;
        new h2d.Bitmap(hxd.Res.gfx.dead.toTile(), this);
    }

    override public function begin() {
        deathSound.play();
        delayTimer = 0;
    }

    override public function update(dt) {
        delayTimer += dt;
        if (delayTimer < DELAY)
            return;

        if (Key.isPressed(Key.MOUSE_LEFT) || Key.isPressed(Key.SPACE))
            Main.scene = levelWorld;
    }
}
