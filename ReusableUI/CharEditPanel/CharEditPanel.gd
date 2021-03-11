extends Panel

var character : CharacterResource

const TRAIT_TABLE_PATH = "VBox/TraitsBox/"

onready var healthBar : ProgressBar = $VBox/HBox/Bars/HealthBar
onready var moraleBar : ProgressBar = $VBox/HBox/Bars/MoraleBar

onready var cName : Label = $VBox/Label
onready var cPoints : Label = $VBox/HBox/CPoints/Points

func setupScene ( newCharacter : CharacterResource ):
	updateUI( newCharacter )

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter
	
	var hpStatBlock = character.hp
	healthBar.setBarValues( hpStatBlock.total , hpStatBlock.current )
	
	var moraleStatBlock = character.morale
	moraleBar.setBarValues( moraleStatBlock.total , moraleStatBlock.current )
	
	cName.set_text( character.getFullName() )
	cPoints.set_text( character.getCPointString() )

	for stat in CharacterResource.TRAITS:
		_updateStatRow( stat )

func _updateStatRow( stat : String ):
	var myStatBlock = character.getTraitStatBlock( stat )
	get_node( TRAIT_TABLE_PATH + stat + "/Base").set_text( str(myStatBlock.value) )
	get_node( TRAIT_TABLE_PATH + stat + "/Mod").set_text( str( myStatBlock.equip + myStatBlock.talent + myStatBlock.mod ) )
	get_node( TRAIT_TABLE_PATH + stat + "/Total").set_text( str(myStatBlock.total) )


func _on_PlusButton_pressed( _trait : String ):
	pass

func _on_MinusButton_pressed( _trait : String ):
	pass # Replace with function body.
