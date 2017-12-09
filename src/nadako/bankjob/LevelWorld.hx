package nadako.bankjob;

import hxd.Key;
import h2d.Tile;
import h2d.Bitmap;
import hxd.Res;
import hxd.res.Sound;

class LevelWorld extends Scene {
    var levelIdx:Int;
    var def:LevelDef;
    var obstacles:Array<Obstacle>;
    var obstacleMap:Map<Int, Obstacle>;
    var emptyImage:Tile;
    var houseTile:HouseTile;
    var player:Player;
    var playerIndex:Int;
    var levelTimer:LevelTimer;

    var stepSound:Sound;
    var pickupSound:Sound;
    var putdownSound:Sound;
    var music:Sound;

    var hud:HUD;

    public function new(levelIdx:Int) {
        super();
        this.levelIdx = levelIdx;
        def = Main.levels[levelIdx];

        stepSound = Res.audio.step;
        pickupSound = Res.audio.pickup;
        putdownSound = Res.audio.putdown;
        music = hxd.Res.audio.gamemusic;
    }

    override function begin() {
        new Bitmap(Res.gfx.bg.toTile(), this);

        emptyImage = Res.gfx.tunnel_tile.toTile();

        var tileX = 0;
        var tileY = 258;

        houseTile = new HouseTile([
            Res.gfx.tunnel_tile.toTile(),
            Res.gfx.home_gold1.toTile(),
            Res.gfx.home_gold2.toTile(),
            Res.gfx.home_gold3.toTile()
        ], this);
        houseTile.x = tileX;
        houseTile.y = tileY;
        tileX += 100;

        obstacleMap = new Map();
        obstacles = [];
        for (i in 0...def.obstacles.length) {
            var obstacleName = def.obstacles[i];
            if (obstacleName != null) {
                var obstacle = new Obstacle(Main.obstacles.get(obstacleName), this);
                obstacleMap.set(i, obstacle);
                obstacle.x = tileX;
                obstacle.y = tileY;
                obstacles.push(obstacle);
            } else {
                var image = new h2d.Bitmap(emptyImage, this);
                image.setPos(tileX, tileY);
            }
            tileX += 100;
        }

        var cash = new Bitmap(Res.gfx.bank_cash_tile.toTile(), this);
        cash.setPos(tileX, tileY);

        playerIndex = 0;

        player = new Player(this);
        player.y = tileY;

        positionPlayer();

        levelTimer = new LevelTimer(def.duration, this);
        levelTimer.x = 254;
        levelTimer.y = 30;

        hud = new HUD();
        hud.setLevel(levelIdx);
        hud.setScore(0);
        hud.updateDeathCount();
        addChild(hud);

        music.play(true, 0.8);
    }

    override function end() {
        music.stop();
    }

    function positionPlayer() {
        player.x = playerIndex * 100;

        if (playerIndex == 0 && player.state == Full) {
            player.state = Empty;
            houseTile.count++;
            putdownSound.play();
            hud.setScore(houseTile.count);
        } else if (playerIndex == lastPlayerIndex && player.state == Empty) {
            player.state = Full;
            pickupSound.play();
        }
    }

    function tryMovePlayer(delta:Int) {
        if (delta == 0)
            return;

        var index = playerIndex + delta;

        if (index < 0)
            return;

        if (index > lastPlayerIndex)
            return;

        var obstacle = obstacleMap.get(index - 1);
        if (obstacle != null && obstacle.isBlocking)
            return;

        playerIndex = index;
        stepSound.play();
        positionPlayer();
    }

    var lastPlayerIndex(get, never):Int;

    inline function get_lastPlayerIndex():Int {
        return def.obstacles.length + 1;
    }

    function handleInput() {
        if (Key.isPressed(Key.LEFT))
            tryMovePlayer(-1);
        else if (Key.isPressed(Key.RIGHT))
            tryMovePlayer(1);
    }

    function checkDeadly() {
        if (playerIndex == 0 || playerIndex == lastPlayerIndex)
            return;

        var obstacle = obstacleMap.get(playerIndex - 1);
        if (obstacle != null && obstacle.isDeadly) {
            Main.totalDeaths++;
            Main.scene = new DeathWorld(this);
        }
    }

    function checkTimer() {
        hud.setTime(levelTimer.timeLeft);

        if (levelTimer.isFinished) {
            if (playerIndex == 0) {
                if (houseTile.count > 0) {
                    Main.totalScore += houseTile.count;
                    Main.scene = new WinWorld(new LevelWorld(levelIdx + 1), houseTile.count);
                } else {
                    Main.scene = new WinWorld(this, houseTile.count);
                }
            } else {
                Main.scene = new SimpleImageWorld(hxd.Res.gfx.busted.toTile(), this);
            }
        }
    }

    override function update(dt) {
        handleInput();
        for (obstacle in obstacles) {
            obstacle.update(dt);
        }
        levelTimer.update(dt);
        checkDeadly();
        checkTimer();
    }
}

typedef LevelDef = {
    var duration:Float;
    var obstacles:Array<String>;
}
