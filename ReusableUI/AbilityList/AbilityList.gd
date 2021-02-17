extends PanelContainer

onready var abilityGrid : GridContainer = $GridContainer # All children of this grid should be AbilityIcon scenes
onready var abilityDetail : PanelContainer = $PanelSpawner/AbilityDetail

var abilityIconScene = preload("res://ReusableUI/AbilityIcon/AbilityIcon.tscn")
var currentState : int = STATE.HIDE

enum STATE {
	SHOW, FOCUS , NOT_FOCUS , HIDE
}

signal abilityActivated( ability )

var currentBattler : CharacterResource
		
func setState( state : int , newBattler ):
	currentState = state
	currentBattler = newBattler

	for child in abilityGrid.get_children():
		child.queue_free()

	if( currentBattler):
		var isAbilityFocused = false

		for action in currentBattler.actions:
			var abilityInstance = abilityIconScene.instance()

			abilityGrid.add_child( abilityInstance )
			abilityInstance.setupScene( action )			
			abilityInstance.allowFocus()

			if(!isAbilityFocused):
				abilityInstance.setFocused()
				isAbilityFocused = true

			abilityInstance.get_node("Button").connect("pressed" , self , "_on_abilityButtonPressed" , [abilityInstance.ability])
			abilityInstance.get_node("Button").connect("focus_entered" , self , "_on_AbilityButton_focus_entered" ,[abilityInstance.ability])
			abilityInstance.get_node("Button").connect("focus_exited" , self , "_on_AbilityButton_focus_exited" ,[abilityInstance.ability])


	match currentState:
		STATE.SHOW:
			show()

		STATE.FOCUS:
			show()
	
		STATE.NOT_FOCUS:
			for icon in abilityGrid.get_children():
				icon.disallowFocus()
		
		STATE.HIDE:
			for icon in abilityGrid.get_children():
				icon.disallowFocus()
			hide()
		
# Signals
# Unfocus yourself and let parent know which ability was pressed
func _on_abilityButtonPressed( ability : AbilityResource ):
	emit_signal("abilityActivated" , ability)
	setState(STATE.NOT_FOCUS , null )

func _on_AbilityButton_focus_entered( ability: AbilityResource ):
	abilityDetail.setupScene( ability )
	#
func _on_AbilityButton_focus_exited( ability : AbilityResource ):
	abilityDetail.setupScene( null )
	#
