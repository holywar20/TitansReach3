extends PanelContainer

onready var abilityGrid : GridContainer = $GridContainer # All children of this grid should be AbilityIcon scenes

var abilityIconScene = preload("res://ReusableUI/AbilityIcon/AbilityIcon.tscn")
var currentState : int = STATE.FOCUS

signal ability_selected

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
		
		abilityInstance.get_node("Button").connect("pressed" , self , "_on_abilityButtonPressed")

func setState( state : int ):
	currentState = state
	
	match currentState:
		STATE.FOCUS:
			for child in abilityGrid.get_children():
				child.allowFocus() 
			var icon = abilityGrid.get_child(0)
			icon.setFocused()
	
		STATE.NOT_FOCUS:
			for icon in abilityGrid.get_children():
				icon.disallowFocus()

func _on_abilityButtonPressed():
	print('Ability button pressed')
