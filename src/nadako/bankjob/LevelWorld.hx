package nadako.bankjob;

import com.haxepunk.Sfx;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.World;

import nadako.bankjob.Player.PlayerState;

class LevelWorld extends World
{
    var levelIdx:Int;
    var def:LevelDef;
    var obstacleMap:Map<Int, Obstacle>;
    var emptyImage:Image;
    var houseTile:HouseTile;
    var player:Player;
    var playerIndex:Int;
    var levelTimer:LevelTimer;

    var stepSound:Sfx;
    var pickupSound:Sfx;
    var putdownSound:Sfx;
//    var music:Sfx;

    var hud:HUD;

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

        obstacleMap = new Map();
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
                addGraphic(emptyImage, 0, tileX, tileY);
            }
            tileX += 100;
        }

        addGraphic(new Image("gfx/bank_cash_tile.png"), 0, tileX, tileY);

        playerIndex = 0;

        player = add(new Player());
        player.y = tileY;

        positionPlayer();

        levelTimer = add(new LevelTimer(def.duration));
        levelTimer.x = 254;
        levelTimer.y = 30;

        hud = new HUD();
        hud.setLevel(levelIdx);
        hud.setScore(0);
        hud.updateDeathCount();
        add(hud);

        //        music.loop(0.1);
    }

    override public function end()
    {
//        music.stop();
    }

    function positionPlayer():Void
    {
        player.x = playerIndex * 100;

        if (playerIndex == 0 && player.state == PlayerState.Full)
        {
            player.state = PlayerState.Empty;
            houseTile.count++;
            putdownSound.play();
            hud.setScore(houseTile.count);
        }
        else if (playerIndex == lastPlayerIndex && player.state == PlayerState.Empty)
        {
            player.state = PlayerState.Full;
            pickupSound.play();
        }
    }

    function tryMovePlayer(delta:Int):Void
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

    var lastPlayerIndex(get, never):Int;

    inline function get_lastPlayerIndex():Int
    {
        return def.obstacles.length + 1;
    }

    function handleInput():Void
    {
        if (Input.pressed("left"))
            tryMovePlayer(-1);
        else if (Input.pressed("right"))
            tryMovePlayer(1);
    }

    function checkDeadly():Void
    {
        if (playerIndex == 0 || playerIndex == lastPlayerIndex)
            return;

        var obstacle:Obstacle = obstacleMap.get(playerIndex - 1);
        if (obstacle != null && obstacle.isDeadly)
        {
            Main.totalDeaths++;
            HXP.scene = new DeathWorld(this);
        }
    }

    function checkTimer():Void
    {
        hud.setTime(levelTimer.timeLeft);

        if (levelTimer.isFinished)
        {
            if (playerIndex == 0)
            {
                if (houseTile.count > 0)
                {
                    Main.totalScore += houseTile.count;
                    HXP.scene = new WinWorld(new LevelWorld(levelIdx + 1), houseTile.count);
                }
                else
                {
                    HXP.scene = new WinWorld(this, houseTile.count);
                }
            }
            else
                HXP.scene = new SimpleImageWorld("gfx/busted.png", this);
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
