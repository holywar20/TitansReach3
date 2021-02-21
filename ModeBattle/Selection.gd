extends TileMap

const PLAYER_TILE_MAP = [
	[Vector2(10,9), Vector2(13,9), Vector2(16,9) , Vector2(19,9) , Vector2(22,9)],
	[Vector2(10,6), Vector2(13,6), Vector2(16,6) , Vector2(19,6) , Vector2(22,6)],
	[Vector2(10,3), Vector2(13,3), Vector2(16,3) , Vector2(19,3) , Vector2(22,3)],
]
const ENEMY_TILE_MAP = [
	[Vector2(22,0), Vector2(19,0), Vector2(16,0) , Vector2(13,0) , Vector2(10,0)],
	[Vector2(22,-3), Vector2(19,-3), Vector2(16,-3) , Vector2(13,-3) , Vector2(10,-3)],
	[Vector2(22,-6), Vector2(19,-6), Vector2(16,-6) , Vector2(13,-6) , Vector2(10,-6)]	
]
const HIGHLIGHT_CELL_INDEX = 0

enum STATE {
	NONE, SELF,  ALLY_FLOOR , ALLY_UNIT , ENEMY_FLOOR, ENEMY_UNIT
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
var currentBattler : Battler
var currentAbility : AbilityResource
var currentEffectGroup : AbilityResource.EffectGroup


var cursorLocation : Vector2 = Vector2( 0 , 2)

signal selection_change

# Bit unnusual here, but state is deteremined by effectGroup. If null, clear all data
func setState( effectGroup = null , formation = null , ability = null , battler = null ):
	currentEffectGroup = effectGroup
	currentFormation = formation
	currentAbility = ability
	currentBattler = battler
	
	cursorLocation = Vector2( 0 , 3 )
	
	if( effectGroup ):
		currentState = convertTargetingToEffectGroup(effectGroup.targetType)
		if(formation.isPlayer):
			currentTilemap = PLAYER_TILE_MAP
			_moveCursor( cursorLocation )	
		else:
			currentTilemap = ENEMY_TILE_MAP
			_moveCursor( cursorLocation )
	else:
		currentState = STATE.NONE

	if( currentFormation ):
		currentFormation.resetFilters()

	match currentState:
		STATE.NONE:
			stateNone()
		STATE.SELF:
			stateSelf()
		STATE.ALLY_FLOOR:
			stateAllyFloor()
		STATE.ALLY_UNIT:
			stateAllyUnit()
		STATE.ENEMY_UNIT:
			stateEnemyUnit()
		STATE.ENEMY_FLOOR:
			stateEnemyFloor()

	# Set initial cursor
	if currentState != STATE.NONE:
		# set via formation
		var tile = currentTilemap[int(cursorLocation.x)][int(cursorLocation.y)]
		set_cell( int(tile.x) , int(tile.y) , HIGHLIGHT_CELL_INDEX)

func stateNone():
	_clearAllSelections()

func stateSelf():
	if( currentEffectGroup.targetType == AbilityResource.TARGET_TYPE.SELF ):
		currentFormation.filterAllButSelf( currentBattler.currentCharacter )
	_seekRow(-1)

func stateAllyFloor():
	_seekRow( -1 )

func stateAllyUnit():
	currentFormation.filterIsABattler()
	_seekRow( -1 )

func stateEnemyFloor():
	currentFormation.filterValidTargetRow( currentAbility.validTargets )
	_seekRow( -1 )

func stateEnemyUnit():
	currentFormation.filterValidTargetRow( currentAbility.validTargets )
	print( currentFormation.filteredPos )
	currentFormation.filterIsABattler()
	print( currentFormation.filteredPos )
	# currentFormation.filterIsABattler()
	_seekRow( -1 )

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
			newState = STATE.SELF
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
		STATE.SELF:
			pass
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
		_seekRow( -1 )
	elif( _ev.is_action_pressed("ui_right")):
		_seekRow( 1 )
	elif( _ev.is_action_pressed("ui_up")):
		_seekColumn( 1 )
	elif ( _ev.is_action_pressed("ui_down")):
		_seekColumn( -1 )

func enemyCursorInput(_ev : InputEvent):
	if( _ev.is_action_pressed("ui_left")):
		_seekRow( 1 )
	elif( _ev.is_action_pressed("ui_right")):
		_seekRow( -1 )
	elif( _ev.is_action_pressed("ui_up")):
		_seekColumn( -1 )
	elif ( _ev.is_action_pressed("ui_down")):
		_seekColumn( 1 )
		
func _seekColumn( direction : int ):
	var seek : Vector2 = Vector2( direction + cursorLocation.x , cursorLocation.y )
	
	var colCount = 5
	var rowCount = 3
	var isValid = false

	while !isValid:
		if( seek == cursorLocation ): # If these locations are the same, there is no valid target and this ability can't be used.
			break

		# Contain up - down movement by left & right
		if( posmod( int(seek.x) , rowCount ) != seek.x ):
			seek.x = posmod( int(seek.x) , rowCount )
			seek.y = posmod( int(seek.y) + 1 , colCount )
			
		var locTest = testLocation( int(seek.x) , int(seek.y) )
		if( locTest ):
			_moveCursor( seek )
			isValid = true
		else:
			seek = Vector2( direction + seek.x , seek.y )

func _seekRow( direction : int ):
	var seek : Vector2 = Vector2( cursorLocation.x , cursorLocation.y + direction )
	
	var colCount = 5
	var rowCount = 3
	var isValid = false

	while !isValid:
		if( seek == cursorLocation ): # If these locations are the same, there is no valid target and this ability can't be used.
			break

		# Contain & wrap up - down movement
		if( posmod( int(seek.y) , colCount ) != seek.y ):
			seek.x = posmod( int(seek.x) + 1 , rowCount )
			seek.y = posmod( int(seek.y) , colCount )
			
		var locTest = testLocation( int(seek.x) , int(seek.y) )
		if( locTest ):
			_moveCursor( seek )
			isValid = true
		else:
			seek = Vector2( seek.x , seek.y + direction )

func testLocation( x : int , y: int):
	if( currentFormation.filteredPos[x][y] ):
		return true
	else:
		return false
		
func _moveCursor( newLocation : Vector2 ):
	# Clear all my current tiles
	_clearAllSelections()

	cursorLocation = newLocation
	var newTile = currentTilemap[int(cursorLocation.x)][int(cursorLocation.y)]
	set_cell( int(newTile.x) , int(newTile.y) , HIGHLIGHT_CELL_INDEX)

	var targetString = currentFormation.getStringAtLocation( cursorLocation )
	emit_signal("selection_change", cursorLocation , targetString )

	# Based on newTile location :
	#	Get the area
	# 	Highlight all areas as well

	




