extends TitansResource
class_name AbilityTreeResource

var parentCharacter
var treeName = "Unassigned Tree"
var isTitanTree = false

var abilityStore = []

enum TREE {
	DEFAULT, MEDIC, COMMANDO
}

func get_class(): 
	return "AbilityResource"

func is_class( name : String ): 
	return name == "AbilityResource"

func _init( props, character ):
	parentCharacter = character

	fillableProps = [
		"treeName" , "isTitanTree"
	]
