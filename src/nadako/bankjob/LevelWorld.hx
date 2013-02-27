package nadako.bankjob;

import com.haxepunk.graphics.Text;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.World;

import nadako.bankjob.Player.PlayerState;

class LevelWorld extends World
{
    private var levelIdx:Int;
    private var def:LevelDef;
    private var obstacleMap:IntHash<Obstacle>;
    private var emptyImage:Image;
    private var houseTile:HouseTile;
    private var player:Player;
    private var playerIndex:Int;
    private var levelTimer:LevelTimer;

    private var stepSound:Sfx;
    private var pickupSound:Sfx;
    private var putdownSound:Sfx;
//    private var music:Sfx;

    private var timeText:Text;
    private var scoreText:Text;

    public function new(levelIdx:Int)
    {
        super();
        this.levelIdx = levelIdx;
        def = Main.levels[levelIdx];

        stepSound = new Sfx("audio/step.wav");
        pickupSound = new Sfx("audio/pickup.wav");
        putdownSound = new Sfx("audio/putdown.wav");
//        music = new Sfx("audio/gamemusic.mp3");
    }

    override public function begin()
    {
        Input.define("left", [Key.LEFT, Key.NUMPAD_4]);
        Input.define("right", [Key.RIGHT, Key.NUMPAD_6]);

        addGraphic(new Image("gfx/bg.png"));

        emptyImage = new Image("gfx/tunnel_tile.png");

        var tileX:Int = 0;
        var tileY:Int = 258;

        houseTile = add(new HouseTile([
            "gfx/tunnel_tile.png",
            "gfx/home_gold1.png",
            "gfx/home_gold2.png",
            "gfx/home_gold3.png"
        ]));
        houseTile.x = tileX;
        houseTile.y = tileY;
        tileX += 100;

        obstacleMap = new IntHash();
        for (i in 0...def.obstacles.length)
        {
            var obstacleName:String = def.obstacles[i];

            if (obstacleName != null)
            {
                var obstacle:Obstacle = new Obstacle(Main.obstacles.get(obstacleName));
                add(obstacle);
                obstacleMap.set(i, obstacle);
                obstacle.x = tileX;
                obstacle.y = tileY;
            }
            else
            {
                addGraphic(emptyImage, HXP.BASELAYER, tileX, tileY);
            }
            tileX += 100;
        }

        addGraphic(new Image("gfx/bank_cash_tile.png"), HXP.BASELAYER, tileX, tileY);

        playerIndex = 0;

        player = add(new Player());
        player.y = tileY;

        positionPlayer();

        levelTimer = add(new LevelTimer(def.duration));
        levelTimer.x = 254;
        levelTimer.y = 30;

        var textSize:Int = 22;
        var textX:Int = 50;
        var textY:Int = 0;

        var levelText:Text = new Text("LEVEL: " + (levelIdx + 1));
        levelText.size = textSize;
        addGraphic(levelText, HXP.BASELAYER, textX, textY);

        timeText = new Text("TIME: " + def.duration);
        timeText.size = textSize;
        addGraphic(timeText, HXP.BASELAYER, textX, textY + levelText.height);

        textX = 225;

        scoreText = new Text("SCORE: 0 (TOTAL: 0)");
        scoreText.size = textSize;
        addGraphic(scoreText, HXP.BASELAYER, textX, textY);
        updateScoreText();

        var deathText:Text = new Text("DEATHS: " + Main.totalDeaths);
        deathText.size = textSize;
        deathText.color = 0xFF0000;
        addGraphic(deathText, HXP.BASELAYER, textX + scoreText.width + 20);

        //        music.loop(0.1);
    }

    override public function end()
    {
//        music.stop();
    }

    private function positionPlayer():Void
    {
        player.x = playerIndex * 100;

        if (playerIndex == 0 && player.state == PlayerState.Full)
        {
            player.state = PlayerState.Empty;
            houseTile.count++;
            putdownSound.play();
            updateScoreText();
        }
        else if (playerIndex == lastPlayerIndex && player.state == PlayerState.Empty)
        {
            player.state = PlayerState.Full;
            pickupSound.play();
        }
    }

    private function updateScoreText():Void
    {
        scoreText.text = "SCORE: " + houseTile.count + " (TOTAL: " + (Main.totalScore + houseTile.count) + ")";
    }

    private function tryMovePlayer(delta:Int):Void
    {
        if (delta == 0)
            return;

        var index:Int = playerIndex + delta;

        if (index < 0)
            return;

        if (index > lastPlayerIndex)
            return;

        var obstacle:Obstacle = obstacleMap.get(index - 1);
        if (obstacle != null && obstacle.isBlocking)
            return;

        playerIndex = index;
        stepSound.play();
        positionPlayer();
    }

    private var lastPlayerIndex(get_lastPlayerIndex, never):Int;

    private inline function get_lastPlayerIndex():Int
    {
        return def.obstacles.length + 1;
    }

    private function handleInput():Void
    {
        if (Input.pressed("left"))
            tryMovePlayer(-1);
        else if (Input.pressed("right"))
            tryMovePlayer(1);
    }

    private function checkDeadly():Void
    {
        if (playerIndex == 0 || playerIndex == lastPlayerIndex)
            return;

        var obstacle:Obstacle = obstacleMap.get(playerIndex - 1);
        if (obstacle != null && obstacle.isDeadly)
        {
            Main.totalDeaths++;
            HXP.world = new DeathWorld(this);
        }
    }

    private function checkTimer():Void
    {
        timeText.text = "TIME: " + levelTimer.timeLeft;

        if (levelTimer.isFinished)
        {
            if (playerIndex == 0)
            {
                if (houseTile.count > 0)
                {
                    Main.totalScore += houseTile.count;
                    HXP.world = new WinWorld(new LevelWorld(levelIdx + 1), houseTile.count);
                }
                else
                {
                    HXP.world = new WinWorld(this, houseTile.count);
                }
            }
            else
                HXP.world = new SimpleImageWorld("gfx/busted.png", this);
        }
    }

    override public function update()
    {
        handleInput();
        super.update();
        checkDeadly();
        checkTimer();
    }
}

typedef LevelDef =
{
    var duration:Float;
    var obstacles:Array<String>;
}