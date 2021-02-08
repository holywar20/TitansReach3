extends Panel

onready var abilityIcon : Button = $Button

var ability : AbilityResource
var character : CharacterResource

func setupScene( newAbility : AbilityResource ):
	ability = newAbility
	
	abilityIcon.set_button_icon( load(ability.iconPath) )

func setFocused():
	abilityIcon.grab_focus()

func allowFocus():
	abilityIcon.set_focus_mode(FOCUS_ALL)

func disallowFocus():
	abilityIcon.set_focus_mode(FOCUS_NONE)
