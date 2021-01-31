extends PanelContainer

var initBoxScene = preload("res://ModeBattle/InitBlock/InitBlock.tscn")

onready var turnBase : HBoxContainer = $HBox
onready var sorting : Node = $Sorting

var currentTurn : TextureRect = null

const INIT_PROTOTYPE = { 
	"roll" : 0 ,
	"crew" : null
	}

func _ready():
	pass

func rollAllTurns( crew : Array, enemy: Array) -> void:
	var rolls = []
	
	for crewman in crew:
		var rollDictionary = INIT_PROTOTYPE.duplicate()
		rollDictionary.roll = crewman.rollInit()
		rollDictionary.crewman = crewman
		rolls.append( rollDictionary )
	
	for crewman in enemy:
		var rollDictionary = INIT_PROTOTYPE.duplicate()
		rollDictionary.roll = crewman.rollInit()
		rollDictionary.crewman = crewman
		rolls.append( rollDictionary )
	
	rolls = sorting.bubbleSortArrayByDictKey(rolls, 'roll')
	
	for rollDict in rolls:
		var newInitBlock = initBoxScene.instance()
		turnBase.add_child( newInitBlock )
		newInitBlock.setupScene( rollDict.roll , rollDict.crewman )

func nextTurn() -> CharacterResource:
	var nextInit = turnBase.get_child(0)
	turnBase.remove_child( nextInit )
	turnBase.add_child( nextInit )
	
	return nextInit.crewman
