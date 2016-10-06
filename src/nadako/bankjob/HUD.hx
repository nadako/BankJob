package nadako.bankjob;

import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;

class HUD extends Entity
{
    var levelText:Text;
    var timeText:Text;
    var scoreText:Text;
    var deathCountText:Text;

    public function new()
    {
        super();
        var textSize:Int = 22;

        levelText = cast addGraphic(new Text("LEVEL: 1"));
        levelText.size = textSize;
        levelText.x = 50;

        timeText = cast addGraphic(new Text("TIME: 30"));
        timeText.size = textSize;
        timeText.x = levelText.x;
        timeText.y = levelText.y + levelText.height;

        scoreText = cast addGraphic(new Text("SCORE: 5 (TOTAL: 30)"));
        scoreText.size = textSize;
        scoreText.x = 225;
        scoreText.y = levelText.y;

        deathCountText = cast addGraphic(new Text("DEATHS: 20"));
        deathCountText.size = textSize;
        deathCountText.color = 0xFF0000;
        deathCountText.x = scoreText.x + scoreText.width + 5;
        deathCountText.y = scoreText.y;
    }

    public function setLevel(levelIdx:Int):Void
    {
        levelText.text = "LEVEL: " + (levelIdx + 1);
    }

    public function setTime(time:Int):Void
    {
        timeText.text = "TIME: " + time;
    }

    public function setScore(score:Int):Void
    {
        scoreText.text = "SCORE: " + score + " (TOTAL: " + Main.totalScore + ")";
    }

    public function updateDeathCount():Void
    {
        deathCountText.text = "DEATHS: " + Main.totalDeaths;
    }
}
