package nadako.bankjob;

import hxd.Key;
import h2d.Text;

class WinWorld extends Scene {
    static inline var DELAY = 0.75;

    var nextWorld:Scene;
    var winSound:hxd.res.Sound;
    var delayTimer:Float;
    var score:Int;
    var bgImage:h2d.Bitmap;

    public function new(nextWorld, score) {
        super();
        this.nextWorld = nextWorld;
        this.score = score;
        winSound = hxd.Res.audio.win;
        bgImage = new h2d.Bitmap(hxd.Res.gfx.win.toTile(), this);
    }

    override function begin() {
        winSound.play();
        delayTimer = 0;

        var scoreText = new Text(Main.defaultFont30, this);
        scoreText.text = "SCORE: " + score + " (TOTAL: " + Main.totalScore + ")";
        scoreText.setPos((bgImage.tile.width - scoreText.textWidth) / 2, 50);

        if (score == 0) {
            var warnText = new Text(Main.defaultFont30, this);
            warnText.text = "next time try to actually do\nthe bank job, loser";
            warnText.textColor = 0xFF0000;
            warnText.setPos((bgImage.tile.width - warnText.textWidth) / 2, 50 + scoreText.textHeight);
        }
    }

    override public function update(dt) {
        delayTimer += dt;
        if (delayTimer < DELAY)
            return;

        if (Key.isPressed(Key.MOUSE_LEFT) || Key.isPressed(Key.SPACE))
            Main.scene = nextWorld;
    }
}
