extends PanelContainer

onready var abilityGrid : GridContainer = $GridContainer 

var abilityIconScene = preload("res://ReusableUI/AbilityIcon/AbilityIcon.tscn")
var currentState : int = STATE.FOCUS

enum STATE {
	FOCUS , NOT_FOCUS
}

var currentBattler : CharacterResource

func updateUI( newBattler : CharacterResource ):
	currentBattler = newBattler
	
	for child in abilityGrid.get_children():
		child.queue_free()
	
	for action in currentBattler.actions:
		var abilityInstance = abilityIconScene.instance()
		abilityGrid.add_child( abilityInstance )
		abilityInstance.setupScene( action )

func setState( state : int ):
	currentState = state
	
	match currentState:
		STATE.FOCUS:
			set_self_modulate( Color(0, 0, 20, 4 ) )
			var icon = abilityGrid.get_child(0)
			icon.setState( icon.STATE.SELECTED)
		STATE.NOT_FOCUS:
			set_self_modulate( Color(0 , 0 , 10 , 4 ) )
			for icon in abilityGrid.get_children():
				icon.setState( icon.STATE.UNSELECTED )
