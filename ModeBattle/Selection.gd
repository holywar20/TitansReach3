extends TileMap

const PLAYER_TILE_MAP = [
	[Vector2(10,9), Vector2(13,9), Vector2(16,9) , Vector2(19,9) , Vector2(22,9)],
	[Vector2(10,6), Vector2(13,6), Vector2(16,6) , Vector2(19,6) , Vector2(22,6)],
	[Vector2(10,3), Vector2(13,3), Vector2(16,3) , Vector2(19,3) , Vector2(22,3)],
]
const ENEMY_TILE_MAP = [
	[Vector2(22,-6), Vector2(19,-6), Vector2(16,-6) , Vector2(13,-6) , Vector2(10,-6)],
	[Vector2(22,-3), Vector2(19,-3), Vector2(16,-3) , Vector2(13,-3) , Vector2(10,-3)],
	[Vector2(22,0), Vector2(19,0), Vector2(16,0) , Vector2(13,0) , Vector2(10,0)]
]
const HIGHLIGHT_CELL_INDEX = 0


enum STATE {
	NONE, ALLY_FLOOR , ALLY_UNIT , ENEMY_FLOOR, ENEMY_UNIT
}

enum HIGHLIGHT {
	NONE, NEAR_ALLY, NEAR_ENEMY , ALLY_FLOOR, ENEMY_FLOOR
}

var highlightParams = {
	HIGHLIGHT.NONE : Color(0,0,0,255),
	HIGHLIGHT.NEAR_ALLY : Color(0,0,0,255),
	HIGHLIGHT.NEAR_ENEMY : Color(0,0,0,255),
	HIGHLIGHT.ALLY_FLOOR : Color(0,0,0,255),
	HIGHLIGHT.ENEMY_FLOOR : Color(0,0,0,255)
}

var currentState : int  =  STATE.NONE
var currentTilemap : Array = PLAYER_TILE_MAP
var currentFormation : FormationResource # This formation will be a subset of the total map
var currentTargetArea = AbilityResource.TARGET_AREA.SINGLE
var currentEffectGroup : AbilityResource.EffectGroup

var cursorLocation : Vector2 = Vector2( 0 , 2)

# Bit unnusual here, but state is deteremined by effectGroup. If null, clear all data
func setState( effectGroup = null , _formation = null , isPlayer = null):
	currentEffectGroup = effectGroup
	cursorLocation = Vector2( 0 , 2 )

	if(isPlayer):
		currentTilemap = PLAYER_TILE_MAP	
	else:
		currentTilemap = ENEMY_TILE_MAP
	
	if( effectGroup ):
		currentState = convertTargetingToEffectGroup(effectGroup.targetType)
	else:
		currentState = STATE.NONE

	match currentState:
		STATE.NONE:
			stateNone()
		STATE.ALLY_FLOOR:
			stateAllyFloor()
		STATE.ALLY_UNIT:
			stateAllyUnit()
		STATE.ENEMY_UNIT:
			stateEnemyFloor()
		STATE.ENEMY_FLOOR:
			stateEnemyUnit()

	# Set initial cursor
	if currentState != STATE.NONE:
		# set via formation
		var tile = currentTilemap[int(cursorLocation.x)][int(cursorLocation.y)]
		set_cell( int(tile.x) , int(tile.y) , HIGHLIGHT_CELL_INDEX)

func stateNone():
	_clearAllSelections()

func stateAllyFloor():
	pass

func stateAllyUnit():
	pass

func stateEnemyFloor():
	pass

func stateEnemyUnit():
	pass

func _clearAllSelections():
	for x in range(0, currentTilemap.size() ):
		for y in range(0 , currentTilemap[x].size() ):
			var tile = currentTilemap[x][y]
			set_cell( int(tile.x) , int(tile.y) , -1)


# Converts targeting state from Ability.TARGET_TYPE into a the right state for this object
func convertTargetingToEffectGroup( targetingState : String ):	
	var newState = null

	match targetingState:
		AbilityResource.TARGET_TYPE.SELF:
			newState = STATE.ALLY_FLOOR
		AbilityResource.TARGET_TYPE.ALLY_UNIT:
			newState = STATE.ALLY_UNIT
		AbilityResource.TARGET_TYPE.ALLY_FLOOR:
			newState = STATE.ALLY_FLOOR
		AbilityResource.TARGET_TYPE.ENEMY_UNIT:
			newState = STATE.ENEMY_UNIT
		AbilityResource.TARGET_TYPE.ENEMY_FLOOR:
			newState = STATE.ENEMY_FLOOR
	
	return newState

# Input handling
func handleInput( _ev : InputEvent ):
	if currentState == STATE.NONE:
		return null
	
	match currentState:
		STATE.ALLY_FLOOR:
			allyCursorInput(_ev)
		STATE.ALLY_UNIT:
			allyCursorInput(_ev)
		STATE.ENEMY_UNIT:
			enemyCursorInput(_ev)
		STATE.ENEMY_FLOOR:
			enemyCursorInput(_ev)
	
func allyCursorInput(_ev : InputEvent):
	if( _ev.is_action_pressed("ui_left")):
		_moveCursor( Vector2(0, -1) )
	elif( _ev.is_action_pressed("ui_right")):
		_moveCursor( Vector2(0, 1) )
	elif( _ev.is_action_pressed("ui_up")):
		_moveCursor( Vector2(1, 0) )
	elif ( _ev.is_action_pressed("ui_down")):
		_moveCursor( Vector2(-1, 0) )

func enemyCursorInput(_ev : InputEvent):
	if( _ev.is_action_pressed("ui_left")):
		_moveCursor( Vector2(0, -1) )
	elif( _ev.is_action_pressed("ui_right")):
		_moveCursor( Vector2(0, 1) )
	elif( _ev.is_action_pressed("ui_up")):
		_moveCursor( Vector2(1, 0) )
	elif ( _ev.is_action_pressed("ui_down")):
		_moveCursor( Vector2(-1, 0) )
		
func _moveCursor( direction : Vector2 ):
	# Clear all my current tiles
	_clearAllSelections()

	# Figure out new position in the valid tiles array.
	cursorLocation = cursorLocation + direction
	if( cursorLocation.x >= 3):
		cursorLocation.x = 0
	elif ( cursorLocation.x <= -1 ):
		cursorLocation.x = 2

	if( cursorLocation.y >= 5):
		cursorLocation.y = 0
	elif ( cursorLocation.y <= -1 ):
		cursorLocation.y = 4 

	var newTile = currentTilemap[int(cursorLocation.x)][int(cursorLocation.y)]
	set_cell( int(newTile.x) , int(newTile.y) , HIGHLIGHT_CELL_INDEX)

	# Based on newTile location :
	#	Get the area
	# 	Highlight all areas as well

	




