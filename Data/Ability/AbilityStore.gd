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
	
	var fString : String = """
		SELECT * FROM AbilityResource
		LEFT JOIN AbilityEffectGroups ON ( AbilityResource.abilityKey = AbilityEffectGroups.abilityKey )
		WHERE AbilityResource.abilityKey = '%s'
	"""
	var queryString = fString % key
	var success = db.query( queryString  )
	
	var abilityDictionary = null
	var effectGroupsArray = []
	
	for abilityData in db.query_result:
		if( abilityDictionary == null ):
			abilityDictionary = abilityData
		effectGroupsArray.append( {
			'targetArea' : abilityData.targetArea,
			'targetType' : abilityData.targetType,
			'effectKeys' : abilityData.effectKeys.split(",")
		} )
	
	if( db.query_result.size() >= 1 ):
		abilityDictionary['effectGroups'] = effectGroupsArray
		return AbilityResource.new( key, abilityDictionary, character )
	else:
		print("Dev Error: Can't find ability of key " + key )
		return null

func getAbilityTree( treePath : int , character ):
	var abilityTree = AbilityTreeResource.new( ABILITY_TREE_METADATA[treePath], character )
	# TODO Filter on ability = learned record
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
