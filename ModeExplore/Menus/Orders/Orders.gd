extends Panel

var myCrew : Array = []
var charShortPanelScene = preload("res://ReusableUI/CharacterShortPanel/CharacterShortPanel.tscn")
const NODE_GROUP_SHORT_PANEL = "SHORT_PANEL"

var stations : Dictionary = {}

#Left Pane
onready var manifestBase = $Tripane/Left/ScrollContainer/Manifest
onready var selected = $Tripane/Left/Selected

#Center Pane
onready var captainPanel = $Tripane/Center/Panel/CaptainsCell

onready var rightStationPanels = {
	"MEDICAL_1" : $Tripane/Right/OffDuty/MEDICAL_1,
	"MEDICAL_2" : $Tripane/Right/OffDuty/MEDICAL_2,
	"MEDICAL_3" : $Tripane/Right/OffDuty/MEDICAL_3,
	"MEDICAL_4" : $Tripane/Right/OffDuty/MEDICAL_4,
	"QRF_1" : $Tripane/Right/QRF/QRF_1,
	"QRF_2" : $Tripane/Right/QRF/QRF_2,
	"QRF_3" : $Tripane/Right/QRF/QRF_3,
	"QRF_4" : $Tripane/Right/QRF/QRF_4,
	"BRIG_1" : $Tripane/Right/BRIG/BRIG_1,
	"BRIG_2" : $Tripane/Right/BRIG/BRIG_2,
	"BRIG_3" : $Tripane/Right/BRIG/BRIG_3,
	"BRIG_4" : $Tripane/Right/BRIG/BRIG_4
}

func setupScene( newCrew : Array , newStations : Dictionary ):
	updateUI( newCrew, newStations )

func updateUI( newCrew : Array , newStations : Dictionary ):
	stations = newStations

	rightStationPanels.MEDICAL_1.setupScene( stations['MEDICAL_1'] )
	rightStationPanels.MEDICAL_2.setupScene( stations['MEDICAL_2'] )
	rightStationPanels.MEDICAL_3.setupScene( stations['MEDICAL_3'] )
	rightStationPanels.MEDICAL_4.setupScene( stations['MEDICAL_4'] )
	rightStationPanels.BRIG_1.setupScene( stations['BRIG_1'] )
	rightStationPanels.BRIG_2.setupScene( stations['BRIG_2'] )
	rightStationPanels.BRIG_3.setupScene( stations['BRIG_3'] )
	rightStationPanels.BRIG_4.setupScene( stations['BRIG_4'] )
	rightStationPanels.QRF_1.setupScene( stations['QRF_1'] )
	rightStationPanels.QRF_2.setupScene( stations['QRF_2'] )
	rightStationPanels.QRF_3.setupScene( stations['QRF_3'] )
	rightStationPanels.QRF_4.setupScene( stations['QRF_4'] )

	updateCrew( newCrew , false )

func updateCrew( newCrew : Array , oneFocused = true ):
	myCrew = newCrew

	for child in get_tree().get_nodes_in_group(NODE_GROUP_SHORT_PANEL):
		child.queue_free()

	for oneCrew in myCrew:
		var newPanel = charShortPanelScene.instance()
		manifestBase.add_child( newPanel )
		newPanel.setupScene( oneCrew )
		newPanel.connect("focusEntered" , self , "_on_CharShortPanelFocusEntered")
		
		if( !oneFocused ):
			newPanel.grab_focus()
			newPanel._on_CPanel_focus_entered() # Firing first event manually
			oneFocused = true

func _on_CharShortPanelFocusEntered( character : CharacterResource ):
	selected.updateUI( character )	

	


