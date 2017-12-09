package nadako.bankjob;

class Player extends h2d.Bitmap {
    public var state(default, set):PlayerState;

    var emptyImage:h2d.Tile;
    var fullImage:h2d.Tile;

    public function new(parent) {
        super(null, parent);
        emptyImage = hxd.Res.gfx.player.toTile();
        fullImage = hxd.Res.gfx.player_gold.toTile();
        set_state(Empty);
    }

    function set_state(value:PlayerState):PlayerState {
        if (state != value) {
            state = value;
            switch (state) {
                case Empty:
                    tile = emptyImage;
                case Full:
                    tile = fullImage;
            }
        }
        return state;
    }
}

enum PlayerState {
    Empty;
    Full;
}
