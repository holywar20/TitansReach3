extends Panel

onready var charIcon : TextureRect = $Title/Icon
onready var charName : Label = $Title/Name

var character : CharacterResource
var currentState : int = STATE.HIDE

enum STATE {
	SHOW, FOCUS , NOT_FOCUS , HIDE
}

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charIcon.set_texture(load(character.smallTexturePath))
	charName.set_text(character.getFullName())

func setState( newState : int ):
	currentState = newState

	match currentState:
		STATE.SHOW:
			show()
		STATE.FOCUS:
			show()
		STATE.NOT_FOCUS:
			pass
		STATE.HIDE:
			hide()
