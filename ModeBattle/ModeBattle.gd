extends Node2D

# UI Nodes
# Data Notes that mostly just display information
onready var turnOrder : Panel = $CanvasLayer/Turnorder

# Targeting Detail
onready var targetUI : Panel = $CanvasLayer/TargetPanel
onready var casterUI : Panel = $CanvasLayer/CasterPanel
onready var abilityDetailUI : Panel = $CanvasLayer/AbilityDetail

# Ability lists
onready var abilityUI : Panel = $CanvasLayer/AbilityList
onready var instantUI : PanelContainer = $CanvasLayer/Instants

onready var battleMap : Control = $BattleMap

# Utility Nodes
onready var enemyActionTimer : Timer = $EnemyActionTimer
onready var crewGenerator : Node = $CrewGenerator

var crew : Array = []
var enemy : Array = []

# State variables
enum STATE {
	PAGE_LOADING,
	PLAYER_FREE_ROAM,
	PLAYER_SELECTING_ABILITY,
	PLAYER_SELECTING_TARGETS,
	PLAYER_EXECUTING_ABILITY,
	ENEMY_SELECTING_ABILITY,
	ENEMY_EXECUTING_ABILITY
}

const NODE_GROUP_BATTLER = "BATTLER"

# abilities tied to state
var currentFocusUI = null
var currentState = STATE.PAGE_LOADING
var currentCharacter : CharacterResource
var currentAbility : AbilityResource

func _ready():
	setupScene()

func setupScene( _crew : Array = []):
	# TODO : have this load crew from a database with maybe a switch allowing for random
	crew = crewGenerator.generateManyCrew(30 , 6, true)
	enemy = crewGenerator.generateManyCrew(30, 6)

	battleMap.setupScene( crew, enemy )
	turnOrder.rollAllTurns(crew, enemy)
	
	_runNextTurn()

func _runNextTurn():
	if( !_testBattleEnd() ):
		pass
		# Show Loot & EXP UI
		#return null

	currentCharacter = turnOrder.nextTurn()

	if( currentCharacter.isPlayer ):
		setState(STATE.PLAYER_SELECTING_ABILITY)
	else:
		setState(STATE.ENEMY_SELECTING_ABILITY)

# ALL inputs are handled here natively, but can be passed to subsidary UI scripts if needed
# IE many elements may need to be aware of inputs, and we want to be very careful with
# Input cascades firing off bazillions of events
func _input( event : InputEvent ):
	match currentState:
		STATE.PLAYER_FREE_ROAM:
			pass
		STATE.PLAYER_SELECTING_ABILITY:
			playerSelectingAbilityInputs( event )
		STATE.PLAYER_SELECTING_TARGETS:
			playerSelectingTargetInputs( event )
		STATE.PLAYER_EXECUTING_ABILITY:
			playerExecutingAbilityInputs( event )
		STATE.ENEMY_SELECTING_ABILITY:
			enemySelectingAbilityInputs( event )

func setState(newState):
	currentState = newState
	
	match currentState:
		STATE.PLAYER_FREE_ROAM:
			pass 
		STATE.PLAYER_SELECTING_ABILITY:
			playerSelectingAbility()
		STATE.PLAYER_SELECTING_TARGETS:
			playerSelectingTargets()
		STATE.PLAYER_EXECUTING_ABILITY:
			playerExecutingAbility()
		STATE.ENEMY_SELECTING_ABILITY:
			enemySelectingAbility()
		STATE.ENEMY_SELECTING_TARGETS:
			enemySelectingTargets()
		STATE.ENEMY_EXECUTING_ABILITY:
			enemyExecutingTargets()

func playerSelectingAbility():
	casterUI.updateUI( currentCharacter )
	casterUI.setState( casterUI.STATE.SHOW )
	abilityUI.setState( abilityUI.STATE.FOCUS , currentCharacter )
	battleMap.setState( battleMap.STATE.NOT_FOCUS , currentAbility, currentCharacter )

	# activeDisplay.activateLabel( activeDisplay.LABELS.ATTACKER , currentCharacter.getNickName() )
	

func playerSelectingAbilityInputs( ev : InputEvent ):
	# Handle B for cancel, to allow for 'free roam of page'
	pass # Many of these are handled by UI natively

func playerSelectingTargets():
	abilityUI.setState( abilityUI.STATE.HIDE , null )
	battleMap.setState( battleMap.STATE.FOCUS , currentAbility, currentCharacter )

func playerSelectingTargetInputs( ev: InputEvent ):
	# B to cancel
	# setState( STATE.PLAYER_SELECTING_ABILITY )
	battleMap.handleParentInput( ev )

func playerExecutingAbility():
	battleMap.setState( battleMap.STATE.EXECUTING , currentAbility, currentCharacter )

func playerExecutingAbilityInputs( ev : InputEvent ):
	# Allow opportunity for certain kinds of instants.
	pass

func enemySelectingAbility():
	# enemyUI.updateUI( currentCharacter )
	# enemyUI.setState( enemyUI.STATE.SHOW )
	enemyActionTimer.start()

func enemySelectingAbilityInputs( ev : InputEvent ):
	# Pass Allow for instants button
	# Also allow for viewing enemy stats
	pass

func enemySelectingTargets():
	pass

func enemyExecutingTargets():
	pass
	
func _testBattleEnd():
	return false

# Signals
func _on_EnemyActionTimer_timeout():
	_runNextTurn()

# Fired when a player has selected an ability.
func _on_AbilityList_abilityActivated( ability ):
	currentAbility = ability
	setState( STATE.PLAYER_SELECTING_TARGETS )

func _on_AbilityList_abilityChanged( ability ):
	abilityDetailUI.setupScene( ability )

func _on_SelectionMap_selection_change( loc : Vector2 , targetString ):
	pass
	#targetUI.updateUI( character )
	#targetUI.setState( casterUI.STATE.SHOW )

func _on_BattleMap_abilitySelectFinished():
	print("ModeBattle : _on_BattleMap_abilitySelectFinished")
	# activeDisplay.clear()
	# playerUI.setState( playerUI.STATE.HIDE )
	# enemyUI.setState( enemyUI.STATE.HIDE )

	setState( STATE.PLAYER_EXECUTING_ABILITY )

func _on_BattleMap_abilityExecuteFinished():
	print("ModeBattle : _on_BattleMap_abilityExecuteFinished")
	_runNextTurn()

func _on_BattleMap_abilitySelectCanceled():
	print("ModeBattle : _on_BattleMap_abilitySelectCanceled!")
	setState( STATE.PLAYER_SELECTING_ABILITY )
	# TODO - will likely need to be a clear all at some point, so we can permit free roam, controlled by ModeBattle.

func _on_BattleMap_playerSelected( character : CharacterResource ):
	casterUI.updateUI( character )
	casterUI.setState( casterUI.STATE.SHOW )

func _on_Battlemap_enemySelected( character: CharacterResource ):
	casterUI.updateUI( character )
	casterUI.setState( casterUI.STATE.SHOW )
