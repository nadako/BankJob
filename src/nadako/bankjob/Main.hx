package nadako.bankjob;

import haxe.Json;

import com.haxepunk.Engine;
import com.haxepunk.HXP;

import openfl.Assets;

import nadako.bankjob.LevelWorld.LevelDef;
import nadako.bankjob.Obstacle.ObstacleDef;

class Main extends Engine
{
    public static var obstacles(default, null):Map<String, ObstacleDef>;
    public static var levels(default, null):Array<LevelDef>;
    public static var totalScore:Int;
    public static var totalDeaths:Int;

    override function init()
    {
        obstacles = new Map();
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
        HXP.scene = mainMenuWorld;
    }
}
