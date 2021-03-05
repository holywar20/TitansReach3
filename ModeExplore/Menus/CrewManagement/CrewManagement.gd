extends Panel

var crew : Array

var charShortPanelScene = preload("res://ReusableUI/CharacterShortPanel/CharacterShortPanel.tscn")

const NODE_GROUP_SHORT_PANEL = "SHORT_PANEL"

onready var crewList = $Tripane/Crewlist/CrewList/Crew
onready var stationBase = $Tripane/Assignments

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
			newPanel._on_CPanel_focus_entered() # Firing first event manually
			oneFocused = true
		
func _on_CharShortPanelFocusEntered( character : CharacterResource ):
	print("we are open now!")
