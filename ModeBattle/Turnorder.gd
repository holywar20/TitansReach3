extends PanelContainer

var initBoxScene = preload("")

const INIT_PROTOTYPE = { 
	"roll" : 0 ,
	"crew" : null
	}

func _ready():
	pass

func rollAllTurns( crew : Array, enemy: Array):
	var rolls = []
	
	for crewman in crew:
		var rollObject = INIT_PROTOTYPE.duplicate()
		rollObject.roll = crewman.rollInit()
		rollObject.crewman = crewman
		
	

func nextTurn():
	pass
