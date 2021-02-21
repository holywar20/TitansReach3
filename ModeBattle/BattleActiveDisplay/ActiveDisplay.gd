extends Control

enum LABELS {
	ATTACKER , ABILITY, TARGET
}

onready var labelNodes = {
	LABELS.ATTACKER : {
		"panel" : $Attacker ,
		"label" : $Attacker/Label
	} ,
	LABELS.ABILITY : {
		"panel" : $Ability,
		"label" : $Ability/Label
	},
	LABELS.TARGET : {
		"panel" : $Target,
		"label" : $Target/Label
	} 
}

func _ready():
	clear()

func clear():
	deactivateLabel( LABELS.ATTACKER )
	deactivateLabel( LABELS.ABILITY )
	deactivateLabel( LABELS.TARGET )
			
func activateLabel( labelIdx : int , labelText ):
	labelNodes[labelIdx].panel.show()
	labelNodes[labelIdx].label.set_text( labelText )

func deactivateLabel( labelIdx : int ):
	labelNodes[labelIdx].panel.hide()
	labelNodes[labelIdx].label.set_text("")
