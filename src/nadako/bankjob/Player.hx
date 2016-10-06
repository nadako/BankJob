package nadako.bankjob;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

class Player extends Entity
{
    public var state(default, set_state):PlayerState;

    var emptyImage:Image;
    var fullImage:Image;

    public function new()
    {
        super();
        emptyImage = new Image("gfx/player.png");
        fullImage = new Image("gfx/player_gold.png");
        set_state(Empty);
    }

    function set_state(value:PlayerState):PlayerState
    {
        if (state != value)
        {
            state = value;
            switch (state)
            {
                case Empty:
                    graphic = emptyImage;
                case Full:
                    graphic = fullImage;
            }
        }
        return state;
    }
}

enum PlayerState
{
    Empty;
    Full;
}
