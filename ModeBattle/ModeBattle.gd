extends Node2D


onready var groundMap : TileMap = $Ground
onready var selectionMap : TileMap = $Selection
onready var areaOfEffectMap : TileMap = $AreaOfEffect

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

# abilities tied to state
var currentFocusUI = null
var currentState = STATE.PAGE_LOADING
var currentCharacter : CharacterResource
var currentBattler : Node2D

# Substate params ( Only used while in STATE.PLAYER_SELECTING_TARGETS )
var currentTargetingState = null
var currentUnselectedEffectGroups : Array
var currentSelectedEffectGroups : Array
var currentAbility : AbilityResource

func _ready():
	setupScene()

func _input(event):
	match currentState:
		STATE.PLAYER_SELECTING_ABILITY:
			playerSelectingAbilityInputs( event )
		STATE.PLAYER_SELECTING_TARGETS:
			pass
		#	match currentTargetingState:
		#		AbilityResource.TARGET_TYPE.SELF:
		#			print(currentTargetingState)
		#		AbilityResource.TARGET_TYPE.ALLY_FLOOR:
		#			print(currentTargetingState)
		#		AbilityResource.TARGET_TYPE.ENEMY_UNIT:
		#			print(currentTargetingState)
		#		AbilityResource.TARGET_TYPE.ALLY_UNIT:
		#			print(currentTargetingState)
		#		AbilityResource.TARGET_TYPE.ENEMY_FLOOR:
		#			print(currentTargetingState)

		STATE.ENEMY_SELECTING_ABILITY:
			enemySelectingAbilityInputs( event )

func setState(newState):
	currentState = newState
	
	match currentState:
		STATE.PLAYER_SELECTING_ABILITY:
			playerSelectingAbility()
		STATE.PLAYER_SELECTING_TARGETS:
			playerSelectingTargets()
		STATE.ENEMY_SELECTING_ABILITY:
			enemySelectingAbility()

func setupScene( _crew : Array = []):
	crew = crewGenerator.generateManyCrew(30 , 6, true)
	playerTiles = FormationResource.new( crew )
	
	for x in range(0, playerTiles.positions.size() ):
		for y in range( 0, playerTiles.positions[x].size() ):
			if playerTiles.positions[x][y]:
				var battler = playerBattlerScene.instance()
				battler.position = groundMap.map_to_world( PLAYER_TILE_MAP[x][y] ) + TILE_OFFSET
				playerBase.add_child( battler )
				battler.setupScene(playerTiles.positions[x][y] ,Vector2( x, y ))

	enemy = crewGenerator.generateManyCrew(30, 6)
	enemyTiles = FormationResource.new( enemy )

	for x in range(0, enemyTiles.positions.size() ):
		for y in range( 0, enemyTiles.positions[x].size() ):
			if enemyTiles.positions[x][y]:
				var battler = enemyBattlerScene.instance()
				battler.position = groundMap.map_to_world( ENEMY_TILE_MAP[x][y] ) + Vector2(32, TILE_SIZE.y)
				enemyBase.add_child( battler )
				battler.setupScene(enemyTiles.positions[x][y], Vector2( x, y ))

	turnOrder.rollAllTurns(crew, enemy)
	_runNextTurn()

func _runNextTurn():
	currentCharacter = turnOrder.nextTurn()

	for node in get_tree().get_nodes_in_group(NODE_GROUP_BATTLER):
		node.setSelectionState( node.SELECTION.NONE ) # All battler nodes have a CharacterRefrence resource

		if( currentCharacter == node.currentCharacter ):
			node.setFocusState( node.CURRENT.FOCUS )

	if( currentCharacter.isPlayer ):
		currentBattler = findCharacterInBattlerList( currentCharacter )
		setState(STATE.PLAYER_SELECTING_ABILITY)
	else:
		setState(STATE.ENEMY_SELECTING_ABILITY)
	
	if( _testBattleEnd() ):
		pass

func playerSelectingAbility():
	playerUI.updateUI( currentCharacter )
	abilityUI.updateUI( currentCharacter )
	
	currentFocusUI = abilityUI
	abilityUI.setState( abilityUI.STATE.FOCUS )

func playerSelectingAbilityInputs( ev : InputEvent ):
	pass # Many of these are handled by UI natively

func playerSelectingTargets():
	print("player selecting targets")
	var nextEffectGroup : AbilityResource.EffectGroup = currentUnselectedEffectGroups.pop_front()
	# Update ability UI to show all data from all abilities

	print(nextEffectGroup)

	if( nextEffectGroup ):
		# Get target area and pass that to next method
		match nextEffectGroup.targetType:
			AbilityResource.TARGET_TYPE.SELF:
				playerTargetingSelf( nextEffectGroup )
			AbilityResource.TARGET_TYPE.ALLY_FLOOR:
				playerTargetingAllyFloor( nextEffectGroup )
			AbilityResource.TARGET_TYPE.ENEMY_UNIT:
				playerTargetingEnemyUnit( nextEffectGroup )	
	else:
		# Handle movement to group execution
		pass 
	
func playerSelectingTargetsInputs( _ev : InputEvent ):
	# Handle cancelation
	# Handling for various left-right-update.
	pass

func playerTargetingSelf( effectGroup : AbilityResource.EffectGroup ):
	currentBattler.setSelectionState( currentBattler.SELECTION.ASSIST_TARGET )
	print("selecting self")

func playerTargetingSelfInputs( _ev : InputEvent):
	pass
	# B to cancel
	# A to accept

func playerTargetingAllyFloor( effectGroup : AbilityResource.EffectGroup ):
	for x in range(0 , PLAYER_TILE_MAP.size()):
		for y in range(0 , PLAYER_TILE_MAP[x].size() ):
			var t : Vector2 = PLAYER_TILE_MAP[x][y]
			selectionMap.set_cell( t.x , t.y , 0 )

			# Place additional placeholder over that tile to indicate Area of effect of ability
			#playerBase.



	print("ally floor")

func playerTargetingAllyFloorInputs( _ev: InputEvent ):
	pass

func playerTargetingEnemyFloor( effectGroup : AbilityResource.EffectGroup ):
	print("enemy floor")

func playerTargetingEnemyFloorInputs( _ev: InputEvent ):
	pass

func playerTargetingEnemyUnit( effectGroup : AbilityResource.EffectGroup ):
	print("enemy unit")

func playerTargetingEnemyUnitInputs( _ev: InputEvent ):
	pass

func playerTargetingAllyUnit( effectGroup : AbilityResource.EffectGroup ):
	print("ally Unit")

func playerTargetingAllyUnitInputs( _ev: InputEvent ):
	pass

func enemySelectingAbility():
	targetUI.updateUI( currentCharacter )
	enemyActionTimer.start()

func enemySelectingAbilityInputs( ev : InputEvent ):
	pass

func findCharacterInBattlerList( character : CharacterResource ):
	for battlerNode in get_tree().get_nodes_in_group( NODE_GROUP_BATTLER ):
		if( battlerNode.currentCharacter == character ):
			return battlerNode

func _testBattleEnd():
	pass

# Signals
func _on_EnemyActionTimer_timeout():
	_runNextTurn()

# Fired when a player has selected an ability.
func _on_AbilityList_abilityActivated( ability : AbilityResource ):
	
	currentAbility = ability
	currentUnselectedEffectGroups = currentAbility.getEffectGroups()
	currentSelectedEffectGroups = []

	setState( STATE.PLAYER_SELECTING_TARGETS )
	
	
