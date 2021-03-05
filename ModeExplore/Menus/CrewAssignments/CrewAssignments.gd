extends Panel

var crew : Array

var charShortPanelScene = preload("res://ReusableUI/CharacterShortPanel/CharacterShortPanel.tscn")

const NODE_GROUP_SHORT_PANEL = "SHORT_PANEL"

onready var unassignedBase = $Tripane/VBox/UnassignedList/Crew
onready var stationBase = $Tripane/Assignments

# Sub UI Scenes
onready var traitDetails = $Tripane/Detail/Traits
onready var abilityDetail = $Tripane/Details/AbilityDetail
onready var primaryAbilityList = $Tripane/Abilities/Primary
onready var secondaryAbilityList = $Tripane/Abilities/Secondary

func setupScene( myCrew : Array ):
	crew = myCrew
	
	for child in get_tree().get_nodes_in_group(NODE_GROUP_SHORT_PANEL):
		child.queue_free()

	var oneFocused = false

	for oneCrew in myCrew:
		var newPanel = charShortPanelScene.instance()
		unassignedBase.add_child( newPanel )
		newPanel.setupScene( oneCrew )
		newPanel.connect("focusEntered" , self , "_on_CharShortPanelFocusEntered")
		
		if( !oneFocused ):
			newPanel.grab_focus()
			newPanel._on_CPanel_focus_entered() # Firing first event manually
			oneFocused = true

# Signal responses
func _on_CharShortPanelFocusEntered( character ):
	traitDetails.updateUI( character )
	primaryAbilityList.updateUI( character.primaryTree )
	secondaryAbilityList.updateUI( character.secondaryTree )

func _on_Primary_abilityChanged(ability):
	abilityDetail.setupScene( ability )

func _on_Secondary_abilityChanged(ability):
	abilityDetail.setupScene( ability )

func _on_Primary_abilityExit(ability):
	abilityDetail.setupScene()

func _on_Secondary_abilityExit(ability):
	abilityDetail.setupScene()
