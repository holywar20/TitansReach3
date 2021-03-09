extends Node

var db

const ABILITY_TREE_METADATA = {
	AbilityTreeResource.TREE.DEFAULT : {
		"treeName" : "DEFAULT",
		"isTitanTree" : false
	},
	AbilityTreeResource.TREE.MEDIC : {
		"treeName" : "TEST_MEDIC_TREE",
		"isTitanTree" : false
	},
	AbilityTreeResource.TREE.COMMANDO : {
		"treeName" : "TEST_COMMANDO_TREE",
		"isTitanTree" : false
	}
}

const ABILITY_FILES = {
	AbilityTreeResource.TREE.DEFAULT : "res://Generators/Data/Abilities/default.json",
	AbilityTreeResource.TREE.MEDIC : "res://Generators/Data/Abilities/testmedic.json",
	AbilityTreeResource.TREE.COMMANDO : "res://Generators/Data/Abilities/testcommando.json"
}

func setupData( newDb ):
	db = newDb

func getAbility( key : String , character : CharacterResource ):
	db.open_db()
	
	var queryString : String = """
		SELECT * FROM AbilityResource WHERE abilityKey = '?'
		LEFT JOIN AbilityEffectGroups ON ( AbilityResource.abilityKey = AbilityEffectGroups.abilityKey )
	"""
	var paramBinds : Array = [ key ]
	var success = db.query_with_bindings( queryString, paramBinds )
	
	var abilityDictionary = null
	var effectGroupsArray = null
	
	for abilityData in db.query_result:
		if( !abilityDictionary ):
			abilityDictionary = abilityData
			effectGroupsArray.append( {
				'targetArea' : abilityData.targetArea,
				'targetType' : abilityData.targetType,
				'effectKeys' : abilityData.effectKeys.split(",")
			} )
			
	abilityDictionary.effectGroups = effectGroupsArray
	
	db.close()
	
	if( success ):
		return AbilityResource.new( key, abilityDictionary, character )
	else:
		return null

func getAbilityTree( treePath : int , character ):
	var abilityTree = AbilityTreeResource.new( ABILITY_TREE_METADATA[treePath], character )

	# Open the file, just to get the name.
	# Bit stupid, but not worth refactoring ability _init, which knows how to build itself.
	var abilityFile = File.new()
	abilityFile.open( ABILITY_FILES[treePath] , File.READ)
	var abilityTable = parse_json( abilityFile.get_as_text() )
	abilityFile.close()

	# TODO Remove 'start learned' . Learning all for now for testing.
	for ability in abilityTable:
		abilityTree.abilityStore.append( getAbility( ability , character ) )
		
	return abilityTree


func getEffects( effectString ):
	pass
