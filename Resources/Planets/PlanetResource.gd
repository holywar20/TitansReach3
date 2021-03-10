extends TitansResource
class_name PlanetResource

export(int) var mySeed = 10000000

const ROMAN_NUMERALS = {
	1 : "I", 2 : "II" , 3 : "III", 4 : "IV", 5 : "V", 6 : "VI",7 : "VII", 8 : "VIII", 9 : "IX"
}

const PLANET_ORBIT_TABLE = {
	"LessBoilLine" :        { "L" : 20, "M" : 10, "G": 20 ,"IG" : 0,  "T" : 0 ,  "B" : 30, "I" : 0,  "S" : 20, "H": 0},
	"EqualBoilLine" :        { "L" : 10, "M" : 10, "G": 20 ,"IG" : 0,  "T" : 10 , "B" : 30, "I" : 0,  "S" : 20, "H": 0},
	"BetweenBoilAndFreeze" : { "L" : 5,  "M" : 10, "G": 20 ,"IG" : 0,  "T" : 20 , "B" : 30, "I" : 0,  "S" : 15, "H": 10},
	"EqualFreezeLine" :      { "L" : 5,  "M" : 10, "G": 10 ,"IG" : 10, "T" : 10 , "B" : 30, "I" : 5,  "S" : 10, "H": 10},
	"GreaterFreezeLine":     { "L" : 5,  "M" : 10, "G": 10 ,"IG" : 20, "T" : 0 , "B" : 15, "I" : 15,  "S" : 5,  "H": 20}
}

const PLANET_CLASS = { 
	"LAVA" : "L", 
	"MESOPLANET" : "T", 
	"GAS_GIANT" : "G", 
	"ICE_GIANT" : "IG", 
	"TERRAN" : "T", 
	"BARREN" : "B", 
	"ICE" : "I", 
	"STORM" : "S", 
	"HYDROCARBON" : "H"
} 

const PLANET_FILE_PATH : String = "res://Generators/Data/PlanetList.json"

# populated by fillable props
export(PLANET_CLASS) var planetClass = PLANET_CLASS.TERRAN

var planetClassName : String = ""
var codex : String = ""
var pColor : String = "crimson"

var texturePath : String = ""
var textureIconPath : String = ""
var textureSmallPath : String = ""

# populated by diffable props
export(float) var mass = 1.0
export(int) var temp = 300

# populated by picking an option at random
var atmopshere : String = ""

# populated by special mechanisms
var orbit = 0

var hasLife = false
var minerals = {}

var distance = 0
var radial = 0
var position2d = 0 # The position of the planet in the 2 dimensional space. 3d position set based on that.

export(String) var planetName = "Unknown Planet"

# Relationships with other resources
var parentStar = null # is a StarResource

func _init( aSeed : int , starResource , newOrbit : int ):
	if( aSeed != 0 ):
		seed(aSeed)
	else:
		seed(mySeed)

	mySeed = genRandomSeed()

	fillableProps = [
		'planetClassName','codex' , 'texturePath' , 'textureIconPath' , 'textureSmallPath', 'pColor'
	]
	hiLoDiffProps = [
		'temp' , 'mass'
	]

	parentStar = starResource
	orbit = newOrbit
	parentStar.addPlanet( orbit, self)

	_generateProps()

# Overrides
func get_class(): 
	return "PlanetResource"

func is_class( name : String ): 
	return name == "PlanetResource"

func _getOrbitTable() -> Dictionary:
	var myTable = null
	if( orbit > parentStar.freezeLine ):
		myTable = PLANET_ORBIT_TABLE['GreaterFreezeLine']
	elif( orbit == parentStar.freezeLine ):
		myTable = PLANET_ORBIT_TABLE['EqualFreezeLine']
	elif( orbit < parentStar.freezeLine && orbit < parentStar.boilLine ):
		myTable = PLANET_ORBIT_TABLE['BetweenBoilAndFreeze']
	elif( orbit == parentStar.boilLine ):
		myTable = PLANET_ORBIT_TABLE['EqualBoilLine']
	else:
		myTable = PLANET_ORBIT_TABLE['LessBoilLine']

	return myTable

func _generateProps() -> void:
	var planetFile = File.new()
	planetFile.open( PLANET_FILE_PATH , File.READ)
	var planetTable = parse_json( planetFile.get_as_text() )
	planetFile.close()

	var myTable = _getOrbitTable()

	var totalWeight = 0
	for planetType in myTable:
		totalWeight += myTable[planetType]
	
	var randomNum = randi() % totalWeight + 1.0

	var weightCount = 0
	var myPlanetKey = null
	for planetType in myTable:
		weightCount += myTable[planetType]
		if( randomNum <= weightCount ):
			myPlanetKey = planetType
			break;

	# Now populate all the properties
	var planetData : Dictionary = planetTable[myPlanetKey]
	flushAndFillProperties( planetData, self )

# Overrides
func calculateSpecialProperties( props: Dictionary, object):
	
	var bioRoll = randi() % 100
	if( bioRoll < props['biosphereChance'] ):
		hasLife = true;

	planetName = parentStar.starName + " " + ROMAN_NUMERALS[parentStar.getCurrentPlanetCount(orbit)+1]

	distance = parentStar.systemScale * orbit
	var randomRadian = randf() * 3.14 * 2
	radial = Vector2( cos(randomRadian) , sin(randomRadian) )
	position2d = distance * radial

	# Use mineralNum + mineralChance to create minerals
	# determine atmoshpere type ( should atmosphere be another resource? )
