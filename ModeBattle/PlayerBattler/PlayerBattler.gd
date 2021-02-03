extends Node2D

var currentCharacter : CharacterResource

onready var nameLabel : Label = $Name
onready var characterSprite : Sprite = $Sprite

enum SELECTION {
	NONE,
	VIEW_TARGET,
	ATTACK_TARGET
}

enum CURRENT {
	FOCUS,
	NOT_FOCUS
}

var selectionState = SELECTION.NONE
var focusState = CURRENT.NOT_FOCUS

func setupScene( newCharacter : CharacterResource ):
	currentCharacter = newCharacter
	nameLabel.set_text( currentCharacter.getNickName() )

# TODO probally need to redo this. Maybe add different independent sprites / particles to show state
func setSelectionState( state : int ):
	var selectionState = state
	
	match selectionState:
		SELECTION.NONE:
			setFocusState(focusState) # FocusState is the default state unless some selection is going on.
		SELECTION.VIEW_TARGET:
			characterSprite.set_modulate( Color(0, 200, 0 , 30) )
		SELECTION.ATTACK_TARGET:
			characterSprite.set_modulate( Color(200, 0, 0 , 30) )

func setFocusState( state : int ):
	var focusState = state
	
	match focusState:
		CURRENT.FOCUS:
			characterSprite.set_modulate( Color(0, 0, 200) )
		CURRENT.NOT_FOCUS:
			if selectionState == SELECTION.NONE:
				characterSprite.set_modulate( Color(255, 255, 255, 255) )
			else:
				setSelectionState(selectionState)
