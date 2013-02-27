package nadako.bankjob;

import nadako.bankjob.LevelWorld.LevelDef;
import haxe.Json;

import nme.Assets;
import com.haxepunk.Engine;
import com.haxepunk.HXP;

import nadako.bankjob.Obstacle.ObstacleDef;

class Main extends Engine
{
    public static var obstacles(default, null):Hash<ObstacleDef>;
    public static var levels(default, null):Array<LevelDef>;
    public static var totalScore:Int;
    public static var totalDeaths:Int;

    public function new()
    {
        super();

        obstacles = new Hash();
        var defs:Array<ObstacleDef> = Json.parse(Assets.getText("defs/obstacles.json"));
        for (obstacleDef in defs)
        {
            obstacles.set(obstacleDef.name, obstacleDef);
        }

        levels = Json.parse(Assets.getText("defs/levels.json"));

//        HXP.console.enable();

        HXP.defaultFont = "font/visitor1.ttf";

        totalScore = 0;
        totalDeaths = 0;

        var playWorld = new LevelWorld(0);
        var tutorialWorld = new SimpleImageWorld("gfx/tutorial.png", playWorld);
        var mainMenuWorld = new SimpleImageWorld("gfx/game_start.png", tutorialWorld);
        HXP.world = mainMenuWorld;
    }
}
