package nadako.bankjob;

import flash.text.TextFormatAlign;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Image;
import com.haxepunk.World;

class WinWorld extends World
{
    static inline var DELAY:Float = 0.75;

    var nextWorld:World;
    var winSound:Sfx;
    var delayTimer:Float;
    var score:Int;
    var bgImage:Image;

    public function new(nextWorld:World, score:Int)
    {
        super();
        this.nextWorld = nextWorld;
        this.score = score;
        winSound = new Sfx("audio/win.wav");

        bgImage = new Image("gfx/win.png");
        addGraphic(bgImage);
    }

    override public function begin()
    {
        winSound.play();
        delayTimer = 0;

        var scoreText:Text = new Text("SCORE: " + score + " (TOTAL: " + Main.totalScore + ")");
        scoreText.size = 30;
        addGraphic(scoreText, 0, (bgImage.width - scoreText.width) / 2, 50);

        if (score == 0)
        {
            var warnText:Text = new Text("next time try to actually do\nthe bank job, loser", 0, 0, 0, 0, {align: TextFormatAlign.CENTER, size: 30, color: 0xFF0000});
            addGraphic(warnText, 0, (bgImage.width - warnText.width) / 2, 50 + scoreText.height);
        }

    }

    override public function update()
    {
        super.update();

        delayTimer += HXP.elapsed;
        if (delayTimer < DELAY)
            return;

        if (Input.mousePressed || Input.pressed(Key.ANY))
            HXP.scene = nextWorld;
    }
}
