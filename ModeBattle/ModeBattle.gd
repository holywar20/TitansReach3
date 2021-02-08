extends Node2D


onready var groundMap : TileMap = $Ground
onready var crewGenerator : Node = $CrewGenerator
onready var playerBase : YSort = $Players
onready var enemyBase : YSort = $Enemy

# UI Nodes
onready var turnOrder : PanelContainer = $CanvasLayer/Turnorder
onready var targetUI : PanelContainer = $CanvasLayer/Target
onready var playerUI : PanelContainer = $CanvasLayer/Player
onready var abilityUI : PanelContainer = $CanvasLayer/AbilityList
onready var instantUI : PanelContainer = $CanvasLayer/Instants

onready var enemyActionTimer : Timer = $EnemyActionTimer

var playerBattlerScene = preload("res://ModeBattle/PlayerBattler/PlayerBattler.tscn")
var enemyBattlerScene = preload("res://ModeBattle/EnemyBattler/EnemyBattler.tscn")

const NODE_GROUP_BATTLER = "BATTLER"

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

var crew : Array = []
var enemy : Array = []

# State variables
enum STATE {
	PAGE_LOADING,
	PLAYER_SELECTING_ABILITY,
	PLAYER_SELECTING_TARGETS,
	PLAYER_EXECUTING_ABILITY,
	ENEMY_SELECTING_ABILITY,
	ENEMY_EXECUTING_ABILITY
}

var currentFocusUI = null
var currentState = STATE.PAGE_LOADING
var currentCharacter : CharacterResource

func _ready():
	setupScene()

func _input(event):
	match currentState:
		STATE.PLAYER_SELECTING_ABILITY:
			playerSelectingAbilityInputs( event )
		STATE.ENEMY_SELECTING_ABILITY:
			enemySelectingAbilityInputs( event )

func setupScene( _crew : Array = []):
	crew = crewGenerator.generateManyCrew(30 , 6, true)
	playerTiles = FormationResource.new( crew )
	
	for x in range(0, playerTiles.positions.size() ):
		for y in range( 0, playerTiles.positions[x].size() ):
			if playerTiles.positions[x][y]:
				var battler = playerBattlerScene.instance()
				battler.position = groundMap.map_to_world( PLAYER_TILE_MAP[x][y] ) + TILE_OFFSET
				playerBase.add_child( battler )
				battler.setupScene(playerTiles.positions[x][y])

	enemy = crewGenerator.generateManyCrew(30, 6)
	enemyTiles = FormationResource.new( enemy )

	for x in range(0, enemyTiles.positions.size() ):
		for y in range( 0, enemyTiles.positions[x].size() ):
			if enemyTiles.positions[x][y]:
				var battler = enemyBattlerScene.instance()
				battler.position = groundMap.map_to_world( ENEMY_TILE_MAP[x][y] ) + Vector2(32, TILE_SIZE.y)
				enemyBase.add_child( battler )
				battler.setupScene(enemyTiles.positions[x][y])

	turnOrder.rollAllTurns(crew, enemy)
	_runNextTurn()

func _runNextTurn():
	currentCharacter = turnOrder.nextTurn()

	for node in get_tree().get_nodes_in_group(NODE_GROUP_BATTLER):
		node.setSelectionState( node.SELECTION.NONE ) # All battler nodes have a CharacterRefrence resource

		if( currentCharacter == node.currentCharacter ):
			node.setFocusState( node.CURRENT.FOCUS )

	if( currentCharacter.isPlayer ):
		setState(STATE.PLAYER_SELECTING_ABILITY)
	else:
		setState(STATE.ENEMY_SELECTING_ABILITY)
	
	if( _testBattleEnd() ):
		pass

func setState(newState):
	currentState = newState
	
	match currentState:
		STATE.PLAYER_SELECTING_ABILITY:
			playerSelectingAbility()
		STATE.ENEMY_SELECTING_ABILITY:
			enemySelectingAbility()

func playerSelectingAbility():
	playerUI.updateUI( currentCharacter )
	abilityUI.updateUI( currentCharacter )
	
	currentFocusUI = abilityUI
	abilityUI.setState( abilityUI.STATE.FOCUS )

func playerSelectingAbilityInputs( ev : InputEvent ):
	pass

func enemySelectingAbility():
	targetUI.updateUI( currentCharacter )
	enemyActionTimer.start()

func enemySelectingAbilityInputs( ev : InputEvent ):
	pass

func _testBattleEnd():
	pass

# Signals
func _on_EnemyActionTimer_timeout():
	_runNextTurn()

func _on_AbilityList_ability_selected( ability : AbilityResource , character : CharacterResource ):
	pass # Replace with function body.
