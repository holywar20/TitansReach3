extends TitansResource
class_name StarResource

enum STAR_CLASS {
	T , M , K , G , F , A, B, O , NEUTRON, BLACKHOLE, RED_GIANT, WOLF_RAYET
}

const STAR_WEIGHT = {
	STAR_CLASS.T: 3 , 
	STAR_CLASS.M: 35 ,
	STAR_CLASS.K: 18,
	STAR_CLASS.G: 12,
	STAR_CLASS.F: 8,
	STAR_CLASS.A: 5,
	STAR_CLASS.B: 3,
	STAR_CLASS.O: 1,
	STAR_CLASS.NEUTRON: 1,
	STAR_CLASS.RED_GIANT: 10,
	STAR_CLASS.BLACKHOLE: 1,
	STAR_CLASS.WOLF_RAYET: 1 
}

export(int) var mySeed = 10000000


# Properties which are generally populated from data
export(STAR_CLASS) var starClass = STAR_CLASS.T
var starClassName : String = "Brown Dwarf" 
var boilLine : int = 0
var freezeLine : int = 1
var temp : int = 3000
var mass : float = 0.01
var codex : String = "Brown Dwarf"

var textureScale :float = 0.25
var texturePath : String = "res://AssettsImage/Stars/celestial_blank.png"
var textureIconPath : String = "res://AssettsImage/Stars/celestial_blank_icon.png"
var textureSmallPath : String = "res://AssettsImage/Stars/celestial_blank_small.png"

var isExotic : bool = false 
var isHabitable : bool = false
var anomChance : float = 1

# Data
var nameFilePath : String = "res://Generators/Data/NameList.json"
var starFilePath : String = "res://Generators/Data/StarList.json"

# Relationships
var parentSystem

var planets : Array = []
var anoms : Array = []

# Overrides
func get_class() -> String: 
	return "StarResource"

func is_class( name : String ) -> bool: 
	return name == "StarResource"

func _init( aSeed: int )->void:
	if( aSeed != 0 ):
		seed(aSeed)
	else:
		seed(mySeed)

	mySeed = genRandomSeed()

	_generateName()
	_generateProps()

func _generateName() -> void:
	var nameFile = File.new()
	nameFile.open(nameFilePath, File.READ)

	nameFile.close()

func _generateProps() -> void:
	var starFile = File.new()
	starFile.open( starFilePath , File.READ)
	var starTable = parse_json( starFile.get_as_text() )
	starFile.close()

	# Calculate the total 'rollWeight' of all stars
	var totalWeight : int = 1
	for star in starTable:
		totalWeight += star.rollWeight 

	var random = randi() % totalWeight + 1.0
	var weightCount = 0
	
	# Find out which star we are creating
	for x in range( 0, starTable.size() ):
		weightCount += starTable[x].rollWeight
		if( weightCount >= random ):
			starClass = x
			break

	# Now populate all the properties
	var starData : Dictionary = starTable[starClass]
	flushAndFillProperties( starData, self )
	
	#starClassName = starData.starClassName
	#boilLine = starData.boilLine
	#freezeLine = starData.freezeLine
	#textureScale = starData.textureScale
	#texturePath = starData.texturePath
	#textureIconPath =  starData.textureIconPath
	#textureSmallPath = starData.textureSmallPath
	#isExotic = starData.isExotic
	#isHabitable = starData.isHabitable
	#anomChance = starData.anomChance
	#codex = starData.codex

	#tempature = randDiffValues( starData.tempLo , starData.tempHi )



	
	
