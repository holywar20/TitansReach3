extends Panel

onready var charIcon : TextureRect = $Title/Icon
onready var charName : Label = $Title/Name

onready var statusEffects : GridContainer = $HBox/Traits/Effects
onready var statusEffectsLabel : Label = $HBox/Traits/EffectsLabel

onready var healthBar = $Title/HealthBar
onready var moraleBar = $Title/MoraleBar

var character : CharacterResource
var currentState : int = STATE.HIDE

const BASE_NODE_TRAIT_PATH = "HBox/Traits/"
const BASE_NODE_DMG_PATH = "HBox/Resists/Status/Grid/"
const BASE_NODE_RESIST_PATH = "HBox/Resists/Status/Grid/"

export var hideStatusEffects = false

enum STATE {
	SHOW, FOCUS , NOT_FOCUS , HIDE
}

func _ready():
	if( hideStatusEffects ):
		statusEffects.hide()
		statusEffectsLabel.hide()

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charIcon.set_texture(load(character.smallTexturePath))
	charName.set_text(character.getFullName())

	for stat in CharacterResource.TRAITS:
		_loadStatBlockIntoRow( stat )
		
	for dmg in ["KINETIC" , "TOXIC" , "THERMAL" , "EM"]:
		_loadDamageBlockIntoRow( dmg )
		
	for resist in CharacterResource.RESISTS:
		_loadResistBlockIntoRow( resist )

	var statBlock = character.hp
	healthBar.setBarValues( statBlock.total , statBlock.current )

	statBlock = character.morale
	moraleBar.setBarValues( statBlock.total , statBlock.current )

func _loadStatBlockIntoRow( traitName ):
	var myStatBlock = character.getTraitStatBlock( traitName )
	get_node( BASE_NODE_TRAIT_PATH + traitName + "/Cur").set_text( str(myStatBlock.total) )

func _loadDamageBlockIntoRow( dmgType ):
	var myStatBlock = character.getDmgResistStatBlock( dmgType )
	get_node(BASE_NODE_DMG_PATH + dmgType + "/Cur").set_text( str(myStatBlock.total ) )

func _loadResistBlockIntoRow( resist ):
	var myStatBlock = character.getResistStatBlock( resist )
	get_node(BASE_NODE_RESIST_PATH + resist + "/Cur").set_text( str(myStatBlock.total ) )

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
