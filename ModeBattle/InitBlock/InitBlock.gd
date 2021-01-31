extends TextureRect

onready var initLabel : Label = $Label

var crewman : CharacterResource
var roll : int

func _ready():
	pass # Replace with function body.

func setupScene( initRoll : int , newCrewman : CharacterResource ):
	initLabel.set_text( str(initRoll) )
	
	roll = initRoll
	crewman = newCrewman
	
	set_texture( load(crewman.smallTexturePath))
