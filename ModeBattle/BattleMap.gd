extends Control



onready var groundMap = $GroundMap
onready var selectionMap = $SelectionMap
onready var areaOfEffect = $AreaOfEffect
onready var enemyBase = $Enemy
onready var playerBase = $Players

const NODE_GROUP_BATTLER = "BATTLER"

var playerBattlerScene = preload("res://ModeBattle/PlayerBattler/PlayerBattler.tscn")
var enemyBattlerScene = preload("res://ModeBattle/EnemyBattler/EnemyBattler.tscn")

const TILE_SIZE : Vector2 = Vector2(128, 64)
const TILE_OFFSET : Vector2 = Vector2(32, 64)
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

var playerTiles : FormationResource
var enemyTiles : FormationResource

enum STATE{
	FOCUS , NOT_FOCUS , EXECUTING
}

enum EFFECT_GROUP_STATE {
	IDLE,
	LIST,
	ALLY_FLOOR , 
	ALLY_UNIT , 
	ENEMY_FLOOR,
	ENEMY_UNIT,
	SELF
}

var currentState : int = STATE.FOCUS
var currentAbility : AbilityResource
var currentBattler : Node2D

var effectGroupState : int = EFFECT_GROUP_STATE.IDLE
var effectGroupQue : Array
var effectGroupSelected : Array

signal abilitySelectFinished
signal abilityExecuteFinished
signal abilitySelectCanceled

func setupScene( newCrew : Array , newEnemy : Array ):
	
	playerTiles = FormationResource.new( newCrew )
	for x in range(0, playerTiles.positions.size() ):
		for y in range( 0, playerTiles.positions[x].size() ):
			if playerTiles.positions[x][y]:
				var battler = playerBattlerScene.instance()
				battler.position = groundMap.map_to_world( PLAYER_TILE_MAP[x][y] ) + TILE_OFFSET
				playerBase.add_child( battler )
				battler.setupScene(playerTiles.positions[x][y] ,Vector2( x, y ))

	enemyTiles = FormationResource.new( newEnemy )
	for x in range(0, enemyTiles.positions.size() ):
		for y in range( 0, enemyTiles.positions[x].size() ):
			if enemyTiles.positions[x][y]:
				var battler = enemyBattlerScene.instance()
				battler.position = groundMap.map_to_world( ENEMY_TILE_MAP[x][y] ) + Vector2(32, TILE_SIZE.y)
				enemyBase.add_child( battler )
				battler.setupScene(enemyTiles.positions[x][y], Vector2( x, y ))

	_resetAllBattlers()

func handleParentInput( event : InputEvent ):
	# TODO add handling for hover
	# TODO add handling for controller exploration
	if( currentState == STATE.NOT_FOCUS ):
		return null
	
	if( event.is_action_pressed("ui_cancel") ):
		_prevEffect()

	if( event.is_action_pressed("ui_accept") ):
		_nextEffect()


	# return when done
	match effectGroupState:
		EFFECT_GROUP_STATE.IDLE:
			pass
		EFFECT_GROUP_STATE.LIST:
			pass
		EFFECT_GROUP_STATE.SELF:
			inputTargetingSelf( event )
		EFFECT_GROUP_STATE.ALLY_UNIT:
			pass
		EFFECT_GROUP_STATE.ALLY_FLOOR:
			inputTargetingAllyFloor( event )
		EFFECT_GROUP_STATE.ENEMY_UNIT:
			inputTargetingEnemyUnit( event )
		EFFECT_GROUP_STATE.ENEMY_FLOOR:
			pass

func _nextEffect():
	var myEffect = effectGroupQue.pop_front()

	if( myEffect ):
		effectGroupSelected.append( myEffect )
		setEffectStateFromEffectGroup( myEffect.targetType )
	else: 
		emit_signal( "abilitySelectFinished" )

func _prevEffect():
	var currentEffect = effectGroupSelected.pop_front()
	effectGroupQue.append( currentEffect )

	var prevEffect = effectGroupSelected.back()

	if( prevEffect ):
		setEffectStateFromEffectGroup( prevEffect.targetType )
	else:
		emit_signal( "abilitySelectCanceled" )

func setState(newState: int , ability , character ):
	currentAbility = ability
	currentState = newState
	currentBattler = findBattlerFromCharacter( character )

	match currentState:
		STATE.FOCUS: # When focused we start ability Que, so we can loop through actions.
			effectGroupQue = ability.getEffectGroups()
			_nextEffect()
	
		STATE.EXECUTING: # When executing, start ability que again to loop through execution of actions
			effectGroupQue = ability.getEffectGroups()
			_executeAllEffects()

		STATE.NOT_FOCUS: # Set the effect group to be cleared, because ability is unselected
			setEffectGroupState( EFFECT_GROUP_STATE.IDLE )
			effectGroupQue = []
			effectGroupSelected = []
	
	currentBattler.setSelectionState( Battler.SELECTION.FOCUS_TARGET )

func setEffectGroupState( newState : int ):
	effectGroupState = newState

	match effectGroupState:
		EFFECT_GROUP_STATE.IDLE:
			pass 
		EFFECT_GROUP_STATE.LIST:
			pass
		EFFECT_GROUP_STATE.ALLY_FLOOR:
			targetingAllyFloor() 
		EFFECT_GROUP_STATE.ALLY_UNIT:
			pass 
		EFFECT_GROUP_STATE.ENEMY_FLOOR:
			pass
		EFFECT_GROUP_STATE.ENEMY_UNIT:
			targetingEnemyUnit()
		EFFECT_GROUP_STATE.SELF:
			targetingSelf()

func _resetAllBattlers():
	updateBattlerSelectionState( Battler.SELECTION.NONE , true )
	updateBattlerSelectionState( Battler.SELECTION.NONE , false )

# Converts targeting state from Ability.TARGET_TYPE into a state appropriote to this object
func setEffectStateFromEffectGroup( targetingState : String ):	
	match targetingState:
		AbilityResource.TARGET_TYPE.SELF:
			setEffectGroupState( EFFECT_GROUP_STATE.SELF )
		AbilityResource.TARGET_TYPE.ALLY_FLOOR:
			setEffectGroupState( EFFECT_GROUP_STATE.ALLY_FLOOR )
		AbilityResource.TARGET_TYPE.ALLY_UNIT:
			setEffectGroupState( EFFECT_GROUP_STATE.ALLY_UNIT )
		AbilityResource.TARGET_TYPE.ENEMY_UNIT:
			setEffectGroupState( EFFECT_GROUP_STATE.ENEMY_UNIT )
		AbilityResource.TARGET_TYPE.ENEMY_FLOOR:
			setEffectGroupState( EFFECT_GROUP_STATE.ENEMY_FLOOR )

func targetingSelf():
	currentBattler.setFocusState( currentBattler.STATE.FOCUS )
	currentBattler.setSelectionState( currentBattler.SELECTION.ASSIST_TARGET )

func inputTargetingSelf( _ev : InputEvent ):
	pass

func targetingAllyFloor():
	print("selecting player floor")
	#Pass
	#selectionMap.setState( selectionMap.STATE.FOCUS )

func inputTargetingAllyFloor( _ev: InputEvent ):
	print("handling an input in player floor")
	#selectionMap.handleInput( _ev ) # Most input logic is handled by the selectionMap

func targetingEnemyUnit():
	print("enemy unit")

func inputTargetingEnemyUnit( _ev: InputEvent ):
	print("handling an input in enemy unit mode")

func inputExecutingEffects( _ev: InputEvent ):
	# Add handling for instants here
	pass

func _executeAllEffects():
	_resetAllBattlers()
	emit_signal("abilityExecuteFinished")


# Methods for updating battlers
func updateBattlerSelectionState( state : int , isPlayer , formationArray = null):
	var myFormation : FormationResource =  playerTiles if ( isPlayer ) else enemyTiles
	var characterList = myFormation.getFilteredCharacterList( formationArray )

	for character in characterList:
		var battler = findBattlerFromCharacter( character )
		if( battler ):
			battler.setSelectionState( state )

func applyEffectToBattlers( effect: AbilityResource.EffectGroup , isPlayer, formationArray = null ):
	var myFormation : FormationResource =  playerTiles if ( isPlayer ) else enemyTiles
	var characterList = myFormation.getFilteredCharacterList( formationArray )

	for character in characterList:
		var battler = findBattlerFromCharacter( character )
		if( battler ):
			pass
			# applyAnimationsToBattler
			# applyDamageToCharacter

func findBattlerFromCharacter( character : CharacterResource ):
	for battlerNode in get_tree().get_nodes_in_group( NODE_GROUP_BATTLER ):
		if( battlerNode.currentCharacter == character ):
			return battlerNode

	return null
