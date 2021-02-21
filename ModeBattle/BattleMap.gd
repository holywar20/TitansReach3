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
	[Vector2(22,0), Vector2(19,0), Vector2(16,0) , Vector2(13,0) , Vector2(10,0)],
	[Vector2(22,-3), Vector2(19,-3), Vector2(16,-3) , Vector2(13,-3) , Vector2(10,-3)],
	[Vector2(22,-6), Vector2(19,-6), Vector2(16,-6) , Vector2(13,-6) , Vector2(10,-6)],	
]

var playerTiles : FormationResource
var enemyTiles : FormationResource

enum STATE{
	FOCUS , NOT_FOCUS , EXECUTING
}

var currentState : int = STATE.FOCUS
var currentAbility : AbilityResource
var currentBattler : Node2D

var effectGroupQue : Array
var effectGroupSelected : Array

signal abilitySelectFinished
signal abilityExecuteFinished
signal abilitySelectCanceled

func setupScene( newCrew : Array , newEnemy : Array ):
	playerTiles = FormationResource.new( newCrew , true )
	for x in range(0, playerTiles.positions.size() ):
		for y in range( 0, playerTiles.positions[x].size() ):
			if typeof(playerTiles.positions[x][y]) == TYPE_OBJECT:
				# TODO : need better check here so I can store multiple object types
				# TODO : Hoist this logic into FormationResource
				var battler = playerBattlerScene.instance()
				battler.position = groundMap.map_to_world( PLAYER_TILE_MAP[x][y] ) + TILE_OFFSET
				playerBase.add_child( battler )
				battler.setupScene(playerTiles.positions[x][y] ,Vector2( x, y ))

	enemyTiles = FormationResource.new( newEnemy , false )
	for x in range(0, enemyTiles.positions.size() ):
		for y in range( 0, enemyTiles.positions[x].size() ):
			if typeof(enemyTiles.positions[x][y]) == TYPE_OBJECT:
				# TODO : need better check here so I can store multiple object types
				# TODO : Hoist this logic into FormationResource
				var battler = enemyBattlerScene.instance()
				battler.position = groundMap.map_to_world( ENEMY_TILE_MAP[x][y] ) + Vector2(32, TILE_SIZE.y)
				enemyBase.add_child( battler )
				battler.setupScene(enemyTiles.positions[x][y], Vector2( x, y ))

func handleParentInput( event : InputEvent ):
	# TODO add handling for hover
	# TODO add handling for controller exploration
	if( currentState == STATE.NOT_FOCUS ):
		return null
	
	if( Input.is_action_just_pressed("ui_cancel") ):
		_prevEffect()

	if( Input.is_action_just_pressed("ui_accept") ):
		_nextEffect()

	match currentState:
		STATE.FOCUS:
			if( selectionMap.currentState != selectionMap.STATE.NONE ):
				selectionMap.handleInput(event)		
		STATE.NOT_FOCUS:
			pass
		STATE.EXECUTING:
			# Allow for instants
			pass

func setState(newState: int , ability , character ):
	currentAbility = ability
	currentState = newState
	currentBattler = findBattlerFromCharacter( character )
	currentBattler.setTurnState( Battler.STATE.TURN )

	match currentState:
		STATE.FOCUS: # When focused we start ability Que, so we can loop through actions.
			effectGroupQue = ability.getEffectGroups()
			_nextEffect()
		
		STATE.EXECUTING: # When executing, start ability que again to loop through execution of actions
			effectGroupQue = ability.getEffectGroups()
			yield(get_tree().create_timer(1), "timeout")
			_executeAllEffects()

		STATE.NOT_FOCUS: # Set the effect group to be cleared, because ability is unselected
			effectGroupQue = []
			effectGroupSelected = []

func findBattlerFromCharacter( character : CharacterResource ):
	for battlerNode in get_tree().get_nodes_in_group( NODE_GROUP_BATTLER ):
		if( battlerNode.currentCharacter == character ):
			return battlerNode

	return null

# Utility Methods
func _executeAllEffects():
	print("executed effects for battler: " + currentBattler.currentCharacter.getNickName())
	currentBattler.setTurnState( Battler.STATE.NOT_TURN )
	emit_signal("abilityExecuteFinished")

func _nextEffect():
	var myEffectGroup : AbilityResource.EffectGroup = effectGroupQue.pop_front()

	if( myEffectGroup ):
		effectGroupSelected.append( myEffectGroup )
		
		# Figure out which formation the selectionMap should be using
		var isTargetingPlayer = myEffectGroup.enemyOrAlly( currentBattler.currentCharacter.isPlayer )
		var formation = playerTiles if isTargetingPlayer else enemyTiles

		selectionMap.setState( myEffectGroup , formation , currentAbility , currentBattler )
	else:
		currentBattler.setHighlightState( currentBattler.HIGHLIGHT.NONE )
		
		selectionMap.setState()
		
		emit_signal( "abilitySelectFinished" )

func _prevEffect():
	var currentEffect = effectGroupSelected.pop_front()
	effectGroupQue.append( currentEffect )

	var prevEffect = effectGroupSelected.back()

	if( prevEffect ):
		pass
	else:
		currentBattler.setHighlightState( currentBattler.HIGHLIGHT.NONE )
		
		selectionMap.setState()
		
		emit_signal( "abilitySelectCanceled" )
