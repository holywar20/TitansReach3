extends TitansResource
class_name AbilityTreeResource

var parentCharacter
var treeName = "Unassigned Tree"
var isTitanTree = false

var abilityStore = []

enum TREE {
	DEFAULT, MEDIC, COMMANDO
}

const ABILITY_TREE_METADATA = {
	TREE.DEFAULT : {
		"treeName" : "DEFAULT",
		"isTitanTree" : false
	},
	TREE.MEDIC : {
		"treeName" : "TEST_MEDIC_TREE",
		"isTitanTree" : false
	},
	TREE.COMMANDO : {
		"treeName" : "TEST_COMMANDO_TREE",
		"isTitanTree" : false
	}
}

const ABILITY_FILES = {
	TREE.DEFAULT : "res://Generators/Data/Abilities/default.json",
	TREE.MEDIC : "res://Generators/Data/Abilities/testmedic.json",
	TREE.COMMANDO : "res://Generators/Data/Abilities/testcommando.json"
}

func get_class(): 
	return "AbilityResource"

func is_class( name : String ): 
	return name == "AbilityResource"

func _init( treePath : int , character ):
	parentCharacter = character
	
	treeName = ABILITY_TREE_METADATA[treePath].treeName
	isTitanTree = ABILITY_TREE_METADATA[treePath].isTitanTree

	# Open the file, just to get the name.
	# Bit stupid, but not worth refactoring ability _init, which knows how to build itself.
	var abilityFile = File.new()
	abilityFile.open( ABILITY_FILES[treePath] , File.READ)
	var abilityTable = parse_json( abilityFile.get_as_text() )
	abilityFile.close()

	# TODO Remove 'start learned' . Learning all for now for testing.
	for ability in abilityTable:
		abilityStore.append( AbilityResource.new( ability , abilityTable[ability] ,  parentCharacter , true ) )

func getFilteredAbilities( unlearned ):
	pass
