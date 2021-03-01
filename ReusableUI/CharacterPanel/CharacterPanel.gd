extends Panel

onready var charIcon : TextureRect = $Title/Icon
onready var charName : Label = $Title/Name

var character : CharacterResource
var currentState : int = STATE.HIDE

const BASE_NODE_TRAIT_PATH = "HBox/Traits/"

enum STATE {
	SHOW, FOCUS , NOT_FOCUS , HIDE
}

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charIcon.set_texture(load(character.smallTexturePath))
	charName.set_text(character.getFullName())

	for stat in ["STR" , "PER", "DEX" , "INT" , "CHA"]:
		_loadStatBlockIntoRow( stat )

func _loadStatBlockIntoRow( traitName ):
	var myStatBlock = character.getTraitStatBlock( traitName )

	get_node( BASE_NODE_TRAIT_PATH + traitName + "/Base").set_text( str(myStatBlock.value) )
	get_node( BASE_NODE_TRAIT_PATH + traitName + "/Mod").set_text( str(myStatBlock.equip + myStatBlock.talent + myStatBlock.mod ) )
	get_node( BASE_NODE_TRAIT_PATH + traitName + "/Cur").set_text( str(myStatBlock.total) )

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
