extends Panel

onready var smallTexture : TextureRect = $TextureRect
onready var charName : Label = $VBox/Label

onready var healthBar : ProgressBar = $VBox/HBox/Stats/HealthBar
onready var moraleBar : ProgressBar = $VBox/HBox/Stats/MoraleBar

onready var raceValue : Label = $VBox/HBox/Profile/HomeworldRow/Value
onready var homeworldValue : Label = $VBox/HBox/Profile/RaceRow/Value
onready var cpDisplay : Label = $VBox/HBox/Stats/CP/Points

var character : CharacterResource

signal focusEntered( character )


const STATE = {
	"FOCUS" : Color( .2 , 1 , .2 , 1 ),
	"NOT_FOCUS" : Color( 1 , 1 , 1 , .7 )
}

func setupScene( newCharacter : CharacterResource ):
	character = newCharacter

	charName.set_text( character.getFullName() )
	
	homeworldValue.set_text( character.getWorldString() )
	raceValue.set_text( character.getRaceString() )
	cpDisplay.set_text( str( character.cp - character.cpSpent ) )

	healthBar.setBarValues( character.hp.current , character.hp.total )
	moraleBar.setBarValues( character.morale.current, character.morale.total )

	smallTexture.set_texture(load(character.smallTexturePath))


func _on_CPanel_focus_entered():
	emit_signal( "focusEntered" , character )
	set_self_modulate( STATE.FOCUS )

func _on_CPanel_focus_exited():
	set_self_modulate( STATE.NOT_FOCUS )
