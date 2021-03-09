extends Node

var db

const ABILITY_TREE_METADATA = {
	AbilityTreeResource.TREE.DEFAULT : {
		"treeName" : "DEFAULT",
		"isTitanTree" : false
	},
	AbilityTreeResource.TREE.MEDIC : {
		"treeName" : "MEDIC",
		"isTitanTree" : false
	},
	AbilityTreeResource.TREE.COMMANDO : {
		"treeName" : "COMMANDO",
		"isTitanTree" : false
	}
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
	db.query( queryString  )
	
	var abilityDictionary = null
	var effectGroupsArray = []

	for abilityData in db.query_result:
		print(abilityData)
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

func getAbilityTree( tree : String , character ):
	var abilityTree = AbilityTreeResource.new( ABILITY_TREE_METADATA[tree], character )
	
	var fString : String = """
		SELECT abilityKey FROM abilityTreeItems WHERE abilityTreeItems.abilityTreeKey = '%s'
	"""
	var queryString = fString % tree
	db.query(queryString)

	# Need to duplicate results here, because further queries need to make use of the query_result buffer before we are done with this.
	var allResults = db.query_result.duplicate()

	for result in allResults:
		var ability = getAbility( result.abilityKey , character )
		if( ability ):
			abilityTree.abilityStore.append( ability )
		
	return abilityTree


func getEffects( effectString ):
	pass
