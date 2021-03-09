extends Node

var stationStore = {}

var qrfFormation : FormationResource
var db

func setupData( newDb ):
	db = newDb
	
	var fString : String = """
		SELECT * FROM StationResource
		LEFT JOIN StationBonusBlocks ON ( StationResource.stationKey = StationBonusBlocks.stationKey )
		WHERE 1
	"""
	db.query( fString )

	var tempStore : Dictionary = {}

	for result in db.query_result:
		if( !tempStore.has( result.stationKey ) ):
			tempStore[result.stationKey] = result
			tempStore[result.stationKey].bonusBlocks = []
			
		tempStore[result.stationKey]['bonusBlocks'].append({
			'blockName' : tempStore[result.stationKey].blockName,
			'priTrait'	: tempStore[result.stationKey].priTrait,
			'secTrait'	: tempStore[result.stationKey].secTrait,
			'effectAmount' : tempStore[result.stationKey].effectAmount  
		})

	for key in tempStore:
		var newStation = StationResource.new( key , tempStore[key] )
		stationStore[key] = newStation

func getStations():
	return stationStore
