extends Panel

var myCharacter : CharacterResource

const PARTIAL_NODE_PATH = "VBox/ResistancePanel/VBox/Left/"

func setupScene( character : CharacterResource ):
	updateUI( character )

func updateUI( character: CharacterResource ):
	myCharacter = character

	for key in character.resists:
		var thisBlock = character.resists[key]
		var path = PARTIAL_NODE_PATH + key + "/"
		
		get_node( path + "Trait").set_text( str(thisBlock.trait ) )
		get_node( path + "Talent").set_text( str(thisBlock.talent)  )
		get_node( path + "Equipment").set_text( str(thisBlock.equip ) )
		get_node( path + "Total").set_text( str(thisBlock.total ) )

