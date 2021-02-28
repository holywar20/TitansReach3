extends Panel

onready var abilityIcon : TextureButton = $TextureButton

var ability : AbilityResource

const STATE_COLOR = {
	"FOCUS" : Color( 0, 1, 0, 1 ),
	"NOT_FOCUS" : Color( 1, 1, 1, 1 ) 
}

func setupScene( newAbility : AbilityResource ):
	ability = newAbility
	abilityIcon.set_normal_texture( load(ability.iconPath) )

func setFocused():
	abilityIcon.grab_focus()
	_on_TextureButton_focus_entered()

func allowFocus():
	abilityIcon.set_focus_mode(FOCUS_ALL)

func disallowFocus():
	abilityIcon.set_focus_mode(FOCUS_NONE)

func _on_TextureButton_focus_entered():
	set_self_modulate( STATE_COLOR.FOCUS )

func _on_TextureButton_focus_exited():
	set_self_modulate( STATE_COLOR.NOT_FOCUS )
