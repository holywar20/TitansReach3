extends Panel

onready var abilityIcon : TextureRect = $AbilityIcon

var ability : AbilityResource
var selectionState : int

enum STATE {
	SELECTED , UNSELECTED
}

func setupScene( newAbility : AbilityResource ):
	ability = newAbility
	
	abilityIcon.set_texture( load(ability.iconPath))

func setSelectionState( state : int):
	selectionState = state
	
	match selectionState:
		STATE.SELECTED:
			set_self_modulate(Color(0, 0, 40 , 50))
		STATE.UNSELECTED:
			set_self_modulate(Color(255, 255, 255 , 255))
