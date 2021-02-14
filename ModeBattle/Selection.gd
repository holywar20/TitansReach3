extends TileMap

const PLAYER_TILE_MAP = [
	[Vector2(10,10), Vector2(13,10), Vector2(16,10) , Vector2(19,10) , Vector2(22,10)],
	[Vector2(10,7), Vector2(13,7), Vector2(16,7) , Vector2(19,7) , Vector2(22,7)],
	[Vector2(10,4), Vector2(13,4), Vector2(16,4) , Vector2(19,4) , Vector2(22,4)],
]

const ENEMY_TILE_MAP = [
	[Vector2(22,-5), Vector2(19,-5), Vector2(16,-5) , Vector2(13,-5) , Vector2(10,-5)],
	[Vector2(22,-2), Vector2(19,-2), Vector2(16,-2) , Vector2(13,-2) , Vector2(10,-2)],
	[Vector2(22,1), Vector2(19,1), Vector2(16,1) , Vector2(13,1) , Vector2(10,1)]
]

enum STATE {
	FOCUS , NOT_FOCUS
}

var currentState : int  =  STATE.NOT_FOCUS
var currentTilemap = PLAYER_TILE_MAP

var isPlayer : bool = true
var cursorLocation : Vector2 = Vector2() 

func _ready():
	pass

func setState( newState : int , isPlayer : bool = true ):
	currentState = newState

	if(isPlayer):
		currentTilemap = PLAYER_TILE_MAP
	else:
		currentTilemap = ENEMY_TILE_MAP
	
	match currentState:
		STATE.FOCUS:
			show()
		STATE.FOCUS:
			hide()
			
func handleInput( _ev : InputEvent ):
	if currentState == STATE.NOT_FOCUS:
		return null
