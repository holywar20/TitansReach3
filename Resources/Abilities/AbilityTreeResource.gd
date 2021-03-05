extends TitansResource
class_name AbilityTreeResource

var treeName = "Unassigned Tree"
var isTitanTree = false

enum PATH {
	MEDIC, COMMANDO
}

const FILES = {
	PATH.MEDIC : "res://Generators/Data/AbilityTree/medic.json",
    PATH.COMMANDO : "res://Generators/Data/AbilityTree/commando.json"
}


class AbilityMeta:
    var ability : AbilityResource
    var isLearned : bool = false
    var cost : int = 5

func get_class(): 
	return "AbilityResource"

func is_class( name : String ): 
	return name == "AbilityResource"

func _init( treePath : int , abilityPath : int ):
    pass

func getFilteredAbilities( unlearned : Bool ):
    pass