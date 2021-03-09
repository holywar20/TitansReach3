extends Panel

var crew : Array

var charShortPanelScene = preload("res://ReusableUI/CharacterShortPanel/CharacterShortPanel.tscn")

const NODE_GROUP_SHORT_PANEL = "SHORT_PANEL"

# Left Panel
onready var crewList = $Tripane/Crewlist/CrewList/Crew
onready var charPanel = $Tripane/Crewlist/CharacterPanel

# Center Panel
onready var equipmentPanel = $Tripane/Detail/EquipmentPane

# Right Panel
onready var armsRoom = $Tripane/ArmsRoom

func setupScene( myCrew : Array ):
	crew = myCrew
	
	for child in get_tree().get_nodes_in_group(NODE_GROUP_SHORT_PANEL):
		child.queue_free()

	var oneFocused = false

	for oneCrew in myCrew:
		var newPanel = charShortPanelScene.instance()
		crewList.add_child( newPanel )
		newPanel.setupScene( oneCrew )
		newPanel.connect("focusEntered" , self , "_on_CharShortPanelFocusEntered")
		
		if( !oneFocused ):
			newPanel.grab_focus()
			newPanel._on_CPanel_focus_entered() # Firing first event manuallyp
			oneFocused = true
		
func _on_CharShortPanelFocusEntered( character : CharacterResource ):
	charPanel.updateUI( character )
	equipmentPanel.updateUI( character )
