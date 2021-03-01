extends Panel

var character : CharacterResource

func _ready():
	grab_focus()

func setupScene( newCharacter : CharacterResource ):
	character = newCharacter

