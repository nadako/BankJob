package nadako.bankjob;

import haxe.Json;

import nadako.bankjob.LevelWorld.LevelDef;
import nadako.bankjob.Obstacle.ObstacleDef;

class Main extends hxd.App {
    public static var obstacles(default, null):Map<String, ObstacleDef>;
    public static var levels(default, null):Array<LevelDef>;
    public static var totalScore:Int;
    public static var totalDeaths:Int;

    public static var scene(default,set):Scene;
    public static var defaultFont(default,null):h2d.Font;
    public static var defaultFont30(default,null):h2d.Font;

    static var inst:Main;

    override function init() {
        inst = this;

        obstacles = new Map();
        var defs:Array<ObstacleDef> = Json.parse(hxd.Res.defs.obstacles.entry.getText());
        for (obstacleDef in defs) {
            obstacles.set(obstacleDef.name, obstacleDef);
        }

        levels = Json.parse(hxd.Res.defs.levels.entry.getText());

        #if js
        defaultFont = hxd.Res.font.visitor1.build(22);
        defaultFont30 = hxd.Res.font.visitor1.build(30);
        #else
        defaultFont = hxd.res.DefaultFont.get();
        defaultFont30 = defaultFont;
        #end

        totalScore = 0;
        totalDeaths = 0;

        var playWorld = new LevelWorld(0);
        var tutorialWorld = new SimpleImageWorld(hxd.Res.gfx.tutorial.toTile(), playWorld);
        var mainMenuWorld = new SimpleImageWorld(hxd.Res.gfx.game_start.toTile(), tutorialWorld);
        scene = mainMenuWorld;
    }

    static function set_scene(newScene:Scene) {
        if (newScene != scene) {
            if (scene != null) {
                scene.remove();
                scene.end();
            }
            scene = newScene;
            inst.s2d.addChild(scene);
            scene.begin();
        }
        return newScene;
    }

    override function update(_) {
        scene.update(hxd.Timer.deltaT);
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}
