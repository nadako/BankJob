package nadako.bankjob;

import h2d.Text;

class HUD extends h2d.Sprite {
    var levelText:Text;
    var timeText:Text;
    var scoreText:Text;
    var deathCountText:Text;

    public function new() {
        super();

        levelText = new Text(Main.defaultFont, this);
        levelText.text = "LEVEL: 1";
        levelText.x = 50;

        timeText = new Text(Main.defaultFont, this);
        timeText.text = "TIME: 30";
        timeText.x = levelText.x;
        timeText.y = levelText.y + levelText.textHeight;

        scoreText = new Text(Main.defaultFont, this);
        scoreText.text = "SCORE: 5 (TOTAL: 30)";
        scoreText.x = 225;
        scoreText.y = levelText.y;

        deathCountText = new Text(Main.defaultFont, this);
        deathCountText.text = "DEATHS: 20";
        deathCountText.textColor = 0xFF0000;
        deathCountText.x = scoreText.x + scoreText.textWidth + 5;
        deathCountText.y = scoreText.y;
    }

    public function setLevel(levelIdx:Int) {
        levelText.text = "LEVEL: " + (levelIdx + 1);
    }

    public function setTime(time:Int) {
        timeText.text = "TIME: " + time;
    }

    public function setScore(score:Int) {
        scoreText.text = "SCORE: " + score + " (TOTAL: " + Main.totalScore + ")";
    }

    public function updateDeathCount() {
        deathCountText.text = "DEATHS: " + Main.totalDeaths;
    }
}
