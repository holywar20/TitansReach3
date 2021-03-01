extends TextureRect

onready var initLabel : Label = $Label

var crewman : CharacterResource
var roll : int

const COLORS = {
	"PLAYER" : Color( .64 , 1 , .64 , 1),
	"ENEMY"  : Color( 1 , .64 , .64 , 1)
}

func _ready():
	pass # Replace with function body.

func setupScene( initRoll : int , newCrewman : CharacterResource ):
	initLabel.set_text( str(initRoll) )
	
	roll = initRoll
	crewman = newCrewman

	if( crewman.isPlayer ):
		set_self_modulate( COLORS.PLAYER )
	else:
		set_self_modulate( COLORS.ENEMY )

	set_texture( load(crewman.smallTexturePath))
