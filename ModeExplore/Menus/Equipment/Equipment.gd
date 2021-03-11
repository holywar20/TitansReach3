extends Panel

var crew : Array
var inventory : Node

var charShortPanelScene = preload("res://ReusableUI/CharacterShortPanel/CharacterShortPanel.tscn")

const NODE_GROUP_SHORT_PANEL = "SHORT_PANEL"

# Left Panel
onready var crewList = $Tripane/Crewlist/CrewList/Crew
onready var charPanel = $Tripane/Crewlist/CharacterPanel

# Center Panel
onready var equipmentPanel = $Tripane/Detail/EquipmentPane
onready var itemPanel = $Tripane/Detail/ItemPanel

# Right Panel
onready var armsRoom = $Tripane/ArmsRoom

var currentItem : ItemResource

const STATE = {}

func setupScene( myCrew : Array , newInventory ):
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
	
	armsRoom.setupScene( newInventory )

# Responses to signals
func _on_CharShortPanelFocusEntered( character : CharacterResource ):
	charPanel.updateUI( character )
	equipmentPanel.updateUI( character )

func _on_ArmsRoom_itemFocused(item):
	itemPanel.updateUI( item )

func _on_ArmsRoom_itemNotFocused( _item ):
	itemPanel.updateUI( null )

func _on_ArmsRoom_itemSelected(item):
	itemPanel.updateUI( item )
	currentItem = item

	equipmentPanel.delegateFocus( currentItem.itemType )

func _on_EquipmentPane_equipmentAssignCancelled():
	armsRoom.backToSelection()
