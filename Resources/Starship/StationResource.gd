extends TitansResource
class_name StationResource

var stationKey : String
var shortName : String
var fullName : String


class BonusBlock:
	# Populated by data
	var blockName : String # This should match a 'does' property so they can map directly into the StationResource object
	var priTrait : String = CharacterResource.TRAITS.STR
	var secTrait : String = CharacterResource.TRAITS.STR
	var effectAmount : int = 1
	var postDisplay = " Dice"
	
	# Calculated locally 
	var bonusTotal : int = 0

	func _init( dict : Dictionary ):
		blockName = dict.blockName
		priTrait = dict.priTrait
		secTrait = dict.secTrait
		effectAmount = 0
		bonusTotal = 0
	
	func getDisplay():
		return str(bonusTotal) + postDisplay

var bonusBlocks = []

# Passive Effect Flags
var doesMedbay : BonusBlock = null
var doesBrig : BonusBlock = null
var doesQrf : BonusBlock = null

#  Decision Flags
var doesNavigation : BonusBlock = null
var doesLeadership : BonusBlock = null
var doesEngineering : BonusBlock = null
var doesScience :  BonusBlock = null
var doesMedical : BonusBlock = null
var doesComms : BonusBlock = null
var doesTraining : BonusBlock = null

# Inhabitant
var character : CharacterResource

# Overrides
func get_class() -> String: 
	return "StationResource"

func is_class( name : String ) -> bool: 
	return name == "StationResource"

func _init( key : String , stationDict : Dictionary , newCharacter = null ):
	stationKey = key

	fillableProps = [
		"shortName" , "fullName"
	]

	flushAndFillProperties( stationDict , self )
	_makeBonusBlocks( stationDict['bonusBlocks'] , self )

	assignCharacter( newCharacter )

func _makeBonusBlocks( allBlockData , objectSelf ):
	for blockData in allBlockData:
		objectSelf[blockData.blockName] = blockData
		bonusBlocks.append( blockData )

func calculateBonuses():
	if( !character ):
		doesMedical = null
		doesBrig = null
		doesQrf = null
		doesNavigation = null
		doesLeadership = null
		doesEngineering = null
		doesScience = null
		doesComms = null
		return null  

	for bonusBlock in bonusBlocks:
		var pri = character.getTraitTotal( bonusBlock.priTrait )
		var sec = character.getTraitTotal( bonusBlock.secTrait )

		if( sec != 0 ):
			sec = sec / 2

		bonusBlock.bonusTotal = int( ( pri + sec ) * bonusBlock.effectAmount )


func assignCharacter( newCharacter : CharacterResource ):
	character = newCharacter
	calculateBonuses()