extends Panel

onready var charName : Label = $Name
onready var hWorld : Label = $HWorld
onready var species : Label =  $Species
onready var cp : Label = $CP 
onready var healthAmount : Label = $HealthAmount
onready var moraleAmount : Label = $MoraleAmount
onready var smallTexture : TextureRect = $TextureRect

var character : CharacterResource

signal focusEntered( character )


const STATE = {
	"FOCUS" : Color( .64 , .77 , .64 , 1 ),
	"NOT_FOCUS" : Color( 1 , 1 , 1 , 1 )
}

func setupScene( newCharacter : CharacterResource ):
	character = newCharacter

	charName.set_text( character.getFullName() )
	hWorld.set_text( character.getWorldString() )
	species.set_text( character.getRaceString() )
	cp.set_text( character.getCPointString() )
	moraleAmount.set_text( character.getMoraleString() )
	healthAmount.set_text( character.getHitPointString() )

	smallTexture.set_texture(load(character.smallTexturePath))


func _on_CPanel_focus_entered():
	emit_signal( "focusEntered" , character )
	set_self_modulate( STATE.FOCUS )

func _on_CPanel_focus_exited():
	set_self_modulate( STATE.NOT_FOCUS )
